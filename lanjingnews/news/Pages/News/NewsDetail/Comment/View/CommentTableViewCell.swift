//
//  CommentTableViewCell.swift
//  news
//
//  Created by wxc on 16/1/6.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    struct Consts {
        static let MarginWidth:CGFloat = 15.0
        static let IntervalToTop:CGFloat = 13
        static let IntervalOfCommon:CGFloat = 10
        static let IntervalToCompanyLabel:CGFloat = 5
        static let IntervalToBottom:CGFloat = 13
        
        static let HeaderImageWidth:CGFloat = 30
        static let HeaderImageHeight:CGFloat = 30
        static let NameLabelHeight:CGFloat = 21.5
        static let TimeLabelHeight:CGFloat = 15
        
        static let CompanyLabelFont = UIFont.systemFont(ofSize: 11)
        
        static let NemeLabelFont = UIFont.systemFont(ofSize: 14)
    }

    private var headeImageView:UIImageView!     //头像
    private var nameLabel:CommentNameLabel!     //姓名
    private var positionLabel:UILabel!          //职位
    private var companyLabel:UILabel!           //所属公司
    private var timeLabel:UILabel!              //评论时间
    private var contentLabel:UILabel!           //内容
    private var lineView:UIView!                //分割线
    private var companyWidth:CGFloat! = 0           //公司名称长度，用于截断
    private var companyHeight:CGFloat! = 0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addAllSubviews()
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addAllSubviews(){
        headeImageView = UIImageView()
        headeImageView.layer.cornerRadius = 15
        headeImageView.layer.masksToBounds = true
        self.addSubview(headeImageView)
    
        nameLabel = CommentNameLabel.init(frame: CGRect.zero)
        nameLabel.nameLabel.font = Consts.NemeLabelFont
        nameLabel.nameLabel.textColor = UIColor.rgba(63, green: 97, blue: 123, alpha: 1)
        self.addSubview(nameLabel)
        
        positionLabel = UILabel()
        positionLabel.textColor = UIColor.rgba(108, green: 108, blue: 108, alpha: 1)
        positionLabel.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(positionLabel)
        
        companyLabel = UILabel()
        companyLabel.textColor = UIColor.rgba(108, green: 108, blue: 108, alpha: 1)
        companyLabel.font = UIFont.systemFont(ofSize: 12)
        companyLabel.textAlignment = .left
        companyLabel.lineBreakMode = .byTruncatingTail
        companyLabel.numberOfLines = 1
        self.addSubview(companyLabel)
        
        timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textColor = UIColor.rgba(197, green: 197, blue: 197, alpha: 1)
        self.addSubview(timeLabel)
        
        contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(contentLabel)
        
        lineView = UIView()
        lineView.backgroundColor = UIColor.themeSplitLineColor()
        self.addSubview(lineView)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        headeImageView.snp.updateConstraints { (make) -> Void in
            make.left.equalTo(self.snp.left).offset(Consts.MarginWidth)
            make.top.equalTo(self.snp.top).offset(Consts.IntervalToTop)
            make.width.equalTo(Consts.HeaderImageWidth)
            make.height.equalTo(Consts.HeaderImageHeight)
        }
    
        nameLabel.snp.updateConstraints { (make) -> Void in
            make.top.equalTo(self.snp.top).offset(Consts.MarginWidth)
            make.left.equalTo(headeImageView.snp.right).offset(Consts.IntervalOfCommon)
            make.height.equalTo(Consts.NameLabelHeight)
        }
        
        companyLabel.snp.updateConstraints { (make) -> Void in
            make.top.equalTo(nameLabel.snp.bottom)
            make.left.equalTo(headeImageView.snp.right).offset(Consts.IntervalOfCommon)
            make.width.equalTo(companyWidth)
            make.height.equalTo(companyHeight)
        }
        
        positionLabel.snp.updateConstraints { (make) -> Void in
            make.top.equalTo(companyLabel.snp.top)
            make.left.equalTo(companyLabel.snp.right).offset(Consts.IntervalOfCommon)
        }
        
        timeLabel.snp.updateConstraints { (make) -> Void in
            make.top.equalTo(self.snp.top).offset(Consts.IntervalToTop)
            make.right.equalTo(self.snp.right).offset(-Consts.MarginWidth)
            make.height.equalTo(Consts.TimeLabelHeight)
        }
        
        contentLabel.snp.remakeConstraints { (make) -> Void in
            make.top.equalTo(companyLabel.snp.bottom).offset(Consts.IntervalToCompanyLabel)
            make.left.equalTo(headeImageView.snp.right).offset(Consts.IntervalOfCommon)
            make.right.equalTo(self.snp.right).offset(-Consts.MarginWidth)
        }
        
        lineView.snp.updateConstraints { (make) -> Void in
            make.left.equalTo(self.snp.left).offset(Consts.MarginWidth)
            make.right.equalTo(self.snp.right).offset(-Consts.MarginWidth)
            make.bottom.equalTo(self.snp.bottom).offset(-0.5)
            make.height.equalTo(0.5)
        }
    }
    
    /**
     通过model给cell赋值
     
     - parameter model: LJCommentModel
     */
    func setValueWithModel(_ model:LJCommentDataListModel?){
        
        let avatar = model?.avatar ?? ""
        headeImageView.sd_setImage(with: URL.init(string: avatar), placeholderImage: UIImage.init(named: "newsdetail_header"))
        
        var type:indentifyType = .none
        if  model?.ukind == "1" {
            type = .reporter
        }else if model?.ukind == "2" {
            type = .expert
        }
        
        if  (model?.name?.length())! > 0 {
            nameLabel.setValueWith((model?.name)!, indentify: type)
        }else {
            nameLabel.setValueWith("", indentify: .none)
        }
        
        companyHeight = 0
        companyWidth = 0
        
        if type != .none {
            companyLabel.text = model?.company
            let companyStr = model?.company ?? ""
            
            var companyMaxWidth = GlobalConsts.screenWidth - 2 * Consts.MarginWidth
            companyMaxWidth = companyMaxWidth - Consts.HeaderImageWidth - Consts.IntervalOfCommon - 50
            companyWidth = companyStr.size(withMaxWidth: companyMaxWidth, font: companyLabel.font).width
            
            companyHeight = companyStr.size(withMaxHeight: Consts.NameLabelHeight, font: companyLabel.font).height
            
            let positionStr = model?.ukindName
            let positionHeight: CGFloat = positionStr!.size(withMaxWidth: companyMaxWidth, font:positionLabel.font).height
            
            companyHeight = companyHeight > positionHeight ? companyHeight : positionHeight
            
            positionLabel.text = model?.ukindName
        }else {
            companyLabel.text = ""
            positionLabel.text = ""
        }
        
        let timeCreate = model?.timeCreate ?? ""
        let timeCreateDouble :Double? = Double(timeCreate)
        var timeCreateDate : Date? = nil
        
        if timeCreateDouble == nil {
            timeCreateDate = Date()
        }else{
            timeCreateDate = Date(timeIntervalSince1970: timeCreateDouble!)
        }
        let timeCearteString = TKCommonTools.dateDesc(for: timeCreateDate)
        timeLabel.text = timeCearteString
        
        let strContent:NSString = (model?.content as NSString?) ?? ""
        let content = strContent.show(with: contentLabel.font, imageOffSet: UIOffset.init(horizontal: 0, vertical: -4), lineSpace: 6, imageWidthRatio: 1.2)
        contentLabel.attributedText = content
        
        self.setNeedsUpdateConstraints()
    }
    
    /**
    *  获取cell的高度
    */
    class func heightForCellWithModel(_ model:LJCommentDataListModel?) -> CGFloat{
        
        let size = CGSize.init(width: (UIScreen.main.bounds.width - 2 * Consts.MarginWidth - Consts.HeaderImageWidth - Consts.IntervalOfCommon), height: 1000)
        
        let strContent:NSString = model?.content as NSString? ?? ""
        let font = UIFont.systemFont(ofSize: 15)
        let content = strContent.show(with: font, imageOffSet: UIOffset.init(horizontal: 0, vertical: -4), lineSpace: 6, imageWidthRatio: 1.2)
        
        let height:CGFloat = content!.size(withMaxWidth: size.width, font: font).height
        
        let company = String(model?.company ?? "")
        let ukindName = String(model?.ukindName ?? "")
        let ukindValue = Int(model?.ukind ?? "0")
        
        var type:indentifyType = .none
        if  model?.ukind == "1" {
            type = .reporter
        }else if model?.ukind == "2" {
            type = .expert
        }
        
        var companyHeight: CGFloat = 0
        
        if type != .none {
            let companyStr = model?.company ?? ""
            
            var companyMaxWidth = GlobalConsts.screenWidth - 2 * Consts.MarginWidth
            companyMaxWidth = companyMaxWidth - Consts.HeaderImageWidth - Consts.IntervalOfCommon - 50
            companyHeight = companyStr.size(withMaxHeight: Consts.NameLabelHeight, font: Consts.CompanyLabelFont).height
            
            let positionStr = model?.ukindName
            let positionHeight: CGFloat = positionStr!.size(withMaxWidth: companyMaxWidth, font:Consts.CompanyLabelFont).height
            
            companyHeight = companyHeight > positionHeight ? companyHeight : positionHeight
        }
        
        if ((company?.length())! <= 0 && (ukindName?.length())! <= 0) || (ukindValue! != 1 && ukindValue! != 2) {
            return height + Consts.MarginWidth + Consts.NameLabelHeight + Consts.IntervalToBottom + Consts.IntervalToCompanyLabel
        }
        
        return height + Consts.MarginWidth + Consts.NameLabelHeight + Consts.IntervalToBottom + companyHeight + Consts.IntervalToCompanyLabel
    }

}
