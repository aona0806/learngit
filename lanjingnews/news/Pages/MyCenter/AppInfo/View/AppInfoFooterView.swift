//
//  AppInfoFooterView.swift
//  news
//
//  Created by 奥那 on 16/1/4.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class AppInfoFooterView: UIView {
    
    private let screenWidth = UIScreen.main.bounds.size.width
    let sender:UIButton?
    
    var clickAction:(() -> ())? = nil
    
    required init?(coder aDecoder: NSCoder) {
        sender = UIButton(type: UIButtonType.system)
        
        super.init(coder: aDecoder)
        customSubviews()
    }
    
    override init(frame: CGRect) {
        sender = UIButton(type: UIButtonType.system)
        super.init(frame: frame)
        
        customSubviews()
    }
    
    func customSubviews(){

        let backView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 80))
        backView.backgroundColor = UIColor.rgb(0xe8e8e8)
        self.addSubview(backView)
        
        sender?.frame = CGRect(x: 10, y: 20, width: screenWidth - 20, height: 40)
        sender?.layer.cornerRadius = 5
        sender?.layer.masksToBounds = true
        sender?.setBackgroundImage(UIImage(named: "login_button"), for: UIControlState())
        sender?.setTitleColor(UIColor.rgb(0xFFFFFF), for: UIControlState())
        sender?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        sender?.setTitle("退出", for: UIControlState())
        sender?.addTarget(self, action: #selector(AppInfoFooterView.signoutAction), for: UIControlEvents.touchUpInside)
        backView.addSubview(sender!)
        
    }
    
    func signoutAction(){
        if clickAction != nil{
            clickAction!()
        }
    }


}
