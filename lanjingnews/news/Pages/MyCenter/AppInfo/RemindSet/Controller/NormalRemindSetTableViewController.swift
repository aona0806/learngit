//
//  NormalRemindSetTableViewController.swift
//  news
//
//  Created by 奥那 on 16/1/14.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class NormalRemindSetTableViewController:  LJBaseTableViewController ,RemindSetTableViewCellDelegate {
    
    var pushInfo = LJPushInfoDataConfigModel()
    var pushInfoList = Array<Int>()
    let identifier = "RemindSetCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "提醒和消息"
        self.view.backgroundColor = UIColor.rgb(0xe8e8e8)
        
        customNavigationItem()
        self.tableView.registerNib(UINib.init(nibName: "RemindSetTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)        
        getPushInfo()
        
        self.tableView.tableFooterView = UIView()

    }
    
    func customNavigationItem(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: "confirmAction:")
    }
    
    func setupData(){
        
        pushInfoList = [pushInfo.news_notify.integerValue]
        
    }
    
    func getPushInfo(){
        
        TKRequestHandler.sharedInstance().getPushInfoWithFinish { (sessionDataTask, model, error) -> Void in
            
            if error != nil{
                self.showToast(error.domain, hideDelay: 1)
            }else{
                self.pushInfo = model.data.config
                self.setupData()
                self.tableView.reloadData()
            }
        }
    }
    
    func confirmAction(sender:UIButton){
        
        TKRequestHandler.sharedInstance().getSyncPushInfoConfig(self.pushInfo, isNormal: true) { (sessiomDataTask, response, error) -> Void in
            
            if error == nil {
                self.showPopHud("同步成功", hideDelay: 1)
                self.navigationController?.popViewControllerAnimated(true)

            }else{
                let result = error.domain
                self.showToast(result, hideDelay: 1)
            }
            
            
        }
    }
    
    // MARK: - Table view delegate dataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as! RemindSetTableViewCell
        
        cell.titleLabel?.text = "新闻"
        if pushInfoList.count > 0{
            cell.switchButton.on = pushInfoList[indexPath.row] != 0
        }
        
        cell.switchDelegate = self
        
        return cell
    }
    
    // MARK: - RemindSetTableViewCellDelegate
    func swithAction(cell: RemindSetTableViewCell) {
        let index = self.tableView.indexPathForCell(cell)?.row
        let on = cell.switchButton.on ? 1 : 0
        switch index! {
        case 0: //新闻
            self.pushInfo.news_notify = on
            
        default:
            return
        }
        
    }
}
