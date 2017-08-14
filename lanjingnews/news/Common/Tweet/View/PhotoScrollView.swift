//
//  PhotoScrollView.swift
//  news
//
//  Created by chunhui on 15/11/26.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

class PhotoScrollView: UIView {

    let  maxImageCount = 3
    
    var imageViews = Array<UIImageView>()
    var placeholderImage : UIImage?
    var padding : CGFloat = 5.0//两个图片间的间隔
    var tapImage : ((_ index : Int )->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    private func addGesture(_ imageView : UIImageView){
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(PhotoScrollView.tapGestureAction(_:)))
        imageView.addGestureRecognizer(gesture)
        imageView.isUserInteractionEnabled = true

    }
    
    
    func updateWithUrls(_ urls: Array<String>){
        
        
        for img in imageViews {
            img.removeFromSuperview()
        }
        imageViews.removeAll()

        var imageView : UIImageView
        for i in 0  ..< urls.count  {
            
            imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.tag = i
            let url = Urlhelper.tryEncode(urls[i])
            imageView .sd_setImage(with: url, placeholderImage: placeholderImage)
            imageViews.append(imageView)
            self.addSubview(imageView)
            addGesture(imageView)
        }
        
        
        
        /*
        
        var i = 0
        var imageView : UIImageView
        for i = 0 ; i < min(urls.count, imageViews.count) ; i++ {
            imageView = imageViews[i]
            imageView.tag = i            
            let url = NSURL(string: urls[i])
            imageView .sd_setImageWithURL(url , placeholderImage: placeholderImage)
        }
        if urls.count > imageViews.count {
            //需要添加更多的imageview
            while i < urls.count {
                imageView = UIImageView()
                imageView.tag = i
                let url = NSURL(string: urls[i])
                imageView .sd_setImageWithURL(url, placeholderImage: placeholderImage)
                ++i
                imageViews.append(imageView)
                self.addSubview(imageView)
                addGesture(imageView)
            }
        }else if urls.count < imageViews.count{
            while i < imageViews.count {
                imageViews[i].removeFromSuperview()
                ++i
            }
            let range = Range(start: urls.count, end: imageViews.count-1)
            imageViews.removeRange(range)
        }
        */
        self.setNeedsLayout()
    }
    
    
    override func layoutSubviews() {
        
        var frame = self.bounds
        frame.size.width = (frame.width - (CGFloat(maxImageCount) - 1)*padding)/CGFloat(maxImageCount)
        for imageView in imageViews {
            imageView.frame = frame
            frame.origin.x += frame.width + padding
        }
        super.layoutSubviews()
    }
    
    func tapGestureAction(_ gesture : UITapGestureRecognizer){

        tapImage?(gesture.view!.tag)
        
    }
    
    
    
}
