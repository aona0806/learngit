//
//  NSAttributeStringExtension.swift
//  news
//
//  Created by 陈龙 on 16/5/12.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

extension NSAttributedString {

    class func buildAttributeString(_ string: String, lineSpace: CGFloat, foreColor: UIColor, font: UIFont) -> NSAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle();
        paragraphStyle.lineSpacing = lineSpace
        paragraphStyle.alignment = .left
        paragraphStyle.lineBreakMode = .byTruncatingTail
        let attributeDic = [NSFontAttributeName: font,
                            NSForegroundColorAttributeName: foreColor,
                            NSParagraphStyleAttributeName: paragraphStyle]
        let summaryAttributeString = NSAttributedString(string: string, attributes: attributeDic)
        return summaryAttributeString
    }
}
