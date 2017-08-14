//
//  NewsMutipleAdTableViewCell.swift
//  news
//
//  Created by chunhui on 2016/12/12.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit
//多图广告

class NewsMutipleAdTableViewCell: BaseTableViewCell {

    
    class Consts: NSObject {
        
        static let ImageHorizontalSpace: CGFloat = 6
        static let ImageHeight: CGFloat = 74.0
        static let ImageTopSpace: CGFloat = 10.0
        
        static let TitleRightSpace = CGFloat(24)
        static let TitleWidth: CGFloat = GlobalConsts.screenWidth - NewsConfig.ContentHorizontalMargin * 2
        
        static let AuthoreInfoTopSpace: CGFloat = 10.0
        static let TagRightSpace: CGFloat = 5.0
        static let TagTopSpace: CGFloat = 7.0
        
    }
    
    private var titleLabel = UILabel()
    private var tagLabel = NewsTagLabel()
    
    private var imageViews: [UIImageView]! = [UIImageView]()
    private let seperateLineView = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(titleLabel)
        tagLabel.font = NewsConfig.TagFont
        tagLabel.textAlignment = .center
        tagLabel.backgroundColor = UIColor.clear
        self.contentView.addSubview(tagLabel)
        
        for _ in 0..<3 {
            
            let aImageView = UIImageView()
            aImageView.isHidden = true
            aImageView.clipsToBounds = true
            aImageView.contentMode = .scaleToFill//.scaleAspectFill
            imageViews.append(aImageView)
            contentView.addSubview(aImageView)
        }
        
        seperateLineView.backgroundColor = NewsConfig.SeperateLineColor
        contentView.addSubview(seperateLineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var info: LJNewsListDataListModel? {
        didSet {
           update()
        }
    }
    
    private func update(){
        
        titleLabel.text = info?.title ?? ""
        
        let tagString = info?.tip?.name ?? ""
        let tagForeColorString: String? = info?.tip?.forecolor
        let tagForeColror = UIColor.colorFromHexString(tagForeColorString, defaultColor: NewsConfig.TagDefaultColor)
        tagLabel.textColor = tagForeColror
        tagLabel.borderColor = tagForeColror
        tagLabel.borderWidth = 0.5
        tagLabel.text = tagString
        tagLabel.sizeToFit()
        
        tagLabel.isHidden = tagString.isEmpty
        
        let imgs: [String] = info!.imgs ?? []
        for index in 0...2 {
            let aImageView = imageViews[index]
            var imageString: String! = ""
            if index < imgs.count {
                imageString = imgs[index]
                let imgUrl = Urlhelper.tryEncode(imageString)
                aImageView.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "default_news_news"))
                aImageView.isHidden = false
            }else{
                aImageView.isHidden = true
            }
        }
        
        self.setNeedsUpdateConstraints()
    }
    
    
    override func updateConstraints() {
        super.updateConstraints()
        
        titleLabel.snp.makeConstraints {(make) -> Void in
            make.left.equalTo(contentView.snp.left).offset(NewsConfig.ContentHorizontalMargin)
            make.top.equalTo(contentView.snp.top).offset(NewsConfig.ContentVerticalMargin)
            make.right.equalTo(contentView.snp.right).offset(-NewsConfig.ContentHorizontalMargin)
        }
        
        let ImageWidth: CGFloat = (GlobalConsts.screenWidth - Consts.ImageHorizontalSpace * 2 - NewsConfig.ContentHorizontalMargin * 2) / 3
        let ImageHeight = ImageWidth * NewsConfig.ImageRatio
        
        var firstView: UIView = contentView
        for index in 0...2 {
            let aImageView = imageViews[index]
            aImageView.snp.makeConstraints { (make) -> Void in
                if index == 0 {
                    make.left.equalTo(contentView.left).offset(NewsConfig.ContentHorizontalMargin)
                } else {
                    make.left.equalTo(firstView.snp.right).offset(Consts.ImageHorizontalSpace)
                    make.width.equalTo(firstView.snp.width)
                }
                if index == 2 {
                    make.right.equalTo(contentView.right).offset(-NewsConfig.ContentHorizontalMargin)
                }
                make.top.equalTo(titleLabel.snp.bottom).offset(Consts.ImageTopSpace)
                make.height.equalTo(ImageHeight)
            }
            firstView = aImageView
        }
        
        
        tagLabel.snp.makeConstraints {[weak self] (make) -> Void in
            make.top.equalTo(self!.imageViews[0].snp.bottom).offset(Consts.TagTopSpace)
            make.left.equalTo(self!.imageViews[0].snp.left)
            make.height.equalTo(NewsConfig.TimeHeight)
            let tagString = self!.tagLabel.text ?? ""
            let tagWidth = tagString.size(withMaxHeight: NewsConfig.TimeHeight, font: NewsConfig.TagFont).width + 10
            make.width.equalTo(tagWidth)
        }
        seperateLineView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp.left).offset(NewsConfig.SeperateLineLeftSpace)
            make.right.equalTo(contentView.snp.right).offset(-NewsConfig.SeperateLineLeftSpace)
            make.bottom.equalTo(contentView.snp.bottom).offset(-0.0)
            make.height.equalTo(0.5)
        }
        
    }
    
    class func heightForInfo(_ info: LJNewsListDataListModel) -> CGFloat {
        
        let titleString = info.title ?? ""
        let titleSize: CGSize! = titleString.size(withMaxWidth: Consts.TitleWidth, font: NewsConfig.TitleFont, maxLineNum:2)
        
        let imageWidth: CGFloat = (GlobalConsts.screenWidth - Consts.ImageHorizontalSpace - Consts.ImageHorizontalSpace * 2) / 3
        let imageHeight = imageWidth * NewsConfig.ImageRatio
        
        var height = NewsConfig.ContentVerticalMargin
        if titleString.length()  > 0 {
            height += titleSize.height + Consts.ImageTopSpace
        }
        height +=  imageHeight + Consts.TagTopSpace + NewsConfig.TimeHeight + NewsConfig.ContentVerticalSpace + 0.5
        
        return ceil(height)
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
