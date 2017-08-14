//
//  MyDollarsCell.swift
//  news
//
//  Created by 奥那 on 15/12/9.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

class MyDollarsCell: BaseTableViewCell {
    
    let screen_width = UIScreen.main.bounds.size.width
    var changeNumLabel : UILabel
    var changeContentLabel : UILabel
    var timeLabel : UILabel
    
    var model : LJDollarsDataListModel?{
        didSet{
            setValuesForMySubViews()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        changeNumLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 40, height: 44))
        changeContentLabel = UILabel(frame: CGRect(x: 50, y: 0, width: screen_width, height: 44))
        timeLabel = UILabel(frame: CGRect(x: 35, y: 0, width: screen_width - 50, height: 44))
        super.init(coder: aDecoder)
        
        layoutMySubViews()
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        changeNumLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 40, height: 44))
        changeContentLabel = UILabel(frame: CGRect(x: 50, y: 0, width: screen_width, height: 44))
        timeLabel = UILabel(frame: CGRect(x: 35, y: 0, width: screen_width - 50, height: 44))
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutMySubViews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    
    func layoutMySubViews(){
        
        self.backgroundColor = UIColor.white;
        
        
        changeNumLabel.backgroundColor = UIColor.clear
        changeNumLabel.font = UIFont.systemFont(ofSize: 16)
        changeNumLabel.textAlignment = NSTextAlignment.center
        changeNumLabel.textColor = UIColor(red: 246/255.0, green: 120/255.0, blue: 24/255.0, alpha: 1)
        self.contentView.addSubview(changeNumLabel)
        
        
        changeContentLabel.backgroundColor = UIColor.clear
        changeContentLabel.font = UIFont.systemFont(ofSize: 13)
        changeContentLabel.textColor = UIColor(red: 80/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1)
        self.contentView.addSubview(changeContentLabel)
        
        
        timeLabel.backgroundColor = UIColor.clear
        timeLabel.font = UIFont.systemFont(ofSize: 10)
        timeLabel.textAlignment = NSTextAlignment.right
        timeLabel.textColor = UIColor(red: 150/255.0, green: 150/255.0, blue: 150/255.0, alpha: 1)
        self.contentView.addSubview(timeLabel)
        
        let lineView = UIView(frame: CGRect(x: 0, y: 43, width: screen_width, height: 1))
        lineView.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1)
        self.contentView.addSubview(lineView)

    }
    
    func setValuesForMySubViews(){
        var value = (model?.affect)!
        if Int(value)! > 0{
            value = "+" + value
        }
        
        changeNumLabel.text = value
        changeContentLabel.text = model?.intro

        let dateString = NSString(string: (model?.timeCreate)!)
        let date = Date(timeIntervalSince1970:dateString.doubleValue)
        timeLabel.text = TKCommonTools.dateString(withFormat: TKDateFormatChineseShortYMD, date: date)
    }
    
}
