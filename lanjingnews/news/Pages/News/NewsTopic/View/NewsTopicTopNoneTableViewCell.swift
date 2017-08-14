//
//  NewsTopicTopNoneTableViewCell.swift
//  news
//
//  Created by 陈龙 on 16/1/12.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

/// 专题没有图片
class NewsTopicTopNoneTableViewCell: BaseTableViewCell {

    class Consts: NSObject {
        
        static let TitleBackImageRatio: CGFloat = 40.0 / 375
        static let TitleFont = UIFont.systemFont(ofSize: 20)
        static let TitleHorizontalSpace: CGFloat = 15.0
        static let TitleVerticalSpace: CGFloat = 20.0
        
        static let ContentHorizontalSpace: CGFloat = 15.0
        static let ContentVerticalSpace: CGFloat = 22.5
        
        static let LineHeight: CGFloat = 0.5
    }
    
    private let titleLabel: UILabel! = UILabel()
    private let contentLabel = UILabel()
    private let lineSpace = UIView()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        buildView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - public
    
    var info: NewsTopicDetailDataTopicInfoModel? {
        didSet {
            
            contentLabel.text = "摘要：" + (info?.desc ?? "")
            
            let title = info?.title ?? ""
            let titleLabelWidth = GlobalConsts.screenWidth - Consts.TitleHorizontalSpace * 2
            let titleLabelHeight = title.size(withMaxWidth: titleLabelWidth, font: Consts.TitleFont, maxLineNum: 2).height 
            
            titleLabel.text = title
            titleLabel.snp.updateConstraints { (make) -> Void in
                make.height.equalTo(titleLabelHeight)
                make.left.equalTo(contentView.snp.left).offset(Consts.TitleHorizontalSpace)
                make.right.equalTo(contentView.snp.right).offset(-Consts.TitleHorizontalSpace)
                make.top.equalTo(contentView.snp.top).offset(Consts.TitleVerticalSpace)
            }
            
            contentLabel.snp.updateConstraints { (make) -> Void in
                make.left.equalTo(contentView.snp.left).offset(Consts.ContentHorizontalSpace)
                make.right.equalTo(contentView.snp.right).offset(-Consts.ContentHorizontalSpace)
                make.top.equalTo(titleLabel.snp.bottom).offset(Consts.ContentVerticalSpace)
                let contetnWidth: CGFloat = GlobalConsts.screenWidth - Consts.ContentHorizontalSpace * 2
                let descString = info?.desc ?? ""
                let contentHegith = descString.size(withMaxWidth: contetnWidth, font: NewsConfig.DetailContentFont).height
                make.height.equalTo(contentHegith)
            }
            
            lineSpace.snp.updateConstraints { (make) -> Void in
                make.left.equalTo(contentLabel.left).offset(Consts.ContentHorizontalSpace)
                make.right.equalTo(contentLabel.right).offset(-Consts.ContentHorizontalSpace)
                make.bottom.equalTo(contentView.snp.bottom).offset(-Consts.LineHeight)
                make.height.equalTo(Consts.LineHeight)
            }
        }
    }
    
    class func heightForCell(_ info: NewsTopicDetailDataTopicInfoModel?) -> CGFloat {
        
        var height: CGFloat = 0
        if info != nil {
            let title = info?.title ?? ""
            let titleLabelWidth = GlobalConsts.screenWidth - Consts.TitleHorizontalSpace * 2
            let titleLabelHeight = title.size(withMaxWidth: titleLabelWidth, font: Consts.TitleFont, maxLineNum: 2).height
            
            let contentWidth: CGFloat = GlobalConsts.screenWidth - Consts.ContentHorizontalSpace * 2
            let descString = "摘要：" + (info?.desc ?? "")
            let contentHegith = descString.size(withMaxWidth: contentWidth, font: NewsConfig.DetailContentFont).height
            height = titleLabelHeight + Consts.TitleVerticalSpace * 2 + contentHegith + Consts.ContentVerticalSpace
        }
        return height
    }
    
    // MARK: - private
    
    private func buildView() {
        
        titleLabel.textColor = NewsConfig.TitleColor
        titleLabel.font = Consts.TitleFont
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.backgroundColor = UIColor.clear
        contentView.addSubview(titleLabel)
        
        contentLabel.textColor = NewsConfig.DetailContentColor
        contentLabel.font = NewsConfig.DetailContentFont
        contentLabel.numberOfLines = 0
        contentLabel.backgroundColor = UIColor.clear
        contentView.addSubview(contentLabel)
        
        lineSpace.backgroundColor = NewsConfig.SeperateLineColor
        contentView.addSubview(lineSpace)
    }

}
