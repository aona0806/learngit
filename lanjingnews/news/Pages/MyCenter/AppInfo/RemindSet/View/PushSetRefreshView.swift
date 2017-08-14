//
//  PushSetRefreshView.swift
//  news
//
//  Created by 奥那 on 2017/1/11.
//  Copyright © 2017年 lanjing. All rights reserved.
//

import UIKit

class PushSetRefreshView: UIView {

    var imageView:UIImageView!
    var refreshButton:UIButton!
    var refreshAction:(() -> ())? = nil

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        customSubviews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func customSubviews() {
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 180/667.0*height, width: 100/375.0*width, height: 110/667.0*height))
        imageView.centerX = self.centerX
        imageView.image = UIImage.init(named: "appPush_network")
        self.addSubview(imageView)
        
        refreshButton = UIButton.init(type: .custom)
        refreshButton.top = imageView.bottom + 27
        refreshButton.width = 150/375.0*width
        refreshButton.height = 40/667.0*height
        refreshButton.centerX = self.centerX
        refreshButton.setBackgroundImage(UIImage(named: "appPush_refresh"), for: UIControlState())
        refreshButton.addTarget(self, action: #selector(clickRefreshButton), for: UIControlEvents.touchUpInside)
        self.addSubview(refreshButton)
        
    }
    
    func clickRefreshButton(sender : UIButton) {
        if refreshAction != nil{
            refreshAction!()
        }
    }

}
