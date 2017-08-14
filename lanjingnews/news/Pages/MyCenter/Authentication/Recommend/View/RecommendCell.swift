//
//  RecommendCell.swift
//  news
//
//  Created by 奥那 on 16/1/8.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class RecommendCell: BaseTableViewCell {
    
    let screen_width = UIScreen.main.bounds.size.width
    var nameLabel = UILabel()
    var detailLabel = UILabel()
    var markButton = UIButton(type: UIButtonType.custom)
    var leftImageView = UIImageView()
    
    var model : LJRecommendDataRecommendListModel?{
        didSet{
            if model != nil{
                nameLabel.text = model?.sname
                detailLabel.text = model?.company
                leftImageView.sd_setImage(with: Urlhelper.tryEncode(model?.avatar), placeholderImage: UIImage(named: "myInfo_default_headerImage"))
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        customSubViews()
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        customSubViews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func customSubViews(){
        
        self.contentView.backgroundColor = UIColor.white
        self.backgroundColor = UIColor.white
        
        leftImageView = UIImageView(frame: CGRect(x: 15, y: 10, width: 40, height: 40))
        leftImageView.backgroundColor = UIColor.clear
        leftImageView.layer.masksToBounds = true
        leftImageView.layer.cornerRadius = 3
        self.contentView.addSubview(leftImageView)
        
        nameLabel = UILabel(frame: CGRect(x: 65, y: 10, width: 200, height: 20))
        nameLabel.backgroundColor = UIColor.white
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        self.contentView.addSubview(nameLabel)
        
        detailLabel = UILabel(frame: CGRect(x: 65, y: 32, width: 250, height: 20))
        detailLabel.backgroundColor = UIColor.white
        detailLabel.font = UIFont.systemFont(ofSize: 12)
        detailLabel.textColor = UIColor.lightGray
        self.contentView.addSubview(detailLabel)
        
        markButton.frame = CGRect(x: screen_width - 35, y: 20, width: 20, height: 20)
        markButton.setImage(UIImage(named: "myInfo_checkoff"), for: UIControlState())
        markButton.setImage(UIImage(named: "myInfo_checkon"), for: UIControlState.selected)
        markButton.isUserInteractionEnabled = false
        markButton.isSelected = true
        self.contentView.addSubview(markButton)
        
    }
    
    
}
