//
//  RedDotManager.swift
//  news
//
//  Created by chunhui on 15/11/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit


class RedDotManager: NSObject {

    static let sharedInstance : RedDotManager = RedDotManager()
    
    var pushRedDot = false
    var redDotModel : LJRedDotDataModel? = nil
    var recommendRefreshTime : TimeInterval =  0 {
        didSet{
            UserDefaults.standard.set(recommendRefreshTime, forKey: GlobalConsts.kHotRecommendRefreshTime)
        }
    }
    
    override init() {
        
        super.init()
        
//        let dotNSPath: NSString = TKFileUtil.docPath()
//        let dotPath: String = dotNSPath.stringByAppendingPathComponent("reddot.plist")
//        
//        let fileManager = NSFileManager.defaultManager()
//        if fileManager.fileExistsAtPath(dotPath){
//            
//            let plist = NSDictionary(contentsOfFile: dotPath)!
//            let value = plist["PushRedDot"] as? NSNumber
//            
//            pushRedDot = value!.boolValue
//            
//        }
        
        self.completeReddotModel()
        self.recommendRefreshTime = UserDefaults.standard.double(forKey: GlobalConsts.kHotRecommendRefreshTime)
        addNotifications()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func addNotifications() -> Void {
        
        let notificationCenter: NotificationCenter! = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(RedDotManager.showMessageRedDot(_:)), name: NSNotification.Name(rawValue: GlobalConsts.Notification_MainTabbarMessage), object: nil)
        notificationCenter.addObserver(self, selector: #selector(RedDotManager.logoutNotification(_:)), name: NSNotification.Name(rawValue: GlobalConsts.kLogoutNotification), object: nil)
    }
    
    func showMessageRedDot(_ n: Notification) {
        
        let controller = AppDelegate.appDelegate().viewController
        
        if self.hasMessageRedDot() {
            controller?.showRedDotAtIndex(.message)
        } else {
            controller?.hideRedDotAtIndex(.message)
        }
    }
    
    /**
     * 完善reddot model里面数据
     */
    func completeReddotModel(){
        
        if redDotModel == nil {
            redDotModel = LJRedDotDataModel()
        }
        
        if redDotModel?.pmsg == nil {
            
            redDotModel?.pmsg = LJRedDotDataPmsgModel()
        }
        
        if redDotModel?.pmsg.fromUid == nil {
            
            redDotModel?.pmsg.fromUid = [String]()
            
        }
        
    }
    
    /**
     删除红点列表中的已经阅读或者删除的uid（该方法主要是为了在oc中使用）
     
     - parameter uid: <#uid description#>
     */
    func deleteTalkRedDotWithUid(_ uid: String) -> () {
        
        if  self.redDotModel?.pmsg.fromUid != nil {
            
            let index = self.redDotModel?.pmsg.fromUid.index(of: uid) ?? -1
            if index >= 0 {
                self.redDotModel?.pmsg.fromUid.remove(at: index)
            }
        }
        
    }
    
    func hasMessageRedDot() -> Bool{
        
        if self.redDotModel != nil {
            return (self.redDotModel!.friendMsg?.intValue ?? 0) > 0 || (self.redDotModel!.pmsg?.fromUid.count ?? 0 > 0)
        }
        return false
    }
    
    
    func loadRedDotInfo() {
        
        //load red dot info
        
        if !AccountManager.sharedInstance.isVerified() {
            
            return
        }
        
        TKRequestHandler.sharedInstance().getRedDotInfo(withRedTimestamp: self.recommendRefreshTime.description ,finish:{ [weak self](task, model, error) -> Void in
          
            guard let strongSelf = self else {
                return
            }
            
            if error == nil && model?.data != nil{
                strongSelf.redDotModel = model?.data
                strongSelf.completeReddotModel()
                
//                self.redDotModel?.friendMsg = 1
//                self.redDotModel?.zan = 2
//                self.redDotModel?.rec = 1
//                self.redDotModel?.circle = 1
//                self.redDotModel?.cmt = 2
//                let msg = LJRedDotDataPmsgModel()
//                msg.fromUid = ["1","2","3"]
//                self.redDotModel?.pmsg = msg
                
                
                strongSelf.refreshRedDotDisplay()
            }
            
        })
        
    }
    
    
    func refreshRedDotDisplay(){
        
        let viewController = AppDelegate.mainController()
        
        var showHotNews = false
        var showCircle  = false
        var showMessage = false
        
        if let model = self.redDotModel {
            
            showHotNews = ((model.rec?.intValue ?? 0) > 0)
            showCircle = ((model.circle?.intValue ?? 0) > 0 || (model.zan?.intValue ?? 0) > 0 || (model.cmt?.intValue ?? 0) > 0)
            showMessage = self.hasMessageRedDot()
        }
        
        if showHotNews {
            viewController.showRedDotAtIndex(.hotNews)
        }else{
            viewController.hideRedDotAtIndex(.hotNews)
        }

        if showCircle {
            viewController.showRedDotAtIndex(.community)
        }else{
            viewController.hideRedDotAtIndex(.community)
        }
        
        if showMessage {
            viewController.showRedDotAtIndex(.message)
        }else{
            viewController.hideRedDotAtIndex(.message)
        }
        
    }
    
    func logoutNotification(_ notification : Notification){
        
        self.recommendRefreshTime = 0
        
    }
    
}
