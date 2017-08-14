//
//  PushManager+News.swift
//  news
//
//  Created by 陈龙 on 16/1/13.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

// MARK: - 做新闻相关跳转
extension PushManager {
    
     /**
     
     新闻页面详情Controller
     :param: url         jump url
     :param: from_sub_id 从首页哪个子sub跳转过来
     
     :returns: 详情controller
     */
    func getNewsDetailViewController(_ url: String? , fromSubId : String? = nil) -> UIViewController? {
        
        let prefix = "lanjing://"
        if url == nil || url?.length() == 0 {
            return nil
        } else if !url!.hasPrefix(prefix) {
//            let moduleWebView = TKModuleWebViewController()
//            moduleWebView.closeTitle = "关闭"
//            moduleWebView.backImage = UIInitManager.defaultNavBackImage()
//            moduleWebView.backByStep = false
//            moduleWebView.loadRequestWithUrl(url)
//            return moduleWebView
            
            let viewController = TKModuleWebViewController()
            viewController.backImage = UIInitManager.defaultNavBackImage()
            
            viewController.backByStep = true;
            viewController.loadRequest(withUrl: url)
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
                // 关于我们、广告 web分享 只向外分享
                if AccountManager.sharedInstance.verified() == "1"{
                    shareView = ShareView(delegate: nil, shareObj: nil, hideLanjing: true)
                }
                
                
                weak var vc = controller
                shareView.shareTapAction = {(type, shareView, shareObj) in
                    //分享内容，PM确定
                    var shareContent : String = ""
                    if url!.contains("static.lanjinger.com/data/page/aboutUs") {
                        shareContent = "提供中国最专业的财经记者工作平台，以及基于平台交互产生的原创财经新闻。"
                    } else {
                        if type != .sinaWeibo {
                            shareContent = url!
                        }
                    }
                    
                    ShareAnalyseManager.sharedInstance().shareWeb(type, presentController: controller!, shareUrl: url!, shareTitle: title!, shareContent: shareContent,  completion: { (success, error) in
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
            return viewController
        } else {
            let info : (String , [String : String]) = self.processSchemeUrl(url!)
            let viewController = newsDetailViewController(info, fromSubId: fromSubId)
            return viewController
        }
    }
    
    
    func newsDetailViewController(_ info : (String , [String : String]), fromSubId: String?) -> UIViewController? {
        let idString = info.1["id"] ?? "0"
        let id = Int(idString) ?? 0
        
        switch info.0 {
        case "news":
            let viewController = NewsDetailTableViewController()
            viewController.newsId = idString
            viewController.fromSubId = fromSubId
            return viewController
        case "topic":
            let viewController = NewsTopicTableViewController(tid: id)
            viewController.fromSubId = fromSubId
            return viewController
        case "activity":
            let viewController = NewsActivityViewController(tid: id)
            viewController.fromSubId = fromSubId
            return viewController
        case "meeting":
            let viewController = LJConferenceDetailViewController()
            viewController.idString = idString
            viewController.fromsubid = fromSubId
            return viewController
        default:
            break
        }
        return nil
    }
    
    func getNewsDetailViewController(_ url: String?, model: LJNewsListDataListModel?) -> UIViewController? {
        
        if url == nil {
            return nil
        } else {
            let info : (String , [String : String]) = self.processSchemeUrl(url!)
            let viewController = newsDetailViewController(info, model: model)
            return viewController
        }
    }
    
    func newsDetailViewController(_ info : (String , [String : String]), model: LJNewsListDataListModel?) -> UIViewController? {
        let idString = info.1["id"] ?? "0"
        let id = Int(idString) ?? 0
        
        switch info.0 {
        case "news":
            let viewController = NewsDetailTableViewController()
            viewController.collectListModel = model
            viewController.newsId = idString
            return viewController
        case "topic":
            let viewController = NewsTopicTableViewController(tid: id)
            viewController.collectListModel = model
            return viewController
        case "activity":
            let viewController = NewsActivityViewController(tid: id)
            viewController.collectListModel = model
            return viewController
        case "meeting":
            let viewController = LJConferenceDetailViewController()
            viewController.idString = idString
            return viewController
        default:
            break
        }
        return nil
        
    }
}
