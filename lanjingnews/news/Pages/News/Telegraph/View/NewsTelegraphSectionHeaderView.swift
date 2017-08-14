//
//  NewsTelegraphSectionHeaderView.swift
//  news
//
//  Created by 奥那 on 2016/12/28.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class NewsTelegraphSectionHeaderView: UIView {
    
    var titleLabel : UILabel!
    var lineView : UIView!
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        customSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    var time: String? {
        didSet {

            let ctime = NSString.init(string: time!)
            let timeStr: String = TKCommonTools.datestring(withFormat: TKDateFormatChineseShortYMD, timeStamp: ctime.doubleValue)
            let date = NSDate.init(timeIntervalSince1970: ctime.doubleValue)
            let weekStr : String = TKCommonTools.week(of: date as Date!, with: TKDateThreeWorldsLength)
            
            titleLabel.text = timeStr+" "+weekStr

        }
    }

    func customSubViews() {
        let width = UIScreen.main.bounds.width

        titleLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: width, height: 25))
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = UIColor.init(colorLiteralRed: 71/255.0, green: 72/255.0, blue: 78/255.0, alpha: 1)
        
        self.addSubview(titleLabel)
        
        lineView = UIView.init(frame: CGRect.init(x: 0, y: 24, width: width, height: 1))
        lineView.backgroundColor = UIColor.init(colorLiteralRed: 242/255.0, green: 243/255.0, blue: 243/255.0, alpha: 1)
        self.addSubview(lineView)
    }

}
