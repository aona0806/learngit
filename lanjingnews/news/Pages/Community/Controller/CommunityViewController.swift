//
//  CommunityViewController.swift
//  news
//
//  Created by chunhui on 15/11/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

@objc class CommunityViewController: BaseViewController
{

    private var titleLabel : UILabel?
    private var titleArrow : UIImageView?
    private var titleRedDotLabel : UILabel?
    
    private var tableView : UITableView?
    
    private var viewModel: TweetViewModel!

    
    private var tweetList = Array<LJTweetDataContentModel>()
    private var reddotModel : CommunityRedDotDataModel?
    private var reddotDetailView : CommunityRedDotDetailView?
    private var tweetOperate : TweetOperationDelegate? = nil
    private var lastNavibarBottom = GlobalConsts.NormalNavbarHeight
    
    // MARK: - lefecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.addObservers()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func addObservers(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(CommunityViewController.modifyTweet(_:)), name: NSNotification.Name(rawValue: GlobalConsts.kTweetInfoChangeNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CommunityViewController.deleteTweet(_:)), name: NSNotification.Name(rawValue: GlobalConsts.kTweetDeleteNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CommunityViewController.forceRefreshNotification(_:)), name: NSNotification.Name(rawValue: GlobalConsts.kCommunityRefreshNotification), object: nil)
        
    }
    
    private func initViews() {
        
        self.tableView = UITableView(frame: self.view.frame, style: .plain)
        tableView?.separatorStyle = .none
        
        
        self.view.addSubview(tableView!)
        tableView?.snp.makeConstraints({ (make) -> Void in
            make.edges.equalTo(self.view.snp.edges)
        })
    }
    
    private func initNavbar(){
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 80, height: 44)
        let labelTitle = UILabel(frame: CGRect(x: 15, y: 11, width: 42, height: 21))
        labelTitle.textColor = UIColor.black
        labelTitle.backgroundColor = UIColor.clear
        labelTitle.font = UIInitManager.navbarTitleFont
        labelTitle.text = "圈子"
        titleView.addSubview(labelTitle)
        
        titleArrow = UIImageView(frame: CGRect(x: labelTitle.frame.maxX, y: 20, width: 8, height: 4))
        let zhuanfaImage  = UIImage(named: "com_nav_arrow")!
        titleArrow!.image = zhuanfaImage
        titleView.addSubview(titleArrow!)
        
        titleRedDotLabel = UILabel(frame: CGRect(x: titleArrow!.right + 5, y: 15, width: 25, height: 15))
        titleRedDotLabel?.layer.cornerRadius = 4;
        titleRedDotLabel?.backgroundColor = UIColor.red
        titleRedDotLabel?.clipsToBounds = true
        titleRedDotLabel?.textColor = UIColor.white
        titleRedDotLabel?.font = UIFont.systemFont(ofSize: 12)
        titleRedDotLabel?.textAlignment = NSTextAlignment.center
        titleRedDotLabel?.isHidden = true
        titleView.addSubview(titleRedDotLabel!)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(CommunityViewController.showRedDotDetail(_:)))
        titleView.addGestureRecognizer(gesture)
        
        self.navigationItem.titleView = titleView
        
        var navImage = UIImage(named:"com_navbar_new_tweet")
        navImage = navImage?.withRenderingMode(.alwaysOriginal)
        if let snavImage = navImage {
            let rightButtonItem = UIBarButtonItem(image: snavImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(CommunityViewController.publishTweet))
            self.navigationItem.rightBarButtonItem = rightButtonItem
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        self.initNavbar()
        self.initViews()
        
        self.addHeaderRefreshView(self.tableView!)
        self.addFooterRefreshView(self.tableView!)
        
        viewModel = TweetViewModel(type: TweetViewModel.TweetType.communityType, tableView: self.tableView, tweetList: nil, viewContrller: self)
        self.loadData(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.refreshRedDot()
        
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        if lastNavibarBottom != self.navigationController!.navigationBar.bottom {
            self.viewModel.updateDate(self.tweetList)
            lastNavibarBottom = self.navigationController!.navigationBar.bottom
        }
    }
    
    // MARK: - ACTION
    
    override func headRefreshAction() {
        
        self.loadData(true)
        
    }
    override func footRefreshAction() {
        
        self.loadData(false)
        
    }
    
    // MARK: - download
    
    private func loadData(_ refresh: Bool) {
        
        var lastTid = ""
        if !refresh && tweetList.count > 0 {
            let model = tweetList.last!
            
            //转发的要用原贴的id
            if  model.originTid != nil && model.originTid != "0" {
                lastTid = model.originTid!
            }else{
                lastTid = model.tid!
            }
                        
        }
        
        TKRequestHandler.sharedInstance().getCommunityTweetListIsNew(refresh, lastTid: lastTid , finish: {[weak self](task, model, error) -> Void in
            
            guard let strongSelf = self else {
                return
            }
            
            if(error != nil){
                
                _ = strongSelf.showToastHidenDefault(error?._domain)

            }else{
                
                if refresh {
                    strongSelf.tweetList.removeAll()
                }
                if let data = model?.data {
                    let tweets = data.content as? [LJTweetDataContentModel]
                    
                    if tweets != nil {
                        strongSelf.tweetList.append(contentsOf: tweets!)
                    }
                }
                strongSelf.viewModel.updateDate(strongSelf.tweetList)
            }
            
            strongSelf.stopRefresh(strongSelf.tableView)
            
        })
        
    }
    
    
    // MARK: - red dot
    private func refreshRedDot(){
        //刷新红点数据
        weak var weakSelf = self
        
        TKRequestHandler.sharedInstance().getCommunityRedDotFinish { (task, model, error) -> Void in
            
            guard let strongSelf = weakSelf else {
                return
            }
            
            if model != nil && error == nil  {
                
                strongSelf.reddotModel = model?.data
                strongSelf.invokeOnUIThread({ () -> Void in
                    
                    var count = 0
                    if(strongSelf.reddotModel != nil){
                        count = Int(strongSelf.reddotModel!.comment) + Int(self.reddotModel!.zan)
                    }
                    
                    if(count > 0){
                        if count < 99 {
                            strongSelf.titleRedDotLabel?.text = String(count)
                        }else{
                            strongSelf.titleRedDotLabel?.text = "99+"
                        }
                        strongSelf.titleRedDotLabel?.isHidden = false
                        
                    }else{
                        strongSelf.titleRedDotLabel?.isHidden = true
                    }

                    //同步红点信息
                    let managerModel = RedDotManager.sharedInstance.redDotModel
                    managerModel?.zan = strongSelf.reddotModel?.zan
                    managerModel?.cmt = strongSelf.reddotModel?.comment
                    //刷新底部红点
                    RedDotManager.sharedInstance.refreshRedDotDisplay()
                    
                })
            }
        }
    }
    
    func showRedDotDetail(_ sender: UIGestureRecognizer){
        
        
        if titleArrow!.isHidden {
            titleArrow!.isHidden = false
        } else {
            titleArrow!.isHidden = true
            
            if self.reddotDetailView == nil {
                let nib = UINib(nibName: "CommunityRedDotDetailView", bundle: nil)
                
                self.reddotDetailView = nib.instantiate(withOwner: self, options: nil)[0] as? CommunityRedDotDetailView
                self.reddotDetailView!.onClick = self.reddotClick
            }else{
                self.reddotDetailView?.isHidden = false
            }
            
            UIApplication.shared.keyWindow?.addSubview(self.reddotDetailView!)
            
            
            if(self.navigationController != nil) {
                if (self.navigationController!.navigationBar.frame.height > 44){
                    reddotDetailView?.bgAnchorYLocationOffset = 20
                }else{
                    reddotDetailView?.bgAnchorYLocationOffset = 0
                }
                reddotDetailView?.setNeedsLayout()
            }
            
            if(self.reddotModel != nil){
                self.reddotDetailView?.readNum = self.reddotModel
            }
            self.event(forName: "Comm_reddot", attr: nil)
        }
    }
    
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
    
    private func reddotClick(_ index : Int){
        
        self.reddotDetailView?.removeFromSuperview()
        self.titleArrow?.isHidden = false
        
        var type = LJSystemNotificationType.comment
        
        switch index {
        case 0:
            //我的讨论
            let discussController = MyDiscussTableViewController()
            discussController.hidesBottomBarWhenPushed = true
            navigateTo(discussController)
            return
            
        case 1:
            type = .comment
            break
        case 2:
            //赞
            type = .praise
            break
        default:
            return
        }
        
        let systemController = SystemNotificationViewController()
        systemController.controllerType = type
        systemController.hidesBottomBarWhenPushed = true
        navigateTo(systemController)
        
    }
    
    //nav bar
    func publishTweet(){
     
        let controller = PublishTweetViewController()
        controller.hidesBottomBarWhenPushed = true
        controller.publishTweetDone = publishNewTweet
        self.event(forName: "Comm_deploy", attr: nil)
        navigateTo(controller)
        
    }
    
    func publishNewTweet(){
        
        self.headRefreshAction()
        self.loadData(true)
        
    }
    
    //refresh notification
    func forceRefreshNotification(_ ntofication : Notification){
        
        self.tableView?.header.beginRefreshing()
    }
    
}
