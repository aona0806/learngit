//
//  RollPushSetController.swift
//  news
//
//  Created by 奥那 on 2017/1/10.
//  Copyright © 2017年 lanjing. All rights reserved.
//

import UIKit

class RollPushSetController: LJBaseTableViewController , RemindSetTableViewCellDelegate {
    
    var pushInfo : LJPushInfoDataConfigModel!
    var items = Array<String>()
    var pushInfoList = Array<Int>()
    let identifier = "RemindSetCell"
    var refreshView : PushSetRefreshView!
    var isNormal = AccountManager.sharedInstance.verified() == "0"

    override func viewDidLoad() {
        super.viewDidLoad()

        if isNormal{
            title = "推送设置"
        }else{
            title = "信息推送"
        }
        self.tableView.register(UINib.init(nibName: "RemindSetTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
        self.tableView.tableFooterView = UIView()

        if pushInfo == nil{
            getPushInfo()
        }else{
            setupData()
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
    
    func setupData(){
        
        guard let pushModel =  pushInfo else {
            return
        }
        
        if pushModel.telegraph != nil && (pushModel.telegraph?.count)! > 0{
            for telegraphInfo in pushModel.telegraph!{
                if (telegraphInfo as! LJPushInfoDataConfigTelegraphModel).status != nil{
                    pushInfoList.append(((telegraphInfo as AnyObject).status?.intValue)!)
                }else{
                    pushInfoList.append(0)
                }
                items.append((telegraphInfo as AnyObject).name)
            }
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
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return items.count > 0 ? 1 : 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! RemindSetTableViewCell

        cell.titleLabel?.text = items[(indexPath as NSIndexPath).row]

        if pushInfoList.count > 0{
            cell.switchButton.isOn = pushInfoList[(indexPath as NSIndexPath).row] != 0
        }
        cell.switchDelegate = self
        
        
        return cell
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
    
    // MARK: - RemindSetTableViewCellDelegate
    func swithAction(_ cell: RemindSetTableViewCell) {
        let index = (self.tableView.indexPath(for: cell) as NSIndexPath?)?.row
        let on = cell.switchButton.isOn ? 1 : 0
        
        let teltModel = pushInfo?.telegraph?[index!] as! LJPushInfoDataConfigTelegraphModel
        self.event(forName: "UserCenter_Roll_PushSet_Click", attr: ["typeId":teltModel.id ?? "","isOpen":on])

        
        teltModel.status? = String.init(on)

        confirmAction(cell)
        
    }


}
