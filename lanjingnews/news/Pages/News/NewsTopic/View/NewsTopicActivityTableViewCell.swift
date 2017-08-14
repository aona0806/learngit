//
//  NewsTopicActivityTableViewCell.swift
//  news
//
//  Created by 陈龙 on 16/1/13.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class NewsTopicActivityTableViewCell: BaseTableViewCell {

    private class Consts: NSObject {
        
        static let TitleRightSpace = CGFloat(5)
        static let TitleWidth = GlobalConsts.screenWidth - NewsConfig.ContentHorizontalSpace * 2  -
            Consts.TitleRightSpace
        
        static let ImageTopSpace = CGFloat(15)
        static let ImageWidth = GlobalConsts.screenWidth - NewsConfig.ContentHorizontalSpace * 2
    }
    
    private var titleLabel: UILabel!
    private var postImageView: UIImageView!
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
            titleLabel.text = title
            let titleHeight: CGFloat! = title.size(withMaxWidth: Consts.TitleWidth, font: NewsConfig.TitleFont, maxLineNum: 2).height
            titleLabel.snp.updateConstraints { (make) -> Void in
                make.top.equalTo(contentView.snp.top).offset(NewsConfig.ContentVerticalMargin)
                make.left.equalTo(contentView.snp.left).offset(NewsConfig.ContentHorizontalSpace)
                make.right.equalTo(contentView.snp.right).offset(-NewsConfig.ContentHorizontalSpace - Consts.TitleRightSpace)
                make.height.equalTo(titleHeight)
            }
            
            let imageUrl = Urlhelper.tryEncode(info?.imgs?.first)
            postImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "default_news_activity"))
            let postImageViewHeight: CGFloat = Consts.ImageWidth * NewsConfig.PostImageRatio
            postImageView.snp.updateConstraints { (make) -> Void in
                make.left.equalTo(contentView.snp.left).offset(NewsConfig.ContentHorizontalSpace)
                make.right.equalTo(contentView.snp.right).offset(-NewsConfig.ContentHorizontalSpace)
                make.top.equalTo(titleLabel.snp.bottom).offset(Consts.ImageTopSpace)
                make.height.equalTo(postImageViewHeight)
            }
            
            let tagString = info?.tip?.name ?? ""
            toliveImageView.isHidden = tagString != "直播"
            toliveImageView.snp.updateConstraints { (make) -> Void in
                make.center.equalTo(postImageView.snp.center)
                make.width.equalTo(88)
                make.height.equalTo(31)
            }
        }
    }
    
    class func heightForCell(_ info: LJNewsListDataListModel!) -> CGFloat {
        
        let title = info!.title ?? ""
        let titleHeight: CGFloat! = title.size(withMaxWidth: Consts.TitleWidth, font: NewsConfig.TitleFont, maxLineNum: 2).height
        
        let postImageViewHeight: CGFloat = Consts.ImageWidth * NewsConfig.PostImageRatio
        
        let height = NewsConfig.ContentVerticalMargin + titleHeight + Consts.ImageTopSpace + postImageViewHeight + NewsConfig.ContentVerticalMargin
        return height
        
    }

}
