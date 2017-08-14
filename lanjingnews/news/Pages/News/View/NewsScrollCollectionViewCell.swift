//
//  NewsScrollCollectionViewCell.swift
//  news
//
//  Created by chunhui on 16/1/5.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class NewsScrollCollectionViewCell: UICollectionViewCell {
 
    struct Consts {
        static let TitleFont = UIFont.systemFont(ofSize: 17)
        static let TitlehighlightedFont = UIFont.boldSystemFont(ofSize: 19)
    }
    
    let titleLabel : UILabel = UILabel()
    
    static func cellWidthForTitle(_ title : String) -> CGFloat {
        
        var width = CGFloat(30.0)
        width += title.size(withMaxWidth: 10000 , font: Consts.TitleFont).width
        
        return width
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        initTitleLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initTitleLabel()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        titleLabel.frame = self.bounds
    }
    
    func updateView (_ isSelected: Bool) -> Void {
        
        let titleFont = isSelected ? Consts.TitlehighlightedFont : Consts.TitleFont
        titleLabel.font = titleFont
        setNeedsDisplay()
    }
    
    private func initTitleLabel() {
        
        titleLabel.textColor = UIColor.rgb(0x1a93d1)
        titleLabel.font = Consts.TitleFont
        titleLabel.textAlignment = .center
        titleLabel.highlightedTextColor = UIColor.rgb(0x268ad6)
        
        self.contentView.addSubview(titleLabel)
        
    }
    
}
