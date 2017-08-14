//
//  LJTopicTableViewCell.swift
//  news
//
//  Created by 陈龙 on 16/1/5.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class LJTopicTableViewCell: BaseTableViewCell {

    private class Consts: NSObject {
        
        static let TitleRightSpace = CGFloat(5)
        static let TitleWidth = GlobalConsts.screenWidth - NewsConfig.ContentHorizontalMargin * 2  -
            Consts.TitleRightSpace
        
        static let ImageTopSpace = CGFloat(15)
        static let ImageWidth = GlobalConsts.screenWidth - NewsConfig.ContentHorizontalMargin * 2
        
        static let TimeTopSpace = CGFloat(15)
        static let TimeLeftSpace = CGFloat(15)
    }
    
    private var titleLabel: UILabel!
    private var tagLabel: NewsTagLabel!
    private var tagImageView: UIImageView!
    private var postImageView: UIImageView!
    private var timeLabel: UILabel!

    // MARK: - Lifecycle
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        titleLabel = UILabel()
        titleLabel.font = NewsConfig.TitleFont
        titleLabel.textColor = NewsConfig.TitleColor
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 2
        titleLabel.backgroundColor = UIColor.clear
        contentView.addSubview(titleLabel)
        
        postImageView = UIImageView()
        contentView.addSubview(postImageView)

        tagLabel = NewsTagLabel()
        tagLabel.font = NewsConfig.TagFont
        tagLabel.textAlignment = .center
        tagLabel.backgroundColor = UIColor.clear
        contentView.addSubview(tagLabel)
        
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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - public
    
    var info: LJNewsListDataListModel? {
        didSet {
            
            let title = info?.title ?? ""
            titleLabel.text = title
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
                        
            let cTime = info?.ctime ?? "0"
            var cTimeNumber :NSNumber?
            if let number = Double(cTime) {
                cTimeNumber = NSNumber(value:number)
            }
            let timeString: String? = TKCommonTools.dateDesc(forTimeInterval: cTimeNumber)

            timeLabel.text = timeString
            
            let tagString = info?.tip?.name ?? ""
            let tagForeColorString: String? = info?.tip?.forecolor
            let tagForeColror = UIColor.colorFromHexString(tagForeColorString, defaultColor: NewsConfig.TagDefaultColor)
            tagLabel.textColor = tagForeColror
            tagLabel.borderColor = tagForeColror
            tagLabel.borderWidth = 0.5
            tagLabel.text = tagString
            let tagWidth: CGFloat! = tagString.size(withMaxHeight: NewsConfig.TimeHeight, font: NewsConfig.TagFont).width + 10
            tagLabel.isHidden = tagString.isEmpty
            
            tagLabel.snp.updateConstraints { (make) -> Void in
                make.left.equalTo(titleLabel.snp.left)
                make.top.equalTo(postImageView.snp.bottom).offset(Consts.TimeTopSpace)
                make.height.equalTo(NewsConfig.TimeHeight)
                make.width.equalTo(tagWidth)
            }
            timeLabel.snp.updateConstraints { (make) -> Void in
                if tagString.isEmpty {
                    make.left.equalTo(titleLabel.snp.left)
                } else {
                    make.left.equalTo(tagLabel.snp.right).offset(Consts.TimeLeftSpace)
                }
                make.top.equalTo(tagLabel.snp.top)
                make.height.equalTo(NewsConfig.TimeHeight)
                make.right.equalTo(contentView.right)
            }
        }
    }
    
    class func heightForCell(_ info: LJNewsListDataListModel!) -> CGFloat {
        
        let title = info!.title ?? ""
        let titleHeight: CGFloat! = title.size(withMaxWidth: Consts.TitleWidth, font: NewsConfig.TitleFont, maxLineNum: 2).height

        let postImageViewHeight: CGFloat = Consts.ImageWidth * NewsConfig.PostImageRatio
        
        let height = NewsConfig.ContentVerticalMargin + titleHeight + Consts.ImageTopSpace + postImageViewHeight + Consts.TimeTopSpace + NewsConfig.TimeHeight + NewsConfig.ContentVerticalMargin
        return height

    }
}
