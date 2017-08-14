//
//  LJTalkBaseTableViewCell.swift
//  news
//
//  Created by 陈龙 on 15/12/10.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

class LJTalkBaseTableViewCell: UITableViewCell {

    struct Consts{
        static let FontSize = CGFloat(16.0)
        static let LineSpace = CGFloat(2.0)
        
        /// avatar margin left
        static let photoPaddingH : CGFloat = 12.0
        static let photoPaddingV : CGFloat = 10.0
        static let photoWidth : CGFloat = 38.0
        static let contentLabelTop : CGFloat = 6.0
        static let contentBackLeadingH : CGFloat = 4.0
        static let contentWidth: CGFloat! = GlobalConsts.screenWidth - 140
        static let contentDefaultHeight: CGFloat! = 40.0
        static let contentBackLeading : CGFloat = 15.0
        
        static let contentFont = UIFont.systemFont(ofSize: Consts.FontSize)
        static let imageOffset = UIOffsetMake(0, -4)
        static let contentBackTrailling : CGFloat = 10.0
        static let lineSpace : CGFloat = 2.0
    }

    var showUrlDetail: ((String) -> ())?

    var avatarImageView: UIImageView!
    var contentLabel: KILabel!
    var paopaoImageView: UIImageView!
    var contentTextColor: UIColor!
    var contentLinkTextColor: UIColor! = UIColor(red: 77/255.0, green: 227/255.0, blue: 1.0, alpha: 1.0)
    
    //MARK - lifCycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        
        self.avatarImageView = UIImageView()
        
        self.avatarImageView.isUserInteractionEnabled = true
        avatarImageView.image = UIImage(named: "icon_my_info_white")
        avatarImageView.layer.cornerRadius = Consts.photoWidth / 2
        avatarImageView.layer.masksToBounds = true
        avatarImageView.contentMode = UIViewContentMode.scaleToFill
        avatarImageView.isUserInteractionEnabled = true
        self.contentView.addSubview(avatarImageView)
        self.avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LJTalkBaseTableViewCell.onAvatarTap(_:))))
        
        self.paopaoImageView = UIImageView()
        //设置坐标待优化
        paopaoImageView.frame = CGRect(x: frame.minX - Consts.contentBackLeading , y: frame.minY - Consts.contentLabelTop, width: frame.width + Consts.contentBackLeading + Consts.contentBackTrailling, height: frame.height + Consts.contentLabelTop * 2) //label.frame
        var image: UIImage! = UIImage(named: "white_paopao")
        image = image?.resizableImage(withCapInsets: UIEdgeInsetsMake(20, 26, 20, 15))
        paopaoImageView.image = image
        paopaoImageView.isUserInteractionEnabled = true
        self.contentView.addSubview(paopaoImageView)
        
        contentLabel = KILabel()
        let option   =  KILinkTypeOption.init(rawValue: 4)
        contentLabel.linkDetectionTypes = option
        contentLabel.autoConvertUrlLink = false
        contentLabel.isUserInteractionEnabled = true
        contentLabel.isCopyingEnabled = true
        contentLabel.linkGroundColor = contentLinkTextColor
        contentTextColor = UIColor.white
        contentLabel.numberOfLines = 0
        contentLabel.font = Consts.contentFont
        paopaoImageView.addSubview(contentLabel)
        contentLabel.urlLinkTapHandler = {(label  , string  , range  , contentString ) -> Void in
            self.showUrlDetail?(string)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func update(_ info: LJMessageTalkDataContentModel!){
        
        if info != nil {
            let url = Urlhelper.tryEncode(info!.avatar)
            let photoPlaceHolder = UIImage(named: "icon_my_info_white")
            avatarImageView.sd_setImage(with: url, placeholderImage: photoPlaceHolder)
            
            guard let contentArrtibuteString = info!.content.show( with: Consts.contentFont, imageOffSet: Consts.imageOffset, lineSpace: Consts.lineSpace,imageWidthRatio: CGFloat(1.05)) else {
                return
            }
            contentArrtibuteString.addAttribute(NSForegroundColorAttributeName, value: contentTextColor, range: NSMakeRange(0, contentArrtibuteString.length))

            contentLabel.attributedText = contentArrtibuteString
            contentLabel.customString = info?.content

            let contentRect = contentArrtibuteString.size(withMaxWidth: Consts.contentWidth, font: Consts.contentFont)
            let contentSize = CGSize(width: contentRect.width, height: contentRect.height)
            
            paopaoImageView.snp.updateConstraints { (make) -> Void in
                make.height.equalTo(contentSize.height + 1 + Consts.contentLabelTop + Consts.contentLabelTop)
                make.width.equalTo(contentSize.width + Consts.contentBackLeading + Consts.contentBackTrailling)
            }
        }
    }
    
    override func updateConstraints() {
        
        super.updateConstraints()
       
        let htmlContentArrtibuteString = contentLabel.attributedText
        let contentRect = htmlContentArrtibuteString!.size(withMaxWidth: Consts.contentWidth, font: Consts.contentFont)
        let contentSize = CGSize(width: contentRect.width, height: contentRect.height)
        
        paopaoImageView.snp.updateConstraints { (make) -> Void in
            make.height.equalTo(contentSize.height + 1 + Consts.contentLabelTop + Consts.contentLabelTop)
            make.width.equalTo(contentSize.width + Consts.contentBackLeading + Consts.contentBackTrailling)
        }
    }
    
    
    func onAvatarTap(_ gesture: UIGestureRecognizer) {
        
    }
    
    //MARK - public

    var info: LJMessageTalkDataContentModel? {
        
        didSet {
            self.update(info)
        }
    }
    
    class func calculateCommentListHeight(_ info : LJMessageTalkDataContentModel!) -> CGFloat {
        
        let contentArrtibuteString = info!.content.show(with:  Consts.contentFont, imageOffSet: Consts.imageOffset, lineSpace: Consts.lineSpace,imageWidthRatio: CGFloat(1.05))
        let contentRect = contentArrtibuteString?.size(withMaxWidth: Consts.contentWidth , font: Consts.contentFont)
        let contentSize = CGSize(width: contentRect!.width, height: contentRect!.height)
        let contentHeight: CGFloat = contentSize.height
        let height = contentHeight + 37.0
        return height
        
    }
}
