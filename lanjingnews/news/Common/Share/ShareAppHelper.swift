//
//  LJShareAppHelper.swift
//  news
//
//  Created by chunhui on 15/9/1.
//  Copyright (c) 2015年 lanjing. All rights reserved.
//

import Foundation

class ShareAppHelper : NSObject {
    
    static func shareApp(_ type : ShareType , _ presentController : UIViewController, isShowCoin: Bool = false){

        let data = TkShareData()
        data.url = "https://app.lanjinger.com/home/download"
        data.title = "蓝鲸财经记者工作平台"
        var contentString: String!
        if isShowCoin {
            contentString = "今天开始入驻了蓝鲸财经记者工作平台，再也不担心主编催稿了！你也值得拥有，一起加入吧。"
        } else {
            contentString = "我已注册蓝鲸财经，和全国6000名记者一起工作，你在哪里？"
        }
        if type == .wxFriend {
            data.title = contentString
        } else {
            data.shareText = contentString
        }

        data.shareImage = UIImage(named:"share_icon")
//        data.urlResource = data.url
        
        //微博改为图片分享
        if type == .sinaWeibo {
            data.shareType = .image
        }

        let TKtype = ShareAnalyseManager.toTkShareType(type)
        TKShareManager.postShare(to: TKtype, shareData: data, presentedController: presentController) { ( success : Bool) -> Void in
            
            if success {
                if isShowCoin {
                    ShareAnalyseManager.shareReport(AccountManager.sharedInstance.uid(), contentType: .registerRecommend, sharetype: type, completion: { (asuccess, aerror) in
                        if asuccess {
                            _ = presentController.showShareCoinToast(type, isSuccess: success, type: .shareAfterVerified, error: aerror)
                        } else {
                            let toastString = success ? "分享成功" : "分享失败"
                            _ = presentController.showToastHidenDefault(toastString)
                        }
                        
                    })
                } else {
                    let toastString = success ? "分享成功" : "分享失败"
                    _ = presentController.showToastHidenDefault(toastString)
                }
            } else {
                let toastString = success ? "分享成功" : "分享失败"
                _ = presentController.showToastHidenDefault(toastString)
            }
            
        }
    }
    
}
