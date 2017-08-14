//
//  NewsTopicSingleTableViewCell.swift
//  news
//
//  Created by 陈龙 on 16/1/12.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class NewsTopicSingleTableViewCell: BaseTableViewCell {

    class Consts: NSObject {
        
        static let ImageHorizontalSpace: CGFloat = 2.5
        static let ImageHeight: CGFloat = 74.0
        static let ImageTopSpace: CGFloat = 15.0
        
        static let TitleRightSpace = CGFloat(24)
        static let TitleWidth: CGFloat = GlobalConsts.screenWidth - NewsConfig.ContentHorizontalSpace * 2 -
            Consts.TitleRightSpace
        static let TitleWidth2: CGFloat = GlobalConsts.screenWidth - NewsConfig.ContentHorizontalSpace * 2
        
    }
    
    private var titleLabel: UILabel!
    private var postImageView: UIImageView!
    
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
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.textAlignment = .left
        contentView.addSubview(titleLabel)
        
        postImageView = UIImageView()
        postImageView.clipsToBounds = true
        contentView.addSubview(postImageView)
        
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
    
    // MARK - public
    
    class func heightForInfo(_ info: LJNewsListDataListModel) -> CGFloat {
        
        let height = NewsConfig.ContentVerticalMargin + Consts.ImageHeight + NewsConfig.ContentVerticalMargin
        return height
    }
    
    var info: LJNewsListDataListModel? {
        didSet {
            
            let img: String = info?.imgs?.first ?? ""
            titleLabel.text = info?.title ?? ""
            
            postImageView.isHidden = false
            postImageView.backgroundColor = UIColor.red
            postImageView.sd_setImage(with: Urlhelper.tryEncode(img), placeholderImage: UIImage(named: "default_news_news"))
            postImageView.snp.updateConstraints { (make) -> Void in
                make.top.equalTo(contentView.snp.top).offset(NewsConfig.ContentVerticalMargin)
                make.right.equalTo(contentView.snp.right).offset(-NewsConfig.ContentHorizontalSpace)
                let postImageViewHeight = Consts.ImageHeight
                let postImageViewWidth = postImageViewHeight / NewsConfig.ImageRatio
                make.width.equalTo(postImageViewWidth)
                make.height.equalTo(postImageViewHeight)
            }
            
            titleLabel.snp.updateConstraints { (make) -> Void in
                make.left.equalTo(contentView.snp.left).offset(NewsConfig.ContentHorizontalSpace)
                make.top.equalTo(contentView.snp.top).offset(NewsConfig.ContentVerticalMargin)
                make.right.equalTo(postImageView.snp.left).offset(-Consts.TitleRightSpace)
                make.height.greaterThanOrEqualTo(0)
            }
        }
    }

}
