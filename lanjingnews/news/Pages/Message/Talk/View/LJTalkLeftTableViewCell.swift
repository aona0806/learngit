//
//  LJTalkTableViewCell.swift
//  news
//
//  Created by 陈龙 on 15/12/10.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

class LJTalkLeftTableViewCell: LJTalkBaseTableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var onOtherHeadTap: (() -> ())? = nil

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
                    
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        var image: UIImage! = UIImage(named: "white_paopao")
        image = image?.resizableImage(withCapInsets: UIEdgeInsetsMake(20, 26, 20, 15))
        paopaoImageView.image = image
        
        self.avatarImageView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.contentView.snp.left).offset(Consts.photoPaddingH)
            make.top.equalTo(self.contentView.snp.top).offset(Consts.photoPaddingV)
            make.width.equalTo(Consts.photoWidth)
            make.height.equalTo(Consts.photoWidth)
        }
        
        self.paopaoImageView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.avatarImageView.snp.right).offset(Consts.contentBackLeadingH)
            make.top.equalTo(self.avatarImageView.snp.top).offset(Consts.contentLabelTop)
            make.width.equalTo(Consts.contentWidth + Consts.contentBackLeading + Consts.contentBackTrailling)
            make.height.equalTo(Consts.contentDefaultHeight)
        }
        
        self.contentLabel.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.paopaoImageView.snp.edges).inset(UIEdgeInsetsMake(Consts.contentLabelTop, Consts.contentBackLeading, Consts.contentLabelTop, Consts.contentBackTrailling))
        }
        
        self.contentLabel.linkGroundColor = UIColor.themeBlueColor()
        self.contentTextColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func onAvatarTap(_ gesture: UIGestureRecognizer) {
        self.onOtherHeadTap?()
    }
}
