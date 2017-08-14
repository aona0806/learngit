//
//  HotEventDetailFooterView.swift
//  news
//
//  Created by 陈龙 on 16/6/7.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class HotEventDetailFooterView: UIView {

    struct Consts {
        
        static let ContentHorizontalSpace = CGFloat(15)
        
        static let ZanButtonSize = CGSize(width: 69, height: 26)
        static let ZanButtonButtomSpace = CGFloat(40)
        static let ZanButtonTopSpace = CGFloat(17)
        
        static let ZanLabelBorderColor = UIColor.rgb(0x1a93d1)
        static let ZanLabelBorderWidth = CGFloat(1)
        static let ZanLabelFont = UIFont.systemFont(ofSize: 12)
        static let ZanLabelHeight = CGFloat(20)
        static let ZanLabelWidth = CGFloat(98)
        
        static let ZanButtonBackColor = UIColor.rgb(0x03a7f4)
        static let ZanButtonFont = UIFont.systemFont(ofSize: 12)
        static let ZanButtonTextColor = UIColor.rgb(0x999898)
    }
    
    private var zanNumButton = UIButton()
    private let zanButton = UIButton()
    
    var zanClickAction: ((Bool, HotEventDetailFooterView) -> ())?
    
    // MARK: - lifecycle
    
    init () {
        let frame = CGRect(x: 0, y: 0, width: GlobalConsts.screenWidth, height: HotEventDetailFooterView.heightForCell())
        super.init(frame: frame)
        
        initView()
        initViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        guard let model = info else {
            return
        }
        
        zanNumButton.snp.updateConstraints { (make) in
            var zanNumString = model.zanNum ?? "0"
            zanNumString = zanNumString.exchangeReadNum()
            let zanString: NSString = "\(zanNumString)人认为有用" as NSString
            let width = zanString.size(withMaxHeight: Consts.ZanLabelFont.lineHeight, font: Consts.ZanLabelFont).width + CGFloat(30)
            make.width.equalTo(width)
        }
    }
    
    // MARK: - private
    
    private func initView() {
        
        self.clipsToBounds = true
        
        zanNumButton.setTitleColor(Consts.ZanButtonTextColor, for: UIControlState())
        zanNumButton.titleLabel?.font = Consts.ZanButtonFont
        let usefulImage = UIImage(named: "hotevent_list_useful")
        zanNumButton.setImage(usefulImage, for: UIControlState())
        zanNumButton.setTitle("0人认为有用", for: UIControlState())
        zanNumButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 6)
        self.addSubview(zanNumButton)
        
        zanButton.setTitleColor(Consts.ZanButtonTextColor, for: UIControlState())
        zanButton.titleLabel?.font = Consts.ZanButtonFont
        let zanImage = UIImage(named: "hotevent_list_zan_cancel")
        zanButton.setImage(zanImage, for: UIControlState())
        zanButton.setTitle("有用", for: UIControlState())
        //zanButton.layer.cornerRadius = CGFloat(2)
        zanButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 6)
        zanButton.addTarget(self, action: #selector(zanAction(_:)), for: .touchUpInside)
        self.addSubview(zanButton)
        
    }
    
    private func initViewConstraints() -> Void {
        
        zanButton.snp.makeConstraints { (make) in
            make.size.equalTo(Consts.ZanButtonSize)
            make.right.equalTo(self.snp.right).offset(-Consts.ContentHorizontalSpace)
            make.top.equalTo(self.snp.top).offset(Consts.ZanButtonTopSpace)
        }
        
        zanNumButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(Consts.ContentHorizontalSpace)
            make.centerY.equalTo(zanButton.snp.centerY)
            make.height.equalTo(Consts.ZanLabelHeight)
            make.width.equalTo(Consts.ZanLabelWidth)
        }
    }
    
    // MARK: - action
    
    @objc private func zanAction(_ sender: UIButton) -> Void {
        let zanNum = self.info?.isZan ?? "0"
        let isZan = zanNum != "1"
        self.zanClickAction?(isZan, self)
    }
    
    // MARK: - public

    var info: HotEventDetailDataModel? {
        
        didSet {
            guard let model = info else {
                return
            }
            
            var zanNumString = model.zanNum ?? "0"
            zanNumString = zanNumString.exchangeReadNum()
            let useString = "人认为有用"
            let zanString = "\(zanNumString)\(useString)"
            
            let zanAttributedString: NSMutableAttributedString! = NSMutableAttributedString(string: zanString)
            zanAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.rgb(0x03a7f4), range: NSMakeRange(0, zanNumString.length()))
            zanAttributedString.addAttribute(NSForegroundColorAttributeName, value: Consts.ZanButtonTextColor, range: NSMakeRange(zanNumString.length(), useString.length()))
            zanNumButton.setAttributedTitle(zanAttributedString, for: UIControlState())
            zanNumButton.sizeToFit()
            
            let isZanString = model.isZan ?? "0"
            let isZan = isZanString == "1"
            let zanImage = isZan ? UIImage(named: "hotevent_list_zan") : UIImage(named: "hotevent_list_zan_cancel")
            zanButton.setImage(zanImage, for: UIControlState())
            
            setNeedsUpdateConstraints()
        }
    }

    class func heightForCell() -> CGFloat {
        
        var height: CGFloat = 0.0
        
        height = Consts.ZanButtonTopSpace + Consts.ZanButtonSize.height + Consts.ZanButtonButtomSpace
        return ceil(height)
        
    }

}
