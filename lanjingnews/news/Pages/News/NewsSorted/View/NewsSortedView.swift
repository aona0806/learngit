//
//  NewsSortedView.swift
//  news
//
//  Created by 奥那 on 2017/5/10.
//  Copyright © 2017年 lanjing. All rights reserved.
//

import UIKit

class NewsSortedView: UIView {
    
    private var titleLabel = UILabel()
    private let title = "栏目切换  长按拖动排序"

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupSubviews()
    }

    func setupSubviews() {
        titleLabel.frame = CGRect.init(x: 11, y: 28, width: 200, height: 20);
        let mutAtt = NSMutableAttributedString.init(string: title)
        mutAtt.addAttribute(NSForegroundColorAttributeName, value: UIColor.rgb(0x2c2825), range: NSMakeRange(0, 4))
        mutAtt.addAttribute(NSForegroundColorAttributeName, value: UIColor.rgb(0xa2abb6), range: NSMakeRange(6, 6))
        
        mutAtt.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 13), range: NSMakeRange(0, 4))
        mutAtt.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 12), range: NSMakeRange(6, 6))

        titleLabel.attributedText = mutAtt
        
        self.addSubview(titleLabel)
    }
}
