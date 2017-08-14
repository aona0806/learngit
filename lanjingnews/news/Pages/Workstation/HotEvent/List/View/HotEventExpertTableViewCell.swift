//
//  HotEventExpertTableView.swift
//  news
//
//  Created by 陈龙 on 16/6/6.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class HotEventExpertTableViewCell: BaseTableViewCell {

    struct Consts {
        
        static let ContentHorizontalSpace = CGFloat(15)
        
        static let NameFont = UIFont.systemFont(ofSize: 15)
        static let NameColor = UIColor.black
        static let NameTopSpace = CGFloat(10)
        
        static let CompanyTopSpace = CGFloat(9)
        static let CompanyColor = UIColor.rgb(0x6c6c6c)
        static let CompanyFont = UIFont.systemFont(ofSize: 12)
        
        static let JobLeftSpace = CGFloat(5)
        static let JobColor = UIColor.rgb(0x6c6c6c)
        static let JobFont = UIFont.systemFont(ofSize: 12)
        
        static let ImageSize = CGSize(width: 17, height: 33)
        
        static let JobMaxNum = Int(10)
    }
    
    private let nameLabel = UILabel()
    private let companyLabel = UILabel()
    private let jobLabel = UILabel()
    private let arrowImageview = UIImageView()
    private let seperateLineView = UIView()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        initView()
        initViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        guard let model = info else {
            return
        }
        
        
        let jobString: NSString = model.job as NSString? ?? ""
        let jobHeight = Consts.JobFont.lineHeight
        let jobWidth = jobString.size(withMaxHeight: jobHeight, font: Consts.JobFont).width
        
        jobLabel.snp.updateConstraints { (make) in
            make.width.equalTo(jobWidth)
        }
        
        let companyMaxWidth = GlobalConsts.screenWidth - Consts.ContentHorizontalSpace * 2 - jobWidth - Consts.JobLeftSpace - Consts.ImageSize.width - Consts.ContentHorizontalSpace
        let companyString: NSString = model.company as NSString? ?? ""
        let companyHeigt = Consts.CompanyFont.lineHeight
        var companyWidth = companyString.size(withMaxHeight: companyHeigt, font: Consts.CompanyFont).width
        companyWidth = min(companyMaxWidth, companyWidth)
        companyLabel.snp.updateConstraints { (make) in
            make.width.equalTo(companyWidth)
        }
    }
    
    // MARK: - private
    
    private func initView() {
        
        nameLabel.backgroundColor = UIColor.clear
        nameLabel.font = Consts.NameFont
        nameLabel.textColor = Consts.NameColor
        nameLabel.numberOfLines = 1
        nameLabel.lineBreakMode = .byTruncatingTail
        contentView.addSubview(nameLabel)
        
        companyLabel.backgroundColor = UIColor.clear
        companyLabel.font = Consts.CompanyFont
        companyLabel.textColor = Consts.CompanyColor
        if #available(iOS 9.0, *) {
            companyLabel.numberOfLines = 0
        } else {
            companyLabel.numberOfLines = 1
        }
        companyLabel.lineBreakMode = .byTruncatingTail
        contentView.addSubview(companyLabel)
        
        jobLabel.backgroundColor = UIColor.clear
        jobLabel.font = Consts.JobFont
        jobLabel.textColor = Consts.JobColor
        jobLabel.numberOfLines = 1
        contentView.addSubview(jobLabel)
        
        let image = UIImage(named: "hotevent_expert_arrow")
        arrowImageview.image = image
        contentView.addSubview(arrowImageview)
        
        seperateLineView.backgroundColor = HotEventConfig.SeperateLineColor
        contentView.addSubview(seperateLineView)
        
    }
    
    private func initViewConstraints() -> Void {
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.snp.edges)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(Consts.ContentHorizontalSpace)
            make.top.equalTo(contentView.snp.top).offset(Consts.NameTopSpace)
            make.height.equalTo(Consts.NameFont.lineHeight)
            make.right.equalTo(arrowImageview.snp.left).offset(-Consts.ContentHorizontalSpace)
        }
        
        companyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(nameLabel.snp.bottom).offset(Consts.CompanyTopSpace)
            make.height.equalTo(Consts.CompanyFont.lineHeight)
            make.width.equalTo(0)
        }
        
        jobLabel.snp.makeConstraints { (make) in
            make.left.equalTo(companyLabel.snp.right).offset(Consts.JobLeftSpace)
            make.centerY.equalTo(companyLabel.snp.centerY)
            make.height.equalTo(Consts.JobFont.lineHeight)
            make.width.equalTo(0)
        }
        
        arrowImageview.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView.snp.centerY)
            make.right.equalTo(contentView.snp.right).offset(-Consts.ContentHorizontalSpace)
            make.size.equalTo(Consts.ImageSize)
        }
        
        seperateLineView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(Consts.ContentHorizontalSpace)
            make.right.equalTo(contentView.snp.right).offset(-Consts.ContentHorizontalSpace)
            make.height.equalTo(HotEventConfig.SeperateLineHeight)
            make.bottom.equalTo(contentView.snp.bottom).offset(-HotEventConfig.SeperateLineHeight)
        }
    }
    
    // MARK: - public
    
    var info: HotEventDataExpertRecListModel? {
        
        didSet {
            guard let model = info else {
                return
            }
            
            
            let nameString = model.name ?? ""
            let companyString = model.company ?? ""
            let jobString = model.job ?? ""
            
            nameLabel.text = nameString
            companyLabel.text = companyString
            jobLabel.text = jobString
            
            self.setNeedsUpdateConstraints()
        }
        
        willSet {
            
//            newValue?.job = "微解读丨石油大涨，什么原因？"
//            newValue?.name = "观点丨丨丨"
//            newValue?.company = "微观点丨未来是创造——关于经济的那些争论"

            
            let jobString = newValue?.job ?? ""
            let maxLength = Consts.JobMaxNum
            if jobString.length() > maxLength {
                let index = jobString.characters.index(jobString.startIndex, offsetBy: maxLength)
                newValue?.job = jobString.substring(to: index) + "..."
            }
        }
    }
    
    class func heightForCell() -> CGFloat {
        
        var height: CGFloat = 0.0
        let nameHeight = Consts.NameFont.lineHeight
        let companyHeight = Consts.CompanyFont.lineHeight
        height = Consts.NameTopSpace + nameHeight + Consts.CompanyTopSpace + companyHeight + 10 + HotEventConfig.SeperateLineHeight
        
        return ceil(height)
        
    }
}
