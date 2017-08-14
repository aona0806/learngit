//
//  CompleteInfoHeaderView.swift
//  news
//
//  Created by 奥那 on 16/1/7.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class CompleteInfoHeaderView: UIView {
    
    var clickAvatar : ((_ imageView : UIImageView) -> ())? = nil
    let imageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        customSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customSubViews()
    }
    
    func customSubViews(){
        self.backgroundColor = UIColor.rgb(0xe8e8e8)
        
        imageView.frame = CGRect(x: 0, y: 20, width: 70, height: 70)
        imageView.centerX = UIScreen.main.bounds.width/2
        imageView.image = UIImage(named: "myInfo_default_headerImage")
        self.addSubview(imageView)
        
        let logoView = UIImageView(frame: CGRect(x: 60, y: 60, width: 19, height: 19))
        logoView.image = UIImage(named: "myInfo_canmer")
        imageView.addSubview(logoView)
        
        let button = UIButton(type: UIButtonType.system)
        button.frame = imageView.frame
        self.addSubview(button)
        button.addTarget(self, action: #selector(CompleteInfoHeaderView.changeAvatar(_:)), for: UIControlEvents.touchUpInside)

    }

    func changeAvatar(_ sender : UIButton){
        
        if clickAvatar != nil{
            clickAvatar!(imageView)
        }
    }
}
