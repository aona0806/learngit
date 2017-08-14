//
//  TweetCommentHeaderView.swift
//  news
//
//  Created by chunhui on 15/12/8.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

class TweetCommentHeaderView: UIView {

    
    private var relateLabel = UILabel()
    private var bottomLineView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        relateLabel.font = UIFont.systemFont(ofSize: 10)
        relateLabel.textColor = UIColor.rgb(0x737373)
        relateLabel.text = "相关评论"
        
        bottomLineView.backgroundColor = UIColor.rgb(0xd7d7d7)
        
        
        self.addSubview(relateLabel)
        self.addSubview(bottomLineView)
        
        relateLabel.sizeToFit()
        
        relateLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(15)
            make.top.equalTo(4)
        }
        
        bottomLineView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(self.snp.bottom)
            make.height.equalTo(0.5)
        }
        
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
