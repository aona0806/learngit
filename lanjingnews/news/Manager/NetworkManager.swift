//
//  NetworkManager.swift
//  news
//
//  Created by chunhui on 15/11/28.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

let Offline = true

class NetworkManager: NSObject , TKRequestHandlerDelegate  {
    
    static let netManagerInstance : NetworkManager = NetworkManager()
    
    class func sharedInstance() -> NetworkManager {
        return netManagerInstance
    }
        
    class func apiHost() -> String {
        #if Offline
            //return "http://123.57.249.33:8056"
//            return "http://devapi.lanjinger.com:8067"
            return "http://test.api.lanjinger.com"
        #else
            return "https://api.lanjinger.com"
        #endif
    }
    
    class func api2Host() -> String {
        #if Offline
            //return "http://123.57.249.33:8058"
            return "http://devapi2.lanjinger.com:8067"
        #else
            return "https://api2.lanjinger.com"
        #endif
    }
    
    class func appHost() -> String {
        #if Offline
            //return "http://123.57.249.33:8055"
            return "http://test.app.lanjinger.com"
        #else
            return "https://app.lanjinger.com"
        #endif
    }
    
    class func appKey() -> String {
        return "100010"
    }
    class func appSecret() -> String {
        return "e853b9b68d83a36cbd706b343f7f25a6"
    }
    
    override init(){
        
        super.init()
        let handler =  TKRequestHandler.sharedInstance()
        handler.timeoutInterval = 20
        handler.delegate  = self
        handler.host = NetworkManager.apiHost()
        handler.extraInfoBlock = userInfoUpdated
        handler.codeSignBlock = LJCodeSignHelper.sign(with:)
        handler.baseParam = self.baseParam()
        
        //initHttps()
    }
    
    func host() -> String! {
        
        return NetworkManager.api2Host()
    }
    
    
    func baseParam() -> [String : String] {
        var baseParam = LJPhoneInfo.phoneInfo()
        
        baseParam?["app_key"] = NetworkManager.appKey()
        baseParam?["app_secret"] = NetworkManager.appSecret()
        
        return baseParam!
    }
    
    func userInfoUpdated() -> [String : String]{
        
        var userInfo = [String : String]()
        
        let uid = AccountManager.sharedInstance.uid()
        let token = AccountManager.sharedInstance.token()
        
        if uid.length() > 0 {
            userInfo[AccountManager.Const.uid] = uid
        }
        if token.length() > 0 {
            userInfo[AccountManager.Const.token] = token
        }
        
        return userInfo
        
    }
    
    fileprivate func initHttps(){
        
        let manager = TKNetworkManager.sharedInstance()
        manager?.loadAllDefaultCers()
        
        
        
    }
    
    func checkError(_ errNo: Int, responseData response: [AnyHashable : Any]? , for forRequest : URLRequest ) {
        
        if errNo >= 10003 && errNo <= 10006 || errNo == 20002 {
        
            let mainViewController = AppDelegate.mainController()
            let currentController = mainViewController.navigationController!.viewControllers.last
            if (currentController != nil && currentController?.isKind(of: LoginRegistViewController.self) == false){
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    if  AppDelegate.mainController().navigationController?.viewControllers.last as? LoginRegistViewController == nil {
                        
                        let controller = LoginRegistViewController()
                        AppDelegate.mainController().navigationController?.pushViewController(controller, animated: true)
                    }
                })
            }

        }
        
    }
    
}
