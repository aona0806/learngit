//
//  PublishBottomBar.swift
//  news
//
//  Created by chunhui on 15/12/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

enum PublishIconType{
    case emoji
}

class PublishBottomBar: UIView {

    var iconTap:((_ type: PublishIconType , _ choose: Bool)->())?
    
    var emojiButton : UIButton? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initItem()
        
        self.layer.borderColor = UIColor.themeGrayColor().cgColor
        self.layer.borderWidth = 0.5
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initItem()
    }
    
    private func initItem(){
        
        if emojiButton == nil {
            emojiButton = UIButton(type: .custom)
            let img = UIImage(named: "emoji_face_blue")
            emojiButton?.setImage(img, for: UIControlState())
            emojiButton?.addTarget(self, action: #selector(PublishBottomBar.tapEmojiAction(_:)), for: .touchUpInside)
            
            self.addSubview(emojiButton!)
        }
    }
    
    
    
    func clearChooseState(){
        
        emojiButton!.isSelected = false
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        emojiButton?.frame = CGRect(x: PublishTweetViewController.Const.horMargin, y: 0, width: 30, height: self.height)
        
    }
    
    
    func tapEmojiAction(_ sender: UIButton){

        sender.isSelected = !sender.isSelected
        iconTap?(.emoji , sender.isSelected)
        
        
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
