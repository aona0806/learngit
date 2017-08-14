//
//  MyDollarsHeader.swift
//  news
//
//  Created by 奥那 on 15/12/26.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

class MyDollarsHeader: UIView {
    var contentLabel : UILabel
    let screen_width = UIScreen.main.bounds.size.width
    var dollars : String?{
        didSet{
            setTotalDollars()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        contentLabel = UILabel(frame: CGRect(x: 44, y: 0, width: screen_width - 44, height: 80))
        super.init(coder: aDecoder)
        layoutMySubViews()
    }
    
    override init(frame: CGRect) {
        
        contentLabel = UILabel(frame: CGRect(x: 44, y: 0, width: screen_width - 44, height: 80))
        super.init(frame: frame)
        layoutMySubViews()
        
    }
    
    func layoutMySubViews(){
        let imageView = UIImageView(frame: CGRect(x: 0, y: 23, width: 44, height: 44))
        imageView.contentMode = UIViewContentMode.center
        imageView.backgroundColor = UIColor.clear
        imageView.image = UIImage(named: "myInfo_dollars")
        self.addSubview(imageView)
        
        contentLabel.backgroundColor = UIColor.clear;
        contentLabel.textColor = UIColor(red: 80/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1)
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(contentLabel)
        
        let lineView = UIView(frame: CGRect(x: 0, y: 79, width: screen_width, height: 1))
        lineView.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1)
        self.addSubview(lineView)
        
    }
    
    func setTotalDollars(){
        let text = "总蓝鲸币  " + dollars! + " 个"
        let attriString = NSMutableAttributedString(string: text)
        
        let range = NSMakeRange(6, (dollars?.length())!)
        
        attriString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 246/255.0, green: 120/255.0, blue: 24/255.0, alpha: 1), range: range)
        attriString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 30), range: range)
        
        contentLabel.attributedText = attriString
        
    }

}
