//
//  PushManager.swift
//  news
//
//  Created by chunhui on 15/11/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit
import Foundation
import UserNotifications

// 1是首页小红点，2是讨论区小红点，3是推送通知，  5新的好友小红点 6 私信红点和好友通知 7 我的讨论
@objc enum NotificationType : Int , RawRepresentable {
    case invalid = 0
    case hotNewsRedDot = 1
    case communityRedDot = 2
    case notification = 3
//    case newFriendRedDot = 5
    case privateMsgAndFriendRedDot = 6
    case myTalkRedDot = 7
}

@objc enum HanleJmpFrom : Int {
    case invalid
    case push
    case openurl
}

class PushManager: NSObject  , JPUSHRegisterDelegate {

    static let sharedInstance : PushManager =  PushManager()
    
    struct PushPathConst {
        static let hotnews         = "indx"//首页列表
        static let webUrl          = "wap"//跳转web 页面
        static let friend          = "friend"//好友消息
        static let tweet           = "tweet"//帖子详情
        static let privateMsg      = "pmsg"//私信列表
        static let userDetail      = "user"// 用户详情
        static let systemMsg       = "smsg"// 系统消息
        static let msgZanList      = "msgzan"//点赞列表
        static let msgCommetList   = "msgcmt"//评论列表
        static let msgFollow       = "msgflw"//好友通知
        static let msgAtMeList     = "msgatme"//@ 消息列表
        static let meetDetail      = "meet"//会议列表
        static let newsSignle      = "news_single"//新闻
        static let newsNone        = "news_none"//新闻
        static let newsMultiple    = "news_multiple"//新闻
        static let news            = "news"//新闻
        static let activity        = "activity"//新闻活动
        static let topic           = "topic"//新闻专题
        static let meeting         = "meeting"//会议
        static let schemeInterview = "scheme_interview"//采访数据库
        static let schemeUser      = "scheme_user"//用户数据库
        static let schemeTimeaxis  = "scheme_timeaxis"//采访事件轴
        static let schemeSecretary = "scheme_secretary"//蓝鲸小秘书
        static let schemeMeeting   = "scheme_meeting"//会议
        static let schemeHotEvent  = "scheme_hotevent"//热门事件
        static let hotEvent        = "hotevent"  // 热门事件
        static let hotEventDeail   = "hotevent_detail" //热门事件详情
        static let telegraphList   = "telegraph_list" //电报列表
        static let telegraphDetail   = "telegraph_detail" //电报详情
        
    }
    
    
    private struct JPushConfig {
        
        #if true        
        //线下
        static let appKey = "72cd14ebe004d23904c4e9c7"
        static let appIsProducation = false
        
        #else
        
        //线上
        static let appKey = "3986addf9f6c73372c7c857c"
        static let appIsProducation = true
        
        #endif
        
        static let appChannel = "www.cocoadev.cn"
        
    }
    
    //MARK: - life cycle
    private var pushToken = ""
    private var feedbackList = [PushFeedbackItem]()
    
    //是否来自后台点击推送
    private var isFromBackground = false
    
    func test() {
        
//        //电报推送
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(5)) {
//            self.handleOpenUrl("lanjing://telegraph_detail?article_id=101478&from_push=1&type_id=6&type_name=蓝鲸传媒电报")
//        }
//
//        //新闻推送
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(5)) {
//            self.handleOpenUrl("lanjing://news?from_push=1&id=101459&type_id=10")
//        }
    
    }
    
    override init(){
        super.init()
        
        //测试
//        self.test()
        
        NotificationCenter.default.addObserver(self, selector: #selector(PushManager.userLogin(_:)), name: NSNotification.Name(rawValue: GlobalConsts.kLoginSuccessNotication), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PushManager.userLogout(_:)), name: NSNotification.Name(rawValue: GlobalConsts.kLogoutNotification), object: nil)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func mainNavigationController() -> UINavigationController {
        return AppDelegate.mainController().navigationController!;
    }
    
    func navigateTo(_ viewController: UIViewController, hideNavigationBar: Bool = false)
    {
        mainNavigationController().pushViewController(viewController, animated: true)
        mainNavigationController().isNavigationBarHidden = hideNavigationBar
    }
    
    func initPush( _ launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Void {
        
        //register jpush
        #if arch(x86_64) || arch(i386)
            
        #else

            NotificationCenter.default.addObserver(self, selector: #selector(PushManager.jpushDidLogin(_:)), name: NSNotification.Name.jpfNetworkDidLogin, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(PushManager.jpushAppMessage(_:)), name: NSNotification.Name.jpfNetworkDidReceiveMessage, object: nil)
            
            if #available(iOS 10.0, *){

                let type : UNAuthorizationOptions = [.alert , .badge , .sound]
                let entity = JPUSHRegisterEntity()
                entity.types = Int(type.rawValue)
                JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
                
            }else{

                let type : UIUserNotificationType = [.alert , .badge, .sound]
                JPUSHService.register(forRemoteNotificationTypes: type.rawValue, categories: nil)
                
                //                JPUSHService.registerForRemoteNotificationTypes(type.rawValue, categories: nil)
                
            }
            JPUSHService.setup(withOption: launchOptions, appKey: JPushConfig.appKey, channel: JPushConfig.appChannel, apsForProduction: JPushConfig.appIsProducation)
            
            JPUSHService.resetBadge()
            
            JPUSHService.setLogOFF()

            
//            #if DEBUG
//                JPUSHService.setDebugMode()
//            #endif
            
        #endif
    }
    
    func registerDeviceToken(_ token : Data) {
        
        var content : String = ""
        
        for i in 0..<token.count {
            content.append(String.init(format: "%02x", UInt(token[i])))
        }
        
        self.pushToken = content
        
        JPUSHService.registerDeviceToken(token)
        
    }
    
    
    func handlePush(_ userInfo : [AnyHashable : Any]) {
        
//        print("push user info is: \n\(userInfo)\n\n")
        
        JPUSHService.handleRemoteNotification(userInfo)
        
        let dic = userInfo as! [String :AnyObject]
        if let msgId = dic["msg_id"] as? String {
            
            self.trySendFeedback(msgId)
        }
        
        let state = UIApplication.shared.applicationState
        if state == .background {
            //后台不处理推送
            return
        }
        
        
        let t  = NotificationType(rawValue: (dic["t"]?.intValue ?? 0))
        
        guard let p = dic["p"] as? Dictionary<String,AnyObject> else {
            return
        }
        guard let message = dic["aps"]!["alert"] as? String else {
            return
        }
        
        if t == nil {
            return
        }
        
        isFromBackground = true
        switch t! {
        case .invalid :
            
            break
        case .hotNewsRedDot , .communityRedDot , .privateMsgAndFriendRedDot  , .myTalkRedDot://红点
            
            handleRedDot(t! , param: p )
            
            
        case .notification:
            if let jmp = p["j"] as? String {
                // WARNING need check login
                handlePushWithAppState(jmp,message: message)
//                handleJump(jmp! , from: .push)
            }
//        default:
//            break
        }
        
        isFromBackground = false
    }
    
    func handlePushWithAppState(_ jmpUrl : String,message : String?){
        
        if UIApplication.shared.applicationState == UIApplicationState.active  &&  self.shouldShowAlert(jmpUrl) {
            
            isFromBackground = false
            var title = message
            if (title?.length())! > 42{
                title = (title?.substring(to: (title?.index((title?.startIndex)!, offsetBy: 30))!))! + "...  "
            }
            let alertView = UIAlertView.bk_alertView(withTitle: title) as! UIAlertView
            weak var weakSelf : PushManager? = self
            alertView.bk_addButton(withTitle: "稍等一会") { () -> Void in
                
            }
            
            alertView.bk_setCancelButton(withTitle: "立即查看") { () -> Void in
                
                weakSelf!.handleJump(jmpUrl, from: .push)
            }
            
            alertView.show()
            
            
        }else{
            self.handleJump(jmpUrl, from: .push)
        }
    }
    
    func handleOpenUrl(_ url : String){
        
        handleJump(url, from: .openurl)
    }
    
    func handleJump(_ jmpUrl : String , from : HanleJmpFrom){

        let (path , param) = processSchemeUrl(jmpUrl)
        
        switch path {
            
        case PushPathConst.hotnews:
            
            handleHotNews(param)
            
        case PushPathConst.webUrl :
            
            handleWebUrl(param)
        
        case PushPathConst.friend:
            
            handleFriendMsg(param)
            
        case PushPathConst.tweet :

            handleTweet(param)
            
        case PushPathConst.privateMsg:
            
            handlePrivateMsg(param)
            
        case PushPathConst.userDetail:
            
            handleUserDetail(param)
            
        case PushPathConst.systemMsg:
            handleSystemMsg(param)
            
        case PushPathConst.msgZanList:
            
            handleZanMsg(param)
        
        case PushPathConst.msgCommetList:
            
            handleCommentMsg(param)
            
        case PushPathConst.msgFollow:
            
            handleFollowMsg(param)
            
        case PushPathConst.msgAtMeList:
            
            handleAtMeListMsg(param)
            
        case PushPathConst.meetDetail,PushPathConst.meeting:
            //会议详情 线上活动进入同一页面
            handleMeetDetail(param)
        case PushPathConst.newsNone:
            
            handleNewsDetail(param)
        case PushPathConst.newsSignle:
            
            handleNewsDetail(param)
        case PushPathConst.newsMultiple:
            
            handleNewsDetail(param)
        case PushPathConst.activity:
            
            handleActivityDetail(param)
        case PushPathConst.topic:
            
            handleTopicDetail(param)
            
        case PushPathConst.news:
            handleNewsDetail(param)
            
        case PushPathConst.schemeInterview:
            handleWorkstationInterview()
            
        case PushPathConst.schemeUser:
            handleWorkstationUser()
            
        case PushPathConst.schemeSecretary:
            handleSecretary()
            
        case PushPathConst.schemeTimeaxis:
            handleWrokstationTimeaxis()
            
        case PushPathConst.schemeMeeting:
            handleMeetingList()
        case PushPathConst.schemeHotEvent:
            handleHotEvent(param)
        case PushPathConst.hotEventDeail:
            handleHotEvnetDetail(param)
        case PushPathConst.hotEventDeail:
            handleHotEvnetDetail(param)
        case PushPathConst.telegraphList:
            handleTelegraphList(param)
        case PushPathConst.telegraphDetail:
            handleTelegraphDetail(param)
        // Android端在解析scheme后统计点击事件，为兼容android增加
        case PushPathConst.hotEvent:
            handleHotEvent(param)
            
        default:
            
            if jmpUrl.hasPrefix("http") || jmpUrl.hasPrefix("www") || jmpUrl.hasPrefix("https"){
                //link jump to module web view
                handleWebUrl(["url":jmpUrl])
            }else{
                
                
            }
            
            break
        }
    }
    
    /**
    处理红点
    
    - parameter type: 处理参数
    */
    func handleRedDot(_ type: NotificationType , param: [ String : AnyObject ] ){
        
        let redDotModel = RedDotManager.sharedInstance.redDotModel
        
        switch type {
        case .hotNewsRedDot:
            
            redDotModel?.rec = 1
            
            break
        case .communityRedDot , .myTalkRedDot :

            redDotModel?.circle = 1
            
            break
            
        case .privateMsgAndFriendRedDot:
            
            if let type = param["l"] as? Int {
                
                if type == 2 {
                    //好友通知处有红点
                    redDotModel?.friendMsg = 1
                    
                }else if type == 3 {
                    //表示私信处红点
                    //uid：对应表示和谁私信的小红点
                    let uid = param["uid"] as? Int
                    if uid != nil {
                        redDotModel?.pmsg.fromUid.append(uid!.description)
                    }
                }
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConsts.Notification_MainTabbarMessage), object: nil)
            }
            break
        default:
            return
        }
        
        RedDotManager.sharedInstance.refreshRedDotDisplay()
        
    }
    
    /**
     显示首页推荐
     
     - parameter param: <#param description#>
     */
    private func handleHotNews(_ param: [String : String]){
        
        let tabbarController = AppDelegate.mainController()
        _ = tabbarController.navigationController?.popToRootViewController(animated: true)
        tabbarController.selectedIndex = 1
        
    }
    
    /**
     打开webview
     
     - parameter param: <#param description#>
     */
    private func handleWebUrl(_ param : [String : String]){
        guard let urlString = param["url"]  else {
            return
        }
        
        if urlString.length() == 0 {
            return 
        }
        
        let viewController = TKModuleWebViewController()
        viewController.backImage = UIInitManager.defaultNavBackImage()
        
        viewController.backByStep = true;
        viewController.loadRequest(withUrl: urlString)
        viewController.hidesBottomBarWhenPushed = true
        
        weak var webVC = viewController
        
        viewController.loadWebViewStateHandle = { (controller, state, error) in
            if state == .start {
                if (webVC?.isShowedGif == false) {
                    controller?.showLoadingGif()
                    webVC?.isShowedGif = true
                }
                
            } else if state == .finish || state == .error {
                let subviews = controller?.view.subviews
                for view in subviews! {
                    if view.isKind(of: MBProgressHUD.self) {
                        let hub = view as! MBProgressHUD
                        hub.hide(animated: true)
                    }
                }
            }
            
        }
        
        // viewController.rightImage = UIImage.init(named: "newsdetail_share")
        viewController.rightImages = [UIImage.init(named: "about_us_close")!, UIImage.init(named: "about_us_share")!]
        viewController.style = .image
        viewController.type = .other
        
        viewController.rightBarButtonItemAction = {
            (controller , title, content) in
            _ = controller?.navigationController?.popViewController(animated: true)
        }
        viewController.otherRightBarButtonItemAction = {
            (controller , title, content) in
            var shareView = ShareView(delegate: nil, shareObj: nil, hideLanjing: true)
            // 关于我们 web分享 只向外分享
            if AccountManager.sharedInstance.verified() == "1"{
                shareView = ShareView(delegate: nil, shareObj: nil, hideLanjing: true)
            }
            
            
            weak var vc = controller
            shareView.shareTapAction = {(type, shareView, shareObj) in
                //分享内容，PM确定
                var shareContent : String = ""
                if urlString.contains("static.lanjinger.com/data/page/aboutUs") {
                    shareContent = "提供中国最专业的财经记者工作平台，以及基于平台交互产生的原创财经新闻。"
                } else {
                    if type != .sinaWeibo {
                        shareContent = urlString
                    }
                }
                
                ShareAnalyseManager.sharedInstance().shareWeb(type, presentController: controller!, shareUrl: urlString, shareTitle: title!, shareContent: shareContent,  completion: { (success, error) in
                    if success {
                        vc!.showToastHidenDefault("分享成功")
                    } else {
                        vc!.showToastHidenDefault("分享失败")
                    }
                })
            }
            
            let window = UIApplication.shared.keyWindow
            shareView.show(window, animated: true)
        }
        
        navigateTo(viewController, hideNavigationBar: false)
        
        
    }
    
    /**
     显示帖子详情
     
     - parameter param: <#param description#>
     */
    private func handleTweet(_ param : [String : String]) {
        
        let viewController = TweetDetailViewController()
        let tidString = param["tid"] ?? "0"
        viewController.tid = tidString
        viewController.hidesBottomBarWhenPushed = true
        navigateTo(viewController, hideNavigationBar: false)
    }
    
    /**
     跳转到好友列表
     
     - parameter param: <#param description#>
     */
    private func handleFriendMsg(_ param : [String : String]) {
            
        if let currentVController = UIViewController.topViewController(AppDelegate.mainController()){

            var friendsListController = currentVController.navigationController?.topViewController as? LJFriendsListController
            
            if friendsListController != nil{
                
                //刷新当前页面
                NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConsts.Notification_NewFriend), object: nil)
                
            }else{
                
                //最外面页面不是好友列表
                friendsListController = LJFriendsListController()
                friendsListController!.hidesBottomBarWhenPushed = true
                navigateTo(friendsListController!, hideNavigationBar: false)
            }
        }
    }
    
    /**
     显示私信页面
     
     - parameter param: <#param description#>
     */
    private func handlePrivateMsg(_ param : [String : String]) {

        let redDotManager = RedDotManager.sharedInstance
        let uid: String! = param["uid"]
        var hasUid = false

        for suid in redDotManager.redDotModel!.pmsg.fromUid {
            if uid == suid {
                hasUid = true

            }
        }
        
        if !hasUid {
            redDotManager.redDotModel!.pmsg.fromUid.append(uid)
        }
        
        redDotManager.refreshRedDotDisplay()
        NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConsts.Notification_MainTabbarMessage), object: self, userInfo: param)

        if let currentVController = UIViewController.topViewController(AppDelegate.mainController()) {
            
            var talkViewController = currentVController.navigationController?.topViewController as? LJTalkTableViewController
            
            if talkViewController != nil && talkViewController!.talkingUserId == Int(uid) {
                
                //是当前正在讨论的用户的信息
                NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConsts.Notification_MessageNew), object: self, userInfo: param)
                
            }else{
                
                //最外面页面不是私信讨论页 或者 不是当前用户的讨论页
                talkViewController = LJTalkTableViewController()
                talkViewController!.talkingUserId = Int(uid)!
                talkViewController!.hidesBottomBarWhenPushed = true
                navigateTo(talkViewController!, hideNavigationBar: false)
            }
        }
    }

    
    /**
     显示用户详情 (deprecated)
     
     - parameter param: <#param description#>
     */
    private func handleUserDetail(_ param : [String : String]) {

        if let currentVController = UIViewController.topViewController(AppDelegate.mainController()){
            
             var userDeatilViewController = currentVController.navigationController?.topViewController as? LJUserDeltailViewController
            let uidString = param["uid"]
            
            if userDeatilViewController != nil && userDeatilViewController?.uid == uidString{
                
                //刷新页面
                NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConsts.Notification_UserDetailNeedRefresh), object: nil, userInfo: param)
            }else{
                
                userDeatilViewController = LJUserDeltailViewController()
                userDeatilViewController!.uid = uidString
                userDeatilViewController!.hidesBottomBarWhenPushed = true
                navigateTo(userDeatilViewController!, hideNavigationBar: false)
            }
            
        }
        
    }
    
    /**
     跳转到系统通知 (deprecated)
     
     - parameter param: <#param description#>
     */
    private func handleSystemMsg(_ param : [String : String]) {
        
        let controller = SystemNotificationViewController()
        controller.controllerType = .normal
        controller.hidesBottomBarWhenPushed = true
        navigateTo(controller, hideNavigationBar: false)
    }
    
    /**
     跳转到点赞列表 (deprecated）
     
     - parameter param: <#param description#>
     */
    private func handleZanMsg(_ param : [String : String]) {

        if let currentVController = UIViewController.topViewController(AppDelegate.mainController()){
            
            var controller = currentVController.navigationController?.topViewController as? SystemNotificationViewController
            
            if controller != nil && controller!.controllerType == .praise{
                //刷新页面
                NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConsts.Notification_NewSystermNotification), object: nil)
            }else{
                
                controller = SystemNotificationViewController()
                controller!.controllerType = .praise
                controller!.hidesBottomBarWhenPushed = true
                navigateTo(controller!, hideNavigationBar: false)
            }

        }
        
    }
    
    /**
     跳转到评论消息列表
     
     - parameter param: <#param description#>
     */
    private func handleCommentMsg(_ param : [String : String]) {

        if let currentVController = UIViewController.topViewController(AppDelegate.mainController()){
            
            var controller = currentVController.navigationController?.topViewController as? SystemNotificationViewController
            
            if controller != nil && controller!.controllerType == . comment {
                //刷新页面
                NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConsts.Notification_NewSystermNotification), object: nil)
            }else{
                
                controller = SystemNotificationViewController()
                controller!.controllerType = .comment
                controller!.hidesBottomBarWhenPushed = true
                navigateTo(controller!, hideNavigationBar: false)
            }
            
        }
        
    }
    
    /**
     跳转到好友通知
     
     - parameter param: <#param description#>
     */
    private func handleFollowMsg(_ param : [String : String]) {
        
        RedDotManager.sharedInstance.redDotModel?.friendMsg = 1
        NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConsts.Notification_MainTabbarMessage),
            object: self, userInfo: nil)

        if let currentVController = UIViewController.topViewController(AppDelegate.mainController()){
            
            var friendsNotificationController = currentVController.navigationController?.topViewController as? LJFriendsNotificationTableViewController
            
            if friendsNotificationController != nil{
                NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConsts.Notification_NewfriendNotification), object: nil)
            }else{
                friendsNotificationController = LJFriendsNotificationTableViewController()
                friendsNotificationController!.hidesBottomBarWhenPushed = true
                navigateTo(friendsNotificationController!, hideNavigationBar: false)
            }
        }
    }
    
    /**
     跳转到@我的页面
     
     - parameter param: <#param description#>
     */
    private func handleAtMeListMsg(_ param : [String : String]) {
        
    }
    
    /**
     转转到会议详情
     
     - parameter param: <#param description#>
     */
    private func handleMeetDetail(_ param : [String : String]) {
        
        
        let idString = param["id"]
        if (idString != nil) {
            let viewController = LJConferenceDetailViewController()
            viewController.idString = idString!

            viewController.hidesBottomBarWhenPushed = true
            navigateTo(viewController, hideNavigationBar: false)
        }
    }
    
    //新闻详情
    private func handleNewsDetail(_ param : [String : String]) {
        
        let idString: String? = param["id"]
        let fromPush:String = param["from_push"] ?? "0";
        let typeId = param["type_id"] ?? "0"
        
        if isFromBackground {
            self.selectChannelWith(typeId: typeId)
        }
        
        if (idString != nil) {
            let viewController = NewsDetailTableViewController()
            viewController.newsId = idString!
            viewController.isFromPush = fromPush == "1"

            viewController.hidesBottomBarWhenPushed = true
            navigateTo(viewController, hideNavigationBar: false)
        }
        
        isFromBackground = false
    }
    
    private func handleTopicDetail(_ param : [String : String]) {
        
        let idString: String? = param["id"]
        if (idString != nil) {
            let tid = Int(idString!) ?? 0
            let viewController = NewsTopicTableViewController(tid: tid)

            viewController.hidesBottomBarWhenPushed = true
            navigateTo(viewController, hideNavigationBar: false)
        }
    }
    
    private func handleActivityDetail(_ param : [String : String]) {
        
        let idString: String? = param["id"]
        if (idString != nil) {
            let tid = Int(idString!) ?? 0
            let viewController = NewsActivityViewController(tid: tid)

            viewController.hidesBottomBarWhenPushed = true
            navigateTo(viewController, hideNavigationBar: false)
        }
    }
    
    private func handleTelegraphList(_ param : [String : String]){

        let viewController = NewsTelegraphListController()
        viewController.typeId = param["type_id"]
        let title = NSString.init(string: param["type_name"] ?? "蓝鲸电报")
        
        viewController.title = title.replacingPercentEscapes(using: String.Encoding.utf8.rawValue)
        

        viewController.hidesBottomBarWhenPushed = true
        navigateTo(viewController, hideNavigationBar: false)
        
    }
    
    private func handleTelegraphDetail(_ param : [String : String]){
        
        let newsId = param["article_id"] ?? ""
        let title = NSString.init(string: param["type_name"] ?? "蓝鲸电报")

        let typeId = param["type_id"] ?? "0"
        
        let newsVc = NewsTelegraphDetailViewController()
        newsVc.title = title.replacingPercentEscapes(using: String.Encoding.utf8.rawValue)
        let fromPush:String = param["from_push"] ?? "0";
        newsVc.fromPush = fromPush == "1"
        newsVc.newsId = newsId
        newsVc.typeId = typeId
        
        var VCs = mainNavigationController().viewControllers
        
        if isFromBackground {
//            self.selectChannelWith(typeId: typeId)
            let newsListVc = NewsTelegraphListController()
            newsListVc.title = title.replacingPercentEscapes(using: String.Encoding.utf8.rawValue)
            newsListVc.typeId = typeId
            VCs.append(newsListVc)
        }
        
        VCs.append(newsVc)
        
        mainNavigationController().setViewControllers(VCs, animated: true)
        mainNavigationController().isNavigationBarHidden = false
        
        isFromBackground = false
    }
    
    //通过Id选择首页频道
    private func selectChannelWith(typeId:String) {
        let array:[LJConfigDataNewsModel] = ConfigManager.sharedInstance().config.news as! [LJConfigDataNewsModel]
        
        for item in array {
            if Int(typeId) == item.id.intValue {
                AppDelegate.mainController().selectedIndex = 0
                
                let NC:UINavigationController? = AppDelegate.mainController().viewControllers?[0] as? UINavigationController
                let _ = mainNavigationController().popToRootViewController(animated: false)
                let VC:NewsSlideViewController? = NC?.viewControllers[0] as? NewsSlideViewController
                VC?.selectIndex = array.index(of:item) ?? 0
                break
            }
        }
    }
    
    /**
     采访通讯录
     */
    private func handleWorkstationInterview() {
        
        let viewController = LJInterviewUserListViewController()

        viewController.hidesBottomBarWhenPushed = true
        navigateTo(viewController, hideNavigationBar: false)
    }
    
    /**
     用户通讯录
     */
    private func handleWorkstationUser() {
        
        let viewController = LJUserAddressBookViewController()

        viewController.hidesBottomBarWhenPushed = true
        navigateTo(viewController, hideNavigationBar: false)
    }
    
    /**
     时间轴
     */
    private func handleWrokstationTimeaxis() {
        
        let viewController = LJTimeAxisTableViewController()

        viewController.hidesBottomBarWhenPushed = true
        navigateTo(viewController, hideNavigationBar: false)
    }
    
    /**
     蓝鲸小秘书
     */
    private func handleSecretary() {
        
        let viewController = LJTalkTableViewController()

        viewController.hidesBottomBarWhenPushed = true
        viewController.talkingUserId = 2;//2代表后台小秘书
        viewController.talkUserName = "蓝鲸财经小秘书";
        navigateTo(viewController, hideNavigationBar: false)
    }
    
    /**
     会议列表
     */
    private func handleMeetingList() {
        
        let viewController = LJConferenceListViewController()

        viewController.hidesBottomBarWhenPushed = true
        navigateTo(viewController, hideNavigationBar: false)
    }
    
    /**
     工作站-热门事件列表 2016.6.6
     */
    private func handleHotEvent(_ param : [String : String]) {
        
        let shareUrl: String = param["share_url"] ?? ""
        
        let viewController = EventListViewController()

        viewController.shareUrl = shareUrl
        viewController.hidesBottomBarWhenPushed = true
        navigateTo(viewController, hideNavigationBar: false)
    }
    
    /**
     热门事件详情
     */
    private func handleHotEvnetDetail(_ param : [String : String]) {
        
        let idString: String? = param["id"]
        if (idString != nil) {
            let vc = HotEventDetailViewController(eventId: idString!)
            vc.hidesBottomBarWhenPushed = true
            navigateTo(vc)
        }
    }
    
    
    /**
     解析url
     
     - parameter url: 要解析的url
     
     - returns: 返回 path 和 参数
     */
    internal func processSchemeUrl(_ url : String) ->(String , [String : String] ){
        
        var info = [String : String]()
        let prefix = "lanjing://"
        if url.length() == 0 /*|| !url.hasPrefix(prefix)*/ {
            return ("",info)
        }
        
        
        let prefixIndex = url.characters.index(url.startIndex, offsetBy: prefix.length())
        let request = url.substring(from: prefixIndex)
        
        if request.hasPrefix(PushPathConst.webUrl){
            //wap 的url可能包含？等，需特殊处理
            let urlIndex = request.characters.index(request.startIndex, offsetBy: "\(PushPathConst.webUrl)?url=".length())
            let url = request.substring(from: urlIndex)
            
            return ("wap",["url":url])
        }
        
        let range = request.range(of: "?")
        if range != nil  {
            
            let path = request.substring(to: range!.lowerBound)
            
            let param = request.substring(from: range!.upperBound)
            
            let kvs = param.components(separatedBy: "&")
            
            for kv in kvs {
                let kandV = kv.components(separatedBy: "=")
                if kandV.count == 2 {
                    info[kandV[0]] = kandV[1]
                }
            }
            return (path , info);
        }
        
        return (request ,info)
        
    }
    
    private func shouldShowAlert( _ jmpUrl : String) -> Bool {
        
        if let _ =  jmpUrl.range(of: PushPathConst.privateMsg) {
            
            if let currentVController = UIViewController.topViewController(AppDelegate.mainController()) {
                
                if let  talkViewController = currentVController.navigationController?.topViewController as? LJTalkTableViewController {
                    
                    let (_ , param) = processSchemeUrl(jmpUrl)
                    
                    let uid: String! = param["uid"]
                    
                    if  talkViewController.talkingUserId == Int(uid) {
                        
                        
                        return false
                    }
                }
            }
        }
        
        
        return true
    }
    
    
    //MARK: - private
    
    func jpushDidLogin(_ notification: Notification) {
        
        self.pushBind()
    }
    
    func userLogin(_ notification : Notification ){
        
        self.pushBind()
        
    }
    
    func userLogout(_ notification : Notification ){
        
        self.removePushBind()
        
    }
    
    //MARK: - public
    
    /**
    push解除绑定
    */
    func removePushBind() {
        
        let registrationId: String? = JPUSHService.registrationID()
        if registrationId == nil || registrationId!.length() == 0 {
            return
        }
        let uid = "0"
        TKRequestHandler.sharedInstance().pushBind(registrationId , deviceToken: self.pushToken, uid: uid , completion:  {  (sessionDataTask, jsonModel, error) -> Void in
            
            if error != nil {
            } else {
                #if DEBUG
                    NSLog("推送解除绑定成功!")
                #endif
            }
        })
    }
    
    func pushBind(){
        
        let registrationId: String? = JPUSHService.registrationID()
        
        if  registrationId != nil && registrationId!.length() > 0 {
            var uid = AccountManager.sharedInstance.uid()
            if uid.length() == 0 {
                uid = "0"
            }
                        
            TKRequestHandler.sharedInstance().pushBind(registrationId , deviceToken:pushToken , uid: uid , completion:  {  (sessionDataTask, jsonModel, error) -> Void in
                
                if error != nil {
                } else {
                    #if DEBUG
                        NSLog("推送解除绑定成功!")
                    #endif
                }
            })
        }
    }
    
    private func trySendFeedback(_ msgId : String){
        
        for item  in self.feedbackList {
            if item.msgId == msgId {
                return
            }
        }
        
        var item = PushFeedbackItem()
        item.msgId = msgId
        item.timestamp = Date().timeIntervalSince1970
        self.feedbackList.append(item)
        
        self.sendPushFeedback(item)
        
    }
    
    private func sendPushFeedback(_ item : PushFeedbackItem){
        
        TKRequestHandler.sharedInstance().pushFeedbackMsgId(item.msgId, timestamp: item.timestamp, deviceToken: pushToken) { (task, success) in
            if success {
                DispatchQueue.main.async(execute: { 
                    
                   let index = self.feedbackList.index(where: { (pitem) -> Bool in
                        if item.msgId == pitem.msgId {
                            return true
                        }
                        return false
                    })
                    
                    if index != nil {
                        self.feedbackList.remove(at: index!)
                    }
                    
                })
            }
        }
        
    }
    
    //MARK: // jpush delegate
    @available(iOS 10.0 , *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        
        if let _ = notification.request.trigger as? UNPushNotificationTrigger  {
            
            let userInfo = notification.request.content.userInfo
            JPUSHService.handleRemoteNotification(userInfo)
        }
        
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
        
    }
    
    @available(iOS 10.0 , *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
     
        if let _ = response.notification.request.trigger as? UNPushNotificationTrigger  {
            
            let userInfo = response.notification.request.content.userInfo
            JPUSHService.handleRemoteNotification(userInfo)
            self.handlePush(userInfo)
        }
        
        completionHandler()
    }
    
    func jpushAppMessage(_ notification : NSNotification){
        
        //print("push app message is: \(notification.userInfo)\n\n")
        self.handlePush(notification.userInfo!)
        
    }
    
}



struct PushFeedbackItem {
    
    var msgId = ""
    var timestamp : TimeInterval = 0
    
}
