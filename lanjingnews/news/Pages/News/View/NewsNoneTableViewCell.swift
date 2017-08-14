//
//  NewsNoneTableViewCell.swift
//  news
//
//  Created by 陈龙 on 16/1/8.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit
import SnapKit

class NewsNoneTableViewCell: BaseTableViewCell {

    class Consts: NSObject {
        
        static let ImageHorizontalSpace: CGFloat = 2.5
        static let ImageHeight: CGFloat = 74.0
        static let ImageTopSpace: CGFloat = 15.0
        
        static let TitleRightSpace = CGFloat(24)
        static let TitleWidth: CGFloat = GlobalConsts.screenWidth - NewsConfig.ContentHorizontalMargin * 2
        
        static let AuthoreInfoTopSpace: CGFloat = 7.0
        
        static let TagRightSpace: CGFloat = 5.0
        
        static let TimeTopSpace: CGFloat = 10.0
    }
    
    private var titleLabel: UILabel!
    /// 摘要label
    private var summaryLabel: UILabel!
    
    private var authorInfoLabel: UILabel!
    private var timeLabel: UILabel!
    private var tagLabel: NewsTagLabel!
    private var readNumLabel: UILabel!
    private let seperateLineView = UIView()

    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        buildView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        if self.info != nil {
            
            titleLabel.snp.remakeConstraints {(make) -> Void in
                let title = info?.title ?? ""
                let titleSize: CGSize! = title.size(withMaxWidth: Consts.TitleWidth, font: NewsConfig.TitleFont, maxLineNum:2)
                make.left.equalTo(contentView.snp.left).offset(NewsConfig.ContentHorizontalMargin)
                make.top.equalTo(contentView.snp.top).offset(NewsConfig.ContentVerticalMargin)
                make.right.equalTo(contentView.snp.right).offset(-NewsConfig.ContentHorizontalMargin)
                make.height.equalTo(titleSize.height)
            }
            
            let summaryString = info?.brief
            if summaryString != nil {
                summaryLabel.snp.remakeConstraints ({ (make) in
                    let summarySize: CGSize! = summaryString!.size(withMaxWidth: Consts.TitleWidth, font: NewsConfig.SummaryFont, linespace: NewsConfig.SummaryLineSpace, maxLine: 2)
                    make.height.equalTo(summarySize.height)
                    make.left.equalTo(titleLabel.snp.left)
                    make.right.equalTo(titleLabel.snp.right)
                    make.top.equalTo(titleLabel.snp.bottom).offset(NewsConfig.SummaryTopSpace)
                })
                
                tagLabel.snp.remakeConstraints { (make) -> Void in
                    make.left.equalTo(titleLabel.snp.left)
                    make.top.equalTo(summaryLabel.snp.bottom).offset(Consts.AuthoreInfoTopSpace)
                    make.height.equalTo(NewsConfig.TimeHeight)
                }

            } else {
                tagLabel.snp.remakeConstraints { (make) -> Void in
                    make.left.equalTo(titleLabel.snp.left)
                    make.top.equalTo(titleLabel.snp.bottom).offset(Consts.AuthoreInfoTopSpace)
                    make.height.equalTo(NewsConfig.TimeHeight)
                }
            }
            
            let tagString = info?.tip?.name ?? ""
            var tagWidth: CGFloat! = 0
            var authorOffsetX = CGFloat(0)
            if tagString.length() > 0  {
                tagWidth = tagString.size(withMaxHeight: NewsConfig.TimeHeight, font: NewsConfig.TagFont).width + 10
                authorOffsetX = 5
            }
            tagLabel.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(tagWidth)
            }
            
            let authorInfoString = info?.authorInfo ?? ""
            
            let authorInfoSize: CGSize! = authorInfoString.size(withMaxHeight: NewsConfig.TimeHeight, font: NewsConfig.authorInfoFont)
            
             authorInfoLabel.snp.remakeConstraints { (make) -> Void in
                make.left.equalTo(tagLabel.snp.right).offset(authorOffsetX)
                make.centerY.equalTo(tagLabel.snp.centerY)
                make.height.equalTo(NewsConfig.TimeHeight)
                make.width.equalTo(authorInfoSize.width)
            }
            
            timeLabel.snp.remakeConstraints({ (make) -> Void in
                let leftSpaceOffset = authorInfoString == "" ? 0 : NewsConfig.TimeLeftSpace
                make.left.equalTo(authorInfoLabel.snp.right).offset(leftSpaceOffset)
                make.centerY.equalTo(authorInfoLabel.snp.centerY)
                make.height.equalTo(NewsConfig.TimeHeight)
            })
            
            var readNumString = info?.appReadNum ?? "0"
            readNumString = "阅读 " + readNumString.exchangeReadNum()
            readNumLabel.snp.remakeConstraints({ (make) in
                let readNumSize: CGSize! = readNumString.size(withMaxHeight: NewsConfig.ReadNumFont.capHeight, font: NewsConfig.ReadNumFont)
                make.right.equalTo(contentView.snp.right).offset(-NewsConfig.ContentHorizontalMargin)
                make.centerY.equalTo(authorInfoLabel.snp.centerY)
                make.height.equalTo(NewsConfig.TimeHeight)
                make.width.equalTo(readNumSize.width)
            })
        }
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
        titleLabel.backgroundColor = UIColor.clear
        contentView.addSubview(titleLabel)
        
        summaryLabel = UILabel()
        summaryLabel.numberOfLines = 0
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
        
        readNumLabel = UILabel()
        readNumLabel.textColor = NewsConfig.ReadNumColor
        readNumLabel.font = NewsConfig.ReadNumFont
        contentView.addSubview(readNumLabel)
        
        tagLabel = NewsTagLabel()
        tagLabel.font = NewsConfig.TagFont
        tagLabel.textAlignment = .center
        tagLabel.backgroundColor = UIColor.clear
        contentView.addSubview(tagLabel)
        
        seperateLineView.backgroundColor = NewsConfig.SeperateLineColor
        contentView.addSubview(seperateLineView)
        
        initConstraints()
        
    }
    
    private func initConstraints(){
        
        titleLabel.snp.makeConstraints {(make) -> Void in
            make.left.equalTo(contentView.snp.left).offset(NewsConfig.ContentHorizontalMargin)
            make.top.equalTo(contentView.snp.top).offset(NewsConfig.ContentVerticalMargin)
            make.right.equalTo(contentView.snp.right).offset(-NewsConfig.ContentHorizontalMargin)
        }
        
        summaryLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(titleLabel.snp.right)
            make.top.equalTo(titleLabel.snp.bottom).offset(NewsConfig.SummaryTopSpace)
        }
        
        tagLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(summaryLabel.snp.bottom).offset(Consts.AuthoreInfoTopSpace)
            make.height.equalTo(NewsConfig.TimeHeight)
        }
        
        authorInfoLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(tagLabel.snp.right)
            make.centerY.equalTo(tagLabel.snp.centerY)
            make.height.equalTo(NewsConfig.TimeHeight)
        }
        
        timeLabel.snp.makeConstraints({ (make) -> Void in
            make.left.equalTo(authorInfoLabel.snp.right)
            make.centerY.equalTo(authorInfoLabel.snp.centerY)
            make.height.equalTo(NewsConfig.TimeHeight)
        })
        
        readNumLabel.snp.makeConstraints { (make) in
            make.right.equalTo(contentView.snp.right).offset(-NewsConfig.ContentHorizontalMargin)
            make.centerY.equalTo(authorInfoLabel.snp.centerY)
            make.height.equalTo(NewsConfig.TimeHeight)
        }
        
        seperateLineView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp.left).offset(NewsConfig.SeperateLineLeftSpace)
            make.right.equalTo(contentView.snp.right).offset(-NewsConfig.SeperateLineLeftSpace)
            make.bottom.equalTo(contentView.snp.bottom).offset(-0.0)
            make.height.equalTo(0.5)
        }
    }
    
    // MARK - public
    
    class func heightForInfo(_ info: LJNewsListDataListModel) -> CGFloat {
        
        let title = info.title ?? ""
        let titleSize: CGSize! = title.size(withMaxWidth: Consts.TitleWidth, font: NewsConfig.TitleFont, maxLineNum:2)
        
        let summaryString = info.brief
        var summaryHeight: CGFloat! = 0.0
        if summaryString != nil {
            let summarySize: CGSize! = summaryString!.size(withMaxWidth: Consts.TitleWidth, font: NewsConfig.SummaryFont, linespace: NewsConfig.SummaryLineSpace, maxLine: 2)
            
            summaryHeight = summarySize.height + NewsConfig.SummaryTopSpace
        }

        var height = NewsConfig.ContentVerticalMargin + titleSize.height + summaryHeight
            
        height = height + Consts.AuthoreInfoTopSpace + NewsConfig.TimeHeight + NewsConfig.ContentVerticalSpace + 0.5
        
        return ceil(height)
    }
    
    var info: LJNewsListDataListModel? {
        didSet {
            
            var cTimeNumber :NSNumber?
            let cTime = info!.ctime ?? "0"
            if let number = Double(cTime) {
                cTimeNumber = NSNumber(value:number)
            }
            let timeString: String? = TKCommonTools.dateDesc(forTimeInterval: cTimeNumber)
            timeLabel.text = timeString

            titleLabel.text = info!.title ?? ""
            
            let summaryString = info?.brief
            if summaryString != nil {
                let summaryAttributeString = NSAttributedString.buildAttributeString(summaryString!, lineSpace: NewsConfig.SummaryLineSpace, foreColor: NewsConfig.SummaryColor, font: NewsConfig.SummaryFont)
                summaryLabel.attributedText = summaryAttributeString
            }
            summaryLabel.isHidden = (summaryString == nil)
            
            let tagString = info?.tip?.name ?? ""
            let tagForeColorString: String? = info?.tip?.forecolor
            let tagForeColror = UIColor.colorFromHexString(tagForeColorString, defaultColor: NewsConfig.TagDefaultColor)
            tagLabel.textColor = tagForeColror
            tagLabel.borderColor = tagForeColror
            tagLabel.borderWidth = 0.5
            tagLabel.text = tagString
            tagLabel.isHidden = false
            
            var readNumString = info?.appReadNum ?? "0"
            readNumString = "阅读 " + readNumString.exchangeReadNum()
            readNumLabel.text = readNumString
            
            tagLabel.isHidden = tagString.isEmpty

            let authorInfoString = info?.authorInfo ?? ""
            authorInfoLabel.text = authorInfoString
            
            setNeedsUpdateConstraints()
        }
    }

}
