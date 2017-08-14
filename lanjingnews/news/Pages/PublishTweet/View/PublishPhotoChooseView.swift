//
//  PublishPhotoChooseView.swift
//  news
//
//  Created by chunhui on 15/12/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

enum PublishPhotoTapType{
    case image //点击图片
    case addImage //点击添加
}

class PublishPhotoChooseView: UIView {

    var leftImageView : UIImageView!
    var middleImageView : UIImageView!
    var rightImageView : UIImageView!
    private var imageViews = [UIImageView]()
    private var currentImages = 0
    private var addImage : UIImage!
    var tapImage : ((_ type:PublishPhotoTapType , _ index : Int)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initImages()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initImages()
    }
    
    func defaultImageView(_ frame: CGRect , tag : Int) -> UIImageView {
        
        let imageView = UIImageView(frame: frame)
        imageView.tag = tag
        imageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(PublishPhotoChooseView.tapImageAction(_:)))
        imageView.addGestureRecognizer(gesture)
        
        return imageView
    }
    
    func initImages(){
        
        var frame = CGRect(x: PublishTweetViewController.Const.horMargin, y: 0, width: self.height, height: self.height)
        
        let tag: Int = 0
        leftImageView = self.defaultImageView(frame, tag: tag)
        frame.origin.x += (10 + frame.size.width)
        middleImageView = self.defaultImageView(frame, tag: tag + 1)
        frame.origin.x += (10 + frame.size.width)
        rightImageView = self.defaultImageView(frame, tag: tag + 2)
        
        self.addSubview(leftImageView)
        self.addSubview(middleImageView)
        self.addSubview(rightImageView)
        
        imageViews.append( contentsOf: [leftImageView,middleImageView,rightImageView])
        addImage = UIImage(named: "com_add_image")
        
        self.refreshViews()
    }
    
    func addImages(_ images: [UIImage]){
        
        for i in 0  ..< images.count  {
            if i + currentImages < imageViews.count {
                imageViews[i+currentImages].image = images[i]
            }
        }
        currentImages += images.count
        if currentImages > imageViews.count {
            currentImages = imageViews.count
        }
        
        self.refreshViews()
        
    }
    
    func removeImageAtIndex(_ index : Int){
        
        if index >= 0 && index < currentImages {
            
            imageViews[index].image = nil
            for i in index+1  ..< imageViews.count   {
                imageViews[i-1].image = imageViews[i].image
            }
            imageViews.last?.image = nil
            
            currentImages -= 1
            
            self.refreshViews()
            
        }
        
    }
    
    func selImages()-> [UIImage] {
        
        var imgs = [UIImage]()
        if currentImages > 0 {
            for i in 0  ..< currentImages  {
                if imageViews[i].image != nil {
                    imgs.append(imageViews[i].image!)
                }
            }
        }
        return imgs
    }
    
    func imageViewAt(_ index : Int) -> UIImageView {
        
        return imageViews[index]
    }
    
    subscript(index : Int) -> UIImage? {
        if index >= 0 && index < imageViews.count {
            return imageViews[index].image
        }
        return nil
    }
    
    func currentImageCount() -> Int {
        return currentImages
    }
    
    private func refreshViews(){
        
        
        for i in 0  ..< currentImages  {
            imageViews[i].isHidden = false
        }
        
        for i in currentImages ..< imageViews.count {
            imageViews[i].isHidden = true
        }
        
        if currentImages < imageViews.count {
            imageViews[currentImages].image = addImage
            imageViews[currentImages].isHidden = false
        }
        
    }
    
    func tapImageAction(_ gesture : UITapGestureRecognizer){
        
        let tag = gesture.view!.tag
        var type : PublishPhotoTapType  = .addImage
        if tag < currentImages {
            type = .image
        }
        
        tapImage?(type, tag)
        
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
