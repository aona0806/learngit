//
//  HotEventListTableViewCel.swift
//  news
//
//  Created by 陈龙 on 16/6/3.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class HotEventListTableViewCel: BaseTableViewCell,UITableViewDelegate,UITableViewDataSource {
    
    struct Consts {
        
        static let ContentHorizontalSpace = CGFloat(15)
        
        static var TagImageViewSize: CGSize {
            get {
                let height = Consts.TitleFont.lineHeight
                let size = CGSize(width: 4, height: height)
                return size
            }
        }
        
        static let TitleFont = UIFont.systemFont(ofSize: 20)
        static let TitleColor = UIColor.black
        static let TitleTopSpace = CGFloat(21)
        
        static let BriefFont = UIFont.systemFont(ofSize: 14)
        static let BriefColor = UIColor.rgb(0x434343)
        static let BriefTopSpace = CGFloat(20)
        static let BriedLineSpace = CGFloat(9)
        
        static let ExpertTitleColor = UIColor.rgb(0x1a93d1)
        static let ExpertTitleFont = UIFont.systemFont(ofSize: 15)
        static let ExpertTitleTopSpace = CGFloat(18)
        static let ExpertTitleString = "推荐专家:"
        
        static let ExpertLineTopSpace = CGFloat(14)
        
        static let ExpertViewMaxNum = 2
        static let ExpertViewHeight = HotEventExpertTableViewCell.heightForCell()
        
        static let ZanLabelBorderColor = UIColor.rgb(0x1a93d1)
        static let ZanLabelBorderWidth = CGFloat(1)
        static let ZanLabelFont = UIFont.systemFont(ofSize: 12)
        static let ZanLabelHeight = CGFloat(20)
        static let ZanLabelWidth = CGFloat(98)
        
        static let ZanButtonBackColor = UIColor.rgb(0x03a7f4)
        static let ZanButtonFont = UIFont.systemFont(ofSize: 12)
        static let ZanButtonTextColor = UIColor.rgb(0x999898)
        
        static let ZanButtonSize = CGSize(width: 69, height: 26)
        static let ZanButtonButtomSpace = CGFloat(17)
        static let ZanButtonTopSpace = CGFloat(17)
        
        static let SeperateLineHeight = CGFloat(7)
        static let SeperateLineColor = UIColor.rgb(0xeeeeee)
    }
    
    private let tagImageView = UIImageView()
    private let titleLabel = UILabel()
    private let briefLabel = UILabel()
    private let expertTitleLabel = UILabel()
    private let expertLineView = UIView()
    
    private var expertTableView:UITableView = UITableView(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0), style: .plain)
    //private let zanNumLabel = UILabel()
    private var zanNumButton = UIButton()
    private let zanButton = UIButton()
    private let seperateLineView = UIView()
    
    var zanClickAction: ((Bool, HotEventListTableViewCel) -> ())?
    var expertDetailClickAction: ((String, HotEventListTableViewCel) -> ())?
    
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
        
        let titleStirng: NSString = model.title as NSString? ?? ""
        titleLabel.snp.updateConstraints { (make) in
            let width = GlobalConsts.screenWidth - Consts.ContentHorizontalSpace * 2
            let height = titleStirng.size(withMaxWidth: width, font: Consts.TitleFont, maxLineNum: 2).height
            make.height.equalTo(height)
        }
        
        let briefString: NSString = model.brief as NSString? ?? ""
        briefLabel.snp.updateConstraints { (make) in
            let width = GlobalConsts.screenWidth - Consts.ContentHorizontalSpace * 2
            let height = briefString.size(withMaxWidth: width, font: Consts.BriefFont, linespace: Consts.BriedLineSpace, maxLine: 3).height

            make.height.equalTo(height)
        }
        
        let expertRecList = info?.expertRecList as? [HotEventDataExpertRecListModel] ?? []
        if expertRecList.count > 0 {
            
            expertTitleLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(briefLabel.snp.left)
                make.top.equalTo(briefLabel.snp.bottom).offset(Consts.ExpertTitleTopSpace)
                make.height.equalTo(Consts.ExpertTitleFont.lineHeight)
                make.right.equalTo(briefLabel.snp.right)
            }
            
            expertLineView.snp.remakeConstraints { (make) in
                make.left.equalTo(briefLabel.snp.left)
                make.right.equalTo(briefLabel.snp.right)
                make.height.equalTo(HotEventConfig.SeperateLineHeight)
                make.top.equalTo(expertTitleLabel.snp.bottom).offset(Consts.ExpertLineTopSpace)
            }
            
            expertTableView.snp.remakeConstraints{ (make) in
                make.left.equalTo(contentView.snp.left)
                make.right.equalTo(contentView.snp.right)
                make.top.equalTo(expertLineView.snp.bottom)
                make.height.equalTo(expertTableView.contentSize.height)
            }

        }
        
        zanNumButton.snp.updateConstraints { (make) in
            var zanNumString = model.zanNum ?? "0"
            zanNumString = zanNumString.exchangeReadNum()
            let zanString: NSString = "\(zanNumString)人认为有用" as NSString
            let width = zanString.size(withMaxHeight: Consts.ZanLabelFont.lineHeight, font: Consts.ZanLabelFont).width + CGFloat(30)
            make.width.equalTo(width)
        }
    }
    
    // MARK: - private
    
    private func initView() {
        
        tagImageView.image = UIImage(named: "hotevent_list_tag")
        contentView.addSubview(tagImageView)
        
        titleLabel.textColor = Consts.TitleColor
        titleLabel.font = Consts.TitleFont
        titleLabel.numberOfLines = 0
        titleLabel.backgroundColor = UIColor.clear
        contentView.addSubview(titleLabel)
        
        briefLabel.textColor = Consts.BriefColor
        briefLabel.font = Consts.BriefFont
        briefLabel.numberOfLines = 0
        briefLabel.backgroundColor = UIColor.clear
        contentView.addSubview(briefLabel)
        
        expertTitleLabel.textColor = Consts.ExpertTitleColor
        expertTitleLabel.font = Consts.ExpertTitleFont
        expertTitleLabel.numberOfLines = 1
        expertTitleLabel.text = Consts.ExpertTitleString
        expertTitleLabel.backgroundColor = UIColor.clear
        contentView.addSubview(expertTitleLabel)
        
        expertLineView.backgroundColor = HotEventConfig.SeperateLineColor
        contentView.addSubview(expertLineView)
        
        contentView.addSubview(expertTableView)
        expertTableView.dataSource = self
        expertTableView.delegate = self
        expertTableView.isScrollEnabled = false
        
        zanNumButton.setTitleColor(Consts.ZanButtonTextColor, for: UIControlState())
        zanNumButton.titleLabel?.font = Consts.ZanButtonFont
        let usefulImage = UIImage(named: "hotevent_list_useful")
        zanNumButton.setImage(usefulImage, for: UIControlState())
        zanNumButton.setTitle("0人认为有用", for: UIControlState())
        zanNumButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 6)
        contentView.addSubview(zanNumButton)
        
        zanButton.setTitleColor(Consts.ZanButtonTextColor, for: UIControlState())
        zanButton.titleLabel?.font = Consts.ZanButtonFont
        let zanImage = UIImage(named: "hotevent_list_zan_cancel")
        zanButton.setImage(zanImage, for: UIControlState())
        zanButton.setTitle("有用", for: UIControlState())
        //zanButton.layer.cornerRadius = CGFloat(2)
        zanButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 6)
        zanButton.addTarget(self, action: #selector(zanAction(_:)), for: .touchUpInside)
        contentView.addSubview(zanButton)
        
        seperateLineView.backgroundColor = Consts.SeperateLineColor
        contentView.addSubview(seperateLineView)
    }
    
    private func initViewConstraints() -> Void {
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(Consts.ContentHorizontalSpace)
            make.right.equalTo(contentView.snp.right).offset(-Consts.ContentHorizontalSpace)
            make.top.equalTo(contentView.snp.top).offset(Consts.TitleTopSpace)
            make.height.equalTo(0)
        }
        
        tagImageView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left)
            make.top.equalTo(titleLabel.snp.top)
            make.size.equalTo(Consts.TagImageViewSize)
        }
        
        briefLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(titleLabel.snp.right)
            make.top.equalTo(titleLabel.snp.bottom).offset(Consts.BriefTopSpace)
            make.height.equalTo(0)
        }
        
        
        zanButton.snp.makeConstraints { (make) in
            make.size.equalTo(Consts.ZanButtonSize)
            make.right.equalTo(contentView.snp.right).offset(-Consts.ContentHorizontalSpace)
            make.bottom.equalTo(seperateLineView.snp.top).offset(-Consts.ZanButtonButtomSpace)
        }
        
        zanNumButton.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(Consts.ContentHorizontalSpace)
            make.centerY.equalTo(zanButton.snp.centerY)
            make.height.equalTo(Consts.ZanLabelHeight)
            make.width.equalTo(Consts.ZanLabelWidth)
        }
        
        seperateLineView.snp.makeConstraints { (make) in
            make.bottom.equalTo(contentView.snp.bottom).offset(0)
            make.height.equalTo(Consts.SeperateLineHeight)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
        }
    }
    
    // MARK: - action
    
    @objc private func zanAction(_ sender: UIButton) -> Void {
        let zanNum = self.info?.isZan ?? ""
        let isZan = zanNum != "1"
        self.zanClickAction?(isZan, self)
    }
    
    
    // MARK: - public
    var info: HotEventDataModel? {
        
        didSet {
            guard let model = info else {
                return
            }
            
            let titleString = model.title ?? ""
            titleLabel.text = titleString
            
            let briefString = model.brief ?? ""
            let briefAttributeString = NSAttributedString.buildAttributeString(briefString, lineSpace: Consts.BriedLineSpace, foreColor: Consts.BriefColor, font: Consts.BriefFont)
            briefLabel.attributedText = briefAttributeString
            
            let expertRecList = model.expertRecList as? [HotEventDataExpertRecListModel] ?? []
           
            expertTitleLabel.isHidden = expertRecList.count == 0
            expertLineView.isHidden = expertRecList.count == 0
            expertTableView.isHidden = info!.expertRecList.count == 0
            
            expertTableView.reloadData()
            
            var zanNumString = model.zanNum ?? "0"
            zanNumString = zanNumString.exchangeReadNum()
            let useString = "人认为有用"
            let zanString = "\(zanNumString)\(useString)"
            
            let zanAttributedString: NSMutableAttributedString! = NSMutableAttributedString(string: zanString)
            zanAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.rgb(0x03a7f4), range: NSMakeRange(0, zanNumString.length()))
            zanAttributedString.addAttribute(NSForegroundColorAttributeName, value: Consts.ZanButtonTextColor, range: NSMakeRange(zanNumString.length(), useString.length()))
            zanNumButton.setAttributedTitle(zanAttributedString, for: UIControlState())
            zanNumButton.sizeToFit()
            
            let isZanString = model.isZan ?? "0"
            let isZan = isZanString == "1"
            let zanImage = isZan ? UIImage(named: "hotevent_list_zan") : UIImage(named: "hotevent_list_zan_cancel")
            zanButton.setImage(zanImage, for: UIControlState())
            
            self.setNeedsUpdateConstraints()
        }
    }
    
    class func heightForCell(_ model: HotEventDataModel) -> CGFloat {
        
        var height: CGFloat = 0.0
        
        let titleStirng: NSString = model.title as NSString? ?? ""
        let titleWidth = GlobalConsts.screenWidth - Consts.ContentHorizontalSpace * 2
        let titleHeight = titleStirng.size(withMaxWidth: titleWidth, font: Consts.TitleFont, maxLineNum: 2).height
        
        let briefString: NSString = model.brief as NSString? ?? ""
        let briefWidth = GlobalConsts.screenWidth - Consts.ContentHorizontalSpace * 2
        let briefHeight = briefString.size(withMaxWidth: briefWidth, font: Consts.BriefFont, linespace: Consts.BriedLineSpace, maxLine: 3).height
        
        let expertRecList = model.expertRecList as? [HotEventDataExpertRecListModel] ?? []
        var expertListHeight = CGFloat(0)
        if expertRecList.count == 0 {
            expertListHeight = CGFloat(0)
        } else {
            
            let count = min(expertRecList.count, Consts.ExpertViewMaxNum)
            let cellHeight = Consts.ExpertViewHeight
            let listHeight = cellHeight * CGFloat(count)
            
            expertListHeight = Consts.ExpertTitleTopSpace + Consts.ExpertTitleFont.lineHeight + Consts.ExpertLineTopSpace + HotEventConfig.SeperateLineHeight + listHeight
        }
        
        height = Consts.TitleTopSpace + titleHeight + Consts.BriefTopSpace + briefHeight + expertListHeight + Consts.ZanButtonTopSpace + Consts.ZanButtonSize.height + Consts.ZanButtonButtomSpace + Consts.SeperateLineHeight
        return ceil(height)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = info?.expertRecList?[indexPath.row] as? HotEventDataExpertRecListModel
        let expertId = item?.id
        
        if expertId != nil {
            self.expertDetailClickAction?(expertId!, self)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if info!.expertRecList.count > 2 {
            return 2
        }
        return info!.expertRecList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:HotEventExpertTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "HotEventExpertTableViewCell") as! HotEventExpertTableViewCell?
        if cell == nil {
            cell = HotEventExpertTableViewCell.init(style: .default, reuseIdentifier: "HotEventExpertTableViewCell")
        }
        let item:HotEventDataExpertRecListModel = (info?.expertRecList[indexPath.row] as! HotEventDataExpertRecListModel?)!
        cell?.info = item
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Consts.ExpertViewHeight
    }
}
