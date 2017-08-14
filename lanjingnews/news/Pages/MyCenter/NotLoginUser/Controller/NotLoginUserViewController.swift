//
//  NotLoginUserViewController.swift
//  news
//
//  Created by 奥那 on 2017/5/11.
//  Copyright © 2017年 lanjing. All rights reserved.
//

import UIKit

class NotLoginUserViewController: LJBaseTableViewController {

    let headerCellIdentifier = "normalInfo"
    let cellIdentifier = "cell"
    let titleList = [["我的资料","我的收藏"], ["应用设置","推送设置"]]
    let iconList = [["myInfo_info","myInfo_collection","myInfo_authentication", "myInfo_activity"],["myInfo_appSetting","myInfo_pushset"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.rgb(0xe8e8e8)
        self.tableView.tableFooterView = UIView()
        self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0)
        
        registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     注册cell
     */
    func registerCell(){
        
        self.tableView.register(UINib(nibName: "NormalUserInfoHeaderCell", bundle: nil), forCellReuseIdentifier: headerCellIdentifier)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    /**
     返回
     */
    override func backAction(){
        _ = self.navigationController?.popViewController(animated: true)
        _ = self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 1
        if section != 0 {
            count = titleList[section - 1].count
        }
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath as NSIndexPath).section == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: headerCellIdentifier) as! NormalUserInfoHeaderCell
            cell.backClick = backAction
            cell.imageClick = clickAvatar
//            cell.model = userInfo
            cell.avatarImage.image = UIImage.init(named: "myInfo_not_login")
            cell.nickName.text = "点击登录"
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)! as UITableViewCell
            cell.textLabel?.text = titleList[(indexPath as NSIndexPath).section - 1][(indexPath as NSIndexPath).row]
            cell.imageView?.image = UIImage(named: iconList[(indexPath as NSIndexPath).section - 1][(indexPath as NSIndexPath).row])
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            
            return cell
        }
        
    }
    
    func clickAvatar(){
        let controller = LoginRegistViewController()
        controller.title = "蓝鲸财经"
        controller.popToRootView = true
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 0{
            return 190
        }
        return 45
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var controller:UIViewController? = nil
        if (indexPath as NSIndexPath).section == 1{
            
            let vc = LoginRegistViewController()
            vc.title = "蓝鲸财经"
            vc.popToRootView = true
            
            controller = vc

        }else if (indexPath as NSIndexPath).section == 2{
            
            switch (indexPath as NSIndexPath).row{
            case 0://应用设置
                let vc = NotLoginAppSettingViewController()
                controller = vc
                break
            case 1://推送设置
                self.event(forName: "UserCenter_PushSet_Click", attr: nil)
                controller = RollPushSetController()
                break
            default:
                return
            }
        }
        
        if controller != nil{
            controller!.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller!, animated: true)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 10;
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(0xe8e8e8)
        return view
    }
    
    
    //MARK: - scroll view delegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var offset = scrollView.contentOffset
        if offset.y < 0 {
            offset.y = 0
            scrollView.contentOffset = offset
        }
    }
    


}
