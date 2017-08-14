//
//  CommentNameLabel.swift
//  news
//
//  Created by wxc on 16/1/6.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

enum indentifyType: Int{
    case none
    case reporter
    case expert
}

class CommentNameLabel: UIView {
    
    var nameLabel:UILabel!
    var indentifyImageView:UIImageView?
    
    var nameWeith:CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addAllSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addAllSubviews(){
        nameLabel = UILabel()
        self.addSubview(nameLabel)
    }
    
    func setValueWith(_ name:String, indentify:indentifyType){
        nameLabel.text = name
        indentifyImageView?.image = nil
        if indentify == .none{
            indentifyImageView?.removeFromSuperview()
            indentifyImageView = nil
        }else{
            indentifyImageView = UIImageView()
            indentifyImageView?.contentMode = UIViewContentMode.scaleAspectFit
            self.addSubview(indentifyImageView!)
            if indentify == .reporter {
                indentifyImageView?.image = UIImage.init(named: "tag_v")
            }else if indentify == .expert {
                indentifyImageView?.image = UIImage.init(named: "tag_v2")
            }
        }
        
        self.setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        self.frame = CGRect(x: 0, y: 0, width: 20, height: 10);
        super.updateConstraints()
        if indentifyImageView == nil {
            nameLabel.snp.remakeConstraints({ (make) -> Void in
                make.left.equalTo(self.snp.left)
                make.right.equalTo(self.snp.right)
                make.top.equalTo(self.snp.top)
                make.bottom.equalTo(self.snp.bottom)
            })
        }else {
            nameLabel.snp.remakeConstraints({ (make) -> Void in
                make.left.equalTo(self.snp.left)
                make.right.equalTo(self.snp.right).offset(-18)
                make.top.equalTo(self.snp.top)
                make.bottom.equalTo(self.snp.bottom)
            })
            
            indentifyImageView!.snp.remakeConstraints({ (make) -> Void in
                make.left.equalTo(self.snp.right).offset(-16)
                make.right.equalTo(self.snp.right)
                make.centerY.equalTo(self.snp.centerY)
//                make.height.equalTo(indentifyImageView!.snp.width)
            })
        }
    }
}
