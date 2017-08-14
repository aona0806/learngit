//
//  ImageBrowserHelper.swift
//  news
//
//  Created by 陈龙 on 15/7/16.
//  Copyright (c) 2015年 lanjing. All rights reserved.
//

import UIKit

class ImageBrowserHelper: NSObject,ZLPhotoPickerBrowserViewControllerDataSource, ZLPhotoPickerBrowserViewControllerDelegate{

    var pickerBrowser: ZLPhotoPickerBrowserViewController!
    var currentIndex: Int = 0
    var imageUrlArray: Array<String>!
    var thumbImages: Array<UIImage>!
    
    var forwardClick: ((Int) -> UIView)? = nil
    
    override init() {
        super.init()
        pickerBrowser = ZLPhotoPickerBrowserViewController()
        pickerBrowser.dataSource = self;
        pickerBrowser.delegate = self;
    }
    
    func show(_ _imageUrlArray: Array<String>!,_thumbImages: Array<UIImage>!,_forwardClick: @escaping (Int) -> UIView) {
        self.imageUrlArray = _imageUrlArray
        self.thumbImages = _thumbImages
        pickerBrowser.isEditing = true
        pickerBrowser.currentIndexPath = IndexPath(item: currentIndex, section: 0)
        pickerBrowser.show()
        self.forwardClick = _forwardClick
    }
    
    func numberOfSectionInPhotos(inPickerBrowser pickerBrowser: ZLPhotoPickerBrowserViewController!) -> Int {
        
        let count = 1
        return count
    }
    
    func photoBrowser(_ photoBrowser: ZLPhotoPickerBrowserViewController!, numberOfItemsInSection section: UInt) -> Int {
        
        let count = imageUrlArray?.count
        return count!
    }
    
    func photoBrowser(_ pickerBrowser: ZLPhotoPickerBrowserViewController!, photoAt indexPath: IndexPath!) -> ZLPhotoPickerBrowserPhoto! {
        
        let imageIndex = indexPath.row
        let image = imageUrlArray[imageIndex]
        let photo = ZLPhotoPickerBrowserPhoto(anyImageObjWith: image)
        photo?.thumbImage = self.thumbImages[imageIndex]
        photo?.toView = self.forwardClick?(imageIndex)
        return photo
    }
}
