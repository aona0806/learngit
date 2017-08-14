//
//  NewsSwitchSlideItemCollectionViewCell.swift
//  news
//
//  Created by liuzhao on 16/6/29.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class NewsSwitchSlideItemCollectionViewCell: TKSwitchSlideItemCollectionViewCell {

    struct Consts {
        static let TitleFont = UIFont.systemFont(ofSize: 17)
        static let TitlehighlightedFont = UIFont.systemFont(ofSize: 19)
        static let slideBarHeight:CGFloat = 3 /* 颜色条高度 */
        static let slideBarEdge:CGFloat = 10 /* 颜色左右距离字的边距 */
    }
    
    var slideBar: UIView?
    
    override static func cellWidth(forTitle title : String) -> CGFloat {
        
        var width = CGFloat(30.0)
        width += title.size(withMaxWidth: 10000 , font: Consts.TitleFont).width
        
        return width
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.customItem()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.customItem()
    }
    
    func customItem() {
        self.titleLabel.textColor = UIColor.rgb(0xc6cdd7)
        self.titleLabel.font = Consts.TitleFont
        self.titleLabel.textAlignment = .center
        
        slideBar = UIView.init()
        slideBar?.backgroundColor = UIColor.black
        slideBar?.alpha = 0
        slideBar?.layer.cornerRadius = Consts.slideBarHeight/2
        
        self.contentView.addSubview(slideBar!)
    }
    
    func updateView (_ isSelected: Bool) -> Void {
        
        let titleFont = isSelected ? Consts.TitlehighlightedFont : Consts.TitleFont
        titleLabel.font = titleFont
        
        if isSelected {
            self.titleLabel.textColor = UIColor.rgb(0x000000)
        }else{
            self.titleLabel.textColor = UIColor.rgb(0xc6cdd7)
        }

        slideBar?.alpha = (isSelected ? 1:0)
        slideBar?.isHidden = !isSelected
    }
    
    override func setSelected(_ selected: Bool) {
        super.setSelected(selected)
        self.updateView(selected)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width =  self.width - 30
        slideBar?.frame = CGRect.init(x: 0, y:self.height - Consts.slideBarHeight, width: width - 2*Consts.slideBarEdge, height: Consts.slideBarHeight)
        self.slideBar?.centerX = self.width / 2
    }
    
    override func update(withOffset offset: CGFloat) {
        slideBar?.alpha = offset;
        slideBar?.isHidden = false
        self.titleLabel.textColor = UIColor.init(red: (0xc6 - 0xc6*offset)/255, green: (0xcd - 0xcd*offset)/255, blue: (0xd7 - 0xd7*offset)/255, alpha: 1);
        self.titleLabel.font = UIFont.systemFont(ofSize: 17 + 2 * offset)
    }
}
