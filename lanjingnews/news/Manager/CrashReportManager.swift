//
//  CrashManager.swift
//  news
//
//  Created by chunhui on 16/1/22.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class CrashReportManager: NSObject , BuglyDelegate{

    struct Const {
        static let appId = "900017909"
        static let appKey = "6j0QRdBcZvcQTLow"
    }
    
    private static let manager : CrashReportManager = CrashReportManager()
        
    class func sharedInstance() ->CrashReportManager {
        
        return manager
    }
    
    override init() {
        super.init()
        
//        #if arch(i386) || arch(x86_64)
//            
//            
//        #else
            //真机才注册
            let config = BuglyConfig()
            config.delegate = self
        
            config.debugMode = false
            Bugly.start(withAppId: Const.appId , config: config)
        
//        #endif
        
        
    }
    
    
    func attachment(for exception: NSException?) -> String? {
        
        var extrainfo = ""
        let uid = AccountManager.sharedInstance.uid()
        if uid.length() > 0 {
            extrainfo.append("uid:\(uid)")
        }
        let controller = AppDelegate.mainController()
        let selIndex = controller.selectedIndex
        extrainfo.append("|tab_index:\(selIndex)")
                
        return extrainfo
    }

    
}
