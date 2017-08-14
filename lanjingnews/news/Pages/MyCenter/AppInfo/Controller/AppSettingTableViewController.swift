//
//  AppSettingTableViewController.swift
//  news
//
//  Created by 奥那 on 15/12/8.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit


class AppSettingTableViewController: LJBaseTableViewController {
    
    let titleList = ["修改密码","会议系统使用说明","提点意见", "服务条款","关于蓝鲸财经 "]
    var configs = ["修改密码","提点意见","关于蓝鲸财经 "]
    var isNormal : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "应用设置"
        self.tableView.tableFooterView = UIView()
        self.view.backgroundColor = UIColor.rgb(0xe8e8e8)
        
        if isNormal == false{
            configs = titleList
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /**
     退出
    */
    func signOutAction(){
        
        TKRequestHandler.sharedInstance().logout()
        AccountManager.sharedInstance.logout()
        
        _ = self.navigationController?.popToRootViewController(animated: false)
        
        NotificationCenter.default.post( name: NSNotification.Name(rawValue: GlobalConsts.kLogoutNotification), object: nil)
               
    }

    // MARK: - Table view delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configs.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "reuseIdentifier1"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
            
        }
        var textString = configs[(indexPath as NSIndexPath).row]
        if (indexPath as NSIndexPath).row == configs.count - 1 {
            textString += TKAppInfo.appVersion()
        }
        cell?.textLabel?.textAlignment = NSTextAlignment.left
        cell?.textLabel?.textColor = UIColor(red: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1)
        cell?.textLabel?.text = textString
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            if let navContoller = self.navigationController {
                return navContoller.navigationBar.bottom - GlobalConsts.NormalNavbarHeight + CGFloat(10.0)
            }
        }
        return 10
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        var controller : UIViewController? = nil
        var url : String? = nil
        switch (indexPath as NSIndexPath).row{
        case 0:
            controller = ForgetPassWordViewController()
            controller?.title = "修改密码"
//
//        case 1:
//            controller = RemindSetTableViewController()
//            
        case 1:
            if isNormal!{
                controller = AdviceViewController()
                
            }else{
                url = "\(NetworkManager.appHost())/share/meeting_manual"
            }
            
        case 2:
            if isNormal!{
                controller = AboutLJViewController()
            }else{
                controller = AdviceViewController()
            }
            
        case 3:
            url = "\(NetworkManager.appHost())/home/protocal"
            
        case 4:
            controller = AboutLJViewController()
        default:
            return
        }
        
        if controller != nil{
            controller?.hidesBottomBarWhenPushed = true
            navigateTo(controller!)
        }else if url != nil {
            let webController = TKModuleWebViewController()
            webController.backImage = UIInitManager.defaultNavBackImage()
            webController.closeTitle = "关闭"
            webController.loadRequest(withUrl: url!)

            navigateTo(webController)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        let view = AppInfoFooterView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 60))
        view.clickAction = { [weak self] () -> Void in
            self?.signOutAction()
        }
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }

    
}
