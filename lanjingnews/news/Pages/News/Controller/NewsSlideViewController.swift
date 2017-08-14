//
//  NewsSlideViewController.swift
//  news
//
//  Created by liuzhao on 16/6/29.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class NewsSlideViewController: TKSwitchSlidePageViewController, TKSwitchSlidePageViewControllerDelegate {

    static let bannerHeight = CGFloat(64)
    
    private var lastNavibarBottom = GlobalConsts.NormalNavbarHeight
    private var lastShowTabbar = false
    
    //自定义导航栏相关
    private var rightBarHeader = UIView()
    private var rightBarHeaderImageView = UIImageView()
    private var rightBarShadowImageView = UIImageView()
    private var navShadowView = UIView()
    
    private var sortBut = UIButton()
    
    private var currentTitle = String()
    
    var selectIndex:Int? = nil{
        didSet{
            self.selected(at: selectIndex!)
        }
    }
    
    
    //pushremind
    private var remindVc = NewsPushRemindViewController()
    
    private  var bannerConfig = LJConfigDataModel()

    private var titleArray = [String]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.isAllowGradualChange = true
        
        self.bannerConfig = ConfigManager.sharedInstance().config
        var newArray: [String] = [String]()
        for newItem in self.bannerConfig.news as! [LJConfigDataNewsModel] {
            newArray.append(newItem.name)
        }
        self.titleArray = newArray
        
        self.delegate = self;
        self.slideSwitchHeight = NewsSlideViewController.bannerHeight
        self.slideItemClass = NewsSwitchSlideItemCollectionViewCell.self
        self.slideEdgeInsets = UIEdgeInsetsMake(24, 50, 4, 50)
        
        rightBarHeader.frame = CGRect.init(x: 0, y: 20, width: 44, height: 44)
        rightBarHeader.left = self.view.left + 6
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(showUserInfo))
        rightBarHeader.addGestureRecognizer(tap)
        
        self.view.addSubview(rightBarHeader)
        navShadowView.frame = CGRect.init(x: 0, y: 63, width: self.view.width, height: 1)
        navShadowView.backgroundColor = UIColor.rgb(0xd3d2d3)
        self.view.addSubview(navShadowView)
        
        rightBarHeaderImageView.frame = CGRect.init(x: 3, y: 5, width: 30, height: 30);
        rightBarHeaderImageView.layer.masksToBounds = true;
        rightBarHeaderImageView.layer.cornerRadius = 15;
        
        sortBut.frame = CGRect.init(x: 0, y: 20, width: 44, height: 44)
        sortBut.setImage(UIImage.init(named: "news_sort_icon"), for: .normal)
        sortBut.addTarget(self, action: #selector(toSortView), for: .touchUpInside)
        sortBut.right = self.view.right
        self.view.addSubview(sortBut)
        
        rightBarShadowImageView.image = UIImage.init(named: "news_nav_shadow")
        rightBarShadowImageView.sizeToFit()
        rightBarShadowImageView.height = sortBut.height
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - initlization
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.slideBackgroundColor = UIColor.white        
        
        rightBarHeader.addSubview(rightBarHeaderImageView)
        
        rightBarShadowImageView.left = 0
        rightBarShadowImageView.top = 0
        sortBut.addSubview(rightBarShadowImageView)
        
        self.updateNaviUserInfoItem()

        NotificationCenter.default.addObserver(self, selector: #selector(forceRefreshNotification(_:)), name: NSNotification.Name(rawValue: GlobalConsts.kNewsRefreshNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(newsConfigChangedNotification(_:)), name: NSNotification.Name(rawValue: GlobalConsts.kAppNewsConfigUpdateNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateNaviUserInfoItem), name: NSNotification.Name(rawValue: GlobalConsts.kUserAvatarDidChanged), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateNewsConfig(_:)), name: NSNotification.Name(rawValue: GlobalConsts.kNewsSortedNotification), object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(5)) {
            [weak self] in
            if self?.selectIndex != nil {
                self?.selected(at: self!.selectIndex!)
            }
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if AccountManager.sharedInstance.isLogin() && AccountManager.sharedInstance.isVerified() {
            self.tabBarController?.tabBar.isHidden = false
        }else{
            self.tabBarController?.tabBar.isHidden = true
        }
        
        if AccountManager.sharedInstance.isLogin() {
            remindVc.checkNeedPushRemind()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        remindVc.cancelShowNeedPushRemind()
    }
    
    func updateNaviUserInfoItem() {
        if AccountManager.sharedInstance.isLogin() {
            let model:LJUserInfoModel  = AccountManager.sharedInstance.getUserInfo()!
            
            rightBarHeaderImageView.sd_setImage(with: LJUrlHelper.tryEncode(model.avatar), placeholderImage: UIImage.init(named:"Logout_defaultAvatar"))
            
            let imageViewV = UIImageView()
            imageViewV.frame = CGRect.init(x: 22, y: 22, width: 16, height: 12)
            rightBarHeader.addSubview(imageViewV)
            
            if model.ukind == "1" {
                imageViewV.image = UIImage.init(named: "tag_v")
            }else if model.ukind == "2" {
                imageViewV.image = UIImage.init(named: "tag_v2")
            }else{
                imageViewV.image = nil
            }
        }else{
            rightBarHeaderImageView.image = UIImage.init(named: "Logout_defaultAvatar")
        }
    }
    
    func updateNewsConfig(_ notification : Notification){
        
        let newArray = notification.object as! [LJConfigDataNewsModel]
        
        self.bannerConfig.news = newArray
        
        var tempArray: [String] = [String]()
        for newItem in self.bannerConfig.news as! [LJConfigDataNewsModel] {
            tempArray.append(newItem.name)
        }
        self.titleArray = tempArray
        
        self.reload()
        self.slideView.update(withItems: tempArray)


        let array = NSMutableArray.init(array: self.titleArray)
        let index = array.index(of: currentTitle)
        self.selectIndex = index 
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        

//        let offset = self.navigationController!.navigationBar.bottom - CGFloat(64.0)
//        let offset = CGFloat(64.0) - self.slideSwitchHeight
//        self.updateSlideViewFrame(offset)
        
        
        if self.tabBarController!.tabBar.isHidden == self.lastShowTabbar || lastNavibarBottom != self.navigationController!.navigationBar.height {
            
            self.lastShowTabbar = !self.tabBarController!.tabBar.isHidden
            
            var tabbarHeight = CGFloat(0.0)
            if lastShowTabbar {
                tabbarHeight = self.tabBarController!.tabBar.height
            }
            
            self.updateCollectionViewFrame(tabbarHeight)
                      
            lastNavibarBottom = self.navigationController!.navigationBar.height
            
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    // MARK: - TKSwitchSlidePageViewControllerDelegate
    func numberofPages() -> Int {
        return self.titleArray.count
    }
    
    func controller(for index: Int) -> UIViewController! {
        var controller : NewsListViewController?
        
        let typeModel = self.bannerConfig.news[index] as! LJConfigDataNewsModel
        
        controller?.view.tag = index
        controller = NewsListViewController(catType: typeModel)
        controller!.pushController = self.onPushController
        //to do add
        controller?.typeModel = self.bannerConfig.news[index] as! LJConfigDataNewsModel
        
        self.addChildViewController(controller!)
        
        return controller!
    }

    public func pageTitles() -> [Any]! {
        return self.titleArray as [Any]!
    }
    
    func willReuse(_ controller: UIViewController!, for index: Int) {
        let listViewController = controller as? NewsListViewController
        let typeModel = self.bannerConfig.news[index] as! LJConfigDataNewsModel
        listViewController!.typeModel = typeModel
        //listViewController!.reload(false)
    }
    
    func tapCurrentItem(_ index: Int, controller: UIViewController!) {
        let listViewController = controller as? NewsListViewController
        listViewController?.reload(true)
    }
    
    func onPushController(_ viewController : UIViewController) -> (){
        
        
        viewController.hidesBottomBarWhenPushed = true
        
        // 4S 以及以下的不显示动画
        let screen = UIScreen.main.bounds
        let animated = (screen.size.width < 321 && screen.size.height < 490) ? false : true
        self.navigationController?.pushViewController(viewController, animated: animated)
        
    }
    
    //refresh notification
    func forceRefreshNotification(_ ntofication : Notification){
        
        let viewController: NewsListViewController! = self.currentShow() as! NewsListViewController        
        viewController.reload(true)
    }
    
    func newsConfigChangedNotification(_ notification : Notification){
        
        self.reload()
        
    }
    
    func toSortView(){

        let currentIndex = self.currentIndex()
        currentTitle = self.titleArray[currentIndex]
        
        let controller = NewsSortedViewController()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller,animated:true)

    }
}
