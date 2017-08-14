//
//  SeleTableViewCell.swift
//  news
//
//  Created by 奥那 on 15/12/10.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

class SeleTableViewCell: UITableViewCell {

    @IBOutlet weak var switchImage: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
