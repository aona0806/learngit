//
//  IconTextControl.swift
//  news
//
//  Created by chunhui on 15/11/26.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

class IconTextControl: UIControl {

    private var iconImageView : UIImageView
    private var titleLabel : UILabel
    var title : String {
        set{
            titleLabel.text = title
        }
        get{
            return titleLabel.text!
        }
    }
    
    init(frame: CGRect , icon : UIImage , iconSize : CGSize , title : String , titleFont : UIFont) {
        iconImageView = UIImageView(image: icon)
        titleLabel = UILabel()
        titleLabel.backgroundColor = UIColor.clear
        super.init(frame: frame)
        iconImageView.frame = CGRect(x: 0, y: 0, width: iconSize.width, height: iconSize.height)
        titleLabel.font = titleFont
    }
    
    required init?(coder aDecoder: NSCoder) {
        iconImageView = UIImageView()
        titleLabel = UILabel()
        super.init(coder: aDecoder)
    }
    
    
    override func sizeToFit() {
        self.titleLabel.sizeToFit()
        
        var frame = self.frame
        frame.size = CGSize(width: iconImageView.width+2+titleLabel.width, height: frame.size.height)
        self.frame = frame
        
    }
    
    
    override func layoutSubviews() {
        
        self.iconImageView.center = CGPoint(x: iconImageView.width/2, y: self.height/2)
        self.titleLabel.left = iconImageView.right + 2
        self.titleLabel.centerY = self.height/2
        
        super.layoutSubviews()
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
