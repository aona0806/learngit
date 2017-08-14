//
//  NewsBannerCell.swift
//  news
//
//  Created by chunhui on 15/11/26.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

class NewsBannerCell: BaseTableViewCell,TKBannerViewDelegate {
    
    var advs : Array<LJAdDataModel>?
    var bannerView : TKBannerView
    var bannerItems = [TKBannerItem]()
    
//    class var Identify : String {
//        get {
//            return "LJNewsBannerCell"
//        }
//    }
    
    class func fitHeight() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return screenWidth * 253 / 498
    }
    func initBannerView(){
        bannerView.currentPageIndicatorTintColor = UIColor.rgba(29,green: 138 , blue: 205, alpha: 1)
        bannerView.pageIndicatorTintColor = UIColor.white
        bannerView.pageLocation = .locationRight
        bannerView.backgroundColor = UIColor.white
        bannerView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        var frame = UIScreen.main.bounds
        frame.size.height = NewsBannerCell.fitHeight()
        self.bannerView = TKBannerView(frame: frame, items: nil)
        super.init(coder: aDecoder)
        self.contentView.addSubview(self.bannerView)
        self.initBannerView()
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        var frame = UIScreen.main.bounds
        frame.size.height = NewsBannerCell.fitHeight()
        self.bannerView = TKBannerView(frame: frame, items: nil)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.bannerView)
        self.initBannerView()
    }
    
    func startScroll(){
        self.bannerView.startScroll()
    }
    
    func stopScroll(){
        self.bannerView.stopScroll()
    }
    
    func updatBanners(_ ads : Array<LJAdDataModel>){
        if ads.count == 0 {
            return
        }
        if self.advs != nil && ads == self.advs! {
            //就是现在显示的无需刷新
            return
        }
        bannerItems.removeAll()
        
        var item : TKBannerItem
        for ad in ads {
            item = TKBannerItem()
            item.imgUrl = ad.imgUrl ?? ""
            item.linkUrl = ad.goUrl ?? ""
            if item.linkUrl.length() == 0 {
                item.canTap = false
            }
            item.placeHolder = UIImage(named: "banner_placeholder_image")
            bannerItems.append(item)
        }
        self.bannerView.update(withItems: bannerItems)
        self.bannerView.startScroll()
        self.advs = ads
    }
    
    func tap(_ item: TKBannerItem!) {
        
        guard  let itemUrl = item.linkUrl else {
            return
        }
        
        if itemUrl.length() == 0 {
            return
        }
        
        let url = item.linkUrl.hasPrefix("lanjing") ? itemUrl : "lanjing://wap?url=\(itemUrl)"
        PushManager.sharedInstance.handleOpenUrl(url)
    }
    
}
