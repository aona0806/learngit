//
//  SelectIndustryTableViewController.swift
//  news
//
//  Created by 奥那 on 15/12/10.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

class SelectIndustryTableViewController: LJBaseTableViewController {

    let identifier = "selectIndustry"
    var industryArr = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "行业选择"
        
        self.navigationItem.rightBarButtonItem = nil
        self.tableView.register(UINib(nibName: "SeleTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConsts.Notification_MyCenterIndustryDidChanged), object: industryArr)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return GlobalConsts.Industry.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! SeleTableViewCell
        let industryName = GlobalConsts.Industry[(indexPath as NSIndexPath).row]
        cell.nameLabel.text = industryName
        cell.switchImage.isHighlighted = industryArr.filter({$0==industryName}).count > 0
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! SeleTableViewCell
        let name = cell.nameLabel.text
        let isSelected = cell.switchImage.isHighlighted
        cell.switchImage.isHighlighted = !isSelected
        if !isSelected{
            industryArr.append(name!)
        }else{
            for i in 0 ..< industryArr.count {
                if industryArr[i] == name {
                    industryArr.remove(at: i)
                    break
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            if let navContoller = self.navigationController {
                return navContoller.navigationBar.bottom - GlobalConsts.NormalNavbarHeight
            }
        }
        return CGFloat.leastNormalMagnitude
    }
    
}
