//
//  MyDollarsTableViewController.swift
//  news
//
//  Created by 奥那 on 15/12/9.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

class MyDollarsTableViewController: LJBaseTableViewController {

    var dataList = Array<LJDollarsDataListModel>()
    var dollars : String = ""
    
    var tableHeader : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "我的蓝鲸币"
        self.tableView.tableFooterView = UIView()
        self.navigationItem.rightBarButtonItem = nil
        
        addHeaderAndFooterRefresh()
        
        tableHeader = UIView()
        tableHeader?.height = 0
        
        self.tableView.tableHeaderView = tableHeader
        
        getData(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        if let navContoller = self.navigationController {
            
            tableHeader?.height = navContoller.navigationBar.bottom - GlobalConsts.NormalNavbarHeight
            
            self.tableView.tableHeaderView = tableHeader
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addHeaderAndFooterRefresh(){
        weak var weakSelf : MyDollarsTableViewController? = self
        addHeaderRefreshView(self.tableView) { () -> Void in
            weakSelf!.getData(true)
        }
        
        addFooterRefreshView(self.tableView) { () -> Void in
            weakSelf!.getData(false)
        }
    }
    
    func getData(_ isHead : Bool){
        
        TKRequestHandler.sharedInstance().getDollarsIsUpRefresh(isHead) { [weak self](sessionDataTask, model, error) -> Void in

            guard let strongSelf = self else {
                return
            }
            
            if error != nil{
                _ = strongSelf.showToastHidenDefault(error?._domain)
                
            } else if model?.data == nil || model?.data?.list?.count == 0{
                
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    strongSelf.stopRefresh(strongSelf.tableView)
                    if isHead{
                        strongSelf.tableView.reloadData()
                    }
                    
                })
                
                
            } else{
                strongSelf.dataList = model?.data?.list as! Array<LJDollarsDataListModel>
               
                DispatchQueue.main.async(execute: { () -> Void in
                    strongSelf.tableView.reloadData()
                    strongSelf.stopRefresh(strongSelf.tableView)
                })
            }

        }
        
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0{
            return 0
        }
        return dataList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = MyDollarsCell.Identify
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MyDollarsCell
        if cell == nil {
            cell = MyDollarsCell(style: .default, reuseIdentifier: identifier)
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
        }
        
        let dollarModel = dataList[(indexPath as NSIndexPath).row]
        cell?.model = dollarModel

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 80
        }
        return 10
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0{
            let width = self.tableView.frame.width
            let headerView = MyDollarsHeader(frame: CGRect(x: 0, y: 0, width: width, height: 80))
            headerView.dollars = self.dollars
            return headerView
        }
        return nil
    }

}
