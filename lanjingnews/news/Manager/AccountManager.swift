//
//  AccountManager.swift
//  news
//
//  Created by chunhui on 15/12/21.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

/// 账号管理
class AccountManager: NSObject {

    struct Const {
        static let uid = "uid"
        static let token = "token"
    }
    
    static let sharedInstance =  AccountManager()
    
    private var userInfo : LJUserInfoModel? = nil
    
    override init() {
        super.init()
        setUserInfo()
    }
    
    func setUserInfo(){
        if userInfo == nil{
            let path = self.cachePath()
            let fm = FileManager.default
            if fm.fileExists(atPath: path){
                userInfo = NSKeyedUnarchiver.unarchiveObject(withFile: path) as?  LJUserInfoModel
            }
        }
    }
    
    func getUserInfo() -> LJUserInfoModel? {
        
        return userInfo
    }

    
    func isLogin() -> Bool {
        
        if userInfo != nil && (userInfo!.uid?.length())! > 0 {
            return true
        }
        
        return false
    }
    
    func isVerified() -> Bool {
        
        if let info = self.userInfo {
            return info.verified == "1"
        }
        return false
    }
    
    func uid() -> String {
        if userInfo != nil {
            return userInfo!.uid!
        }
        return ""
    }
    
    func token() -> String {
        if userInfo != nil {
            return userInfo!.token!
        }
        return ""
        
    }
    
    /**
     获取用户姓名（当用户未注册是为nickname,注册用户：sname)
     
     - returns: <#return value description#>
     */
    func userName() -> String {
        
        if userInfo == nil {
            return ""
        }
        
        if userInfo?.verified == "1" {
            return userInfo!.sname!
        }
        return userInfo!.nickname!
    }
    
    func verified() -> String {
        
        if let verify = userInfo?.verified {
            return verify
        }
        return ""
        
    }
    
    func updateToken(_ token : String , forUid: String){
        if forUid == self.uid() {
            self.userInfo?.token = token
            save()
        }
    }

    func updateVerified(_ verified : String , forUid: String){
        if forUid == self.uid() {
            self.userInfo?.verified = verified
            save()
        }
    }
    
    func updateUid(_ uid : String){
        self.userInfo?.uid = uid
        save()
    }
    
    func updateDollars(_ gold:String , foUid:String){
        if foUid == self.uid(){
            self.userInfo?.gold = gold
            save()
        }
    }
    
    func updateAvatar(_ avatar:String , foUid:String){
        if foUid == self.uid(){
            self.userInfo?.avatar = avatar
            save()
        }
    }
    
    func updateAccountInfo(_ info : LJUserInfoModel) {

        self.userInfo = info

        self.save()
        
    }
    
    func save(){
        
        if userInfo != nil {
            let data = NSKeyedArchiver.archivedData(withRootObject: self.userInfo!)
            _ = try? data.write(to: URL(fileURLWithPath: self.cachePath()), options: [.atomicWrite])
//            try? data.write(to: URL(fileURLWithPath: self.cachePath()), options: [.dataWritingAtomic])
        }
        
    }
    
    func logout(){
        
        self.userInfo = nil
        let path = self.cachePath()
        let fm = FileManager.default
        if fm.fileExists(atPath: path){
            
            do {
                try fm.removeItem(atPath: path)
            } catch  {
//                print("remove cache \(path) failed")
            }
            
        }
        
    }
    
    
    private func cachePath() -> String{
        
        var path  = TKFileUtil.docPath()
        if !(path?.hasSuffix("/"))!{
            path?.append("/")
        }
        path?.append("userinfo.data")
        
        return path!
    }
    
    
}
