//
//  TweetCommentTableViewCell.swift
//  news
//
//  Created by chunhui on 15/12/7.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

class TweetCommentTableViewCell: BaseTableViewCell {
    
    struct Const  {
        
        static let  HorMargin = CGFloat(15)
        static let  VerMargin = CGFloat(15)
        static let  AvatarWidth = CGFloat(30)
        static let  ContentHorMargin = CGFloat(15)
        static let  ContentButtonVerMargin = CGFloat(5)
        
        static let  ContentFontSize = CGFloat(14)
        static let  ContentImageOffset = UIOffsetMake(0, -4)
        static let  ContentImageRatio = CGFloat(1.5)
    }
    
    private var avatar : UIImageView!
    private var fromUserButton : UIButton!
    private var toLabel : UILabel!
    private var toUserButton : UIButton!
    private var dateLabel : UILabel!
    private var contentLabel : UILabel!
    private var bottomLineView : UIView!
    
    var tapAvatarAction:((_ comment:LJTweetCommentDataContentModel)->Void)? = nil
    var tapFromUserAction :((_ comment:LJTweetCommentDataContentModel)->Void)? = nil
    var tapToUserAction :((_ comment:LJTweetCommentDataContentModel)->Void)? = nil
    
    var comment : LJTweetCommentDataContentModel? {
        didSet {
            updateComment()
        }
    }
    
    class func cellHeightForComment(_ comment : LJTweetCommentDataContentModel) -> CGFloat {
            
        var height = CGFloat(0)
        
        let width = GlobalConsts.screenWidth - Const.HorMargin*2 - Const.AvatarWidth - Const.ContentHorMargin
        let font = UIFont.systemFont(ofSize: Const.ContentFontSize)
        height += 22 //姓名
        if let attr = comment.content.show(with: font , imageOffSet:Const.ContentImageOffset , lineSpace: 2 , imageWidthRatio:  Const.ContentImageRatio) {
            height += attr.size(withMaxWidth: width , font:font).height
        }
        
        if height < Const.AvatarWidth {
            height = Const.AvatarWidth
        }
        height += Const.VerMargin * 2

        return height
    }
    
    func userButton() -> UIButton {
        
        let button = UIButton()
        let titleColor = UIColor.rgb(0x3C8ABF)
        button.setTitleColor( titleColor, for: UIControlState())
        button.setTitleColor(titleColor, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        return button
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        avatar = UIImageView()
        avatar.isUserInteractionEnabled = true
        avatar.layer.cornerRadius = Const.AvatarWidth/2
        avatar.layer.masksToBounds = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(TweetCommentTableViewCell.avatarTapAction(_:)))
        avatar.addGestureRecognizer(gesture)
            
        fromUserButton = userButton()
        toUserButton = userButton()
        fromUserButton.addTarget(self, action: #selector(TweetCommentTableViewCell.fromUserTapAction(_:)), for: .touchUpInside)
        toUserButton.addTarget(self, action: #selector(TweetCommentTableViewCell.toUserTapAction(_:)), for: .touchUpInside)
        
        toLabel = UILabel()
        toLabel.font = UIFont.systemFont(ofSize: 16)
        toLabel.text = "回复了"
        toLabel.sizeToFit()
        
        dateLabel = UILabel()
        dateLabel.textColor = UIColor.rgb(0xA0A4A3)
        dateLabel.font = UIFont.systemFont(ofSize: 11)
        
        
        contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: Const.ContentFontSize)
        
        bottomLineView = UIView()
        bottomLineView.backgroundColor = UIColor.rgb(0xd7d7d7)
        
        
        self.contentView.addSubview(avatar)
        self.contentView.addSubview(fromUserButton)
        self.contentView.addSubview(toLabel)
        self.contentView.addSubview(toUserButton)
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(contentLabel)
        self.contentView.addSubview(bottomLineView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func updateComment(){
        
        let avatarUrl = Urlhelper.tryEncode(comment!.avatar)
        let defaultHead = UIImage(named: "user_default_head")
        avatar.sd_setImage(with: avatarUrl, placeholderImage: defaultHead)
        
        fromUserButton.setTitle(comment!.sname, for: UIControlState())
        fromUserButton.setTitle(comment!.sname, for: .highlighted)
        fromUserButton.titleLabel?.sizeToFit()
        var size = fromUserButton.titleLabel!.size
        fromUserButton.size = size
        
        if  let replaySname = comment!.replySname {
            
            toLabel.isHidden = false
            toUserButton.setTitle(replaySname, for: UIControlState())
            toUserButton.setTitle(replaySname, for: .highlighted)
            toUserButton.isHidden = false
            
            toUserButton.titleLabel!.sizeToFit()
            size = toUserButton.titleLabel!.size
            toUserButton.size = size
            
        } else {
            
            toLabel.isHidden = true
            toUserButton.isHidden = true
            
        }
        
        dateLabel.text = comment?.ctime
        dateLabel.sizeToFit()
        
        if let content = comment?.content?.show(with:  contentLabel.font , imageOffSet:Const.ContentImageOffset , lineSpace: 2 ,imageWidthRatio: Const.ContentImageRatio) {
            
            contentLabel.attributedText = content
            
            let contentSize = content.size( withMaxWidth: GlobalConsts.screenWidth - Const.HorMargin -  Const.AvatarWidth - Const.ContentButtonVerMargin - Const.HorMargin , font: contentLabel.font)
            
            contentLabel.size = contentSize
            
        }
        self.setNeedsUpdateConstraints()
        
    }
    
    override func updateConstraints() {
        
        avatar.snp.updateConstraints { (make) -> Void in
            make.left.equalTo(Const.HorMargin)
            make.top.equalTo(Const.VerMargin)
            make.width.equalTo(Const.AvatarWidth)
            make.height.equalTo(Const.AvatarWidth)
        }
        
        fromUserButton.snp.updateConstraints { (make) -> Void in
            make.left.equalTo(avatar.snp.right).offset(Const.ContentHorMargin)
            make.top.equalTo(avatar.snp.top)
//            make.width.equalTo(fromUserButton.width)
            make.height.equalTo(fromUserButton.height)
        }
        
        
        if !toLabel.isHidden {
            toLabel.snp.remakeConstraints({ (make) -> Void in
                make.left.equalTo(fromUserButton.snp.right)
                make.centerY.equalTo(fromUserButton.snp.centerY)
                make.width.equalTo(toLabel.width)
                make.height.equalTo(toLabel.height)
            })
            
            toUserButton.snp.remakeConstraints({ (make) -> Void in
                make.left.equalTo(toLabel.snp.right)
                make.top.equalTo(fromUserButton.snp.top)
                make.height.equalTo(toUserButton.height)
                make.right.lessThanOrEqualTo(dateLabel.snp.left)
            })
        }
        
        dateLabel.snp.updateConstraints { (make) -> Void in
            make.top.equalTo(avatar.snp.top)
            make.right.equalTo(dateLabel.superview!.snp.right).offset(-Const.HorMargin)
            make.width.equalTo(dateLabel.width)
            make.height.equalTo(dateLabel.height)
        }
        
        contentLabel.snp.updateConstraints { (make) -> Void in
            make.left.equalTo(fromUserButton.snp.left)
            make.top.equalTo(fromUserButton.snp.bottom).offset(Const.ContentButtonVerMargin)
            make.right.equalTo(dateLabel.snp.right)
//            make.bottom.equalTo(contentLabel.superview!.snp.bottom).priorityLow()
            make.height.equalTo(contentLabel.height)
        }
        
        bottomLineView.snp.updateConstraints { (make) -> Void in
            make.left.equalTo(0)
            make.right.equalTo(bottomLineView.superview!.snp.right)
            make.bottom.equalTo(bottomLineView.superview!.snp.bottom)
            make.height.equalTo(0.5)
        }
        
        super.updateConstraints()
    }
    
    
    func avatarTapAction(_ sender : UITapGestureRecognizer){
        
        if tapAvatarAction != nil {
            tapAvatarAction!(comment!)
        }
    }
    
    func fromUserTapAction(_ sender : UIButton){
        
        if tapFromUserAction != nil {
            tapFromUserAction!(comment!)
        }
    }
    
    func toUserTapAction(_ sender : UIButton){
        if tapToUserAction != nil {
            tapToUserAction!(comment!)
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
