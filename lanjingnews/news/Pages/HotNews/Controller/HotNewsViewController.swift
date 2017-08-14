//
//  HotNewsViewController.swift
//  news
//
//  Created by chunhui on 15/11/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit
/*
* 推荐
*/
@objc class HotNewsViewController: LJBaseViewController {

    var tableView : UITableView?
    var advItems = Array<LJAdDataModel>()
    
    private var titleArrow : UIImageView?
    private var titleRedDotLabel : UILabel?
    
    private var viewModel: TweetViewModel!
    
    private var tweetOperate : TweetOperationDelegate? = nil
    private var tweetList = Array<LJTweetDataContentModel>()
    private var loadingAd = false
    private var loadingTweet = false
    private var lastNavibarBottom = GlobalConsts.NormalNavbarHeight
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.addObservers()
        self.customUserInfoItem = true
        self.customBackItem = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    private func addObservers(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(HotNewsViewController.modifyTweet(_:)), name: NSNotification.Name(rawValue: GlobalConsts.kTweetInfoChangeNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HotNewsViewController.deleteTweet(_:)), name: NSNotification.Name(rawValue: GlobalConsts.kTweetDeleteNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HotNewsViewController.forceRefreshNotification(_:)), name: NSNotification.Name(rawValue: GlobalConsts.kHotNewsRefreshNotification), object: nil)
        
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.tableView = UITableView()
        tableView?.separatorStyle = .none
        
//        tableView?.delegate = self
//        tableView?.dataSource = self
        
        self.view.addSubview(tableView!)
        
        tableView?.snp.makeConstraints({ (make) -> Void in
            
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 49, 0))
            
        })
        
        self.viewModel = TweetViewModel(type: TweetViewModel.TweetType.hotNewsType, tableView: self.tableView, tweetList: nil, viewContrller: self)

        self.loadAds()
        self.loadTweets(true)

        self.addRefreshView(tableView!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
                
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewModel.startScroll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.startScroll()
    }
    
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        if lastNavibarBottom != self.navigationController!.navigationBar.height {
            
            self.viewModel.updateDate(self.tweetList)
            lastNavibarBottom = self.navigationController!.navigationBar.height
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func headRefreshAction() {
        self.loadAds()
        self.loadTweets(true)
    }
    
    override func footRefreshAction() {
        self.loadTweets(false)
    }
    
    
    override func refreshAction() {
        //拉取失败点击重新加载
        self.headRefreshAction()
        
    }

    // MARK:- download
    
    func loadAds(){
        if self.loadingAd {
            return
        }
        self.loadingAd = true
        
        TKRequestHandler.sharedInstance().getAdInfoFinish { [weak self](sessionDataTask, model, error) -> Void in
            guard let strongSelf = self else {
                return
            }
            
            if error == nil {
                if model?.data != nil && (model?.data.count)! > 0 {
                    strongSelf.advItems.removeAll()
                    strongSelf.advItems.append(contentsOf: model!.data as! [LJAdDataModel])
                    
                    strongSelf.viewModel.updateAdData(strongSelf.advItems)
                }
            } else {
                
            }
            
            strongSelf.loadingAd = false
            if !strongSelf.loadingTweet {
                strongSelf.stopRefresh(strongSelf.tableView)
            }
        }
    }
    
    func loadTweets(_ loadNew: Bool){
        
        if self.loadingTweet {
            return
        }
        self.loadingTweet = false
        
        var firstId = "0"
        if !loadNew && self.tweetList.count > 0 {
            let model = self.tweetList.last!
            //转发的要用原贴的id
            
            if  model.originTid != nil && model.originTid != "0" {
                firstId = model.originTid!
            }else{
                firstId = model.tid!
            }
        }
        TKRequestHandler.sharedInstance().getNewsTweetListIsNew(loadNew, firstTid: firstId) { [weak self](sessionDataTask, model, error) -> Void in
            guard let strongSelf = self else {
                return
            }
            
            if error == nil {
                
                if loadNew {
                    self!.tweetList.removeAll()
                    //更新红点刷新时间
                    RedDotManager.sharedInstance.recommendRefreshTime = Date().timeIntervalSince1970
                }
                
                let list = model?.data?.content as! [LJTweetDataContentModel]
                strongSelf.tweetList.append(contentsOf: list)
                strongSelf.viewModel.updateDate(strongSelf.tweetList)
                
            } else {
                
                let msg = error?._domain ?? GlobalConsts.NetErrorNetMessage
                
                _ = strongSelf.showToastHidenDefault(msg)
                
            }
                        
            strongSelf.loadingTweet = false
            if !strongSelf.loadingAd {
                strongSelf.stopRefresh(strongSelf.tableView)
            }
        }
    }
    
    // MARK: - show tweet detail info
    func showTweetDetail(_ info : LJTweetDataContentModel){
        
        let controller = TweetDetailViewController()
        controller.tid = info.tid
        controller.hidesBottomBarWhenPushed = true
        navigateTo(controller)
        
    }
        
    // MARK: - Notification Action
    
    func modifyTweet(_ notification : Notification){
        
        if  let tweet = notification.object as? LJTweetDataContentModel {
            
            var index = 0
            for t in self.tweetList {
                if t.tid == tweet.tid {
                    t.comment = tweet.comment
                    break
                }
                index += 1
            }
            if index < self.tweetList.count {
                
                self.viewModel.updateDate(self.tweetList)
            }
            
        }
        
    }
    
    func deleteTweet(_ notification : Notification){
        
        if  let tweet = notification.object as? LJTweetDataContentModel {
            
            var index = 0
            for t in self.tweetList {
                if t.tid == tweet.tid {
                    break
                }
                index += 1
            }
            if index < self.tweetList.count {
                self.tweetList.remove(at: index)
                self.viewModel.updateDate(self.tweetList)
            }
            
        }
        
    }
    
    func forceRefreshNotification(_ ntofication : Notification){
        
        self.tableView?.header.beginRefreshing()
    }
}
