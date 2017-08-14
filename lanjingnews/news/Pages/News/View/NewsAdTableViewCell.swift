//
//  NewsAdTableViewCell.swift
//  news
//
//  Created by 陈龙 on 16/6/6.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class NewsAdTableViewCell: BaseTableViewCell {

    struct Consts {
        
        static let ImageRatio = CGFloat(3)
        
        static let TitleWidth: CGFloat = GlobalConsts.screenWidth - NewsConfig.ContentHorizontalSpace * 2

        static let TagTopSpace: CGFloat = 7.0

    }
    
    private let titleLabel = UILabel()
    private let postImageView = UIImageView()
    private var tagLabel = NewsTagLabel()
    private let seperateLineView = UIView()

    
    // MARK: - lifecycle
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: .default, reuseIdentifier: NewsAdTableViewCell.Identify)
        
        initView()
        initViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        guard info != nil else {
            return
        }
        
//        titleLabel.snp.updateConstraints { (make) in
//            make.top.equalTo(contentView.snp.top).offset(NewsConfig.ContentVerticalMargin)
//            make.left.equalTo(contentView.snp.left).offset(NewsConfig.ContentHorizontalSpace)
//            make.right.equalTo(contentView.snp.right).offset(-NewsConfig.ContentHorizontalSpace)
//            
//            
//            let titleString = model.title
//            var titleHeight = CGFloat(0)
//            if titleString != nil {
//                titleHeight = titleString!.sizeWithMaxWidth(Consts.TitleWidth, font: NewsConfig.TitleFont, maxLineNum: 2).height
//            }
//            make.height.equalTo(titleHeight)
//        }

        postImageView.snp.remakeConstraints { (make) -> Void in
            
//            let titleString = model.title
//            if titleString == nil {
//                make.top.equalTo(contentView.snp.top).offset(NewsConfig.SummaryTopSpace)
//            } else {
//                make.top.equalTo(titleLabel.snp.bottom).offset(NewsConfig.SummaryTopSpace)
//            }
            make.top.equalTo(contentView.snp.top).offset(NewsConfig.ContentVerticalMargin)
            make.left.equalTo(contentView.snp.left).offset(NewsConfig.ContentHorizontalMargin)
            let width = GlobalConsts.screenWidth - NewsConfig.ContentHorizontalMargin * 2
            let height = width / Consts.ImageRatio
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
    }
    
    // MARK: - private
    
    private func initView() -> Void {
        
        self.selectionStyle = .none
        
        titleLabel.textColor = NewsConfig.TitleColor
        titleLabel.font = NewsConfig.TitleFont
        titleLabel.textAlignment = .left
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 2
        titleLabel.backgroundColor = UIColor.clear
        contentView.addSubview(titleLabel)
        titleLabel.isHidden = true
        
        postImageView.clipsToBounds = true
        postImageView.contentMode = .scaleToFill//.scaleAspectFill
        contentView.addSubview(postImageView)
        
        tagLabel.font = NewsConfig.TagFont
        tagLabel.textAlignment = .center
        tagLabel.backgroundColor = UIColor.clear
        tagLabel.textColor = UIColor.rgb(0xff3824)
        tagLabel.borderColor = UIColor.rgb(0xff3824)
        tagLabel.borderWidth = 0.5
        tagLabel.text = "广告"
        contentView.addSubview(tagLabel)
        
        seperateLineView.backgroundColor = NewsConfig.SeperateLineColor
        contentView.addSubview(seperateLineView)

    }
    
    private func initViewConstraints() {
        
        tagLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(postImageView.snp.bottom).offset(Consts.TagTopSpace)
            make.left.equalTo(postImageView.snp.left)
            make.height.equalTo(NewsConfig.TimeHeight)
            let tagString = "广告"
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
    
    // MARK: - public
    
    var info: LJNewsListDataListModel? {
        didSet {
            
            let titleString = info?.title
            titleLabel.isHidden = titleString == nil
            titleLabel.text = info!.title ?? ""
            
            if let _ = info?.imgs {
                
            }else{
                self.info?.imgs = nil
            }

            let img: String = info!.imgs?.first ?? ""
            postImageView.isHidden = false
            if postImageView.sd_imageURL()?.absoluteString != img {
                let imgUrl = Urlhelper.tryEncode(img)
                postImageView.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "default_news_news"))
            }
            
            let tagString = info?.tip?.name ?? ""
            let tagForeColorString: String? = info?.tip?.forecolor
            let tagForeColror = UIColor.colorFromHexString(tagForeColorString, defaultColor: NewsConfig.TagDefaultColor)
            tagLabel.textColor = tagForeColror
            tagLabel.borderColor = tagForeColror
            tagLabel.borderWidth = 0.5
            tagLabel.text = tagString
            tagLabel.isHidden = tagString.isEmpty
            
            self.setNeedsUpdateConstraints()
        }
    }
    
    class func heightForInfo(_ info: LJNewsListDataListModel) -> CGFloat {
        
//        let titleString = info.title
//        var titleHeight = CGFloat(0)
//        if titleString != nil {
//            titleHeight = titleString!.sizeWithMaxWidth(Consts.TitleWidth, font: NewsConfig.TitleFont, maxLineNum: 2).height
//            titleHeight = titleHeight + NewsConfig.ContentVerticalMargin
//        }
        
        let postImageWidth = GlobalConsts.screenWidth - NewsConfig.ContentHorizontalMargin * 2
        let postImageheight = postImageWidth / Consts.ImageRatio

        var height = CGFloat(0)
        height = NewsConfig.ContentVerticalMargin + postImageheight + Consts.TagTopSpace + NewsConfig.TimeHeight + NewsConfig.ContentVerticalSpace + 0.5
        
        return ceil(height)
    }

}
