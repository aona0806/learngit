//
//  NewsTopicTableViewController.swift
//  news
//
//  Created by 陈龙 on 16/1/8.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class NewsTopicTableViewController: LJBaseViewController, UITableViewDataSource, UITableViewDelegate {

    var fromSubId: String?  //用来标记是从哪个页面进入

    private var tid: Int! = 0
    private var dataArray: Array<LJNewsListDataListModel>! = []
    private var topicInfo: NewsTopicDetailDataTopicInfoModel?
    private var tableView: UITableView! = UITableView()
    var collectListModel: LJNewsListDataListModel?
    
    private let collectButton = UIButton()

    // MARK: - Lifecycle
    
    init(tid: Int) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.tid = tid
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "专题详情"
        self.buildNavbar()
        self.buildView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.update(refreshType: .refresh, tid: self.tid, lastTime: "0", fromSubId: self.fromSubId)
    }
    
    override func refreshAction() {
        self.update(refreshType: .refresh, tid: self.tid, lastTime: "0",fromSubId: self.fromSubId)
    }

    // MARK: - private
    
    private func buildNavbar() {
        collectButton.frame = CGRect(x: 0, y: 0, width: NewsConfig.NavbarSize, height: NewsConfig.NavbarSize)
        let collectNormalImage = UIImage(named: "news_collect_hollowstar")
        let collectSelectedImage = UIImage(named: "news_collect_solidstar")
        collectButton.setImage(collectNormalImage, for: UIControlState())
        collectButton.setImage(collectSelectedImage, for: .selected)
        let collectButtonItem = UIBarButtonItem(customView: collectButton)
        collectButton.addTarget(self, action: #selector(NewsTopicTableViewController.onCollect(_:)), for: .touchUpInside)

        self.navigationItem.rightBarButtonItem = collectButtonItem
    }
    
    private func buildView() {
        
        self.tableView.separatorStyle = .none
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view.snp.edges)
        }
        
        self.addHeaderRefreshView(self.tableView) {[weak self] () -> Void in
            self?.update(refreshType: .refresh, tid: self!.tid, lastTime: "0",fromSubId: self!.fromSubId)
        }
        self.addFooterRefreshView(self.tableView) { [weak self]() -> Void in

            let lastTime = self?.dataArray?.last?.lastTime ?? "0"
            self?.update(refreshType: .loadMore, tid: self!.tid, lastTime: lastTime, fromSubId: self!.fromSubId)
        }
    }
    
    private func notificationCollect(_ isCollected: Bool, ctime: NSNumber) {
        
        if self.topicInfo?.tid != nil {
            var userInfo: [String:AnyObject]! = [GlobalConsts.kNewsCollectId: (self.topicInfo?.tid)! as AnyObject]
            if self.collectListModel != nil {
                self.collectListModel?.favStatus = isCollected ? "1" : "0"
                self.collectListModel?.favTime = ctime.stringValue
                userInfo[GlobalConsts.kNewsCollectInfo] = self.collectListModel!
            }
            
            if !isCollected {
                NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConsts.kNewsCollectNotification), object: nil, userInfo: userInfo)
            }
        }
    }
    
    // MARK: - download
    
    func update(refreshType: TKDataFreshType, tid: Int, lastTime: String, fromSubId: String?) {
        
        TKRequestHandler.sharedInstance().getTopicListFeed(tid, fromSubId: fromSubId, lastTime: lastTime, rn: 20, refreshType: refreshType) { [weak self](sesstionDataTask, model, error) -> Void in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.stopRefresh(strongSelf.tableView)
            if error == nil {
                
                let dataArray = model?.data?.newsList as? Array<LJNewsListDataListModel> ?? []
                if refreshType == .refresh  {
                    strongSelf.dataArray = dataArray
                    strongSelf.topicInfo = model?.data?.topicInfo
                    strongSelf.tableView.reloadData()
                    
                } else {
                    let row = strongSelf.dataArray.count
                    let section = strongSelf.tableView.numberOfSections - 1
                    let indexPath = IndexPath(row: row, section: section)
                    strongSelf.dataArray = strongSelf.dataArray + dataArray
                    strongSelf.tableView.reloadData()
                    if row < strongSelf.tableView.numberOfRows(inSection: section) {
                        strongSelf.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
                    }
                }
                strongSelf.collectButton.isSelected = strongSelf.topicInfo?.favStatus == "1"
                
            } else {
                if strongSelf.topicInfo == nil {
                    strongSelf.showNetErrorView(nil)
                } else {
                    let msg = error?._domain ?? GlobalConsts.NetErrorNetMessage
                    _ = strongSelf.showToastHidenDefault(msg)
                }
            }
        }
    }
    
    // MARK: - action
    
    func onCollect(_ button: UIButton) {
        
        if topicInfo == nil {
             return
        }
        
        if !AccountManager.sharedInstance.isLogin() {
            let viewController = LoginRegistViewController()
            self.navigateTo(viewController)
            return
        }
        
        if button.isSelected {
            
            TKRequestHandler.sharedInstance().cancelFavorite(withType: self.topicInfo!.favType!, aid: self.topicInfo!.tid!, finish: { [weak self] (sessionDataTask, model, error) -> Void in
                
                guard let strongSelf = self else {
                    return
                }
                
                let hud  = MBProgressHUD.showAdded(to: strongSelf.view, animated:true)
                hud.mode = .text
                if error == nil {
                    button.isSelected = false
                    strongSelf.topicInfo?.favStatus = "0"
                    
                    let time = model.dtime ?? ""
                    var timeNumber:NSNumber? = 0
                    if let number = Double(time) {
                        timeNumber = NSNumber(value:number)
                    }
                    if timeNumber != nil {
                        strongSelf.notificationCollect(false, ctime: timeNumber!)
                        hud.label.text = "取消收藏"
                    }
                    
                    hud.hide(animated: true, afterDelay: 0.5)

                }else {
                    hud.label.text = error!._domain
                    hud.hide(animated: true, afterDelay: 0.5)
                }

            })
        } else {
            TKRequestHandler.sharedInstance().createFavorite(withType: self.topicInfo!.favType!, aid: self.topicInfo!.tid!) { [weak self](sessionDataType, model, error) -> Void in
                
                guard let strongSelf = self else {
                    return
                }
                let hud  = MBProgressHUD.showAdded(to: strongSelf.view, animated:true)
                hud.mode = .text
                if error == nil {
                    button.isSelected = true
                    strongSelf.topicInfo?.favStatus = "1"
                    let time = model.dtime ?? ""
                    var timeNumber:NSNumber? = 0
                    if let number = Double(time) {
                        timeNumber = NSNumber(value:number)
                    }
                    if timeNumber != nil {
                        strongSelf.notificationCollect(true, ctime: timeNumber!)
                        hud.label.text = "已收藏"
                    }
                    hud.hide(animated: true, afterDelay: 0.5)

                }else {
                    hud.label.text = error!._domain
                    hud.hide(animated: true, afterDelay: 0.5)
                }
            }
        }
    }

    
    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        switch section {
        case 0:
            count = self.topicInfo == nil ? 0 : 1;
            break
        case 1:
            count = self.dataArray.count;
            break
        default:
            break
        }
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var tableCell: UITableViewCell?
        switch (indexPath as NSIndexPath).section {
        case 0:
            if self.topicInfo?.focusImg == nil || self.topicInfo?.focusImg?.length() == 0 {
                var cell = tableView.dequeueReusableCell(withIdentifier: NewsTopicTopNoneTableViewCell.Identify) as? NewsTopicTopNoneTableViewCell
                if cell == nil {
                    cell = NewsTopicTopNoneTableViewCell(style: .default, reuseIdentifier: NewsTopicTopNoneTableViewCell.Identify)
                }
                cell?.info = self.topicInfo
                tableCell = cell
            } else {
                var cell = tableView.dequeueReusableCell(withIdentifier: NewsTopicTopTableViewCell.Identify) as? NewsTopicTopTableViewCell
                if cell == nil {
                    cell = NewsTopicTopTableViewCell(style: .default, reuseIdentifier: NewsTopicTopTableViewCell.Identify)
                }
                cell?.info = self.topicInfo
                tableCell = cell
            }
        case 1:
            let model = self.dataArray[(indexPath as NSIndexPath).row]
            switch model.templateType {
            case LJTemplateType.newsNone.translateString()? :
                
                var cell = tableView.dequeueReusableCell(withIdentifier: NewsTopicNoneTableViewCell.Identify) as? NewsTopicNoneTableViewCell
                if cell == nil {
                    cell = NewsTopicNoneTableViewCell(style: .default, reuseIdentifier: NewsTopicNoneTableViewCell.Identify)
                }
                cell?.info = model
                tableCell = cell
            case LJTemplateType.newsSingle.translateString()?:
                var cell = tableView.dequeueReusableCell(withIdentifier: NewsTopicSingleTableViewCell.Identify) as? NewsTopicSingleTableViewCell
                if cell == nil {
                    cell = NewsTopicSingleTableViewCell(style: .default, reuseIdentifier: NewsTopicSingleTableViewCell.Identify)
                }
                cell?.info = model
                tableCell = cell
                
            case LJTemplateType.newsMultiple.translateString()?:
                var cell = tableView.dequeueReusableCell(withIdentifier: NewsTopicMultipleTableViewCell.Identify) as? NewsTopicMultipleTableViewCell
                if cell == nil {
                    cell = NewsTopicMultipleTableViewCell(style: .default, reuseIdentifier: NewsTopicMultipleTableViewCell.Identify)
                }
                cell?.info = model
                tableCell = cell
            case LJTemplateType.activity.translateString()?:
                var cell = tableView.dequeueReusableCell(withIdentifier: NewsTopicActivityTableViewCell.Identify) as? NewsTopicActivityTableViewCell
                if cell == nil {
                    cell = NewsTopicActivityTableViewCell(style: .default, reuseIdentifier: NewsTopicActivityTableViewCell.Identify)
                }
                cell!.templateType = LJTemplateType.activity
                cell?.info = model
                tableCell = cell
            case LJTemplateType.conference.translateString()?:
                var cell = tableView.dequeueReusableCell(withIdentifier: NewsTopicActivityTableViewCell.Identify) as? NewsTopicActivityTableViewCell
                if cell == nil {
                    cell = NewsTopicActivityTableViewCell(style: .default, reuseIdentifier: NewsTopicActivityTableViewCell.Identify)
                }
                cell!.templateType = LJTemplateType.conference
                cell?.info = model
                tableCell = cell
            default:
                tableCell = UITableViewCell()
                break
            }
        default:
            break
        }
        
        return tableCell!
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height: CGFloat! = 0
        switch (indexPath as NSIndexPath).section {
        case 0:
            if self.topicInfo?.focusImg == nil || self.topicInfo?.focusImg?.length() == 0 {
                height = NewsTopicTopNoneTableViewCell.heightForCell(self.topicInfo)
            } else {
                height = NewsTopicTopTableViewCell.heightForCell(self.topicInfo)
            }
            break
        case 1:
            
            let model: LJNewsListDataListModel! = dataArray[(indexPath as NSIndexPath).row]
            switch model.templateType {
            case LJTemplateType.newsNone.translateString()?:
                height = NewsTopicNoneTableViewCell.heightForInfo(model)
                break
            case LJTemplateType.newsSingle.translateString()?:
                height = NewsTopicSingleTableViewCell.heightForInfo(model)
                break
            case LJTemplateType.newsMultiple.translateString()?:
                height = NewsTopicMultipleTableViewCell.heightForInfo(model)
                break
            default:
                break
            }
        default:
            break
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath as NSIndexPath).section {
        case 0:
            let model = self.topicInfo
            let detailVc = NewsDetailTableViewController()
            detailVc.newsId = model!.nid!
            self.navigateTo(detailVc)
            break
        case 1:
            
            let model: LJNewsListDataListModel = dataArray[(indexPath as NSIndexPath).row]
            let viewController = PushManager.sharedInstance.getNewsDetailViewController(model.jump, model: model)
            if viewController != nil {
                self.navigateTo(viewController!)
            }
            break
        default:
            break
        }

    }
    
}
