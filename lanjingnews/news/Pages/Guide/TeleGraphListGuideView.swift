//
//  TeleGraphListGuideView.swift
//  news
//
//  Created by 奥那 on 2017/1/13.
//  Copyright © 2017年 lanjing. All rights reserved.
//

import UIKit

class TeleGraphListGuideView: UIView {
    
    var imageView:UIImageView!
    var confirmImageView:UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        customSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    func customSubViews() {
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(removeView))
        self.addGestureRecognizer(tap)
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 173/667.0*height, width: 289/375.0*width, height: 145/667.0*height))
        imageView.centerX = self.centerX
        imageView.image = UIImage.init(named: "tele_list_guide")
        self.addSubview(imageView)
        
        confirmImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 128/375.0*width, height: 48/667.0*height))
        confirmImageView.centerX = self.centerX
        confirmImageView.top = imageView.bottom + 50/667.0*height
        confirmImageView.image = UIImage.init(named: "tele_list_confirm")
        self.addSubview(confirmImageView)
        
    }
    
    func removeView(){
        if self.superview != nil {
            self.removeFromSuperview()
        }
    }
}
