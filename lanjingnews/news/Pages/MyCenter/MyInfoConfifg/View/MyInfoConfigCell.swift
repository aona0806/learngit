//
//  MyInfoConfigCell.swift
//  news
//
//  Created by 奥那 on 15/12/9.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

class MyInfoConfigCell: UITableViewCell {
    @IBOutlet weak var inputContent: UITextField!

    @IBOutlet weak var titleLB: UILabel!
    
    @IBOutlet weak var titleLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var titleLabelLeading: NSLayoutConstraint!
    
    var isMyInfo : String?{
        didSet{
            setupMyLabel(isMyInfo!)
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
    
    func setupMyLabel(_ isMyInfo : String){
        if isMyInfo == "myInfo"{
            setupMyInfoLabel()
        }else if isMyInfo == "timeAxis"{
            setupTimeAxisLabel()

        }
    }
    
    func setupMyInfoLabel(){
        self.titleLB.textColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)
        self.titleLB.textAlignment = NSTextAlignment.left
        self.inputContent.font = UIFont.systemFont(ofSize: 16)
    }
    
    func setupTimeAxisLabel(){
        titleLabelLeading.constant = -10;
        titleLabelWidth.constant = 40;
        self.titleLB.textColor = UIColor(red: 144/255.0, green: 168/255.0, blue: 201/255.0, alpha: 1)
        self.titleLB.font = UIFont.systemFont(ofSize: 14)
        self.inputContent.font = UIFont.systemFont(ofSize: 14)
        self.inputContent.textColor = UIColor(red: 41/255.0, green: 41/255.0, blue: 41/255.0, alpha: 1)
        
        self.inputContent.clearButtonMode = UITextFieldViewMode.whileEditing
        self.inputContent.autocorrectionType = UITextAutocorrectionType.no;
        self.inputContent.autocapitalizationType = UITextAutocapitalizationType.none;
        self.inputContent.returnKeyType = UIReturnKeyType.done;
    }

}
