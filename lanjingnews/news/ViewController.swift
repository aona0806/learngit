//
//  ViewController.swift
//  news
//
//  Created by chunhui on 15/11/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

@objc enum TabbarItem : Int {
    case news = 0 //新闻
    case hotNews = 1 //推荐
    case community = 2 //圈子
    case message   = 3 //消息
    case workStation = 4 //工作站
}


class ViewController: UITabBarController , UIGestureRecognizerDelegate,UIAlertViewDelegate,ShareViewProtocol  ,UITabBarControllerDelegate {
    
    private let redDotTagBase = 10000
    private let mobDatas = ["News","HotNews","Community","Message","WorkStation"]
    var showAppRecommend = false //是否显示应用推荐
    
    //private var newsController : NewsViewController? = nil
    
    private var newsSlideViewController: NewsSlideViewController? = nil

    // MARK: - lefecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.addNotifications()
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.addNotifications()
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    private func addNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.userLoginNotification(_:)), name: NSNotification.Name(rawValue: GlobalConsts.kLoginSuccessNotication), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.authenticationNotification(_:)), name: NSNotification.Name(rawValue: GlobalConsts.kAuthenticationNotication), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.userLogoutNotification(_:)), name: NSNotification.Name(rawValue: GlobalConsts.kLogoutNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.registerDoneNotification), name: NSNotification.Name(rawValue: GlobalConsts.kRegisterShowAppRecommend), object: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UIInitManager.initTabbarStyle()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//        self.navigationController?.navigationBar.isTranslucent = true
        
        self.initTabItems()
        self.delegate = self
        self.view.backgroundColor = UIColor.white
        
        requestUserInfo()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        DispatchQueue.main.async {
            self.showAppRecommendView()
        }
        
        
        /**
         弹出认证之后会出现键盘，在这隐藏
         */
        self.view.endEditing(true)


        //检查是否有帮助页  5.2.0删除帮助页
//        self.checkHelpViewIfNeeded()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func keyboardWillShow(_ info: Notification) {
        
    }
    
    /**
     检查是否需要帮助页
     */
    func checkHelpViewIfNeeded() {
        let isNotFirstOpenApp:Bool = UserDefaults.standard.bool(forKey: GlobalConsts.KUserDefaultsFirstOpenTheApp) 
        if !isNotFirstOpenApp {
            UserDefaults.standard.set(true, forKey: GlobalConsts.KUserDefaultsFirstOpenTheApp)
            UserDefaults.standard.synchronize()
            let helpPageView:HelpPageView = HelpPageView.init(frame: UIScreen.main.bounds)
            self.view.addSubview(helpPageView)
        }
    }
    
    private func userIsVerified() -> Bool {
        
        if !AccountManager.sharedInstance.isLogin() {
            return false
        }
        
        if AccountManager.sharedInstance.verified() == "1"{
            return true
        }
        
        return false
    }
    
    
    // MARK: - private
    
    func initTabItems(){
        
        
        var news : TKTabControllerItem? = nil
        var items = [TKTabControllerItem]()
        
        if self.newsSlideViewController == nil {
            news = TKTabControllerItem(controllerName: "NewsSlideViewController", title: "新闻", tabImageName: "tabbar_news_gray" , selectedImageName:"tabbar_news_blue")
            items.append(news!)
        }
        
    
        if self.userIsVerified() {
            
            let recmd = TKTabControllerItem(controllerName: "HotNewsViewController", title: "推荐", tabImageName: "tabbar_love_gray", selectedImageName: "tabbar_love_blue")
            let community = TKTabControllerItem(controllerName: "CommunityViewController", title: "圈子", tabImageName: "tabbar_circle_gray", selectedImageName: "tabbar_circle_blue")
            let message = TKTabControllerItem(controllerName: "LJMessageViewController", title: "消息", tabImageName: "tabbar_message_gray", selectedImageName: "tabbar_message_blue")
            let workstation = TKTabControllerItem(controllerName: "LJWorkStationTableViewController", title: "工作站", tabImageName: "tabbar_workstation_gray", selectedImageName: "tabbar_workstation_blue")
            items.append(recmd!)
            items.append(community!)
            items.append(message!)
            items.append(workstation!)
//            items.append([recmd!,community!,message!,workstation!])

        }

        let navClassName = "LJNavigationController"
        for item in items {
            item.addNavController = true
            item.navContorllerName = navClassName
        }
        
        self.tabBar.backgroundColor = UIColor.white
        var controllers = [UIViewController]()
         controllers.append( contentsOf: TKTabControllerIniter.viewControllers( withItems: items))
        
        if newsSlideViewController == nil {
            let newsNavController = controllers.first as! UINavigationController
            newsSlideViewController = newsNavController.viewControllers.first as? NewsSlideViewController
            
        }else{
            controllers.insert(newsSlideViewController!.navigationController!, at: 0)
            var frame = UIScreen.main.bounds
            if controllers.count > 1 {
                frame.size.height -= (CGFloat(49) + 64)
            }
            newsSlideViewController?.view.frame = frame
            newsSlideViewController?.view.setNeedsUpdateConstraints()
        }

        self.viewControllers = controllers
        
        for nav in controllers {
            if let con = (nav as? UINavigationController)?.viewControllers.first as? LJBaseViewController {
                con.customBackItem = false
            }
        }
        
        if self.viewControllers?.count == 1 {
            self.tabBar.isHidden = true
//            newsSlideViewController!.hidesBottomBarWhenPushed = true
        }else{
            self.tabBar.isHidden = false
//            newsSlideViewController!.hidesBottomBarWhenPushed = false
        }
        
        self.newsSlideViewController?.view.setNeedsUpdateConstraints()
        
        
    }
    
    private func defaultRedDot() -> UILabel {
        
        let width = CGFloat(10)
        
        let label = UILabel(frame: CGRect(x: 0,y: 0,width: width,height: width))
        label.font = UIFont.systemFont(ofSize: width-2)
        label.layer.cornerRadius = width/2
        label.layer.masksToBounds = true
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.backgroundColor = UIColor.red
        
        return label
    }
    
    //请求用户信息
    private  func requestUserInfo(){
        
        let uid = AccountManager.sharedInstance.uid()
        if  uid.length() == 0 {
            //未登录
            return
        }
        TKRequestHandler.sharedInstance().getUserInfo(withUid: uid , finish:  { (task, model, error) -> Void in
            
            if error != nil{
                
            }else if model != nil{
                
                if model?.dErrno.intValue != 0{
                    return
                }
                let isVerified = AccountManager.sharedInstance.isVerified()
                let originalAvatar = AccountManager.sharedInstance.getUserInfo()?.avatar
                
                let userInfo = model?.data
                
                userInfo?.token = AccountManager.sharedInstance.token();
                AccountManager.sharedInstance.updateAccountInfo(userInfo!)
                
                let nowVerified = (userInfo?.verified == "1")
                
                if isVerified != nowVerified {
                   //认证状态发生变化需要更新
                    self.initTabItems()
                }
                if let nowAvatar = userInfo?.avatar {
                    if nowAvatar != originalAvatar {
                        //刷新头像
                        NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConsts.kUserAvatarDidChanged), object: nil)
                    }
                }
                                
            }
        })
    }
    
    private func redDotAtIndex(_ index : TabbarItem) -> UILabel{
        
        let tabIndex = index.rawValue
        var label = self.tabBar.viewWithTag(tabIndex+redDotTagBase) as? UILabel
        if label == nil {
            label = self.defaultRedDot()
            let offset = self.view.width/CGFloat(self.viewControllers!.count)*CGFloat(tabIndex+1) - 20
            
            label?.center = CGPoint(x: offset,y: label!.height-2)
            label?.tag = tabIndex + redDotTagBase
            
            self.tabBar.addSubview(label!)
        }
        
        return label!
        
    }
    
    private func showAppRecommendView(){
        //是否显示应用推荐
        if showAppRecommend {
            self.showAppRecommend = false
            let alert = UIAlertView(title: "", message:"恭喜认证成功！送您10个蓝鲸币\n动动手指，将蓝鲸财经APP分享给好友吧！", delegate: self, cancelButtonTitle: "分享", otherButtonTitles: "取消")
            alert.tag = 1001
            alert.show()
        }
    }
    
    //MARK: 认证成功
    func registerDoneNotification(){
        
        self.showAppRecommend = UserDefaults.standard.bool(forKey: GlobalConsts.kRegisterShowAppRecommend)
        initTabItems()
        
        
        
        showAppRecommendView()
        
        if (self.newsSlideViewController?.navigationController?.viewControllers.count)! > 0 {
           //在新闻详情等页面
            
            DispatchQueue.main.async(execute: {
                
                var controllers = [UIViewController]()
                for  i in 1 ..< self.newsSlideViewController!.navigationController!.viewControllers.count {
                    controllers.append(self.newsSlideViewController!.navigationController!.viewControllers[i])
                }
                for  controller in controllers {
                    controller.hidesBottomBarWhenPushed = true
                    _ = self.newsSlideViewController!.navigationController?.popToRootViewController(animated: false)
                    self.newsSlideViewController?.navigationController!.pushViewController(controller, animated: false)
                }
                
            })
        }
        
    }
    
    private func showAppRecommendTip(){
        
        let share = ShareView(delegate: self, shareObj: nil, hideLanjing: true)
        share.show(self.view.window ,animated:true)
    }
    
    //shareViewDelegate
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        if alertView.tag == 1001 {
            UserDefaults.standard.set(false, forKey: GlobalConsts.kRegisterShowAppRecommend)
            
            
            if buttonIndex == 0{
                DispatchQueue.main.async(execute: { () -> Void in
                    self.showAppRecommendTip()
                })
            }
        }
    }
    
    //MARK: share delegate
    func shareAction(_ type : ShareType , shareView:ShareView , shareObj: AnyObject?) -> Void{
        if(shareObj == nil){
            ShareAppHelper.shareApp(type , self, isShowCoin: true)
        }
    }
    

    //MARK: - public
    
    func showRedDotAtIndex(_ index: TabbarItem){
        
        if validIndex(index){
            let redDot = self.redDotAtIndex(index)
            redDot.isHidden = false
        }
    }
    
    func hideRedDotAtIndex(_ index : TabbarItem){

        if validIndex(index) {
            let redDot = self.redDotAtIndex(index)
            redDot.isHidden = true
        }
    }
    
    //MARK: user login
    func userLoginNotification(_ notification: Notification) {
        
        self.initTabItems()
        self.newsSlideViewController?.updateNaviUserInfoItem()
        
        if let controllers = self.newsSlideViewController?.navigationController?.viewControllers {
            if controllers.count > 1 {
                
                self.tabBar.isHidden = true
                for i in 1 ..< controllers.count {
                    let con = controllers[i]
                    con.hidesBottomBarWhenPushed = true
                }
                self.newsSlideViewController?.navigationController?.setViewControllers(controllers, animated: false)
            }
        }
        
    }
    
    func authenticationNotification(_ notification: Notification) {
        
        var controller: UIViewController!
        let bindCode = AccountManager.sharedInstance.getUserInfo()?.bind_invite_code
        if bindCode == 0{
            controller = AuthenticationTableViewController()
        }else{
            controller = CompleteInfoTableViewController(style:.grouped)
        }
        self.navigateTo(controller)

    }
    
    func userLogoutNotification(_ notification: Notification){
        
        for subController in self.viewControllers! {
            if let nav = subController as? UINavigationController {
                nav.popToRootViewController(animated: false)
            }
        }
        self.newsSlideViewController = nil
        self.initTabItems()
        self.newsSlideViewController?.updateNaviUserInfoItem()
//        self.navigationController?.popToRootViewControllerAnimated(false)
        self.newsSlideViewController?.view.setNeedsUpdateConstraints()
        
    }
    
    private func validIndex(_ index : TabbarItem) -> Bool {
        
        if self.viewControllers == nil || (self.viewControllers?.count)! <= 1 {
            return false
        }
        
        if index.rawValue >= self.viewControllers!.count {
            return false
        }
        return true
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        let redModel = RedDotManager.sharedInstance.redDotModel
        
        if let index  = tabBar.items!.index(of: item){
            
            //统计
            let str = mobDatas[index]
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async(execute: { 
                MobClick.event("Tab_\(str)")
            })
            
            //去掉红点
            let tabIndex = TabbarItem(rawValue: index)
            switch tabIndex! {
            case .hotNews :
                redModel?.rec = 0
            case .community :
                redModel?.circle = 0

            default:
                return
            }
            
            RedDotManager.sharedInstance.refreshRedDotDisplay()
            
        }
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool{
        
        let redModel = RedDotManager.sharedInstance.redDotModel
        
        let item = TabbarItem(rawValue: self.selectedIndex)
        var notificationName = ""
        
        
        if tabBarController.selectedViewController == viewController {
            
            if item == nil {
                return false
            }
            
            switch item! {
            case .news:
                notificationName = GlobalConsts.kNewsRefreshNotification
                
            case .hotNews :
                
                notificationName = GlobalConsts.kHotNewsRefreshNotification
                redModel?.rec = 0
                
            case .community:
                
                notificationName = GlobalConsts.kCommunityRefreshNotification
                redModel?.circle = 0
                
            case .workStation:
                
                notificationName = GlobalConsts.kWorkStationRefreshNotification
                
            default:
                
                return false
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: notificationName), object: nil)
           //当在推荐和圈子页面时，再次点击需要清空红点
            RedDotManager.sharedInstance.refreshRedDotDisplay()
            
            return false
        }
        return true
    }
    
}

