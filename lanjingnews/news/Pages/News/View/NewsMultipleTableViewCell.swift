//
//  NewsMultipleTableViewCell.swift
//  news
//
//  Created by 陈龙 on 16/1/8.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class NewsMultipleTableViewCell: BaseTableViewCell {

    class Consts: NSObject {
        
        static let ImageHorizontalSpace: CGFloat = 6
        static let ImageHeight: CGFloat = 74.0
        static let ImageTopSpace: CGFloat = 10.0
        
        static let TitleRightSpace = CGFloat(24)
        static let TitleWidth: CGFloat = GlobalConsts.screenWidth - NewsConfig.ContentHorizontalMargin * 2
        
        static let AuthoreInfoTopSpace: CGFloat = 10.0
        static let TagRightSpace: CGFloat = 5.0
        static let TimeTopSpace: CGFloat = 10.0
        
    }
    
    private var titleLabel: UILabel!
    private var authorInfoLabel: UILabel!
    private var timeLabel: UILabel!
    private var tagLabel: NewsTagLabel!
    
    private var summaryLabel: UILabel!
    private var readNumLabel: UILabel!
    
    private var imageViews: [UIImageView]! = [UIImageView]()
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        buildView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private
    
    private func buildView() {
        
        self.selectionStyle = .none
        
        titleLabel = UILabel()
        titleLabel.textColor = NewsConfig.TitleColor
        titleLabel.font = NewsConfig.TitleFont
        titleLabel.textAlignment = .left
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 2
        contentView.addSubview(titleLabel)
        
        summaryLabel = UILabel()
        summaryLabel.numberOfLines = 2
        contentView.addSubview(summaryLabel)
        
        authorInfoLabel = UILabel()
        authorInfoLabel.textColor = NewsConfig.authorInfoColor
        authorInfoLabel.font = NewsConfig.authorInfoFont
        authorInfoLabel.numberOfLines = 1
        authorInfoLabel.textAlignment = .left
        contentView.addSubview(authorInfoLabel)
        
        timeLabel = UILabel()
        timeLabel.textColor = NewsConfig.TimeColor
        timeLabel.font = NewsConfig.TimeFont
        contentView.addSubview(timeLabel)
        
        tagLabel = NewsTagLabel()
        tagLabel.font = NewsConfig.TagFont
        tagLabel.textAlignment = .center
        tagLabel.backgroundColor = UIColor.clear
        contentView.addSubview(tagLabel)
        
        readNumLabel = UILabel()
        readNumLabel.textColor = NewsConfig.ReadNumColor
        readNumLabel.font = NewsConfig.ReadNumFont
        contentView.addSubview(readNumLabel)
        
        for _ in 0..<3 {
            
            let aImageView = UIImageView()
            aImageView.isHidden = true
            aImageView.clipsToBounds = true
            aImageView.contentMode = .scaleAspectFill
            imageViews.append(aImageView)
            contentView.addSubview(aImageView)
        }
        
        let seperateLineView = UIView()
        seperateLineView.backgroundColor = NewsConfig.SeperateLineColor
        contentView.addSubview(seperateLineView)
        seperateLineView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp.left).offset(NewsConfig.SeperateLineLeftSpace)
            make.right.equalTo(contentView.snp.right).offset(-NewsConfig.SeperateLineLeftSpace)
            make.bottom.equalTo(contentView.snp.bottom).offset(-0.0)
            make.height.equalTo(0.5)
        }
        
        initConstraints()
    }
    
    private func initConstraints(){
        
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
        
        summaryLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(imageViews.first!.snp.bottom).offset(NewsConfig.SummaryTopSpace)
            make.right.equalTo(titleLabel.snp.right)
        }
        
        tagLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(titleLabel.snp.left)
            make.height.equalTo(NewsConfig.TimeHeight)
            make.top.equalTo(summaryLabel.snp.bottom).offset(Consts.AuthoreInfoTopSpace)
        }
        
        authorInfoLabel.snp.makeConstraints { (make) -> Void in
            
            make.left.equalTo(tagLabel.snp.right).offset(Consts.TagRightSpace)
            make.top.equalTo(tagLabel.snp.top)
            make.height.equalTo(NewsConfig.TimeHeight)
            
        }
        
        timeLabel.snp.makeConstraints { (make) -> Void in
            
            make.right.equalTo(contentView.snp.right).offset(-10)
            make.centerY.equalTo(tagLabel.snp.centerY)
            make.height.equalTo(NewsConfig.TimeFont.capHeight)
        }
        
        readNumLabel.snp.makeConstraints { (make) in
            make.right.equalTo(contentView.snp.right).offset(-NewsConfig.ContentHorizontalMargin)
            make.centerY.equalTo(tagLabel.snp.centerY)
            make.height.equalTo(NewsConfig.ReadNumFont.capHeight)
        }
        
    }
    
    
    // MARK: - public
    
    class func heightForInfo(_ info: LJNewsListDataListModel) -> CGFloat {
        let titleString = info.title ?? ""
        let titleSize: CGSize! = titleString.size(withMaxWidth: Consts.TitleWidth, font: NewsConfig.TitleFont, maxLineNum:2)
        let ImageWidth: CGFloat = (GlobalConsts.screenWidth - Consts.ImageHorizontalSpace - Consts.ImageHorizontalSpace * 2) / 3
        let ImageHeight = ImageWidth * NewsConfig.ImageRatio
        
        let summaryString = info.brief
        var summaryHeight: CGFloat = 0.0
        if summaryString != nil {
            let summarySize: CGSize! = summaryString!.size(withMaxWidth: Consts.TitleWidth, font: NewsConfig.SummaryFont, linespace: NewsConfig.SummaryLineSpace, maxLine: 2)
            
            summaryHeight = summarySize.height + NewsConfig.SummaryTopSpace
        }
        
        var height = NewsConfig.ContentVerticalMargin + titleSize.height + Consts.ImageTopSpace
        height = height + ImageHeight + summaryHeight + Consts.AuthoreInfoTopSpace + NewsConfig.TimeHeight + NewsConfig.ContentVerticalSpace + 0.5
        
        return ceil(height)
    }
    
    var info: LJNewsListDataListModel? {
        didSet {
            
            let imgs: [String] = info!.imgs ?? []
            var cTimeNumber :NSNumber?
            let cTime = info!.ctime ?? "0"
            if let number = Double(cTime) {
                cTimeNumber = NSNumber(value:number)
            }
            let timeString: String? = TKCommonTools.dateDesc(forTimeInterval: cTimeNumber)
            titleLabel.text = info?.title ?? ""
            timeLabel.text = timeString
            let authorInfoString: String! = info?.authorInfo ?? ""
            authorInfoLabel.text = authorInfoString
            
            titleLabel.snp.remakeConstraints {(make) -> Void in
                let titleString = info?.title ?? ""
                let titleSize: CGSize! = titleString.size(withMaxWidth: Consts.TitleWidth, font: NewsConfig.TitleFont, maxLineNum:2)
                make.height.equalTo(titleSize.height)
                make.left.equalTo(contentView.snp.left).offset(NewsConfig.ContentHorizontalMargin)
                make.top.equalTo(contentView.snp.top).offset(NewsConfig.ContentVerticalMargin)
                make.right.equalTo(contentView.snp.right).offset(-NewsConfig.ContentHorizontalMargin)
            }
            
            for index in 0...2 {
                let aImageView = imageViews[index]
                aImageView.isHidden = false
                var imageString: String! = ""
                if index < imgs.count {
                    imageString = imgs[index]
                }
                let imgUrl = Urlhelper.tryEncode(imageString)
                aImageView.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "default_news_news"))
            }
            
            let summaryString = info?.brief
            var summaryHeight: CGFloat = 0.0
            var lastView: UIView! = summaryLabel
            if summaryString != nil {
                summaryLabel.isHidden = false
                let summaryAttributeString = NSAttributedString.buildAttributeString(summaryString!, lineSpace: NewsConfig.SummaryLineSpace, foreColor: NewsConfig.SummaryColor, font: NewsConfig.SummaryFont)

                summaryLabel.attributedText = summaryAttributeString
                let summarySize: CGSize! = summaryString!.size(withMaxWidth: Consts.TitleWidth, font: NewsConfig.SummaryFont, linespace: NewsConfig.SummaryLineSpace, maxLine: 2)
                summaryHeight = summarySize.height
                lastView = summaryLabel

            } else {
                summaryLabel.isHidden = true
                lastView = imageViews.first
            }
            
            summaryLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(titleLabel.snp.left)
                make.top.equalTo(imageViews.first!.snp.bottom).offset(NewsConfig.SummaryTopSpace)
                make.right.equalTo(titleLabel.snp.right)
                make.height.equalTo(summaryHeight)
            }
            
            let tagString = info?.tip?.name ?? ""
            let tagForeColorString: String? = info?.tip?.forecolor
            let tagForeColror = UIColor.colorFromHexString(tagForeColorString, defaultColor: NewsConfig.TagDefaultColor)
            tagLabel.textColor = tagForeColror
            tagLabel.borderColor = tagForeColror
            tagLabel.borderWidth = 0.5
            tagLabel.text = tagString
            tagLabel.isHidden = tagString.isEmpty
            
            var tagWidth: CGFloat! = CGFloat(0)
            var authorOffsetX = CGFloat(0)
            if tagString.length() > 0 {
                tagWidth = tagString.size(withMaxHeight: NewsConfig.TimeHeight, font: NewsConfig.TagFont).width + 10
                authorOffsetX = Consts.TagRightSpace
            }
            
            tagLabel.snp.remakeConstraints { (make) -> Void in
                make.width.equalTo(tagWidth)
                make.left.equalTo(titleLabel.snp.left)
                make.height.equalTo(NewsConfig.TimeHeight)
                make.top.equalTo(lastView.snp.bottom).offset(Consts.AuthoreInfoTopSpace)
            }
            
            authorInfoLabel.snp.remakeConstraints { (make) -> Void in
                
                make.left.equalTo(tagLabel.snp.right).offset(authorOffsetX)
                make.top.equalTo(tagLabel.snp.top)
                make.height.equalTo(NewsConfig.TimeHeight)
                
                let authorInfoSize: CGSize! = authorInfoString.size(withMaxHeight: NewsConfig.TimeHeight, font: NewsConfig.authorInfoFont)
                make.width.equalTo(authorInfoSize.width)                
            }
            
            timeLabel.snp.remakeConstraints { (make) -> Void in
                let leftSpaceOffset = authorInfoString == "" ? 0 : NewsConfig.TimeLeftSpace
                make.left.equalTo(authorInfoLabel.snp.right).offset(leftSpaceOffset)
                
                make.right.equalTo(contentView.snp.right).offset(-10)
                make.centerY.equalTo(tagLabel.snp.centerY)
                make.height.equalTo(NewsConfig.TimeFont.capHeight)
            }
            
            var readNumString = info?.appReadNum ?? "0"
            readNumString = "阅读 " + readNumString.exchangeReadNum()
            readNumLabel.text = readNumString
            readNumLabel.snp.remakeConstraints({ (make) in
                let readNumSize: CGSize! = readNumString.size(withMaxHeight: NewsConfig.ReadNumFont.capHeight, font: NewsConfig.ReadNumFont)
                make.width.equalTo(readNumSize.width)
                make.right.equalTo(contentView.snp.right).offset(-NewsConfig.ContentHorizontalMargin)
                make.centerY.equalTo(tagLabel.snp.centerY)
                make.height.equalTo(NewsConfig.ReadNumFont.capHeight)
            })
        }
    }
}
