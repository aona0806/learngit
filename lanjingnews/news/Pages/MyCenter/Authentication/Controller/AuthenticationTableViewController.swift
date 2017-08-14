//
//  AuthenticationTableViewController.swift
//  news
//
//  Created by 奥那 on 16/1/4.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit
//蓝鲸认证
class AuthenticationTableViewController: LJBaseViewController {

    var authenticationView = AuthenticationView()
    override func viewDidLoad() {

        super.viewDidLoad()
        
        authenticationView = AuthenticationView(frame: self.view.frame)
        self.view.addSubview(authenticationView)
        
        customNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "记者认证通道"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /**
     自定义Navigation
     */
    func customNavigationItem(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "下一步", style: UIBarButtonItemStyle.done, target: self, action: #selector(AuthenticationTableViewController.nextStepAction))
    }

    /**
     下一步
     */
    func nextStepAction(){

        let text = authenticationView.textField.text
        if text?.length() == 0 {
            let msg = "请输入邀请码"
            _ = self.showToastHidenDefault(msg)
            return
        }
        
        TKRequestHandler.sharedInstance().checkInvitationCode(withCode: text) { [weak self](sessionDataTask, response, error) -> Void in
            
            guard let strongSelf = self else {
                return
            }
            
            if error != nil{
                _ = strongSelf.showToastHidenDefault(error?._domain)
                return
            } else {
                let controller = CompleteInfoTableViewController(style:.grouped)
                strongSelf.navigateTo(controller)
            }
        }
    }
}
