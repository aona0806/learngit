//
//  AppDelegate.swift
//  news
//
//  Created by chunhui on 15/11/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navController : UINavigationController?
    var viewController : ViewController?
    
    class func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    class func mainController() -> ViewController {
        
        return appDelegate().viewController!
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
//    }
//    
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        PushManager.sharedInstance.initPush(launchOptions)
        UIInitManager.initNavStyle()
        _ = NetworkManager.sharedInstance()
        _ = ShareAnalyseManager.sharedInstance()
        LJLongLinkManager.sharedInstance().autoConnect(3)
        _ = CrashReportManager.sharedInstance()
        
        // 这里先调用redDotManager,避免有红点消息过来，无对象接受改变下方红点
        _ = RedDotManager.sharedInstance
        
        Thread.sleep(forTimeInterval: 1.5)
        
        let rootController = self.window?.rootViewController
        if rootController is ViewController {
            self.viewController = rootController as? ViewController
            navController = UINavigationController(rootViewController: rootController!)
            self.viewController?.navigationController?.setNavigationBarHidden(true, animated: false)
            self.window?.rootViewController = navController
        }
        

        checkUpdateIfNeeded()
        if !checkShowGuide() {
            SplashManager.sharedInstance().checkShowSplash()
        }
        
        if !AccountManager.sharedInstance.isLogin() && !UserDefaults.standard.bool(forKey: GlobalConsts.kNewsNotLoginFirstShowKey){
            self.viewController?.view.addSubview(NewsPushRemindNoLogin())
        }
        
        return true
    }
    
    func  application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
//    }
//    
//    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        let userDefault = UserDefaults.standard
        if !(userDefault.bool(forKey: GlobalConsts.KEverLaunched)) {
            
            userDefault.set(true, forKey: GlobalConsts.KEverLaunched)
            userDefault.set(true, forKey: GlobalConsts.kFirstLaunched)
            userDefault.set(true, forKey: GlobalConsts.kFirstLaunched_NoteSearch)
            userDefault.set(true, forKey: GlobalConsts.kFirstLaunched_noteShare)

        } else {
            userDefault.set(false, forKey: GlobalConsts.kFirstLaunched)
        }
        return true
    }
    
    var updateUrl: URL?
    func checkUpdateIfNeeded(){
        
        LJVersionManager.checkUpdateIfNeeded { (urlString) -> Void in
            self.updateUrl = Urlhelper.tryEncode(urlString)
            let alertView = UIAlertView(title: "版本更新", message: "有新版本啦", delegate: self, cancelButtonTitle: "稍后更新")
            alertView.addButton(withTitle: "立即更新")
            alertView.show()
        }
    }
    
    //检查是否需要引导页
    func checkShowGuide() -> Bool{
        let lastShowVersion:String  = UserDefaults.standard.object(forKey: GlobalConsts.KUserDefaultsUpdateGuidancePage) as? String ?? ""
        
        if lastShowVersion.length() == 0 || lastShowVersion != TKAppInfo.appVersion() {
            let guidancePageView:LJGuidancePageView = LJGuidancePageView.init(frame: UIScreen.main.bounds)
            
            UserDefaults.standard.set(TKAppInfo.appVersion(), forKey: GlobalConsts.KUserDefaultsUpdateGuidancePage)
            UserDefaults.standard.synchronize()
            guidancePageView.drawFistActionRect()
            self.window?.rootViewController?.view.addSubview(guidancePageView)
            self.window?.rootViewController?.view.bringSubview(toFront: guidancePageView)
            
            return true
        }
        return false
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            if self.updateUrl != nil {
                UIApplication.shared.openURL(self.updateUrl!)
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        JPUSHService.resetBadge()
        application.applicationIconBadgeNumber = 0
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //前后台切换同步红点
        RedDotManager.sharedInstance.loadRedDotInfo()
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        PushManager.sharedInstance.registerDeviceToken(deviceToken)
    }

    // MARK: - remotification
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        PushManager.sharedInstance.handlePush(userInfo)
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
//        JPUSHService.showLocalNotification(atFront: notification, identifierKey: nil)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        PushManager.sharedInstance.handlePush(userInfo)
        completionHandler(.newData)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return self.handle(url,app)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return self.handle(url,application)
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        
        return self.handle(url,application)
    }

    private func handle(_ url : URL , _ application : UIApplication) -> Bool {
        if url.description.hasPrefix("lanjing") {
            PushManager.sharedInstance.handleOpenUrl(url.absoluteString)
            return true
        }
        
        return TKShareManager.handleOpen(url)
    }
    
}

