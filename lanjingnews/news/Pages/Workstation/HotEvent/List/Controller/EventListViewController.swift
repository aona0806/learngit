//
//  EventListViewController.swift
//  news
//
//  Created by 陈龙 on 16/6/3.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class EventListViewController: LJBaseViewController, UITableViewDelegate, UITableViewDataSource, ShareViewProtocol {

    struct Consts {
        static let MaxRN = 10
        
    }
    private let tableView = UITableView()
    private var dataList: [HotEventDataModel]! = [HotEventDataModel]()
    
    var HeaderInSectionHeight = 10
    
    private var lastId: String?
    
    private var tableHeadView: MJRefreshNormalHeader!
    private var tableFootView: MJRefreshBackNormalFooter!
    
    private var isFirstLoading: Bool = true
    
    //MARK: 是否加载完毕
    private var isLoadingFinished: Bool = false
    
    var shareUrl: String = ""
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initNavigationbar()
        initView()
        initViewConstraints()
        
        isFirstLoading = true
        updateEventList(lastId: nil, refreshType: .refresh)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - private
    
    private func initNavigationbar(){
        
        let shareItem = UIBarButtonItem.createItem(withTarget: self, action: #selector(HotEventDetailViewController.shareButtonClick),image: "newsdetail_share")
        
        self.navigationItem.rightBarButtonItem = shareItem
        
        self.title = "热点事件专家推荐"
    }
    
    // MARK: - private
    
    private func initView() -> Void {
        
        tableHeadView = MJRefreshNormalHeader(refreshingBlock: { [weak self]() -> Void in
            guard let strongSelf = self else {
                return
            }
            strongSelf.updateEventList(lastId: nil, refreshType: .refresh)
        })
        
        tableFootView = MJRefreshBackNormalFooter(refreshingBlock: { [weak self]() -> Void in
            guard let strongSelf = self else {
                return
            }
            strongSelf.updateEventList(lastId: strongSelf.lastId, refreshType: .loadMore)
        })
        
        tableView.header = tableHeadView
        tableView.footer = tableFootView
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateZan(_:)), name: NSNotification.Name(rawValue: GlobalConsts.Notification_HotEventZan), object: nil)
    }
    
    func initViewConstraints() -> Void {
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.snp.edges).inset(UIEdgeInsets.zero)
        }
    }
    
    // MARK: - download
    
    func updateEventList(lastId: String?, refreshType: TKDataFreshType, rn: Int = Consts.MaxRN) -> Void {
        var hud: MBProgressHUD? = nil
        if isFirstLoading {
            hud = self.showLoadingGif()
            isFirstLoading = false
        }
        
        isLoadingFinished = false
        
        
        TKRequestHandler.sharedInstance().getHotEventList(withId: lastId, rn: rn, refreshType: refreshType) { [weak self](task, model, error) in
            
            if hud != nil {
                hud!.hide(animated: true)
            }
            
            
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.isLoadingFinished = true
            
            strongSelf.tableHeadView.endRefreshing()
            strongSelf.tableFootView.endRefreshing()
            
            if error != nil {
                _ = strongSelf.showToastHidenDefault(error?._domain)
            } else {
                let list = model?.data as? [HotEventDataModel] ?? []
                strongSelf.update(list, refreshType: refreshType)
                
                strongSelf.lastId = list.last?.id
            }
        }
    }
    
    // MARK: - download
    
    func zanAction(_ action: Bool, idString: String!, cell: HotEventListTableViewCel!) -> Void {
        
        TKRequestHandler.sharedInstance().getEventZan(withId: idString, iszan: action) { [weak self](task, model, error) in
            guard let strongSelf = self else {
                return
            }
            
            if error != nil {
                _ = strongSelf.showToastHidenDefault(error?._domain)
            } else {
                
                let indexPath = strongSelf.tableView.indexPath(for: cell)
                if indexPath != nil {
                    let row = (indexPath! as NSIndexPath).row
                    strongSelf.dataList[row].isZan = model?.data.action
                    strongSelf.dataList[row].zanNum = model?.data.num
                    strongSelf.tableView.reloadData()
                    //                    strongSelf.tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .None)
                }
            }
        }
    }
    
    // MARK: - public
    
    func update(_ dataArray: [HotEventDataModel], refreshType: TKDataFreshType) {
        
        switch refreshType {
        case .refresh:
            self.dataList = dataArray 
            self.tableView.reloadData()
            break
        case .loadMore:
            self.dataList = self.dataList + dataArray 
            self.tableView.reloadData()
            
            break
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataList[(indexPath as NSIndexPath).row]
        let height = HotEventListTableViewCel.heightForCell(model)
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = dataList[(indexPath as NSIndexPath).row]
        
        if model.id != nil {
            let vc = HotEventDetailViewController(eventId: model.id)
            vc.hidesBottomBarWhenPushed = true
            navigateTo(vc)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = dataList.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tcellId = HotEventListTableViewCel.Identify
        var tcell = tableView.dequeueReusableCell(withIdentifier: tcellId) as? HotEventListTableViewCel
        if tcell == nil {
            tcell = HotEventListTableViewCel(style: .default, reuseIdentifier: tcellId)
            
        }
        let model = dataList[(indexPath as NSIndexPath).row]
        tcell?.info = model
        tcell?.zanClickAction = {[weak self](isZan, cell) in
            
            self?.zanAction(isZan, idString: model.id, cell: tcell)
        }
        tcell?.expertDetailClickAction = { [weak self](expertId, cell) in
            
            guard let strongSelf = self else {
                return
            }
            
            let vc = LJAddressBookDetailViewController()
            vc.otherUserId = expertId
            strongSelf.navigateTo(vc)
            
        }
        return tcell!
    }
    
    @objc private func updateZan(_ notification : Notification) -> Void {
        let model = notification.object as? HotEventDetailDataModel
        for item in dataList {
            if item.id == model?.id {
                item.zanNum = model?.zanNum
                item.isZan = model?.isZan
                tableView.reloadData()
            }
        }
        
    }
    
    //MARK: 分享
    /**
     分享
     */
    func shareButtonClick(){
        if self.isLoadingFinished {
            var shareView = ShareView(delegate: self, shareObj: nil, hideLanjing: true)
            if AccountManager.sharedInstance.verified() == "1"{
                shareView = ShareView(delegate: self, shareObj: nil, hideLanjing: false)
            }
            
            let window = UIApplication.shared.keyWindow
            shareView.show(window, animated: true)
        }
    }
    
    func shareAction(_ type: ShareType, shareView: ShareView, shareObj: AnyObject?) {
        //分享
        if self.dataList != nil && self.dataList.count > 0 {
            ShareAnalyseManager.sharedInstance().shareHotNewsList(type, info: self.dataList!, shareUrl:self.shareUrl, presentController: self, completion: { [weak self](success, error) -> () in
                
                if success {
                    _ = self?.showToastHidenDefault("分享成功")
                } else {
                    _ = self?.showToastHidenDefault("分享失败")
                }
            })
        }
    }
    
}
