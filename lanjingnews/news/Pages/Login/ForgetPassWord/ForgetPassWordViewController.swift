//
//  ForgetPassWordViewController.swift
//  news
//
//  Created by 奥那 on 16/1/6.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class ForgetPassWordViewController: TKForgetPassWordViewController {

    var identifierString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customNavigationItem()
    }
    
    //自定义NavigationItem
    func customNavigationItem(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.defaultLeftItem(withTarget: self, action: #selector(ForgetPassWordViewController.backAction))
    }
    
    override func backAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func clickcaptcha(_ phoneNumber: String!) {
        
        if phoneNumber.length() != 11 || !self.isPureInt(phoneNumber) {
            _ = self.showToastHidenDefault("无效的手机号,请重新输入")
            return
        }
        
        let manager = LJVeriftCodeManager.shareInstance()
        
        if (manager?.isShowVerifyView())! {
            manager?.phoneNum = phoneNumber
            manager?.verifyType = .forgetPassword
            manager?.showVerifyCodeView()
            manager?.verifySuccess = {[weak self](ticket,validate) in
                self?.sendCaptchaWithPhoneNum( phoneNumber , validate: validate , ticket: ticket)
            }
        }else{
            self.sendCaptchaWithPhoneNum( phoneNumber , validate: "" , ticket: "")
            
        }
    
    }
    
    func sendCaptchaWithPhoneNum(_ phoneNum:String! , validate:String! , ticket:String!){
    
        TKRequestHandler.sharedInstance().forgetPassWordSendCaptcha(withPhoneNumber: phoneNum, ticket:ticket , captcha:validate) { [weak self](sessionDataTask, response, error) -> Void in
            
            guard let strongSelf = self else {
                return
            }
            
            if error != nil{
                _ = strongSelf.showToastHidenDefault(error?._domain)
                return
            } else {
                
                strongSelf.timeCount = 60;
                strongSelf.timer = Timer.scheduledTimer(timeInterval: 1, target: self!, selector: #selector(TKForgetPassWordViewController.timeCountDown), userInfo: nil, repeats: true)
                strongSelf.forgetPassWordView.captchaButton.isEnabled = false
                
                let dic = response as? NSDictionary
                let data = dic!["data"] as? NSDictionary
                strongSelf.identifierString = data!["identifier"] as! String
                let sendMsg = "发送成功"
                _ = strongSelf.showToastHidenDefault(sendMsg)
            }

        }
    
    }
    
    override func clickSubmit(_ phoneNumber: String!, captcha: String!, password: String!) {
        
        let check = checkInput(phoneNumber, captcha: captcha, pass: password)
        if check.length() != 0{
            _ = self.showToastHidenDefault(check)
            return
        }

        TKRequestHandler.sharedInstance().findUserPsssword(withPhone: phoneNumber, withCaptcha: captcha, withIdentifier: identifierString, withPassword: password) { [weak self](sessionDataTask, response, error) -> Void in
            
            guard let strongSelf = self else{
                return
            }
            
            if error != nil{
                _ = strongSelf.showToastHidenDefault(error?._domain)

                return
            } else {
                _ = strongSelf.showPopHud("密码修改成功", hideDelay: 1)
                _ = strongSelf.navigationController?.popViewController(animated: true)
            }            
        }
        
    }
    
    func checkInput(_ phoneNumber:String,captcha: String!,pass:String) -> String{
        if phoneNumber.length() != 11 || !self.isPureInt(phoneNumber) {
            return "用户不存在"
        }
        if captcha.length() == 0{
            return "验证码错误，请重新输入"
        }
        if pass.length() < 6 || pass.length() > 15{
            return "密码长度6-15个字符"
        }
        return ""
    }
    
}
