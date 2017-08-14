//
//  LJNewsActivityTableViewCell.swift
//  news
//
//  Created by 陈龙 on 16/1/5.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class LJNewsActivityTableViewCell: BaseTableViewCell {

    private class Consts: NSObject {
        
        static let TitleRightSpace = CGFloat(5)
        static let TitleWidth = GlobalConsts.screenWidth - NewsConfig.ContentHorizontalMargin * 2  -
            Consts.TitleRightSpace
        
        static let ImageTopSpace = CGFloat(15)
        static let ImageWidth = GlobalConsts.screenWidth - NewsConfig.ContentHorizontalMargin * 2
        
        static let AuthorInfoTopSpace = CGFloat(15)
        static let AuthorInfoLeftSpace = CGFloat(15)
        
        static let TimeTopSpace = CGFloat(5)
        static let TimeLeftSpace = CGFloat(10)
    }
    
    private var titleLabel: UILabel!
    private var tagLabel: NewsTagLabel!
    private var postImageView: UIImageView!
    private var authorInfoLabel: UILabel!
    private var timeLabel: UILabel!
    private var toliveImageView: UIImageView!
    
    var templateType: LJTemplateType! = LJTemplateType.activity
    
    // MARK: - Lifecycle
    
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
        titleLabel.font = NewsConfig.TitleFont
        titleLabel.textColor = NewsConfig.TitleColor
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.numberOfLines = 2
        contentView.addSubview(titleLabel)
        
        postImageView = UIImageView()
        contentView.addSubview(postImageView)
        
        toliveImageView = UIImageView()
        toliveImageView.image = UIImage(named: "news_activity_tolive")
        toliveImageView.isHidden = true
        postImageView.addSubview(toliveImageView)
        
        tagLabel = NewsTagLabel()
        tagLabel.font = NewsConfig.TagFont
        tagLabel.textAlignment = .center
        tagLabel.backgroundColor = UIColor.clear
        contentView.addSubview(tagLabel)
        
        authorInfoLabel = UILabel()
        authorInfoLabel.font = NewsConfig.authorInfoFont
        authorInfoLabel.textColor = NewsConfig.authorInfoColor
        authorInfoLabel.backgroundColor = UIColor.clear
        contentView.addSubview(authorInfoLabel)
        
        timeLabel = UILabel()
        timeLabel.font = NewsConfig.TimeFont
        timeLabel.textColor = NewsConfig.TimeColor
        timeLabel.backgroundColor = UIColor.clear
        contentView.addSubview(timeLabel)
        
        let seperateLineView = UIView()
        seperateLineView.backgroundColor = NewsConfig.SeperateLineColor
        contentView.addSubview(seperateLineView)
        seperateLineView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp.left).offset(NewsConfig.SeperateLineLeftSpace)
            make.right.equalTo(contentView.snp.right).offset(-NewsConfig.SeperateLineLeftSpace)
            make.bottom.equalTo(contentView.snp.bottom).offset(0.0)
            make.height.equalTo(0.5)
        }
    }
    
    // MARK: - public
    
    var info: LJNewsListDataListModel? {
        didSet {
            
            let title = info!.title ?? ""
            titleLabel.text = title as String
            let titleHeight: CGFloat! = title.size(withMaxWidth: Consts.TitleWidth, font: NewsConfig.TitleFont, maxLineNum: 2).height
            titleLabel.snp.updateConstraints { (make) -> Void in
                make.top.equalTo(contentView.snp.top).offset(NewsConfig.ContentVerticalMargin)
                make.left.equalTo(contentView.snp.left).offset(NewsConfig.ContentHorizontalMargin)
                make.right.equalTo(contentView.snp.right).offset(-NewsConfig.ContentHorizontalMargin - Consts.TitleRightSpace)
                make.height.equalTo(titleHeight)
            }
            
            let imageString = info?.imgs?.first ?? ""
            
            let imageUrl = Urlhelper.tryEncode(imageString)
            postImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "default_news_activity"))
            let postImageViewHeight: CGFloat = Consts.ImageWidth * NewsConfig.PostImageRatio
            postImageView.snp.updateConstraints { (make) -> Void in
                make.left.equalTo(contentView.snp.left).offset(NewsConfig.ContentHorizontalMargin)
                make.right.equalTo(contentView.snp.right).offset(-NewsConfig.ContentHorizontalMargin)
                make.top.equalTo(titleLabel.snp.bottom).offset(Consts.ImageTopSpace)
                make.height.equalTo(postImageViewHeight)
            }
            
            let tagString = info?.tip?.name ?? ""
            let tagForeColorString: String? = info?.tip?.forecolor
            let tagForeColror = UIColor.colorFromHexString(tagForeColorString, defaultColor: NewsConfig.TagDefaultColor)
            tagLabel.borderColor = tagForeColror
            tagLabel.borderWidth = CGFloat(0.5)
            tagLabel.textColor = tagForeColror
            tagLabel.text = tagString
            let tagWidth: CGFloat! = tagString.size(withMaxHeight: NewsConfig.TimeHeight, font: NewsConfig.TagFont).width + 10
            tagLabel.isHidden = tagString.isEmpty
            tagLabel.snp.updateConstraints { (make) -> Void in
                make.left.equalTo(postImageView.snp.left)
                make.top.equalTo(postImageView.snp.bottom).offset(Consts.AuthorInfoTopSpace)
                make.height.equalTo(NewsConfig.TimeHeight)
                make.width.equalTo(tagWidth)
            }
            
            if self.templateType == LJTemplateType.conference {
                toliveImageView.isHidden = tagString != "直播"
                toliveImageView.snp.updateConstraints { (make) -> Void in
                    make.center.equalTo(postImageView.snp.center)
                    make.width.equalTo(88)
                    make.height.equalTo(31)
                }
            } else {
                toliveImageView.isHidden = true
            }
            
            let sponsor = info?.sponsor ?? ""
            let authorInfoString = "主办方：" + sponsor
            authorInfoLabel.text = authorInfoString
            authorInfoLabel.snp.updateConstraints { (make) -> Void in
                if tagString.isEmpty {
                    make.left.equalTo(postImageView.snp.left)
                } else {
                    make.left.equalTo(tagLabel.snp.right).offset(Consts.AuthorInfoLeftSpace)
                }
                make.height.equalTo(NewsConfig.TimeHeight)
                make.top.equalTo(tagLabel.snp.top)
                make.right.equalTo(titleLabel.snp.right)
            }
                 
            var timeString: String! = ""
            if info?.timeStart != nil {
                let timeStartString = NSString(string: (info?.timeStart)!)
                let timeDate = Date(timeIntervalSince1970: timeStartString.doubleValue)
                timeString = TKCommonTools.dateString(withFormat: "MM月dd日 HH:mm", date: timeDate)
            }
            
            let timeAttributes = [NSForegroundColorAttributeName:NewsConfig.TimeColor, NSFontAttributeName: NewsConfig.TimeFont]
            let timeStrings = "时时间：" + timeString
            let timeStringAttribute = NSMutableAttributedString(string: timeStrings, attributes: timeAttributes)
            timeStringAttribute.addAttribute(NSForegroundColorAttributeName, value: UIColor.clear, range: NSMakeRange(1, 1))
            timeLabel.attributedText = timeStringAttribute
            timeLabel.snp.updateConstraints { (make) -> Void in
                make.left.equalTo(authorInfoLabel.snp.left)
                make.top.equalTo(authorInfoLabel.snp.bottom).offset(Consts.TimeTopSpace)
                make.height.equalTo(NewsConfig.TimeHeight)
                make.right.equalTo(contentView.snp.right)
            }
        }
    }
    
    class func heightForCell(_ info: LJNewsListDataListModel!) -> CGFloat {
        
        let title = info!.title ?? ""
        let titleHeight: CGFloat! = title.size(withMaxWidth: Consts.TitleWidth, font: NewsConfig.TitleFont, maxLineNum: 2).height
        
        let postImageViewHeight: CGFloat = Consts.ImageWidth * NewsConfig.PostImageRatio
        
        let height = NewsConfig.ContentVerticalMargin + titleHeight + Consts.ImageTopSpace + postImageViewHeight + Consts.AuthorInfoTopSpace + NewsConfig.TimeHeight + Consts.TimeTopSpace + NewsConfig.TimeHeight + NewsConfig.ContentVerticalSpace
        return height
        
    }
}
