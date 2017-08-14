//
//  NewsTagLabel.swift
//  news
//
//  Created by chunhui on 16/1/9.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class NewsTagLabel: UILabel {
    
    var borderColor : UIColor! = UIColor.white
    var borderWidth : CGFloat = CGFloat(0.5)
    var cornerRadius: CGFloat = 2.0
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        
        let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setStrokeColor((self.borderColor?.cgColor)!)
        context!.setLineWidth(borderWidth)
        context!.addPath(path.cgPath)
        context!.setAllowsAntialiasing(true)
        context!.strokePath()
    }
    
}
