//
//  UIInitManager.swift
//  news
//
//  Created by chunhui on 15/11/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import Foundation
import UIKit

class UIInitManager: NSObject{
    
    static let navbarTitleFont : UIFont! = UIFont.boldSystemFont(ofSize: 18.0)
    static let themeColor = UIColor.rgb(0x2b97c6)
    
    class func initNavStyle(){
        //        // 设置全局导航栏样式
        let navigationbar : UINavigationBar = UINavigationBar.appearance()
        var barImage = UIImage(named: "navi_theme_bg")
        barImage = barImage?.resizableImage(withCapInsets: UIEdgeInsetsMake(8, 1, 10, 1))
        navigationbar.setBackgroundImage(barImage, for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
//        navigationbar.barTintColor = UIColor.white
        navigationbar.shadowImage = UIImage.init()
        
        navigationbar.titleTextAttributes = [
            NSFontAttributeName: UIInitManager.navbarTitleFont,
            NSForegroundColorAttributeName: UIColor.black
        ]
        
        navigationbar.tintColor = UIColor.white

        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        let backImage : UIImage! = UIImage(named: "navi_back")
        navigationbar.backIndicatorImage = backImage
        navigationbar.backIndicatorTransitionMaskImage = backImage
        navigationbar.backItem?.title = ""
        
        /*
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:
        [UIColor colorWithInteger:0x0093ff]}forState:UIControlStateSelected];
        [[UITabBarItem appearance] setTitleTextAttributes:
        @{NSForegroundColorAttributeName: [UIColor colorWithInteger:0x404040]}forState:UIControlStateNormal];
        [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -3)];
        */
        
        if #available(iOS 9.0, *) {
            UINavigationBar.appearance(whenContainedInInstancesOf: [UIImagePickerController.self]).tintColor = UIColor.black
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UIViewController.self]).setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.black], for: .normal)
        } else {
            
            LJUIInitManagerExtend.navbariOS8Init()

            
        }
        
    }
    
    class func initTabbarStyle() {
        
        let tabbarItem = UITabBarItem.appearance()
        
        var attribute = [String : AnyObject]()
        attribute[NSForegroundColorAttributeName] = UIColor.rgb(0x008dfc) //UIColor.rgba(28, green: 138, blue: 205, alpha: 1.0)
        attribute[NSBackgroundColorAttributeName] = UIColor.rgb(0xc5cdd5)
        
        tabbarItem.setTitleTextAttributes(attribute, for: .selected)
        
    }
    
    class func initCommonStyle(){
        
        let activity = UIActivityIndicatorView.appearance()
        activity.backgroundColor = UIColor.black
    }
    
    class func defaultNavBackImage() -> UIImage? {
        
        return UIImage(named: "navi_back")
        
    }
    
}
