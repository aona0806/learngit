//
//  NotLoginAppSettingViewController.swift
//  news
//
//  Created by 奥那 on 2017/5/11.
//  Copyright © 2017年 lanjing. All rights reserved.
//

import UIKit

class NotLoginAppSettingViewController: LJBaseTableViewController {

    let titleList = ["提点意见","关于蓝鲸财经 "]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "应用设置"
        self.tableView.tableFooterView = UIView()
        self.view.backgroundColor = UIColor.rgb(0xe8e8e8)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleList.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "reuseIdentifier1"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
            
        }
        var textString = titleList[(indexPath as NSIndexPath).row]
        if (indexPath as NSIndexPath).row == titleList.count - 1 {
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
        switch (indexPath as NSIndexPath).row{
        case 0:
            controller = AdviceViewController()
        case 1:
            controller = AboutLJViewController()

        default:
            return
        }
        
        if controller != nil{
            controller?.hidesBottomBarWhenPushed = true
            navigateTo(controller!)
        }
    }
    

}
