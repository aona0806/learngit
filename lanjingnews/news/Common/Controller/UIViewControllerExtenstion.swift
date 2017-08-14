//
//  UIViewControllerExtenstion.swift
//  news
//
//  Created by chunhui on 15/12/7.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    
    public func finish(animated : Bool = true)
    {
        guard let controller = self.navigationController?.viewControllers.last else {
            return
        }
        if controller == self {
           let _ = controller.navigationController?.popViewController(animated: animated)
        }
    }
    
    func mainNavigationController() -> UINavigationController {
        return AppDelegate.mainController().navigationController!;
    }
    
    func navigateTo(_ viewController: UIViewController, hideNavigationBar: Bool = false)
    {
        self.navigationController?.isNavigationBarHidden = hideNavigationBar
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func setNavigationRightButton( icon: UIImage, action:Selector)
    {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: icon, style:UIBarButtonItemStyle.plain, target: self, action: action)
    }
    
    func navigationRightButton( title: String, action:Selector)
    {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, style:UIBarButtonItemStyle.plain, target: self, action: action)
    }
}

@objc enum LJCoinShareType: NSInteger {
    case tweet // 帖子分享
    case newsActivity // 新闻活动
    case newsDetail //新闻详情
    case timeaxis //时间轴分享
    case shareAfterVerified //认证成功后分享
    case sendTweet// 首次发布帖子
}

extension UIViewController {
    
    func showEmptyHud() -> MBProgressHUD
    {

        var hud : MBProgressHUD = MBProgressHUD()
        hud  = MBProgressHUD.showAdded(to: self.showHudView(), animated:true)
        hud.bezelView.color = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        
//        hud.activityIndicatorColor = UIColor.black() // 这里更改有风险
//        UIActivityIndicatorView.appearance().tintColor = UIColor.blackColor()
        return hud
    }
    /**
     显示加载中toast信息 正文显示
     
     - parameter label: 显示内容
     
     - returns: 显示的hud
     */
    func showHud(_ label: String) -> MBProgressHUD
    {
        let hud  = MBProgressHUD.showAdded(to: self.showHudView(), animated:true)
        hud.label.text = label
        return hud
    }
    
    /**
     显示加载中toast 信息 正文显示
     
     - parameter label:     显示内容
     - parameter hideDelay: 持续时间
     
     - returns: 显示的hud
     */
    func showHud(_ label: String, hideDelay: Double) -> MBProgressHUD
    {
        let hud  = MBProgressHUD.showAdded(to: self.showHudView(), animated:true)
        hud.label.text = label
        hud.hide(animated: true, afterDelay: hideDelay)
        return hud
    }
    
    /**
     显示加载中toast 内容显示，小字 多行
     
     - parameter label: 显示内容
     
     - returns: 显示的hud
     */
    func showToast(_ label: String) -> MBProgressHUD
    {
        let hud  = MBProgressHUD.showAdded(to: self.showHudView(), animated:true)
        hud.mode = MBProgressHUDMode.text
        hud.detailsLabel.text = label
        return hud
    }
    
    /**
     显示toast 内容显示 小字
     
     - parameter label:     显示内容
     - parameter hideDelay: 持续时间
     
     - returns: 显示hud
     */
    func showToast(_ label: String, hideDelay: Double) -> MBProgressHUD
    {
        let hud  = MBProgressHUD.showAdded(to: self.showHudView(), animated:true)
        hud.mode = MBProgressHUDMode.text
        hud.detailsLabel.text = label;
        hud.detailsLabel.font = GlobalConsts.ToastFont
        hud.hide(animated: true, afterDelay: hideDelay)
        return hud
    }
    
    func showToast(_ label: String, hideDelay: Double, superView: UIView) -> MBProgressHUD
    {
        let hud  = MBProgressHUD.showAdded(to: superView, animated:true)
        hud.mode = MBProgressHUDMode.text
        hud.detailsLabel.text = label;
        hud.detailsLabel.font = GlobalConsts.ToastFont
        hud.hide(animated: true, afterDelay: hideDelay)
        return hud
    }
    
    /**
     显示toast 内容 持续时间默认
     
     - parameter label: 显示内容
     
     - returns: 显示hud
     */
    @discardableResult
    func showToastHidenDefault(_ label: String?) -> MBProgressHUD
    {
        var content = label
        if content == nil || content?.length() == 0 {
            content = "请求失败"
        }
        let hidenDelay = LJUtil.toastInterval(content!)
        let hud = self.showToast(content!, hideDelay: hidenDelay)
        return hud
    }
    
    /**
     显示toast 内容 持续时间默认
     
     - parameter label: 显示内容
     - parameter superView: <#superView description#>
     
     - returns: 显示hud
     */
    func showToastHidenDefault(_ label: String?, isInWindow: Bool) -> MBProgressHUD
    {
        var content = label
        if content == nil || content?.length() == 0 {
            content = "请求失败"
        }
        let hidenDelay = LJUtil.toastInterval(content!)
        
        var showView = self.view
        if isInWindow && self.view.window != nil {
            showView = self.view.window!
        }
        let hud = self.showToast(content!, hideDelay: hidenDelay, superView: showView!)
        return hud
    }
    
    /**
     显示正文  并且返回上级页面
     
     - parameter label:     正文
     - parameter hideDelay: 显示时间
     
     - returns: 
     */
    func showPopHud(_ label: String, hideDelay: Double) -> MBProgressHUD
    { 
        let hud  = MBProgressHUD.showAdded(to: self.showHudView(), animated:true)
        hud.mode = .text
        hud.label.text = label;
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: hideDelay)
        
        return hud
    }
    
    private func showHudView() -> UIView {
        
//        var showView = self.view
//        if self.view.window != nil {
//            showView = self.view.window!
//        }
//        return showView
        return self.view
    }
    
    /**
     弹出蓝鲸币增加提示（VS）
     
     - parameter shareType: 分享平台
     - parameter isSuccess: 是否分享成功
     - parameter type:      分享类型
     - parameter error:     返回错误码
     
     - returns: <#return value description#>
     */
    func showShareCoinToast(_ shareType : ShareType, isSuccess: Bool, type: LJCoinShareType, error: NSError?) -> MBProgressHUD
    {
        var titleFaile: String = "分享失败"
        if shareType == .lanjing {
            titleFaile = error?._domain ?? "分享失败"
        }
        let hud = self.showToastCoinToast(isSuccess, type: type, error: error, titleSuccess: "分享成功", titleFaile: titleFaile) {
        }
        return hud
    }
    
    @discardableResult
    func showLoadingGif( _ containView: UIView? = nil) -> MBProgressHUD {
        
        var view: UIView? = containView
        if containView == nil {
            view = self.showHudView()
        }
        let hud = MBProgressHUD.showAdded(to: view!, animated: true)
        hud.mode = .customView
        
        let superView = UIView()
        hud.customView = superView
        
        superView.backgroundColor = UIColor.clear
        let imageView = UIImageView()
        let image = UIImage.sd_animatedGIFNamed("lanjing_loading")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = false
        imageView.image = image
        superView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(superView)
        }
        
        superView.snp.makeConstraints { (make) in
            make.center.equalTo(hud)
            var width: CGFloat
            var height: CGFloat
            switch GlobalConsts.ScreenType {
            case .screenWidth320:
                width = CGFloat(125)
                height = CGFloat(76)
                break
            case .screenWidth375:
                width = CGFloat(150.0)
                height = CGFloat(91)
                break
            case .screenWidth414:
                width = CGFloat(200)
                height = CGFloat(121)
                break
            }
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
        
        hud.bezelView.backgroundColor = UIColor.clear
        return hud
    }
    
    /**
     蓝鲸币增加提示
     
     - parameter isSuccess:    是否成功
     - parameter type:         分享类型
     - parameter error:        error
     - parameter titleSuccess: 成功提示title
     - parameter titleFaile:   失败提示title
     - parameter block:        toast消失block
     
     - returns: hud
     */
    func showToastCoinToast(_ isSuccess: Bool, type: LJCoinShareType, error: NSError?, titleSuccess: String, titleFaile: String, block: @escaping ()->()) -> MBProgressHUD
    {
        weak var hud  = MBProgressHUD.showAdded(to: self.showHudView(), animated:true)
        hud!.mode = .text
        if (isSuccess) {
            var hidenDelay = LJUtil.toastInterval(titleSuccess)
            hud!.label.text = titleSuccess
            if error == nil {
                var keyid: String!
                switch type {
                case .tweet:
                    keyid = "tweet_repost"
                case .newsActivity:
                    keyid = "tweet_repost"
                case .newsDetail:
                    keyid = "tweet_repost"
                case .timeaxis:
                    keyid = "timeline_share"
                case .shareAfterVerified:
                    keyid = "share_after_verified"
                case .sendTweet:
                    keyid = "send_tweet"
                    
                }
                
                let config = ConfigManager.sharedInstance().config
                var coinString: String! = ""
                if ((config?.hasData) != nil) {
                    let currency = ConfigManager.sharedInstance().config.currency ?? []
                    for model in currency {
                        if (model as AnyObject).keyid == keyid {
                            coinString = (model as AnyObject).gold ?? "1"
                        }
                    }
                }
                let detailString = "蓝鲸币+" + coinString
                let detailAttributeString = NSMutableAttributedString(string: detailString)
                //            detailAttributeString.addAttributes([NSForegroundColorAttributeName:UIColor.redColor()], range: NSMakeRange(3, detailString.length() - 3))
                hud!.detailsLabel.attributedText = detailAttributeString
                
                hidenDelay = LJUtil.toastInterval(titleSuccess + detailString)
            }
            
            let when = DispatchTime.now() + Double((Int64)(UInt64(hidenDelay) * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
        
            DispatchQueue.main.asyncAfter(deadline: when, execute: { 
                hud!.hide(animated: false)
                DispatchQueue.main.async(execute: block)
            })
            
        } else {
            let hidenDelay = LJUtil.toastInterval(titleFaile)
            hud!.label.text = titleFaile
            
            let when = DispatchTime.now() + Double((Int64)(UInt64(hidenDelay) * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
        
            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                hud!.hide(animated: false)
                DispatchQueue.main.async(execute: block)
            })
        }
        
        return hud!
    }
}

extension UIViewController {
    
    func invoke(_ background: @escaping ()->Void)
    {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            background()
        }
    }
    
    func invokeOnUIThread(_ uiThread: @escaping ()->Void)
    {
        DispatchQueue.main.async(execute: {
            uiThread()
        })
    }
    
    func synced(_ lock: AnyObject, closure: () -> ()) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
}

extension UIViewController {
    
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            let nav = tab.navigationController
            if nav?.visibleViewController is ViewController {
                if let selected = tab.selectedViewController {
                    return topViewController(selected)
                }
            } else {
                return nav?.visibleViewController
            }
        }
        
        return base
    }
}
