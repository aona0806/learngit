//
//  NewsTelegraphDetailImageTableViewCell.swift
//  news
//
//  Created by wxc on 2017/2/20.
//  Copyright © 2017年 lanjing. All rights reserved.
//

import UIKit

class NewsTelegraphDetailImageTableViewCell: UITableViewCell {
    
    static let ScreenWidth = UIScreen.main.bounds.size.width
    
    var imageTapAtCell:((NewsTelegraphDetailImageTableViewCell)->Void)?
    
    var imgView = NewsImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = UIColor.clear
        
        self.contentView.addSubview(imgView)
        imgView.contentMode = .scaleToFill
        imgView.backgroundColor = UIColor.rgb(0xf3f3f3)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(imageTap))
        self.imgView.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCellImage(model:LJNewsTelegraphDetailDataImgsDetailModel){
        
        let imageW:CGFloat = CGFloat(model.w)
        let imageH:CGFloat = CGFloat(model.h)
        
        if imageH * imageW == 0 {
            return;
        }
        
        self.imgView.height = NewsTelegraphDetailImageTableViewCell.heightWith(model:model) - 14
        self.imgView.width = self.imgView.height * imageW / imageH
        
        self.imgView.setImage(URL.init(string: model.url ?? ""), holderImage: UIImage.init(named: ""))
        
        self.imgView.centerX = NewsTelegraphDetailImageTableViewCell.ScreenWidth / 2
        self.imgView.top = 7
    }
    
    func imageTap(){
        if imageTapAtCell != nil {
            imageTapAtCell!(self)
        }
    }
    
    class func heightWith(model:LJNewsTelegraphDetailDataImgsDetailModel) -> CGFloat{
        var width = CGFloat(model.w ?? 0) / 2
        if width > CGFloat(ScreenWidth - 28) {
            width = CGFloat(ScreenWidth - 28)
            return CGFloat(model.h) * width / CGFloat(model.w) + 14
        }
        
        return CGFloat(model.h) / 2 + 14
    }
}
