//
//  LoginRegistViewController.swift
//  news
//
//  Created by 奥那 on 16/1/5.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class LoginRegistViewController: TKRegistViewController, UIAlertViewDelegate  {
        
    var identifierString = ""
    
    var popToRootView = false
    
    private var usernameString: String?
    private var passwordString: String?
    
    private var loginTask: URLSessionDataTask?
    private var getUserinfoTask: URLSessionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.titleString = "蓝鲸财经"
        
        customNavigationItem()
        self.loginRegisterView.hasEmail = false
    }
    
    deinit{
        
        NotificationCenter.default.removeObserver(self)
    }
    
    //自定义NavigationItem
    func customNavigationItem(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.defaultLeftItem(withTarget: self, action: #selector(LoginRegistViewController.backAction))
    }
    
    override func backAction(){
                
        if  AccountManager.sharedInstance.isLogin() {
            //用户之前登录，但由于token失效重新登录，但用户点击返回，触发退出登录
            AccountManager.sharedInstance.logout()
            NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConsts.kLogoutNotification), object: nil)
        }
        
        //退出后调用 logout
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    //点击发送验证码
    override func clickcaptcha(withPhoneNumber phoneNumber: String!) {
        
        if phoneNumber.length() != 11 || !self.isPureInt(phoneNumber) {
            _ = self.showToastHidenDefault("无效的手机号,请重新输入")

            return
        }

        let manager = LJVeriftCodeManager.shareInstance()

        if (manager?.isShowVerifyView())! {
            manager?.phoneNum = phoneNumber
            manager?.verifyType = .register
            manager?.showVerifyCodeView()
            manager?.verifySuccess = {[weak self](ticket,validate) in
                self?.sendCaptchaWithPhoneNum( phoneNumber , validate: validate , ticket: ticket)
            }
        }else{
            self.sendCaptchaWithPhoneNum( phoneNumber , validate: "" , ticket: "")
            
        }
        
    }
    
    func sendCaptchaWithPhoneNum(_ phoneNum:String! , validate:String! , ticket:String!){

        TKRequestHandler.sharedInstance().registSendCaptcha(withPhoneNumber: phoneNum , ticket:ticket , captcha:validate) { [weak self] (sessionDataTask, response, error) -> Void in

            guard let strongSelf = self else{
                return
            }

            if error != nil{
                _ = strongSelf.showToastHidenDefault(error?._domain)
                return
            }

            var sendMsg = ""
            let dic = response as? NSDictionary
            let errMsg = dic?["errno"] as! NSNumber
            if errMsg == 0{

                strongSelf.loginRegisterView.timeCount = 60;
                strongSelf.loginRegisterView.timer = Timer.scheduledTimer(timeInterval: 1, target: strongSelf, selector: #selector(TKForgetPassWordViewController.timeCountDown), userInfo: nil, repeats: true)
                strongSelf.loginRegisterView.captchaButton.isEnabled = false

                let dic = response as? NSDictionary
                let data = dic!["data"] as? NSDictionary
                strongSelf.identifierString = data!["identifier"] as! String
                sendMsg = "发送成功"

            }else{
                let dic = response as? NSDictionary
                sendMsg = dic?["msg"] as! String
            }
            
            if sendMsg.length() != 0{
                _ = strongSelf.showToastHidenDefault(sendMsg)
            }

        }
    }
    
    //注册
    override func clickRegist(withPhoneNumber phoneNumber: String!, captcha: String!, passWord: String!, nickName: String!) {
        
        let result = checkPhoneNumber(phoneNumber, captcha: captcha, passWord: passWord, nickName: nickName)
        if result != nil{
            _ = self.showToastHidenDefault(result!)
            return
        }
        
        TKRequestHandler.sharedInstance().regist(withPhoneNmuber: phoneNumber, passWord: passWord, captcha: captcha, nickname: nickName, identifier: identifierString) {[weak self] (sessionDataTask, response, error) -> Void in
            
            guard let strongSelf = self else{
                return
            }

            if error != nil{
                _ = strongSelf.showToastHidenDefault(error?._domain)
                return
            }
            let dic = response as? NSDictionary
            let code = dic?["errno"] as! NSNumber
            if code != 0{
                let msg = dic?["msg"] as! String
                _ = strongSelf.showToastHidenDefault(msg)
            }else{
                _ = strongSelf.showPopHud("注册成功", hideDelay: 1)
                
                //注册成功跳转登录
                strongSelf.loginRegisterView.clickLoginView()
            }
        }
    }
    
    //登录
    override func clickLogin(withPhoneNumber phoneNumber: String!, passWord: String!) {
        
        if loginRegisterView.phoneTextField.text == usernameString && loginRegisterView.passWordField.text == passwordString {
            return
        } else {
            loginTask?.cancel()
            getUserinfoTask?.cancel()
        }
        
        usernameString = phoneNumber
        passwordString = passWord

        let errMsg = self.checkPhoneNumber(phoneNumber, passsword: passWord)
        if errMsg != nil{
            _ = self.showToastHidenDefault(errMsg!)
            usernameString = nil
            passwordString = nil
            return
        }
        
        
        loginTask = TKRequestHandler.sharedInstance().login(withPhoneNumber: phoneNumber, passWord: passWord) { [weak self](sessionDataTask, response, error) -> Void in
            
            guard let strongSelf = self else{
                return
            }
            
            if error != nil{
                strongSelf.usernameString = nil
                strongSelf.passwordString = nil
                _ = strongSelf.showToastHidenDefault(error!._domain)
            }else{
                
                let model = LJUserInfoModel()
                let dic = response as! NSDictionary
                let data = dic["data"] as! NSDictionary
                model.uid = data["uid"] as? String
                model.verified = data["verified"] as? String
                model.token = data["token"] as? String
                
                AccountManager.sharedInstance.updateAccountInfo(model)
                strongSelf.getUserInfo(model.uid!, token: model.token!)
            }
        }
        
    }
    
    override func forgetPassWord() {
        let controller = ForgetPassWordViewController()
        controller.title = "忘记密码"
        self.navigateTo(controller)
        
    }
    
    //登录 判断 输入是否正确
    func checkPhoneNumber(_ phone:String,passsword:String) -> String?{
        if phone.length() != 11 || !self.isPureInt(phone){
            return "用户不存在"
        }
        if passsword.length() == 0{
            return "密码错误"
        }
        
        return nil
    }

    //注册 判断 输入是否正确
    func checkPhoneNumber(_ phoneNumber: String!, captcha: String!, passWord: String!, nickName: String!) -> String?{
        if phoneNumber.length() != 11 || !self.isPureInt(phoneNumber){
            return "无效的手机号,请重新输入"
        }
        if captcha.length() == 0{
            return "验证码错误,请重新输入"
        }
        if passWord.length() < 6 || passWord.length() > 15{
            return "密码长度6-15个字符"
        }
        if !self.checkNickName(nickName){
            return "昵称2-16个字符，支持英文、下划线"
        }
        
        return nil
    }
    
    //登录成功获取用户信息
    func getUserInfo(_ uid:String,token:String){

        getUserinfoTask = TKRequestHandler.sharedInstance().getUserInfo(withUid: uid , finish:  { [weak self](task, model, error) -> Void in
            
            guard let strongSelf = self else{
                return
            }

            strongSelf.view.endEditing(true)
            if error != nil{
                _ = strongSelf.showToastHidenDefault(error?._domain)
                strongSelf.usernameString = nil
                strongSelf.passwordString = nil
            } else if model != nil{
                
                if model?.dErrno.intValue != 0{
                    strongSelf.usernameString = nil
                    strongSelf.passwordString = nil
                    return
                }
                
                let userInfo = model?.data
                userInfo?.token = token
                AccountManager.sharedInstance.updateAccountInfo(userInfo!)
                
                // 添加注册成功之后认证提示
                let accountManager = AccountManager.sharedInstance
                let userDefaults = UserDefaults.standard
                var firstUserArray: Array<String> = userDefaults.object(forKey: GlobalConsts.kUserFirstLoginUid) as? [String] ?? []
                
                let isNeedAuthentication = accountManager.isLogin() && !accountManager.isVerified() && !firstUserArray.contains(accountManager.uid())
                
                //登录获取用户信息成功发送通知 统计登录
                NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConsts.kLoginSuccessNotication), object: nil)

                if isNeedAuthentication {
                    strongSelf.view.endEditing(true)

                    let alertTitle = "温馨提示"
                    let alertMessage = "记者立即认证专业身份\n以使用工作站系列工具"
//                    if #available(iOS 8.0, *) {
                    
                        let alertViewController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                        alertViewController.addAction(UIAlertAction(title: "取消", style: .default, handler: { (alertAction) in
                            strongSelf.usernameString = nil
                            strongSelf.passwordString = nil
                            
                            if strongSelf.popToRootView{
                               _ = strongSelf.navigationController?.popToRootViewController(animated: false)
                            }else{
                                _ = strongSelf.navigationController?.popViewController(animated: true)
 
                            }
                        }))
                        alertViewController.addAction(UIAlertAction(title: "立即认证", style: .default, handler: { (alertAction) in
                            
                            strongSelf.usernameString = nil
                            strongSelf.passwordString = nil
                            
                            if strongSelf.popToRootView{
                                _ = strongSelf.navigationController?.popToRootViewController(animated: false)
                            }else{
                                _ = strongSelf.navigationController?.popViewController(animated: true)
                                
                            }
                            NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConsts.kAuthenticationNotication), object: nil)

                        }))
                        strongSelf.present(alertViewController, animated: true, completion: nil)
                        
//                    } else {
//                        let alertView = UIAlertView(title: "温馨提示", message: alertMessage, delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "立即认证")
//                        alertView.tag = 1002
//                        alertView.show()
//                    }
                    
                    _ = GlobalConsts.CHelpView_background
                    firstUserArray.append(accountManager.uid())
                    userDefaults.set(firstUserArray, forKey: GlobalConsts.kUserFirstLoginUid)
                } else {
                    //登录获取用户信息成功发送通知 统计登录
                    if strongSelf.popToRootView{
                        _ = strongSelf.navigationController?.popToRootViewController(animated: false)
                    }else{
                        _ = strongSelf.navigationController?.popViewController(animated: true)
                        
                    }
                    strongSelf.usernameString = nil
                    strongSelf.passwordString = nil
                }
            }
        })

    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        if alertView.tag == 1002 {
            usernameString = nil
            passwordString = nil

            if buttonIndex == 1 {
                _ = self.navigationController?.popViewController(animated: false)
                NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConsts.kAuthenticationNotication), object: nil)
            } else {
                _ = self.navigationController?.popViewController(animated: true)
            }
        } else {
            switch buttonIndex {
            case 0:
                //注册成功跳转登录
                self.loginRegisterView.clickLoginView()
                
                break
            case 1:
                
                //注册成功跳转登录
                self.loginRegisterView.clickLoginView()
                
                break
            default:
                break
            }
        }
    }


}
