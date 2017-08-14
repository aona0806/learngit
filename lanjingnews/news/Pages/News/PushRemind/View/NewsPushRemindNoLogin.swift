//
//  NewsPushRemindNoLogin.swift
//  news
//
//  Created by wxc on 2017/1/17.
//  Copyright © 2017年 lanjing. All rights reserved.
//

import UIKit

class NewsPushRemindNoLogin: UIView {
    
    //页面二 设置成功/失败
    var bgView = UIImageView()
    var knownButton = UIButton()
    
    var closeButton = UIButton()
    
    var adjustWidthAlpha:CGFloat = 1
    var adjustHeightAlpha:CGFloat = 1

    init() {
        super.init(frame: UIScreen.main.bounds)
        self.setUpSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpSubViews() {
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        
        adjustWidthAlpha = self.width / 375
        adjustHeightAlpha = self.height / 667
        
        bgView.frame = CGRect.init(x: 44*adjustWidthAlpha, y: 0, width: self.width - 88*adjustWidthAlpha, height: 405*adjustHeightAlpha)
        bgView.centerY = self.height / 2
        bgView.image = UIImage.init(named: "news_not_login_backImage")
        bgView.isUserInteractionEnabled = true
        self.addSubview(bgView)
        
        knownButton.setTitle("立即体验", for: .normal)
        knownButton.setTitleColor(UIColor.rgb(0x505050), for: UIControlState())
        knownButton.frame = CGRect.init(x: 0, y: 0, width: 150, height: 40)
        knownButton.centerX = bgView.width / 2
        knownButton.bottom = bgView.height - 30
        knownButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        knownButton.setBackgroundImage(UIImage.init(named: "news_not_login_confirm"), for: UIControlState())
        knownButton.addTarget(self, action: #selector(knownButtonAction(_:)), for: .touchUpInside)
        bgView.addSubview(knownButton)
                    
        closeButton.setImage(UIImage.init(named: "news_not_login_close"), for: .normal)
        closeButton.sizeToFit()
        closeButton.top = 15
        closeButton.right = bgView.width - 15
        closeButton.addTarget(self, action: #selector(closeButtonAction(_:)), for: .touchUpInside)
        bgView.addSubview(closeButton)
    }
    
    func knownButtonAction(_ sender:UIButton) {
        self.removeFromSuperview()
        UserDefaults.standard.set(true, forKey: GlobalConsts.kNewsNotLoginFirstShowKey)
//AppDelegate.mainController().navigationController?.pushViewController(LoginRegistViewController(), animated: true)
    }
    
    func closeButtonAction(_ sender:UIButton) {
        self.removeFromSuperview()
        UserDefaults.standard.set(true, forKey: GlobalConsts.kNewsNotLoginFirstShowKey)

    }

}
