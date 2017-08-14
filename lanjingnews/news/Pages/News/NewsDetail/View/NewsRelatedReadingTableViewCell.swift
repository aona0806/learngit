//
//  NewsRelatedReadingTableViewCell.swift
//  news
//
//  Created by liuzhao on 16/7/5.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class NewsRelatedReadingTableViewCell: UITableViewCell {
    struct Consts {

        static let TitleColor = UIColor.black
        static let TitleFont: UIFont = UIFont.systemFont(ofSize: 17.0)
        static let TagColor = UIColor.rgb(0xaaaaaa)
        static let TagFont = UIFont.systemFont(ofSize: 11.0)
        static let LineColor = UIColor.rgb(0xdcdcdc)
        
        static let MarginValue: CGFloat = 15
        static let IntervalToTop: CGFloat = 13
        static let IntervalToTitle: CGFloat = 8
        static let IntervalToTag: CGFloat = 14
    }
    
    private var titleLabel: UILabel!
    private var lineView: UIView!
    private var tagLabel: UILabel!
    
    // MARK: - LifeCycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.selectionStyle = .none
        
        titleLabel = UILabel()
        titleLabel.textColor = Consts.TitleColor
        titleLabel.textAlignment = .left
        titleLabel.font = Consts.TitleFont
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        
        tagLabel = UILabel()
        tagLabel.textColor = Consts.TagColor
        tagLabel.textAlignment = .left
        tagLabel.font = Consts.TagFont
        tagLabel.numberOfLines = 0
        contentView.addSubview(tagLabel)
        
        lineView = UIView()
        lineView.backgroundColor = Consts.LineColor
        contentView.addSubview(lineView)
    }
    
    func setValueWithArticleRecModel(_ model: LJNewsDetailDataArticleRecModel?) {
        titleLabel.text = model?.title
        
        let time = model?.ctime ?? ""
        let source = model?.source ?? ""
        let author = model?.author ?? ""
        
        var tagStr: String! = ""
        if source.length() != 0 || author.length() != 0 {
            tagStr = tagStr + "文 / " + source + " " + author + " ";
        }
        tagStr = tagStr + DateFormatter.dayTimeZhunHuan(time, withFormat: "MM-dd HH:mm")

        tagLabel.text = tagStr
        
        
        self.updateConstraints()
    }
    
    class func cellHeightWithArticleRecModel(_ model: LJNewsDetailDataArticleRecModel?) -> CGFloat {
        var height: CGFloat = 0
        var titleHeight: CGFloat = 0
        var tagHeight: CGFloat = 0
        if model?.title != nil {
            let titleSize: CGSize! = model?.title!.size(withMaxWidth: GlobalConsts.screenWidth - 2 * Consts.MarginValue, font: Consts.TitleFont)
            titleHeight = titleSize.height
        }
        if model?.author != nil || model?.source != nil || model?.ctime != nil {
            let time = model?.ctime ?? ""
            let source = model?.source ?? ""
            let author = model?.author ?? ""
            
            var tagStr: String! = ""
            if source.length() != 0 || author.length() != 0 {
                tagStr = tagStr + "文 / " + source + " " + author + " ";
            }
            tagStr = tagStr + DateFormatter.dayTimeZhunHuan(time, withFormat: "MM-dd HH:mm")
            
            let tagSize: CGSize! = tagStr.size(withMaxWidth: GlobalConsts.screenWidth - 2 * Consts.MarginValue, font: Consts.TitleFont)
            tagHeight = tagSize.height
        }
        
        height = Consts.IntervalToTop + titleHeight + Consts.IntervalToTitle + tagHeight + Consts.IntervalToTag
        return ceil(height)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        titleLabel.snp.updateConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(Consts.MarginValue)
            make.right.equalTo(contentView.snp.right).offset(-Consts.MarginValue)
            make.top.equalTo(contentView.snp.top).offset(Consts.IntervalToTop)
        }
        
        tagLabel.snp.updateConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(Consts.MarginValue)
            make.right.equalTo(contentView.snp.right).offset(-Consts.MarginValue)
            make.top.equalTo(titleLabel.snp.bottom).offset(Consts.IntervalToTitle)
        }
        
        lineView.snp.updateConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(Consts.MarginValue)
            make.right.equalTo(contentView.snp.right).offset(-Consts.MarginValue)
            make.bottom.equalTo(contentView.snp.bottom).offset(0.0)
            make.height.equalTo(0.5)
        }
        
    }
}
