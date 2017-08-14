//
//  NormalUserInfoHeaderCell.swift
//  news
//
//  Created by 奥那 on 16/1/4.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class NormalUserInfoHeaderCell: UITableViewCell {
    
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    var imageClick : (() -> ())? = nil
    var backClick : (() -> ())? = nil
    
    var model:LJUserInfoModel?{
        didSet{
            
            if model?.avatar != nil{
            self.avatarImage.sd_setImage(with: Urlhelper.tryEncode(model?.avatar), placeholderImage: UIImage(named: "myInfo_default_headerImage"))
            
            }
            self.nickName.text = model?.nickname
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        avatarImage.layer.cornerRadius = self.avatarImage.frame.width / 2
        avatarImage.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func clickAvatarAction(_ sender: UIButton) {
        self.imageClick!()
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.backClick!()
    }
}
