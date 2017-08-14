//
//  ShareView.swift
//  news
//
//  Created by chunhui on 15/12/7.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit


@objc protocol ShareViewProtocol
{
    func shareAction(_ type : ShareType , shareView:ShareView , shareObj: AnyObject?) -> Void
    @objc optional func cancelAction(_ shareView:ShareView) ->Void
    @objc optional func deleteAction(_ shareView:ShareView,shareObj: AnyObject?) ->Void
}

class ShareView: UIView {

    
    var pane : SharePaneView!
    var shareObj : AnyObject?
    var shareDelegate : ShareViewProtocol?
    
    var shareTapAction:((_ type: ShareType, _ shareView:ShareView , _ shareObj: AnyObject?) -> Void)?
    
    convenience init(delegate:ShareViewProtocol? , shareObj: AnyObject?){
        
        var hideLanjing = false
        if !AccountManager.sharedInstance.isLogin() {
            //用户未登录的时候不现实分享到蓝鲸
            hideLanjing = true
        }
        
        self.init(delegate:delegate,shareObj:shareObj,hideLanjing:hideLanjing)
    }
    
    init(delegate:ShareViewProtocol? , shareObj: AnyObject? , hideLanjing: Bool){
        super.init(frame: CGRect.zero)
        pane = SharePaneView()
        pane.shareTapAction = shareAction
        
        if hideLanjing {
            pane.hideLanjing(hideLanjing)
        }
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        self.shareDelegate = delegate
        self.shareObj = shareObj
        let mask: UIViewAutoresizing = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        self.autoresizingMask = mask
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    func show(_ inView:UIView! , animated: Bool) {
        self.frame = inView.bounds
        if(pane.superview == nil){
            let height = CGFloat(150)
            pane.frame = CGRect(x: 0, y: self.frame.height - height , width: self.frame.width, height: height)
            
            self.addSubview(pane)
        }
        inView.addSubview(self)
        
        if(animated){
            var frame = pane.frame
            
            
            frame.origin.y = self.bounds.maxY
            var oframe = frame
            oframe.origin.y -= frame.height
            
            pane.frame = frame
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.pane.frame = oframe
            });
        }
    }
    
    func dismiss(_ animated: Bool){
        if (animated){
            var frame = pane.frame
            frame.origin.y = self.bounds.maxY
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                //                self.frame = CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))
                self.pane.frame = frame
                }, completion: { (Bool) -> Void in
                    self.removeFromSuperview()
            })
        }else{
            self.removeFromSuperview()
        }
    }
    
    // MARK: share pane delegate
    func shareAction(_ type: ShareType) -> Void {
        self.dismiss(true)
        if self.shareDelegate != nil {
            self.shareDelegate?.shareAction(type, shareView: self, shareObj: self.shareObj)
        } else {
            if self.shareTapAction != nil {
                self.shareTapAction!(type, self, self.shareObj)
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch  = touches.first!
        let touchpoint:CGPoint = touch.location(in: self)
        if (!self.pane.frame.contains(touchpoint)){
            self.dismiss(true);
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
