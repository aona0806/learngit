//
//  HotEventDetailViewController.swift
//  news
//
//  Created by 陈龙 on 16/6/3.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit
import SnapKit

class HotEventDetailViewController: BaseViewController, HotEventDetailHeaderViewDelegate, UITableViewDelegate, UITableViewDataSource, ShareViewProtocol {

    private var dataList: [HotEventDataExpertRecListModel]! = [HotEventDataExpertRecListModel]()
    
    var HeaderInSectionHeight = 10
    
    private var eventId: String!
    private var tableHeaderView: HotEventDetailHeaderView!
    private var tableFooterView: HotEventDetailFooterView!
    
    private let tableView = UITableView()
    
    private var dataModel: HotEventDetailDataModel?
    
    //MARK: 是否加载完毕
    private var isLoadingFinished: Bool = false
    
    // MARK: - lifecycle
    
    init(eventId: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.eventId = eventId
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initNavigationbar()
        initView()
        initViewConstraints()
        getHotEventDetail(idString: self.eventId)
    }
    
    // MARK: - private
    
    private func initNavigationbar(){
        
        let shareItem = UIBarButtonItem.createItem(withTarget: self, action: #selector(HotEventDetailViewController.shareButtonClick),image: "newsdetail_share")
        
        self.navigationItem.rightBarButtonItem = shareItem
        
        self.title = "专家推荐详情"
    }
    
    func initView() -> Void {
        
        tableHeaderView = HotEventDetailHeaderView(delegate: self)
        tableFooterView = HotEventDetailFooterView()
        tableFooterView.zanClickAction = {[weak self](action, view) in
            
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.zanAction(action, idString: strongSelf.eventId)
        }
        
        tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.view.addSubview(tableView)
    }
    
    func initViewConstraints() -> Void {
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets.zero)
        }
    }
    
    // MARK: - download
    
    func getHotEventDetail(idString: String) -> Void {
        isLoadingFinished = false
        
        let hud = self.showLoadingGif()
        TKRequestHandler.sharedInstance().getHotEventDetail(withId: idString) { [weak self](task, model, error) in
            hud.hide(animated: true)
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.isLoadingFinished = true
            if error != nil {
                _ = strongSelf.showToastHidenDefault(error?._domain)
            } else {
                
                strongSelf.dataModel = model?.data
                strongSelf.tableHeaderView.info = model?.data
                strongSelf.tableFooterView.info = model?.data
            }
        }
    }
    
    // MARK: - action
    
    func zanAction(_ action: Bool, idString: String!) -> Void {
        
        TKRequestHandler.sharedInstance().getEventZan(withId: idString, iszan: action) { [weak self](task, model, error) in
            guard let strongSelf = self else {
                return
            }
            
            if error != nil {
                _ = strongSelf.showToastHidenDefault(error?._domain)
            } else {
                
                strongSelf.dataModel?.isZan = model?.data.action
                strongSelf.dataModel?.zanNum = model?.data.num
                strongSelf.tableFooterView.info = strongSelf.dataModel
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConsts.Notification_HotEventZan), object: strongSelf.dataModel)
            }
        }
    }

    // MARK: - HotEventDetailHeaderViewDelegate
    
    func contentWebViewDidLoad(_ view: HotEventDetailHeaderView) -> Void {
        
        tableView.tableHeaderView = tableHeaderView
        let expertRecList = dataModel?.expertRecList as? [HotEventDataExpertRecListModel] ?? []
        update(expertRecList, refreshType: .refresh)
        tableView.tableFooterView = tableFooterView

    }
    
    func update(_ dataArray: [HotEventDataExpertRecListModel], refreshType: TKDataFreshType) {
        
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
        let height = HotEventExpertTableViewCell.heightForCell()
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = dataList[(indexPath as NSIndexPath).row]
        
        let vc = LJAddressBookDetailViewController() 
        vc.otherUserId = model.id
        navigateTo(vc)
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
        
        let tcellId = HotEventExpertTableViewCell.Identify
        var tcell = tableView.dequeueReusableCell(withIdentifier: tcellId) as? HotEventExpertTableViewCell
        if tcell == nil {
            tcell = HotEventExpertTableViewCell(style: .default, reuseIdentifier: tcellId)
            
        }
        let model = dataList[(indexPath as NSIndexPath).row]
        tcell?.info = model
        return tcell!
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
        if self.dataModel != nil {
            ShareAnalyseManager.sharedInstance().shareHotNewsDetail(type, info: self.dataModel!, presentController: self, completion: { [weak self](success, error) -> () in
                
                if success {
                    _ = self?.showToastHidenDefault("分享成功")
                } else {
                    _ = self?.showToastHidenDefault("分享失败")
                }
            })
        }
    }
}
