//
//  RemindSetTableViewController.swift
//  news
//
//  Created by 奥那 on 15/12/8.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

class RemindSetTableViewController: LJBaseTableViewController ,RemindSetTableViewCellDelegate {

    var pushInfo : LJPushInfoDataConfigModel? = nil
    var items : Array<String>!
    var pushInfoList = Array<Int>()
    let identifier = "RemindSetCell"
    var isNormal = AccountManager.sharedInstance.verified() == "0"
    var refreshView : PushSetRefreshView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "推送设置"
        self.view.backgroundColor = UIColor.rgb(0xe8e8e8)
        self.tableView.tableFooterView = UIView()

        registerCell()
        
        getPushInfo()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func registerCell(){
        self.tableView.register(UINib.init(nibName: "RemindSetTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    func setupData(){
        
        items = ["信息推送","评论","点赞","私信","好友消息","会议提醒"]
//        if isNormal {
//            items = ["信息推送","新闻"]
//        }
        
        guard let pinfo =  pushInfo else {
            return
        }
        
//        if isNormal{
//            pushInfoList = [pinfo.newsNotify?.intValue ?? 0]
//            return
//        }
        pushInfoList = [pinfo.commentNotify?.intValue ?? 0,pinfo.zanNotify?.intValue ?? 0, pinfo.pmsgNotify?.intValue ?? 0,pinfo.friendNotify?.intValue ?? 0,pinfo.meetNotify?.intValue ?? 0]
    }
    
    func getPushInfo(){
        
        TKRequestHandler.sharedInstance().getPushInfo {[weak self] (sessionDataTask, model, error) -> Void in
            
            guard let strongSelf = self else {
                return
            }
            if error != nil{
                _ = strongSelf.showToastHidenDefault(error?._domain)
                strongSelf.addRefreshView()
                strongSelf.pushInfo = nil
            }else{
                strongSelf.pushInfo = model?.data?.config
                strongSelf.setupData()
                strongSelf.tableView.reloadData()
                strongSelf.removeRefreshView()
            }
        }
    }
    
    func confirmAction(_ cell: RemindSetTableViewCell){

        guard let pinfo = pushInfo else {
            return
        }
        
        let hud = MBProgressHUD.showAdded( to: self.view ,animated:true)
        TKRequestHandler.sharedInstance().syncPushInfoConfig(pinfo) {[weak self] (sessiomDataTask, response, error) -> Void in
            
            guard self != nil else {
                return
            }
            if error == nil {
                hud.detailsLabel.text = "同步成功"
            }else{
                cell.switchButton.isOn = !cell.switchButton.isOn
                let result = error?._domain
                hud.detailsLabel.text = result
            }
            hud.hide(animated: true, afterDelay: 0.5)

        }
    }
    
    func addRefreshView() {
        if refreshView == nil{
            refreshView = PushSetRefreshView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.height-64) )
            refreshView.refreshAction = { [weak self] () -> Void in
                self?.getPushInfo()
            }

        }
        
        if refreshView.superview == nil{
            self.view.addSubview(refreshView)
        }
    }
    
    func removeRefreshView(){
        if refreshView != nil && refreshView.superview != nil{
            refreshView.removeFromSuperview()
        }
    }
    
    // MARK: - Table view delegate dataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return items != nil ? 1 : 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! RemindSetTableViewCell
        cell.hideSwitchButton = indexPath.row == 0
        cell.titleLabel?.text = items[(indexPath as NSIndexPath).row]
        if indexPath.row == 0 {
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }else{
            if pushInfoList.count > 0{
                cell.switchButton.isOn = pushInfoList[(indexPath as NSIndexPath).row-1] != 0
            }
            cell.switchDelegate = self
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0  {
            let vc = RollPushSetController()
            vc.pushInfo = pushInfo
            self.event(forName: "UserCenter_Roll_PushSet_Click", attr: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - RemindSetTableViewCellDelegate
    func swithAction(_ cell: RemindSetTableViewCell) {
        let index = (self.tableView.indexPath(for: cell) as NSIndexPath?)?.row
        let on = cell.switchButton.isOn ? 1 : 0
        switch index! {
        case 1: //评论
//            if isNormal{
//                self.pushInfo?.newsNotify = on as NSNumber!
//                break
//            }
            self.pushInfo?.commentNotify = on as NSNumber!
        case 2: //点赞
            self.pushInfo?.zanNotify = on as NSNumber!
        case 3: //私信
            self.pushInfo?.pmsgNotify = on as NSNumber!
        case 4: //系统消息
            self.pushInfo?.friendNotify = on as NSNumber!
        case 5: //好友消息
            self.pushInfo?.meetNotify = on as NSNumber!
        default:
            return
        }
        
        confirmAction(cell)

    }
}
