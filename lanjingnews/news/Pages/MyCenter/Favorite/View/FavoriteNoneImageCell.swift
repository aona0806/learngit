//
//  FavoriteNoneImageCell.swift
//  news
//
//  Created by wxc on 16/1/12.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class FavoriteNoneImageCell: UITableViewCell {
    
    let topHeight:CGFloat = 20
    let edgeWeith:CGFloat  = 15
    
    private var timeLabel:UILabel!
    private var titleLabel:UILabel!
    
    private var tagLabel: NewsTagLabel!
    
    private var authorInfoLabel:UILabel!
    
    private var titleHeight:CGFloat = 0
    
    private var tagWeith:CGFloat = 0
    
    private var tagHeigth:CGFloat = 0
    
    //删除
    private var deleteView:UIView!
    private var deleteLable:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildView(){
        self.selectionStyle = .none
        
        titleLabel = UILabel()
        titleLabel.textColor = NewsConfig.TitleColor
        titleLabel.font = NewsConfig.TitleFont
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .left
        contentView.addSubview(titleLabel)
        
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
        
        tagLabel = NewsTagLabel()
        tagLabel.font = NewsConfig.TagFont
        tagLabel.textAlignment = .center
        tagLabel.backgroundColor = UIColor.clear
        self.contentView.addSubview(tagLabel)
        
        let seperateLineView = UIView()
        seperateLineView.backgroundColor = UIColor.lightGray
        contentView.addSubview(seperateLineView)
        seperateLineView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp.left).offset(NewsConfig.SeperateLineLeftSpace)
            make.right.equalTo(contentView.snp.right).offset(-NewsConfig.SeperateLineLeftSpace)
            make.bottom.equalTo(contentView.snp.bottom).offset(0.0)
            make.height.equalTo(0.5)
        }
        
        deleteView = UIView()
        deleteView.backgroundColor = UIColor.init(red: 188/255.0, green: 188/255.0, blue: 188/255.0, alpha: 0.9)
        contentView.addSubview(deleteView)
        deleteView.layer.cornerRadius = 3
        deleteView.layer.masksToBounds = true
        deleteView.alpha = 0
        
        deleteLable = UILabel()
        deleteLable.textAlignment = .center
        deleteLable.text = "收藏文章已删除"
        deleteLable.textColor = UIColor.white
        deleteView.addSubview(deleteLable)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        timeLabel.snp.updateConstraints { (make) -> Void in
            make.left.equalTo(self.contentView.snp.left).offset(edgeWeith)
            make.top.equalTo(self.contentView.snp.top).offset(topHeight)
        }
        
        titleLabel.snp.updateConstraints { (make) -> Void in
            make.left.equalTo(self.contentView.snp.left).offset(edgeWeith)
            make.top.equalTo(timeLabel.snp.bottom).offset(8)
            make.right.equalTo(self.contentView.snp.right).offset(-edgeWeith)
            make.height.equalTo(titleHeight)
        }
        
        tagLabel.snp.updateConstraints { (make) -> Void in
            make.left.equalTo(self.contentView.snp.left).offset(edgeWeith)
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-topHeight)
            make.width.equalTo(tagWeith)
            make.height.equalTo(tagHeigth)
        }
        
        authorInfoLabel.snp.updateConstraints { (make) -> Void in
            if tagWeith == 0 {
                make.left.equalTo(self.tagLabel.snp.right)
            }else {
                make.left.equalTo(self.tagLabel.snp.right).offset(6)
            }
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-topHeight + 2)
            make.right.equalTo(self.contentView.snp.right).offset(-topHeight)
        }
        
        deleteView.snp.updateConstraints { (make) -> Void in
            make.top.equalTo(contentView.snp.top).offset(6.5)
            make.left.equalTo(contentView.snp.left).offset(6.5)
            make.right.equalTo(contentView.snp.right).offset(-6.5)
            make.bottom.equalTo(contentView.snp.bottom).offset(-6.5)
        }
        
        deleteLable.snp.updateConstraints { (make) -> Void in
            make.top.equalTo(contentView.snp.top)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    class func heightForInfo(_ model: LJFavoriteDataModel) -> CGFloat {
        
//        let titleSize: CGSize! = info.title.sizeWithMaxWidth(UIScreen.mainScreen().bounds.width - 30, font: NewsConfig.TitleFont)
        let titleString = model.info?.title ?? ""
        let titleSize: CGSize! = titleString.size(withMaxWidth: UIScreen.main.bounds.width - 30, font: NewsConfig.TitleFont, maxLineNum: 2)
        let height = titleSize.height + 85
        
        return height
    }
    
    func setValueWithModel(_ model:LJFavoriteDataModel) {
        let favTime = model.ctime?.doubleValue
        
        if favTime != nil {
            let timeDate = Date(timeIntervalSince1970: favTime!)
            let timeString = TKCommonTools.dateDesc(for: timeDate)
            timeLabel.text = timeString
        }else {
            timeLabel.text = ""
        }
        
        let titleString  = model.info?.title ?? ""
        let titleSize: CGSize! = titleString.size(withMaxWidth: UIScreen.main.bounds.width - 30, font: NewsConfig.TitleFont, maxLineNum: 2)
        titleHeight = titleSize.height
        titleLabel.text = titleString
        
        authorInfoLabel.text = ""
        let favtype: String = model.info!.favType ?? "3"
        if favtype == "3" {
            authorInfoLabel.text = model.info?.authorInfo
        }
        
        var tagForeColror = UIColor.red
        if let tagForeColorString = model.info?.tip?.forecolor {
            tagForeColror = UIColor.colorFromHexString(tagForeColorString, defaultColor: NewsConfig.TagDefaultColor)
        }
        tagLabel.textColor = tagForeColror
        tagLabel.borderColor = tagForeColror
        
        tagLabel.borderWidth = 0.5
        tagLabel.text = model.info?.tip?.name
        if model.info?.tip?.name == nil || model.info?.tip?.name?.length() == 0 {
            tagLabel.borderColor = UIColor.clear
        }
        
        if let name = tagLabel.text {
            
            tagWeith = name.size(withMaxHeight: NewsConfig.TimeHeight, font: NewsConfig.TitleFont).width 
            
        }else{
            tagWeith = 0
        }
        
        tagHeigth = NewsConfig.TimeHeight
        
        if (model.info?.isDel != nil) && (model.info?.isDel!.intValue == 1){
            deleteView.alpha = 1
            self.isUserInteractionEnabled = false
        }else {
            deleteView.alpha = 0
            self.isUserInteractionEnabled = true
        }

        self.setNeedsUpdateConstraints()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
