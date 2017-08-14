//
//  LJSeperateLineView.swift
//  news
//
//  Created by 陈龙 on 16/1/11.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class LJSeperateLineView: UIView {

    enum LJSeperateLineType {
        
        case top
        case bottom
        case both
    }
    
    var lineType: LJSeperateLineType = .both
    
    init(type: LJSeperateLineType) {
        self.lineType = type
        borderColor = UIColor.lightGray.cgColor
        
        super.init(frame: CGRect.zero)
    }
    
    var borderColor: CGColor

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setStrokeColor(borderColor)
        
        context?.setLineCap(.square)
        context?.setLineWidth(0.5)
        
        context?.beginPath()
        
        if lineType == .top || lineType == .both {
            context?.move(to: CGPoint.init(x: 0, y: 0))
            context?.addLine(to: CGPoint.init(x: rect.size.width, y: 0))
        }
        
        if lineType == .bottom || lineType == .both {
            context?.move(to: CGPoint.init(x: 0, y: rect.size.height))
            context?.addLine(to: CGPoint.init(x: rect.size.width, y: rect.size.height))
        }
        context?.strokePath()
    }

}
