//
//  SharePaneView.swift
//  news
//
//  Created by chunhui on 15/12/7.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

class SharePaneView: UIView {
    
    var sharetoLabel     : UILabel!
    
    var lanjingBtn       : UIButton!
    var lanjingIconBtn   : UIButton!
    
    var wxSessionBtn     : UIButton!
    var wxSessionIconBtn : UIButton!
    var wxFriendsBtn     : UIButton!
    var wxFriendsIconBtn : UIButton!
    
    var sinaWeiboBtn     : UIButton!
    var sinaWeiboIconBtn : UIButton!
    
    var qqBtn        : UIButton!
    var qqIconBtn    : UIButton!
    
    var hideLanjing : Bool = false
    
    var shareTapAction:((_ type: ShareType) -> Void)?
    
    
    func shareTypeButton(_ image : UIImage , title : String , selector : Selector) -> (UIButton , UIButton){
        
        let iconButton = UIButton()
        let textButton = UIButton()
        
        let btnfont = UIFont.systemFont(ofSize: 10)
        let btnTitleColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1.0)
        
        iconButton.setBackgroundImage(image, for: UIControlState())
        iconButton.setBackgroundImage(image, for: UIControlState.selected)
        textButton.setTitle(title, for: UIControlState())
        textButton.titleLabel?.font = btnfont
        textButton.setTitleColor(btnTitleColor, for: UIControlState())
        textButton.addTarget(self, action:selector, for: UIControlEvents.touchUpInside)
        iconButton.addTarget(self, action:selector, for: UIControlEvents.touchUpInside)
        
        return (iconButton,textButton)
    }
    
    init(){
        
        super.init(frame:CGRect.zero)
        
 
        
        sharetoLabel  = UILabel(frame:CGRect.zero)
        
        let textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1.0)
        
        
        sharetoLabel.font = UIFont.systemFont(ofSize: 13)
        sharetoLabel.textColor = textColor
        sharetoLabel.text = "分享到"
        
        let sel = #selector(SharePaneView.shareAction(_:))
        
        //蓝鲸
        var image = UIImage(named: "share_lanjing")
         var (iconButton, textButton) = self.shareTypeButton(image!, title: "蓝鲸财经", selector: sel)
        lanjingIconBtn = iconButton
        lanjingBtn = textButton
        
        //微信好友
        image = UIImage(named: "share_weixin")
        (iconButton, textButton) = self.shareTypeButton(image!, title: "微信好友", selector: sel)
        
        wxSessionIconBtn = iconButton
        wxSessionBtn = textButton
        
        //微信朋友圈
        image = UIImage(named: "share_wx_friend")
        (iconButton, textButton) = self.shareTypeButton(image!, title: "微信朋友圈", selector: sel)
        wxFriendsIconBtn = iconButton
        wxFriendsBtn = textButton

        //微博
        image = UIImage(named: "share_sina")
        (iconButton, textButton) = self.shareTypeButton(image!, title: "微博", selector: sel)
        sinaWeiboIconBtn = iconButton
        sinaWeiboBtn = textButton
        
        //qq
        image = UIImage(named: "share_qq")
        (iconButton, textButton) = self.shareTypeButton(image!, title: "QQ", selector: sel)
        qqIconBtn = iconButton
        qqBtn = textButton
        
        self.addSubview(sharetoLabel)
        self.addSubview(lanjingBtn)
        self.addSubview(wxSessionBtn)
        self.addSubview(wxFriendsBtn)
        self.addSubview(sinaWeiboBtn)
        self.addSubview(qqBtn)
        
        self.addSubview(lanjingIconBtn)
        self.addSubview(wxSessionIconBtn)
        self.addSubview(wxFriendsIconBtn)
        self.addSubview(sinaWeiboIconBtn)
        self.addSubview(qqIconBtn)
        
        
        if !TKShareManager.isQQInstalled() {
            qqBtn.isHidden = true
            qqIconBtn.isHidden = true
        }
        
        if !TKShareManager.isWeixinInstalled() {
            wxSessionBtn.isHidden = true
            wxSessionIconBtn.isHidden = true
            wxFriendsBtn.isHidden = true
            wxFriendsIconBtn.isHidden = true
        }
        
        let mask: UIViewAutoresizing = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleTopMargin]
        self.autoresizingMask = mask
        
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func hideLanjing(_ hide: Bool){
        self.hideLanjing = hide
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        sharetoLabel.sizeToFit()
        var frame = sharetoLabel.frame
        frame.origin = CGPoint(x: 10, y: 22)
        sharetoLabel.frame = frame
        
        let iconBounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        var iconBtns :[UIButton] = []
        var textBtns :[UIButton] = []
        
        if !self.hideLanjing {
            iconBtns.append(lanjingIconBtn)
            textBtns.append(lanjingBtn)
        }
        
        if !wxSessionIconBtn.isHidden{
            iconBtns.append(wxSessionIconBtn)
            iconBtns.append(wxFriendsIconBtn)
            
            textBtns.append(wxSessionBtn)
            textBtns.append(wxFriendsBtn)
        }
        iconBtns.append(sinaWeiboIconBtn)
        textBtns.append(sinaWeiboBtn)
        
        if !qqIconBtn.isHidden{
            iconBtns.append(qqIconBtn)
            textBtns.append(qqBtn)
        }
        
        for btn in iconBtns {
            btn.bounds = iconBounds
        }
        
        for btn in textBtns {
            btn.sizeToFit()
        }
        
        var maxCount = 5;
        if iconBtns.count > maxCount {
            maxCount = iconBtns.count
        }
        
        let margin = CGFloat(self.bounds.width - 20.0-CGFloat(maxCount)*iconBounds.width)/CGFloat(maxCount) + iconBounds.width
        
        let verpadding : CGFloat = sharetoLabel.frame.maxY+12+20
        
        let horpadding = CGFloat(30)
        
        let textVerPadding : CGFloat = verpadding + iconBounds.height/2+15
        
        
        for index in 0  ..< iconBtns.count  {
            let btn = iconBtns[index]
            let centerx : CGFloat = horpadding+CGFloat(CGFloat(index)*(margin))
            btn.center = CGPoint(x: centerx, y: CGFloat(verpadding))
            
            let textBtn = textBtns[index]
            textBtn.center = CGPoint(x: centerx, y: textVerPadding)            
        }
        
    }
    
    
    func shareAction(_ sender: UIButton){
        var type: ShareType
        
        switch sender{
        case lanjingBtn ,lanjingIconBtn:
            type = .lanjing
        case wxFriendsBtn , wxFriendsIconBtn:
            type = .wxFriend
        case wxSessionBtn ,wxSessionIconBtn:
            type = .wxSession
        case sinaWeiboBtn,sinaWeiboIconBtn:
            type = .sinaWeibo
        case qqBtn,qqIconBtn:
            type = .qqFriend
        default:
            return
        }
        
        if shareTapAction != nil {
            shareTapAction!(type)
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
