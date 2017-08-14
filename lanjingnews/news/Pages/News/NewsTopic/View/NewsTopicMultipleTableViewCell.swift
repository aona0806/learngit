//
//  NewsTopicMultipleTableViewCell.swift
//  news
//
//  Created by 陈龙 on 16/1/12.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class NewsTopicMultipleTableViewCell: BaseTableViewCell {
    
    class Consts: NSObject {
        
        static let ImageHorizontalSpace: CGFloat = 2.5
        static let ImageHeight: CGFloat = 74.0
        static let ImageTopSpace: CGFloat = 15.0
        
        static let TitleRightSpace = CGFloat(24)
        static let TitleWidth: CGFloat = GlobalConsts.screenWidth - NewsConfig.ContentHorizontalSpace * 2 -
            Consts.TitleRightSpace
        static let TitleWidth2: CGFloat = GlobalConsts.screenWidth - NewsConfig.ContentHorizontalSpace * 2
        
        static let AuthoreInfoTopSpace: CGFloat = 10.0
        
        static let TagRightSpace: CGFloat = 5.0
        
        static let TimeTopSpace: CGFloat = 10.0
        static let TimeLeftSpace: CGFloat = 10.0
        
    }
    
    private var titleLabel: UILabel!
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
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byTruncatingTail
        contentView.addSubview(titleLabel)
        
        for _ in 0..<3 {
            
            let aImageView = UIImageView()
            aImageView.isHidden = true
            imageViews.append(aImageView)
            contentView.addSubview(aImageView)
        }
        
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
        let title = info.title ?? ""
        let titleSize: CGSize! = title.size(withMaxWidth: Consts.TitleWidth2, font: NewsConfig.TitleFont, maxLineNum: 2)
        let ImageWidth: CGFloat = (GlobalConsts.screenWidth - Consts.ImageHorizontalSpace - Consts.ImageHorizontalSpace * 2) / 3
        let ImageHeight = ImageWidth * NewsConfig.ImageRatio
        let height = NewsConfig.ContentVerticalMargin + titleSize.height + Consts.ImageTopSpace + ImageHeight + NewsConfig.ContentVerticalMargin
        
        return height
    }
    
    var info: LJNewsListDataListModel? {
        didSet {
            
            let imgs: [String] = info?.imgs ?? []
            let title = info?.title ?? ""
            titleLabel.text = title
            
            titleLabel.snp.updateConstraints {(make) -> Void in
                make.left.equalTo(contentView.snp.left).offset(NewsConfig.ContentHorizontalSpace)
                make.top.equalTo(contentView.snp.top).offset(NewsConfig.ContentVerticalMargin)
                make.right.equalTo(contentView.snp.right).offset(-NewsConfig.ContentHorizontalSpace)
                let titleSize: CGSize! = title.size(withMaxWidth: Consts.TitleWidth2, font: NewsConfig.TitleFont, maxLineNum: 2)
                make.height.equalTo(titleSize.height)
            }
            
            var firstView: UIView = contentView
            for index in 0...2 {
                let aImageView = imageViews[index]
                aImageView.isHidden = false
                var imageString: String! = ""
                if index < imgs.count {
                    imageString = imgs[index] 
                    imageViews[index].isHidden = false
                } else {
                    imageViews[index].isHidden = true
                }
                aImageView.sd_setImage(with: Urlhelper.tryEncode(imageString), placeholderImage: UIImage(named: "default_news_news"))
                let ImageWidth: CGFloat = (GlobalConsts.screenWidth - Consts.ImageHorizontalSpace - Consts.ImageHorizontalSpace * 2) / 3
                let ImageHeight = ImageWidth * NewsConfig.ImageRatio
                aImageView.snp.removeConstraints()
                aImageView.snp.updateConstraints { (make) -> Void in
                    if index == 0 {
                        make.left.equalTo(contentView.left).offset(NewsConfig.ContentHorizontalSpace)
                    } else {
                        make.left.equalTo(firstView.snp.right).offset(Consts.ImageHorizontalSpace)
                        make.width.equalTo(firstView.snp.width)
                    }
                    if index == 2 {
                        make.right.equalTo(contentView.right).offset(-NewsConfig.ContentHorizontalSpace)
                    }
                    make.top.equalTo(titleLabel.snp.bottom).offset(Consts.ImageTopSpace)
                    make.height.equalTo(ImageHeight)
                }
                firstView = aImageView
            }
        }
    }
}
