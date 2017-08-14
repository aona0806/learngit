//
//  RemindSetTableViewCell.swift
//  news
//
//  Created by chunhui on 15/3/17.
//  Copyright (c) 2015年 lanjing. All rights reserved.
//

import UIKit


class RemindSetTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var switchButton : UISwitch!
    
    var hideSwitchButton : Bool!{
        willSet{
            switchButton.isHidden = newValue

        }
    }
    
    weak var switchDelegate : RemindSetTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.switchButton.addTarget(self, action: #selector(RemindSetTableViewCell.switchAction(_:)), for: UIControlEvents.valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func switchAction(_ sender: AnyObject?){
        
        switchDelegate?.swithAction(self)
        
    }
    
}

@objc protocol RemindSetTableViewCellDelegate
{
    func swithAction(_ cell: RemindSetTableViewCell)
}
