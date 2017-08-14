//
//  MyInfoRedView.swift
//  news
//
//  Created by 奥那 on 16/1/9.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class MyInfoRedView: UIView {

    let numberLabel = UILabel()
    let redView = UIImageView()
    var collectionNum : String?{
        didSet{
            numberLabel.text = collectionNum

        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customSubViews()
    }
    
    func customSubViews(){
        
        redView.frame = CGRect(x: 0, y: 0, width: 30, height: 18)
        redView.image = UIImage(named: "myInfo_redView")
        self.addSubview(redView)
        
        numberLabel.frame = CGRect(x: 0, y: 0, width: 30, height: 18)
        numberLabel.textColor = UIColor.white
        numberLabel.font = UIFont.systemFont(ofSize: 14)
        numberLabel.textAlignment = NSTextAlignment.center
        redView.addSubview(numberLabel)
        
        
        
    }
}
