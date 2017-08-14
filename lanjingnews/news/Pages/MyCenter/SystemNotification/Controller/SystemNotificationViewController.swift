//
//  SystemNotificationViewController.swift
//  news
//
//  Created by chunhui on 16/1/11.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit


class SystemNotificationViewController: LJBaseTableViewController {
    
    var messageList = Array<LJSystemNofiticationDataMsgListModel>()
    
    var controllerType : LJSystemNotificationType? = .normal {
        didSet{
            self.updateTitle()
        }
    }
    
    func updateTitle(){
        
        var title = ""
        switch controllerType! {
        case .normal:
            title = "系统通知"
        case .comment:
            title = "评论"
        case .praise:
            title = "赞"
        }
        self.title = title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName:"SystemNotificationTableViewCell" ,bundle:nil)
        self.tableView.register(nib, forCellReuseIdentifier: SystemNotificationTableViewCell.Identifier)
        
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.backgroundColor = UIColor.rgba(242, green: 242, blue: 242, alpha: 1.0)
        
        handleHeaderRefresh()
        addHeaderFooterRefresh()
        NotificationCenter.default.addObserver(self, selector: #selector(SystemNotificationViewController.handleHeaderRefresh), name: NSNotification.Name(rawValue: GlobalConsts.Notification_NewSystermNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        self.tableView.reloadData()
        
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addHeaderFooterRefresh(){
        // 设置TableView的刷新
        weak var weakSelf : SystemNotificationViewController? = self
        
        addHeaderRefreshView(self.tableView) { () -> Void in
            weakSelf?.handleHeaderRefresh()
        }
        
        addFooterRefreshView(self.tableView) { () -> Void in
            weakSelf?.handleFooterRefresh()
        }
        
    }
    

    func handleHeaderRefresh()
    {
        self.getMessages(true)
    }
    
    func handleFooterRefresh()
    {
        self.getMessages(false)
    }
    
    
    func getMessages(_ isHead:Bool){
        
        var cid : String? = nil
        var refreshType = TKDataFreshType.refresh
        
        if isHead {
            
            cid = self.messageList.first?.sysMsgId?.description
            
        }else{
            
            cid = self.messageList.last?.sysMsgId?.description
            refreshType = .loadMore
        }

        
        TKRequestHandler.sharedInstance().getSystemMessage(withRefreshType: refreshType, actionType: controllerType!, cid: cid) {[weak self] (task, model, error) -> Void in
            
            
            guard let strongSelf = self else {
                return
            }
            
            if error == nil && model != nil && (model?.data?.msgList?.count)! > 0 {
                
                if isHead {
                    
                    var msgList = [LJSystemNofiticationDataMsgListModel]()
                    msgList.append(contentsOf: model?.data?.msgList as! [LJSystemNofiticationDataMsgListModel])
                    
                    strongSelf.messageList = msgList
                    
                }else{
                    
                    strongSelf.messageList.append(contentsOf: model?.data?.msgList as! [LJSystemNofiticationDataMsgListModel])
                    
                }
                
                strongSelf.tableView.reloadData()
                
            }else if model == nil || model?.data?.msgList?.count == 0 {
                
                switch strongSelf.controllerType! {
                case .normal:
                    _ = strongSelf.showHud("暂时没有通知", hideDelay: 1)
                case .comment:
                    _ = strongSelf.showToastHidenDefault("还没有收到评论")
                case .praise:
                    _ = strongSelf.showToastHidenDefault("还没有收到赞")
                }
                
            }
            
            strongSelf.stopRefresh(strongSelf.tableView)
        }
        
    }
    
    func gotoOtherPage(_ model: LJSystemNofiticationDataMsgListModel){
        
        if (model.jump?.length())! > 0 {
            
            PushManager.sharedInstance.handleOpenUrl(model.jump!)
        }
    }
    
    
    func otherHeadTapAction(_ model : LJSystemNofiticationDataMsgListModel?){
        
        if let uid = model?.fromUser?.uid {
            let userInfoController = LJUserDeltailViewController.init()
            userInfoController.uid = uid
            navigateTo(userInfoController)
        }
        
    }
    
    
    // MARK: -Table view delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.messageList[(indexPath as NSIndexPath).row]
        return SystemNotificationTableViewCell.CellHeightForModel(model)
    }
    
    // MARK: -Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        let model = self.messageList[(indexPath as NSIndexPath).row]
        self.gotoOtherPage(model)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            if let navContoller = self.navigationController {
                return navContoller.navigationBar.bottom - GlobalConsts.NormalNavbarHeight
            }
        }
        
        return CGFloat.leastNormalMagnitude
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return messageList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SystemNotificationTableViewCell.Identifier, for: indexPath) as! SystemNotificationTableViewCell
        
        // Configure the cell...
        let model = self.messageList[(indexPath as NSIndexPath).row]
        cell.model = model
        cell.headClick = otherHeadTapAction
        return cell
    }

    

}
