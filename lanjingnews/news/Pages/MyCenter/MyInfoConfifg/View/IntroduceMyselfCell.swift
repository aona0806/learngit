//
//  IntroduceMyselfCell.swift
//  news
//
//  Created by 奥那 on 15/12/9.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

class IntroduceMyselfCell: UITableViewCell {

    @IBOutlet weak var introduceTextView: UITextView!
    
    @IBOutlet weak var titleLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var titleLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    var isMyInfo : String?{
        didSet{
            if isMyInfo == "timeAxis"{
                setupTimeAxisLabel()
            }
            if isMyInfo == "myInfo"{
                setupMyInfoLabel()
            }
        }
    }
    
    var introduce : String?{
        didSet{
            if introduce != nil{
                let body = introduce!.show( with: UIFont.systemFont(ofSize: 16), imageOffSet: UIOffsetMake(0, -4), lineSpace: 4.0,imageWidthRatio: CGFloat(1.5))
                
                self.introduceTextView?.attributedText = body
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupTimeAxisLabel(){
        titleLabelLeading.constant = 10
        
        introduceTextView.placeholder = ""
        self.titleLabel.textColor = UIColor(red: 144/255.0, green: 168/255.0, blue: 201/255.0, alpha: 1)
        self.titleLabel.font = UIFont.systemFont(ofSize: 14)
        self.introduceTextView.font = UIFont.systemFont(ofSize: 14)
        self.introduceTextView.textColor = UIColor(red: 41/255.0, green: 41/255.0, blue: 41/255.0, alpha: 1)
    }
    
    func setupMyInfoLabel(){
        self.titleLabel.textColor = UIColor(red: 170/255.0, green: 170/255.0, blue: 170/255.0, alpha: 1)
        self.titleLabel.font = UIFont.systemFont(ofSize: 16)
        self.introduceTextView.font = UIFont.systemFont(ofSize: 16)
        self.introduceTextView.textColor = UIColor.black

    }

}
