//
//  AuthenticationView.swift
//  news
//
//  Created by 奥那 on 16/1/6.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit
//蓝鲸认证页面
class AuthenticationView: UIView , UITextFieldDelegate{
    
    let textField : UITextField
    
    override init(frame: CGRect) {
        textField = UITextField()
        super.init(frame: frame)
        customSubViews()
    }

    required init?(coder aDecoder: NSCoder) {
        textField = UITextField()
        super.init(coder: aDecoder)
        customSubViews()
    }
    
    func customSubViews(){
        let width = self.width
        self.backgroundColor = UIColor.rgb(0xe8e8e8)
        
        textField.frame = CGRect(x: 10, y: 27, width: width - 20, height: 44)
        textField.backgroundColor = UIColor.white;
        textField.delegate = self;
        textField.placeholder = "填写邀请码";
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.textColor = UIColor.black;
        textField.clearButtonMode = UITextFieldViewMode.whileEditing;
        textField.autocorrectionType = UITextAutocorrectionType.no;
        textField.autocapitalizationType = UITextAutocapitalizationType.none;
        textField.returnKeyType = UIReturnKeyType.done;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignment.center;
        textField.font = UIFont.systemFont(ofSize: 17);
        self.addSubview(textField)
        
        //认证说明
//        let label = UILabel(frame: CGRectMake(15, 91, width - 30, 44))
//        label.textColor = UIColor.rgb(0x262626)
//        label.font = UIFont.systemFontOfSize(16)
//        let instruction =  "认证说明: \n1.\n2.\n"
//        let paragraphStyle = NSMutableParagraphStyle();
//        paragraphStyle.lineSpacing = 10
//        let attributeString = NSMutableAttributedString(string: instruction)
//        attributeString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributeString.length))
//        label.attributedText = attributeString
//        label.numberOfLines = 0
//        
//        let contentRect = attributeString.sizeWithMaxWidth(label.width, font: label.font)
//        label.height = contentRect.height
//        self.addSubview(label)
        
        let label = UILabel(frame: CGRect(x: 20, y: 91, width: width - 40, height: 150))
        label.numberOfLines = 0
        label.backgroundColor = UIColor.clear
        label.text = "请联系蓝鲸财经人员索要邀请码  小秘书QQ1729572640  个人微信lanjingxms  蓝鲸财经助理QQ1132093810  个人微信lanjingzhuli"
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        label.sizeToFit()
        self.addSubview(label)
   
    }
}
