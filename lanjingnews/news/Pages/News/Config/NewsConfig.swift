//
//  NewConfig.swift
//  news
//
//  Created by 陈龙 on 16/1/6.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class NewsConfig: NSObject {
    
    static var ContentVerticalMargin: CGFloat {
        get {
            var value: CGFloat!
            switch GlobalConsts.ScreenType {
            case .screenWidth320:
                value = CGFloat(10.0)
                break
                
            default:
                value = CGFloat(10.0)
            }
            return value
        }
    }
    
    static var ContentHorizontalMargin: CGFloat {
        get {
            var value: CGFloat!
            switch GlobalConsts.ScreenType {
            case .screenWidth320:
                value = CGFloat(15.0)
                break
                
            default:
                value = CGFloat(15.0)
            }
            return value
        }
    }
    
    static var ContentVerticalSpace : CGFloat {
        get {
            var value: CGFloat!
            switch GlobalConsts.ScreenType {
            case .screenWidth320:
                value = CGFloat(7.0)
            default:
                value = CGFloat(7.0)
            }
            return value
        }
    }
    
    static var ContentHorizontalSpace: CGFloat {
        get {
            var value: CGFloat!
            switch GlobalConsts.ScreenType {
            case .screenWidth320:
                value = CGFloat(10.0)
                break
                
            default:
                value = CGFloat(10.0)
            }
            return value
        }
    }
    
    static let TitleColor = UIColor.rgb(0x000000)
    static var TitleFont: UIFont {
        get {
            var value: UIFont!
            switch GlobalConsts.ScreenType {
            case .screenWidth320:
                value = UIFont.boldSystemFont(ofSize: 14.5)
                break
                
            default:
                value = UIFont.boldSystemFont(ofSize: 17.0)
            }
            return value
        }
    }
    
    static let SummaryColor = UIColor.rgb(0x1b1b1b)
    static var SummaryFont: UIFont {
        get {
            var value: UIFont!
            switch GlobalConsts.ScreenType {
            case .screenWidth320:
                value = UIFont.systemFont(ofSize: 12.0)
                break
                
            default:
                value = UIFont.systemFont(ofSize: 14.0)
            }
            return value
        }
    }
    static var SummaryTopSpace: CGFloat {
        get {
            var value: CGFloat!
            switch GlobalConsts.ScreenType {
            case .screenWidth320:
                value = CGFloat(9.0)
                break
                
            default:
                value = CGFloat(10)
            }
            return value
        }
    }
    static var SummaryLineSpace: CGFloat {
        get {
            var value: CGFloat!
            let offset = SummaryFont.lineHeight - SummaryFont.pointSize
            switch GlobalConsts.ScreenType {
            case .screenWidth320:
                value = CGFloat(6.0) - offset
                break
                
            default:
                value = CGFloat(10.0) - offset
            }
            return value
        }
    }

    
    static let DetailTitleColor = UIColor.rgb(0x020202)
    static let DetailTitleFont = UIFont.boldSystemFont(ofSize: 23)
    
    static let DetailContentColor = UIColor.rgb(0x595959)
    static let DetailContentFont = UIFont.systemFont(ofSize: 18)
    
    static let authorInfoColor = UIColor.rgb(0x7d7d7d)
    static var authorInfoFont: UIFont {
        get {
            var value: UIFont!
            switch GlobalConsts.ScreenType {
            case .screenWidth320:
                value = UIFont.systemFont(ofSize: 10.0)
                break
                
            default:
                value = UIFont.systemFont(ofSize: 12.0)
            }
            return value
        }
    }

    
    static let TimeColor = UIColor.rgb(0x7d7d7d)
    static let TimeFont = NewsConfig.authorInfoFont
    static var TimeHeight: CGFloat = NewsConfig.TimeFont.lineHeight
    static var TimeLeftSpace: CGFloat {
        get {
            var value: CGFloat!
            switch GlobalConsts.ScreenType {
            case .screenWidth320:
                value = CGFloat(13)
                break
                
            default:
                value = CGFloat(14)
            }
            return value
        }
    }

    
    static let ReadNumColor = NewsConfig.authorInfoColor
    static var ReadNumFont: UIFont {
        get {
            var value: UIFont!
            switch GlobalConsts.ScreenType {
            case .screenWidth320:
                value = UIFont.systemFont(ofSize: 9.0)
                break
            default:
                value = UIFont.systemFont(ofSize: 11.0)
            }
            return value
        }
    }
    
    static var TagFont: UIFont {
        get {
            var value: UIFont!
            switch GlobalConsts.ScreenType {
            case .screenWidth320:
                value = UIFont.systemFont(ofSize: 9)
                break
                
            default:
                value = UIFont.systemFont(ofSize: 11)
            }
            return value
        }
    }
 
    static let TagWidth: CGFloat = NewsConfig.TimeHeight / 12 * 25
    static let TagHeight: CGFloat = TimeHeight
    static let TagDefaultColor: UIColor = UIColor.rgb(0x848282)
    
// /// 活动、会议图片长宽比例
//    static let PostImageRatio: CGFloat = 360 / 690
// /// 新闻图片长宽比
//    static let ImageRatio: CGFloat = 148 / 226
    
    /// 专题、活动、会议图片长宽比例
    static let PostImageRatio: CGFloat = 4 / 7.0
    /// 新闻图片长宽比
    static let ImageRatio: CGFloat = 2 / 3.0
    
    static let SeperateLineLeftSpace: CGFloat = 15
    static let SeperateLineRightSpace: CGFloat = 15
    
    static let ButtonTextColor = UIColor.rgb(0xffffff)
    static let ButtonTextFont = UIFont.systemFont(ofSize: 20)
    
    static let NavbarSize: CGFloat = CGFloat(22)
    
    static let SeperateLineColor = UIColor.rgba(230, green: 229, blue: 234, alpha: 1)
}
