//
//  CommunityRedDotDetailView.swift
//  news
//
//  Created by chunhui on 15/12/23.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

class CommunityRedDotDetailView: UIView {

    @IBOutlet   var backView : UIView!
    @IBOutlet   var backTopConstraint : NSLayoutConstraint!
    @IBOutlet   var backImageView: UIImageView!
    
    @IBOutlet   var discussButton: UIButton!
    @IBOutlet   var discussTitleLabel: UILabel!
    @IBOutlet   var discussNumLabel: UILabel!
    
    @IBOutlet   var commentButton: UIButton!
    @IBOutlet   var commentTitleLabel: UILabel!
    @IBOutlet   var commentNumLabel: UILabel!
    
    @IBOutlet   var praiseButton: UIButton!
    @IBOutlet   var pariseTitleLabel: UILabel!
    @IBOutlet   var praiseNumLabel: UILabel!
    
    
    
    var onClick : ((_ row : Int) -> ())? = nil
    
    
    struct Consts {
    }
    
    let _height = UIScreen.main.bounds.height
    
    var itemArray : Array<String>! = Array<String>()
    
    var _MenuWidth : Int = 185
    
    var dataArray : Array<Int>! = [0,0,0]
    
    var numLabelArray : Array<UILabel>!
    var titleLabelArray : Array<UILabel>!
    var buttonArray : Array<UIButton>!
    
    var bgAnchorYLocationOffset :CGFloat  = 0
    var bgOrginAnchorY : CGFloat  = 0
    
    var readNum : CommunityRedDotDataModel! = CommunityRedDotDataModel(){
        didSet{
            dataArray[1] = Int(readNum.comment)
            dataArray[2] = Int(readNum.zan)
            
            for index in 1...2 {
                let num = dataArray[index]
                let numLabel = numLabelArray[index]
                
                if num > 0 {
                    numLabel.layer.cornerRadius = 7
                    numLabel.layer.masksToBounds = true
                    numLabel.text = num.description
                    numLabel.isHidden = false
                    
                    numLabel.setNeedsDisplay()
                    numLabel.layoutSubviews()
                    
                } else {
                    numLabel.text = 0.description
                    numLabel.isHidden = true
                }
            }
        }
    }
    
    override func layoutSubviews() {
        
        self.backTopConstraint.constant = self.bgOrginAnchorY + self.bgAnchorYLocationOffset
        //call super at last ,or will cause layoutSublayersOfLayer assert failed
        super.layoutSubviews()
    }
    
    
    func onClick(_ sender : UIButton){
        
        for index in 0...2 {
            let button = buttonArray[index]
            let numLabel = numLabelArray[index]
            let titleLabel = titleLabelArray[index]
            if button.tag == sender.tag {
                titleLabel.textColor = UIColor.rgb(0xfbde8d)
                
                dataArray[index] = 0
                numLabel.isHidden = true
            } else {
                titleLabel.textColor = UIColor.white
            }
        }
        
        self.onClick?(sender.tag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isHidden = true
        self.onClick?(4)
        
        super.touchesBegan(touches, with: event)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.frame = UIScreen.main.bounds
        
    }
    
    override func awakeFromNib() {
        
        numLabelArray = [discussNumLabel,commentNumLabel,praiseNumLabel]
        buttonArray = [discussButton,commentButton,praiseButton]
        titleLabelArray = [discussTitleLabel,commentTitleLabel,pariseTitleLabel]
        
        bgOrginAnchorY = self.backTopConstraint.constant
        
        
//        let backImage = UIImage(named: "information_frame")
//        self.backImageView.image = backImage
        
        for index in 0...2 {
            let num = dataArray[index]
            let numLabel = numLabelArray[index]
            let button = buttonArray[index]
            let titleLabel = titleLabelArray[index]
            
            if num > 0 {
                numLabel.layer.cornerRadius = 7
                numLabel.layer.masksToBounds = true
                numLabel.text = num.description
                numLabel.isHidden = false
            } else {
                numLabel.text = 0.description
                numLabel.isHidden = true
            }
            
            titleLabel.textColor = UIColor.white
            
            button.addTarget(self, action: #selector(CommunityRedDotDetailView.onClick(_:)), for: UIControlEvents.touchUpInside)
            button.setBackgroundImage(UIImage(named: "com_reddot_btn_high_bg"), for: UIControlState.highlighted)
            button.setBackgroundImage(nil, for: UIControlState())
            button.tag = index
        }
    }


}
