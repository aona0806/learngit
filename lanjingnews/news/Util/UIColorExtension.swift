//
//  UIColorUtil.swift
//  news
//
//  Created by chunhui on 15/11/26.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import Foundation

extension UIColor {
    
    static func rgb(_ c: UInt) -> UIColor
    {
        let r = CGFloat((c >> 16) % 256);
        let g = CGFloat((c >> 8) % 256);
        let b = CGFloat((c) % 256);
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
    }
    
    static func argb(_ c: UInt) -> UIColor
    {
        let a = CGFloat((c >> 24) % 256);
        let r = CGFloat((c >> 16) % 256);
        let g = CGFloat((c >> 8) % 256);
        let b = CGFloat((c) % 256);
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a/255.0)
    }
    
    static func rgba(_ red: Int,green: Int,blue: Int, alpha a : CGFloat) -> UIColor
    {
        let r = CGFloat(red) / CGFloat(255.0)
        let g = CGFloat (green) / CGFloat(255.0)
        let b = CGFloat (blue) / CGFloat(255.0)
        return UIColor(red: r ,green: g, blue: b, alpha: a)
    }
    
    static func colorFromHexString(_ colorString: String?, defaultColor: UIColor!) -> UIColor
    {
        
        if colorString == nil {
            return defaultColor
        }
        var cString:String = colorString!.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.hasPrefix("0X")) {
            cString = (cString as NSString).substring(from: 2)
        }
        
        if (cString.length() != 6) {
            return defaultColor
        }
        
        let colorUInt = UInt(cString, radix: 16)
        if colorUInt == nil {
            return defaultColor
        } else {
            let color = UIColor.rgb(colorUInt!)
            return color
        }
    }
    
}

extension UIColor {
        
    static func themeBlueColor() -> UIColor
    {
        let color = UIColor.rgba(49, green: 105, blue: 148, alpha: 1)
        return color
    }
    
    
    static func themeGrayColor() -> UIColor
    {
        return UIColor.gray
    }
    static func themeLightGrayColor() -> UIColor
    {
        return UIColor.lightGray
    }
    
    static func themeDarkGrayColor() -> UIColor {
        return UIColor.darkGray
    }
    
    static func themeSplitLineColor() -> UIColor {
        
        return UIColor.rgb(0xdddddd)
    }
    
}
