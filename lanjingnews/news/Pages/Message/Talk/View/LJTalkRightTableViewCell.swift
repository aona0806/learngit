//
//  LJTalkRightTableViewCell.swift
//  news
//
//  Created by 陈龙 on 15/12/10.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

class LJTalkRightTableViewCell: LJTalkBaseTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var onMyHeadTap: (() -> ())? = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        var image: UIImage! = UIImage(named: "blue_paopao")
        image = image?.resizableImage(withCapInsets: UIEdgeInsetsMake(20, 12, 20, 26))
        paopaoImageView.image = image
        
        self.avatarImageView.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(self.contentView.snp.right).offset(-Consts.photoPaddingH)
            make.top.equalTo(self.contentView.snp.top).offset(Consts.photoPaddingV)
            make.width.equalTo(Consts.photoWidth)
            make.height.equalTo(Consts.photoWidth)
        }
        
        self.paopaoImageView.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(self.avatarImageView.snp.left).offset(-Consts.contentBackLeadingH)
            make.top.equalTo(self.avatarImageView.snp.top).offset(Consts.contentLabelTop)
            make.width.equalTo(Consts.contentWidth + Consts.contentBackLeading + Consts.contentBackTrailling)
            make.height.equalTo(Consts.contentDefaultHeight)
        }
        
        self.contentLabel.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.paopaoImageView.snp.edges).inset(UIEdgeInsetsMake(Consts.contentLabelTop, Consts.contentBackTrailling, Consts.contentLabelTop, Consts.contentBackLeading))
        }
        
        self.avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LJTalkBaseTableViewCell.onAvatarTap(_:))))
        
        self.contentTextColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func onAvatarTap(_ gesture: UIGestureRecognizer) {
        if (self.onMyHeadTap != nil) {
            self.onMyHeadTap!()
        }
    }
}
