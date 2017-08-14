//
//  LJBannerTableViewCell.swift
//  news
//
//  Created by 陈龙 on 16/1/4.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

/// 新闻页面中的banner
class LJBannerTableViewCell: BaseTableViewCell, TKBannerViewDelegate {
    
    struct Const {
        static let ImageRatio = CGFloat(400.0 / 750)
    }
    
    private var dataInfo : LJNewsListDataListModel?
    private var bannerView : TKBannerView!
    private var bannerItems = [TKBannerItem]()
    
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initBannerView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initBannerView()
    }
    
    // MARK: - private
    
    private func initBannerView(){
        
        var frame = UIScreen.main.bounds
        frame.size.height = LJBannerTableViewCell.fitHeight()
        self.bannerView = TKBannerView(frame: frame, items: nil)
        bannerView.currentPageIndicatorTintColor = UIColor.rgba(29,green: 138 , blue: 205, alpha: 1)
        bannerView.pageIndicatorTintColor = UIColor.white
        bannerView.pageLocation = .locationCenter
        bannerView.backgroundColor = UIColor.white
        bannerView.titleInCell = true
        bannerView.delegate = self
        
        bannerView.titleLabel.numberOfLines = 2
        bannerView.titleLabel.textAlignment = .center
        bannerView.titleLabel.font = UIFont.systemFont(ofSize: 17)
        
        let bannerBg = UIImage(named:"banner_bg")
        bannerView.bannerBg = bannerBg
        
//        bannerView.bannerView.backgroundColor = UIColor.clear
        
//        let blurView = UIImageView(image:bannerBg)
//        blurView.frame = CGRect(x: 0, y: bannerView.height - 130, width: bannerView.width, height: 130)
//        bannerView.insertSubview(blurView, belowSubview: bannerView.bannerView)
        
        //        bannerView.cycleShow = false
        self.contentView.addSubview(self.bannerView)
        self.bannerView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.contentView);
        }
    }
    
    // MARK: - public
    
    class func fitHeight() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return ceil(screenWidth * 4 / 7)
    }
    
    func startScroll(){
        self.bannerView.startScroll()
    }
    
    func stopScroll(){
        self.bannerView.stopScroll()
    }
    
    func updatBanners(_ info : LJNewsListDataListModel){
        
        guard let banner = info.bannerContent as? [LJNewsListDataListBannerModel] else {
            return
        }
        if banner.count == 0 {
            return
        }
        if self.dataInfo != nil && self.dataInfo! == info {
            //就是现在显示的无需刷新
            return
        }
        bannerItems.removeAll()
        
        for item in banner {
            let bannerItem = TKBannerItem()
            bannerItem.linkUrl = item.jump ?? ""
            bannerItem.title = item.title ?? ""
            bannerItem.imgUrl = item.img ?? ""
            bannerItem.canTap = !bannerItem.linkUrl.isEmpty
            let placeholder = UIImage(named: "banner_placeholder_image")
            bannerItem.placeHolder = placeholder
            bannerItems.append(bannerItem)
        }
        self.bannerView.update(withItems: bannerItems)
        self.bannerView.startScroll()
        self.dataInfo = info
    }
    
    // MARK: - TKBannerViewDelegate
    
    func tap(_ item: TKBannerItem!) {
        let templateTypeString = self.dataInfo!.templateType ?? ""
        if templateTypeString == LJTemplateType.banner.translateString() {
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                MobClick.event("AD_banner_click")
                
            }
            PushManager.sharedInstance.handleOpenUrl(item.linkUrl)
            
        }
    }
    
}
