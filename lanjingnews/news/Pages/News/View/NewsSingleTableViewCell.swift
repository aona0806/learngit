//
//  NewsSingleTableViewCell.swift
//  news
//
//  Created by 陈龙 on 16/1/8.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class NewsSingleTableViewCell: BaseTableViewCell {

    class Consts: NSObject {
        
        static let ImageHorizontalSpace: CGFloat = 2.5
        static let ImageHeight: CGFloat = 66.0
        static let ImageTopSpace: CGFloat = 15.0
        
        static let TitleRightSpace = CGFloat(10)
        static let TitleWidth: CGFloat = GlobalConsts.screenWidth - NewsConfig.ContentHorizontalMargin * 2
        static let TitleWidth2: CGFloat = GlobalConsts.screenWidth - NewsConfig.ContentHorizontalMargin - Consts.TitleRightSpace - Consts.ImageHeight / NewsConfig.ImageRatio - TitleRightSpace
        
        static var SummaryRightSpace: CGFloat {
            get {
                var value: CGFloat!
                switch GlobalConsts.ScreenType {
                case .screenWidth320:
                    value = CGFloat(14.0)
                    break
                    
                default:
                    value = CGFloat(15)
                }
                return value
            }
        }
        static let AuthoreInfoTopSpace: CGFloat = 10.0
        static let TagRightSpace: CGFloat = 5.0
        static let TimeTopSpace: CGFloat = 10.0
        static let SummaryMaxLine: Int = 3
    }
    
    private var titleLabel: UILabel!
    
    private var summaryLabel: UILabel!
    
    private var authorInfoLabel: UILabel!
    private var timeLabel: UILabel!
    
    private var tagLabel: NewsTagLabel!
    
    private var readNumLabel: UILabel!
    
    private var postImageView: UIImageView!
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK - public
    
    class func heightForInfo(_ info: LJNewsListDataListModel) -> CGFloat {
        
        var height = NewsConfig.ContentVerticalMargin + Consts.ImageHeight + NewsConfig.ContentVerticalMargin

        let summaryString = info.brief
        if summaryString != nil {
            let titleString = info.title ?? ""
            let titleHeight = titleString.size(withMaxWidth: Consts.TitleWidth, font: NewsConfig.TitleFont, maxLineNum: 2).height
            let postImageViewWidth = Consts.ImageHeight / NewsConfig.ImageRatio
            let summaryMaxWidth = GlobalConsts.screenWidth - NewsConfig.ContentHorizontalSpace * 2 - postImageViewWidth - Consts.SummaryRightSpace
            let summaryHeight = summaryString!.size(withMaxWidth: summaryMaxWidth, font: NewsConfig.SummaryFont, linespace: NewsConfig.SummaryLineSpace, maxLine: Consts.SummaryMaxLine).height
            let imageheight = max(summaryHeight, Consts.ImageHeight)

            height = NewsConfig.ContentVerticalMargin + titleHeight + NewsConfig.SummaryTopSpace + imageheight + Consts.TimeTopSpace + NewsConfig.TimeHeight + NewsConfig.ContentVerticalSpace + 0.5
        } else {
            height = NewsConfig.ContentVerticalMargin + Consts.ImageHeight + Consts.TimeTopSpace + NewsConfig.TimeHeight + NewsConfig.ContentVerticalSpace + 0.5
        }
        return ceil(height)
    }
    
    // MARK: - private
    
    private func buildView() {
        
        self.selectionStyle = .none
        
        titleLabel = UILabel()
        titleLabel.textColor = NewsConfig.TitleColor
        titleLabel.font = NewsConfig.TitleFont
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.textAlignment = .left
        contentView.addSubview(titleLabel)
        
        summaryLabel = UILabel()
        summaryLabel.numberOfLines = Consts.SummaryMaxLine
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
        
        postImageView = UIImageView()
        postImageView.clipsToBounds = true
        postImageView.contentMode = .scaleAspectFill
        contentView.addSubview(postImageView)
        
        let seperateLineView = UIView()
        seperateLineView.backgroundColor = NewsConfig.SeperateLineColor
        contentView.addSubview(seperateLineView)
        seperateLineView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp.left).offset(NewsConfig.SeperateLineLeftSpace)
            make.right.equalTo(contentView.snp.right).offset(-NewsConfig.SeperateLineLeftSpace)
            make.bottom.equalTo(contentView.snp.bottom).offset(-0.0)
            make.height.equalTo(0.5)
        }
        
        readNumLabel = UILabel()
        readNumLabel.textColor = NewsConfig.ReadNumColor
        readNumLabel.font = NewsConfig.ReadNumFont
        contentView.addSubview(readNumLabel)
        
    }
    
    var info: LJNewsListDataListModel? {
        
        didSet {

            titleLabel.text = info!.title ?? ""
            
            let img: String = info!.imgs?.first ?? ""
            postImageView.isHidden = false
            if postImageView.sd_imageURL()?.absoluteString != img {
                
                let imageUrl = Urlhelper.tryEncode(img)
                postImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "default_news_news"))
            }
            
            let summaryString = info?.brief
            if summaryString != nil {
                let summaryAttributeString = NSAttributedString.buildAttributeString(summaryString!, lineSpace: NewsConfig.SummaryLineSpace, foreColor: NewsConfig.SummaryColor, font: NewsConfig.SummaryFont)
                summaryLabel.attributedText = summaryAttributeString

            }
            summaryLabel.isHidden = summaryString == nil
            
            let cTime = info?.ctime ?? "0"
            
            var cTimeNumber :NSNumber?
            if let number = Double(cTime) {
                cTimeNumber = NSNumber(value:number)
            }
            let timeString: String? = TKCommonTools.dateDesc(forTimeInterval: cTimeNumber)
            let authorInfoString = info?.authorInfo ?? ""
            timeLabel.text = timeString
            authorInfoLabel.text = authorInfoString
            
            let tagString = info?.tip?.name ?? ""
            let tagForeColorString: String? = info?.tip?.forecolor
            let tagForeColror = UIColor.colorFromHexString(tagForeColorString, defaultColor: NewsConfig.TagDefaultColor)
            tagLabel.textColor = tagForeColror
            tagLabel.borderColor = tagForeColror
            tagLabel.borderWidth = 0.5
            tagLabel.text = tagString
            tagLabel.isHidden = tagString.isEmpty
            
            var readNumString = info?.appReadNum ?? "0"
            readNumString = "阅读 " + readNumString.exchangeReadNum()
            readNumLabel.text = readNumString

            self.setNeedsUpdateConstraints()
        }
    }

    override func updateConstraints() {
        super.updateConstraints()

        if self.info != nil {
            
            let summaryString = info?.brief
            let hasSummary = summaryString != nil
            
            var readNumString = info?.appReadNum ?? "0"
            readNumString = "阅读 " + readNumString.exchangeReadNum()

            var lastView: UIView!
            if hasSummary {
                titleLabel.snp.remakeConstraints { (make) in
                    make.top.equalTo(contentView.snp.top).offset(NewsConfig.ContentVerticalMargin)
                    make.left.equalTo(contentView.snp.left).offset(NewsConfig.ContentHorizontalMargin)
                    make.right.equalTo(contentView.snp.right).offset(-NewsConfig.ContentHorizontalMargin)
                    
                    let titleString = info?.title ?? ""
                    let titleHeight = titleString.size(withMaxWidth: Consts.TitleWidth, font: NewsConfig.TitleFont, maxLineNum: 2).height
                    make.height.equalTo(titleHeight)
                }
                
                
                let postImageViewHeight = Consts.ImageHeight
                let postImageViewWidth = postImageViewHeight / NewsConfig.ImageRatio
                let summaryMaxWidth = GlobalConsts.screenWidth - NewsConfig.ContentHorizontalMargin * 2 - postImageViewWidth - Consts.SummaryRightSpace
                let summaryHeight = summaryString!.size(withMaxWidth: summaryMaxWidth, font: NewsConfig.SummaryFont, linespace: NewsConfig.SummaryLineSpace, maxLine: Consts.SummaryMaxLine).height

                summaryLabel.snp.remakeConstraints { (make) in
                    make.top.equalTo(postImageView.snp.top)
                    make.left.equalTo(postImageView.snp.right).offset(NewsConfig.ContentHorizontalSpace)
                    make.right.equalTo(contentView.snp.right).offset(-NewsConfig.ContentHorizontalMargin)
                    make.height.equalTo(summaryHeight)
                }
                
                postImageView.snp.remakeConstraints { (make) -> Void in
                    make.top.equalTo(titleLabel.snp.bottom).offset(NewsConfig.SummaryTopSpace)
                    make.left.equalTo(titleLabel.snp.left)
                    make.width.equalTo(postImageViewWidth)
                    make.height.equalTo(postImageViewHeight)
                }

                lastView = summaryHeight > postImageViewHeight ? summaryLabel : postImageView
                
            } else {
                
                postImageView.snp.remakeConstraints { (make) -> Void in
                    make.top.equalTo(contentView.snp.top).offset(NewsConfig.ContentVerticalMargin)
                    make.left.equalTo(contentView.snp.left).offset(NewsConfig.ContentHorizontalMargin)
                    let postImageViewHeight = Consts.ImageHeight
                    let postImageViewWidth = postImageViewHeight / NewsConfig.ImageRatio
                    make.width.equalTo(postImageViewWidth)
                    make.height.equalTo(postImageViewHeight)
                }
                
                titleLabel.snp.remakeConstraints { (make) -> Void in
                    make.left.equalTo(postImageView.snp.right).offset(Consts.TitleRightSpace)
                    make.top.equalTo(postImageView.snp.top)
                    make.right.equalTo(contentView.snp.right).offset(-NewsConfig.ContentHorizontalMargin)
                    let titleString = info?.title ?? ""
                    let titleHeight = titleString.size(withMaxWidth: Consts.TitleWidth2, font: NewsConfig.TitleFont, maxLineNum: 2).height

                    make.height.equalTo(titleHeight)
                }
                
                lastView = postImageView
            }
            
            tagLabel.snp.remakeConstraints { (make) -> Void in
                make.top.equalTo(lastView.snp.bottom).offset(Consts.TimeTopSpace)
                make.left.equalTo(postImageView.snp.left)
                make.height.equalTo(NewsConfig.TimeHeight)
                make.width.equalTo(0)
            }
            
            authorInfoLabel.snp.remakeConstraints { (make) -> Void in
                
                make.left.equalTo(tagLabel.snp.right).offset(Consts.TagRightSpace)
                make.top.equalTo(lastView.snp.bottom).offset(Consts.TimeTopSpace)
                make.height.equalTo(NewsConfig.TimeHeight)
                make.width.equalTo(0)
            }
            
            timeLabel.snp.remakeConstraints({ (make) -> Void in
                make.left.equalTo(authorInfoLabel.snp.right).offset(NewsConfig.TimeLeftSpace)
                make.height.equalTo(NewsConfig.TimeHeight)
                make.top.equalTo(lastView.snp.bottom).offset(Consts.TimeTopSpace)
            })
            
            readNumLabel.snp.remakeConstraints({ (make) in
                make.right.equalTo(contentView.snp.right).offset(-NewsConfig.ContentHorizontalMargin)
                make.height.equalTo(NewsConfig.TimeHeight)
                make.top.equalTo(lastView.snp.bottom).offset(Consts.TimeTopSpace)
                let readNumSize: CGSize! = readNumString.size(withMaxHeight: Consts.TimeTopSpace, font: NewsConfig.ReadNumFont)
                make.width.equalTo(readNumSize.width)
            })
            
            var authorOffsetX = CGFloat(0)
            var tagWidth: CGFloat! =  CGFloat(0)
            if let tagText = tagLabel.text {
                if !tagText.isEmpty  {
                    tagWidth = tagText.size(withMaxHeight: NewsConfig.TimeHeight, font: NewsConfig.TagFont).width + 10
                    authorOffsetX = Consts.TagRightSpace
                }
            }
            
            let authorInfoString = info?.authorInfo ?? ""
            
            let authorInfoSize: CGSize! = authorInfoString.size(withMaxHeight: NewsConfig.TimeHeight, font: NewsConfig.authorInfoFont)
            
            tagLabel.snp.updateConstraints { (make) -> Void in
                make.width.equalTo(tagWidth)
            }
            
            authorInfoLabel.snp.updateConstraints { (make) -> Void in
                make.left.equalTo(tagLabel.snp.right).offset(authorOffsetX)
                make.width.equalTo(authorInfoSize.width)
            }
            
            let leftSpaceOffset = authorInfoString == "" ? 0 : NewsConfig.TimeLeftSpace
            timeLabel.snp.updateConstraints({ (make) -> Void in
                make.left.equalTo(authorInfoLabel.snp.right).offset(leftSpaceOffset)
            })

        }
   }
    
}
