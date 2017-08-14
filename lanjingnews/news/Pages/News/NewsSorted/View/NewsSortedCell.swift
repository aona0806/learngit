//
//  NewsSortedCell.swift
//  news
//
//  Created by 奥那 on 2017/5/8.
//  Copyright © 2017年 lanjing. All rights reserved.
//

import UIKit

class NewsSortedCell: UICollectionViewCell {
    
    private var titleLabel : UILabel!
    private var backImageView : UIImageView!
    var showAnimation : Bool?{
        didSet{
            if showAnimation! {
                beginAnimaion()
            }else{
                stopAnimation()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupSubviews()
    }
    
    func setupSubviews() {
        let width = (UIScreen.main.bounds.width-36 - 3 * 13)/4.0
        
        backImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: 28))
        backImageView.image = UIImage.init(named: "news_back_image")
        self.contentView.addSubview(backImageView)

        titleLabel = UILabel.init(frame: CGRect.init(x: 5, y: 0, width: width-10, height: 28))
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = UIColor.clear
        backImageView.addSubview(titleLabel)
        
        
    }
    
    func updateTitle(title:String) {
        titleLabel.text = title
    }
    
    func startMove(){
        backImageView.image = UIImage.init(named: "news_sort_image")
        titleLabel.isHidden = true
    }
    
    func stopMove(){
        backImageView.image = UIImage.init(named: "news_back_image")
        titleLabel.isHidden = false
    }
    
    func beginAnimaion(){
//        
//        let animation = CAKeyframeAnimation()
//        animation.keyPath = "transform.rotation"
//        animation.values = [(-5/180.0 * M_PI),(5/180.0 * M_PI),(-5/180.0 * M_PI)]
//        animation.isRemovedOnCompletion = false
//        animation.fillMode = kCAFillModeForwards
//        animation.duration = 0.2
//        animation.repeatCount = MAXFLOAT
//        self.contentView.layer.add(animation, forKey: nil)
    }
    
    func stopAnimation(){
//        self.contentView.layer.removeAllAnimations()
    }

}
