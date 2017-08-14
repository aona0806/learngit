//
//  RecommendFriendsTableViewController.swift
//  news
//
//  Created by 奥那 on 16/1/8.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit
//推荐好友
class RecommendFriendsTableViewController: LJBaseTableViewController {

    var dataList = Array<LJRecommendDataRecommendListModel>()
    let deSelectData = NSMutableArray()
    let identifier = "footerCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.rgb(0xe8e8e8)
        
        registerCell()
        getRecommendList()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.defaultLeftItem(withTarget: self, action: #selector(RecommendFriendsTableViewController.backAction))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.tableView.reloadData()
    }
    
    func registerCell(){
        self.tableView.register(RecommendCell.self, forCellReuseIdentifier: RecommendCell.Identify)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
    }
    
    override func backAction(){
        //认证成功需要弹出分享给蓝鲸币提示
        
        let model = AccountManager.sharedInstance.getUserInfo()
        model?.verified = "1"
        AccountManager.sharedInstance.updateAccountInfo(model!)
        UserDefaults.standard.set(true, forKey: GlobalConsts.kRegisterShowAppRecommend)
        
        _ = self.navigationController?.popToRootViewController(animated: false)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: GlobalConsts.kRegisterShowAppRecommend), object: nil)
        
    }
    
    //获取推荐关注列表
    func getRecommendList(){
        TKRequestHandler.sharedInstance().getRecommendListFinish {[weak self] (sessionDataTask, model, error) -> Void in
           
            guard let strongSelf = self else {
                return
            }
            if error != nil{
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: GlobalConsts.kRegisterShowAppRecommend), object: nil)
                _ = strongSelf.navigationController?.popToRootViewController(animated: true)
            } else {
                let model = model as! LJRecommendModel
                
                if model.data?.recommendList?.count != 0{
                    strongSelf.dataList = model.data?.recommendList as! Array<LJRecommendDataRecommendListModel>
                    strongSelf.tableView.reloadData()
                    
                }else{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: GlobalConsts.kRegisterShowAppRecommend), object: nil)
                    _ = strongSelf.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    //下一步
    func nextStep(){

        let indexSet = NSMutableIndexSet()
        for rowNum in self.deSelectData {
            if let row = rowNum as? Int {
                indexSet.add(row)
            }
        }
        
        let allData = NSMutableArray(array: dataList)
        if indexSet.count > 0 && !(indexSet.max()! > allData.count - 1){
            allData.removeObjects(at: indexSet as IndexSet)
        }
        
        
        let uidArray = NSMutableArray()
        for model in self.dataList {
            if model.uid != nil {
                uidArray.add(model.uid ?? "")
            }
        }
        
        let uidString = uidArray.componentsJoined(by: "|")
        TKRequestHandler.sharedInstance().focusManyPerson(withFollowerUid: uidString) { [weak self](sessionDataTask, response, error) -> Void in
            
            //无论上传成功还是失败都要dismiss
            self?.backAction()
        }
        
    }
    
    //MARK: - UITableViewDelegate UItableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataList.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).row == dataList.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            cell?.backgroundColor = UIColor.rgb(0xe8e8e8)
            let width = UIScreen.main.bounds.width
            let sender = UIButton(type: UIButtonType.custom)
            sender.frame = CGRect(x: 10, y: 20, width: width - 20, height: 40)
            sender.layer.cornerRadius = 5
            sender.layer.masksToBounds = true
            sender.setBackgroundImage(UIImage(named: "login_button"), for: UIControlState())
            sender.setTitleColor(UIColor.rgb(0xFFFFFF), for: UIControlState())
            sender.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            sender.setTitle("下一步", for: UIControlState())
            sender.addTarget(self, action: #selector(RecommendFriendsTableViewController.nextStep), for: UIControlEvents.touchUpInside)
            cell?.contentView.addSubview(sender)
            return cell!
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: RecommendCell.Identify) as! RecommendCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.model = dataList[(indexPath as NSIndexPath).row]
            
//            cell.markButton.selected = true

            if self.deSelectData.contains((indexPath as NSIndexPath).row){
                cell.markButton.isSelected = false
            }

            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).row == dataList.count{
            return 80
        }
        return 60
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            if let navContoller = self.navigationController {
                return navContoller.navigationBar.bottom - GlobalConsts.NormalNavbarHeight
            }
        }
        
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).row < dataList.count{
            let cell = tableView.cellForRow(at: indexPath) as! RecommendCell
            
            if cell.markButton.isSelected{
                cell.markButton.isSelected = false
                if !deSelectData.contains((indexPath as NSIndexPath).row){
                    self.deSelectData.add((indexPath as NSIndexPath).row)
                }
                
            }else{
                cell.markButton.isSelected = true
                if deSelectData.contains((indexPath as NSIndexPath).row){
                    self.deSelectData.remove((indexPath as NSIndexPath).row)
                }
            }
        }
        

    }

}
