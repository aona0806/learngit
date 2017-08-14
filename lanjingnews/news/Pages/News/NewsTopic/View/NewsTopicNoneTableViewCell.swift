//
//  NewsTopicNoneViewController.swift
//  news
//
//  Created by 陈龙 on 16/1/12.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class NewsTopicNoneTableViewCell: BaseTableViewCell {
    
    class Consts: NSObject {
        
        static let TitleRightSpace = CGFloat(24)
        static let TitleWidth: CGFloat = GlobalConsts.screenWidth - NewsConfig.ContentHorizontalSpace * 2 -
            Consts.TitleRightSpace
        static let TitleWidth2: CGFloat = GlobalConsts.screenWidth - NewsConfig.ContentHorizontalSpace * 2
        
    }
    
    private var titleLabel: UILabel!
    
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
        let height = NewsConfig.ContentVerticalMargin + titleSize.height + NewsConfig.ContentVerticalMargin
        
        return height
    }
    
    var info: LJNewsListDataListModel? {
        didSet {
            
            let title = info?.title ?? ""
            titleLabel.text = title
            titleLabel.snp.updateConstraints {(make) -> Void in
                let titleSize: CGSize! = title.size(withMaxWidth: Consts.TitleWidth2, font: NewsConfig.TitleFont, maxLineNum: 2)
                make.left.equalTo(contentView.snp.left).offset(NewsConfig.ContentHorizontalSpace)
                make.top.equalTo(contentView.snp.top).offset(NewsConfig.ContentVerticalMargin)
                make.right.equalTo(contentView.snp.right).offset(-NewsConfig.ContentHorizontalSpace)
                make.height.equalTo(titleSize.height)
            }
            
        }
    }
}
