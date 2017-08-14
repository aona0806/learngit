//
//  SystemNotificationTableViewCell.swift
//  news
//
//  Created by chunhui on 15/3/14.
//  Copyright (c) 2015年 lanjing. All rights reserved.
//

import UIKit

class SystemNotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var headImageView : UIImageView?
    @IBOutlet weak var nameLabel : UILabel?
    @IBOutlet weak var actionLabel : UILabel?
    @IBOutlet weak var timeLabel     : UILabel?
    @IBOutlet weak var digestLabel : UILabel?
    
    
    @IBOutlet weak var nameTopConstraint : NSLayoutConstraint?
    @IBOutlet weak var contentBgHeightConstraint : NSLayoutConstraint?
    
    var headClick:((LJSystemNofiticationDataMsgListModel?) -> Void)? = nil
    
    struct Consts{
        
        static let ContentFontSize : Int = 14
        static let ForwardFontSize : Int = 12
        static let PraiseListFontSize : Int = 11
        static let authodSize : Int = 14
        static let dateFontSize : Int! = 12
        static let CompanyFontSize : Int = 12
        
        static let Padding = 10.0
        static let ForwardHorPadding = 10.0
        static let ForwardLineSpacing = CGFloat(3.0)
        
        static let ContentLineSpacing = CGFloat(4.0)
        static let ContentFaceOffset = UIOffset(horizontal: 0, vertical: -5)
        
        
        /// 点赞label上下边距
        static let PraiseListLabelMarginV = 6.0
        
        static let contentWidth = UIScreen.main.bounds.width - 80
        static let zanContentWidth = UIScreen.main.bounds.width - 63
        
        static func getFontSize(_ size : Int!) -> CGFloat{
            let fontSize = CGFloat(size)
            return fontSize
        }
    }

    
    class var Identifier: String {
        get{
            return "SystemNotificationTableViewCell"
        }
    }
    
    class func CellHeightForModel(_ model:LJSystemNofiticationDataMsgListModel) ->CGFloat{
    
        var height = CGFloat(10)
        
        height += CGFloat(20) //name
        
        if ((model.digest?.length())! > 0){
            
            height += CGFloat(30)
            let digestString = model.digest
            let contentFont = UIFont.systemFont(ofSize: 14)
            if let bodyString = digestString?.show(with: contentFont , imageOffSet: Consts.ContentFaceOffset , lineSpace:Consts.ContentLineSpacing ,imageWidthRatio: CGFloat(1.5)) {
                
                let vheight = bodyString.size(withMaxWidth: Consts.contentWidth, font: contentFont).height
                
                height += CGFloat(vheight)
            }
            
        }
        height += CGFloat(10)
        
        if(height < 50){
            height = CGFloat(50)
        }
        
        return height
    }
    var model : LJSystemNofiticationDataMsgListModel? {
        didSet{
            
            let user = model?.fromUser
            if (user != nil){
                if ((user?.avatar?.length())! > 0){
                    let url = Urlhelper.tryEncode(user!.avatar)
                    headImageView?.sd_setImage(with: url)
                }
                nameLabel?.text = user?.sname
            }

            actionLabel?.text = model?.actionContent
            if((model?.digest?.length())! > 0){
                
                let digestString = model?.digest
                let contentFont = UIFont.systemFont(ofSize: 14)
                
                let bodyString = digestString!.show(with: contentFont , imageOffSet: Consts.ContentFaceOffset , lineSpace:Consts.ContentLineSpacing ,imageWidthRatio: CGFloat(1.5))
                
                digestLabel?.attributedText = bodyString
                nameTopConstraint?.constant = 0

                var height = CGFloat(20.0)
                
                if let vheight = bodyString?.size(withMaxWidth: Consts.contentWidth, font: contentFont).height {
                    
                    height += CGFloat(vheight)
                    
                    contentBgHeightConstraint?.constant = height
                }
            }else{
                digestLabel?.text = nil
                nameTopConstraint?.constant = 5
                contentBgHeightConstraint?.constant = 0
            }
            
            if (model?.ctime != nil ){
                timeLabel?.text = model?.ctime
            }else if (model?.timestamp != nil){
                let timestamp = model?.timestamp
                let date = Date(timeIntervalSince1970: timestamp!.doubleValue)
                timeLabel?.text = TKCommonTools.dateDesc(for: date)
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.headImageView?.isUserInteractionEnabled = true
        self.headImageView?.layer.masksToBounds = true
        self.headImageView?.layer.cornerRadius = self.headImageView!.frame.width / 2
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SystemNotificationTableViewCell.headTapAction(_:)))
        self.headImageView?.addGestureRecognizer(tapGesture)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func headTapAction(_ sender : AnyObject){
        
        if self.headClick != nil {
            self.headClick!(self.model)
        }
    }
    
}


class SystemNotificationBgView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        let color = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)
        
        context?.setStrokeColor(color.cgColor)
        context?.setLineWidth(0.5)
        

        context?.move(to: CGPoint.init(x: 10, y: rect.height-1))
        context?.addLine(to: CGPoint.init(x: rect.width, y: rect.height-1))
        
        context?.strokePath()
        
    }
}

class SystemNotificationOriginBgView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setLineWidth(1)
        
        context?.stroke(rect)
        
    }
}
