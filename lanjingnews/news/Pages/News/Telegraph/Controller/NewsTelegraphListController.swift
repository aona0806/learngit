//
//  NewsTelegraphListController.swift
//  news
//
//  Created by 奥那 on 2016/12/27.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class NewsTelegraphListController: LJBaseTableViewController , ShareViewProtocol{
    
    var lastTime : String!
    var dataArray = NSMutableArray()
    var listArray = NSMutableArray()
    var typeId : String!
    var tableHeadView: MJRefreshNormalHeader!
    var tableFootView: MJRefreshAutoNormalFooter!
    var choosedArray = NSMutableArray()
    var selectedIndexPath : IndexPath? = nil
    var loadTask : URLSessionDataTask? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = .none
        self.tableView.register(NewsTelegraphListCell.self, forCellReuseIdentifier: "teleCell")
        
        
        self.tableView.contentInset = UIEdgeInsets(top:0,left:0,bottom:-40,right:0)
        
        weak var weakSelf = self
        tableHeadView = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            weakSelf!.loadData(.refresh)
        })
        
        tableFootView = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            weakSelf!.loadData(.loadMore)
        })
        tableFootView.appearencePercentTriggerAutoRefresh = -2.5
        
        self.tableView.header = tableHeadView
        self.tableView.footer = tableFootView
        // Do any additional setup after loading the view.
        
        tryLoadCache(typeId)
        loadData(.refresh)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name(rawValue: GlobalConsts.kRollCommentSuccess), object: nil) 
    
    }

    func updateRefreshTip(){
        let refreshTip = ConfigManager.sharedInstance().nextRollRefreshTip(typeId: typeId)
        
        if refreshTip.characters.count > 0 {
            tableHeadView.setTitle(refreshTip, for: MJRefreshStateIdle)
            tableHeadView.setTitle(refreshTip, for: MJRefreshStatePulling)
            tableHeadView.setTitle(refreshTip, for: MJRefreshStateRefreshing)
            tableHeadView.setTitle(refreshTip, for: MJRefreshStateWillRefresh)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveCache(typeId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let version = UIDevice.current.systemVersion
        if version.hasPrefix("8") {
            self.tableView.reloadData()
        }
        checkGuideView()
    }
    
    func checkGuideView(){
        let isLoad:Bool = UserDefaults.standard.bool(forKey: GlobalConsts.KUserDefaultsTelegraphListGuideView)
        if !isLoad {
            UserDefaults.standard.set(true, forKey: GlobalConsts.KUserDefaultsTelegraphListGuideView)
            UserDefaults.standard.synchronize()
            let view = TeleGraphListGuideView.init(frame: UIScreen.main.bounds)
            let window = UIApplication.shared.keyWindow
            window?.addSubview(view)
        }
    }
    
    func refreshData(){
        loadData(.refresh)
    }

    func loadData(_ refreshType: TKDataFreshType){
        
        if lastTime == nil {
            lastTime = "0"
        }
        
       let task =  TKRequestHandler.sharedInstance().getNewsRollList(with: typeId, lastTime: lastTime, refreshType: refreshType, complated: { [weak self](task, model, error) -> Void in
            
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.updateRefreshTip()
            
            if error == nil{
                
                if (model?.data?.list?.count)! > 0{
                    var newList = [LJNewsRollListDataListModel]()
                    for item in (model?.data?.list)!{
                        let itemModel = item as! LJNewsRollListDataListModel
                        if itemModel.templateType == "single_roll"{
                            newList.append(item as! LJNewsRollListDataListModel)
                            if strongSelf.choosedArray.contains(itemModel.nid ?? ""){
                                itemModel.isRead = true
                            }
                        }
                    }
                    if refreshType == .refresh{
                        strongSelf.selectedIndexPath = nil
                        strongSelf.listArray = NSMutableArray.init(array: newList)
                    }else if refreshType == .loadMore{
                        strongSelf.listArray.addObjects(from: newList)
                        
                        if strongSelf.listArray.count > 100 {
                            strongSelf.selectedIndexPath = nil
                            strongSelf.listArray.removeObjects(in : NSMakeRange(0, 60))
                        }
                        
                    }
                    strongSelf.lastTime = (strongSelf.listArray.lastObject as! LJNewsRollListDataListModel).lastTime
                    strongSelf.dataArray = strongSelf.handleData(strongSelf.listArray)
                    
                    strongSelf.tableView.reloadData()
                }
                
            }else{
                let toAddView: UIView! = strongSelf.tableView.superview
                let hud  = MBProgressHUD.showAdded(to: toAddView, animated:true)
                hud.mode = .text
                let msg = error?._domain ?? GlobalConsts.NetRequestNoResult
                hud.detailsLabel.text = msg
                hud.detailsLabel.font = GlobalConsts.ToastFont
                hud.hide(animated: true, afterDelay: LJUtil.toastInterval(msg))
            }
        
        strongSelf.stopRefresh(strongSelf.tableView)
                
            
        })
        
        self.loadTask = task
    }
    
    func handleData(_ data: NSArray) -> NSMutableArray{
        let mutArr = NSMutableArray()
        let rowArr = NSMutableArray()

        for item in data {
            if rowArr.count > 0 && formatTimeStr(item as! LJNewsRollListDataListModel) != formatTimeStr(rowArr.lastObject as! LJNewsRollListDataListModel){

                let newArr = rowArr.copy()
                mutArr.add(newArr)
                rowArr.removeAllObjects()
            }

            rowArr.add(item)

            if (data.lastObject as! LJNewsRollListDataListModel).nid == (item as AnyObject).nid{
                let newArr = rowArr.copy()
                mutArr.add(newArr)
                rowArr.removeAllObjects()
            }

            
        }
        return mutArr
    }
    
    func formatTimeStr(_ model : LJNewsRollListDataListModel) -> String {

        let timeStr = NSString.init(string: model.ctime ?? "")
        let time = TKCommonTools.datestring(withFormat: "yyyy-MM-dd", timeStamp: timeStr.doubleValue)
        return time!
    }
    
    /**
     分享
     */
    func showShareView(_ model : LJNewsRollListDataListModel) {
        let shareView = ShareView(delegate: self, shareObj: model, hideLanjing: true)
        
        let window = UIApplication.shared.keyWindow
        shareView.show(window, animated: true)
        MobClick.event("Roll_List_Share", attributes: ["typeId":typeId])
    }
    
    //详情
    func toTelegraphDetailView(_ cell : NewsTelegraphListCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        let data = dataArray.object(at: (indexPath?.section)!) as! [LJNewsRollListDataListModel]
        let model = (data as NSArray).object(at: (indexPath?.row)!) as! LJNewsRollListDataListModel
        if model.jump != nil{
            MobClick.event("RollList_To_Detail", attributes: ["typeId":typeId])
            PushManager.sharedInstance.handleOpenUrl(model.jump!)
        }
        
        if !self.choosedArray.contains(model.nid ?? ""){
            choosedArray.add(model.nid ?? "")
        }
        
        model.isRead = true
        self.tableView.reloadRows(at: [indexPath!],with:.automatic)
    }
    
    func shareAction(_ type: ShareType, shareView: ShareView, shareObj: AnyObject?) {
        
        if shareObj != nil {
            let shareModel = shareObj as! LJNewsRollListDataListModel
            ShareAnalyseManager.sharedInstance().shareTelegraphList(type, info: shareModel, presentController: self, completion: { [weak self](success, error) -> () in
                
                if success {
                    _ = self?.showToastHidenDefault("分享成功")
                } else {
                    _ = self?.showToastHidenDefault("分享失败")
                }
            })
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = dataArray.object(at: section) as! [LJNewsRollListDataListModel]
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = dataArray.object(at: indexPath.section) as! [LJNewsRollListDataListModel]
        let model = (data as NSArray).object(at: indexPath.row) as! LJNewsRollListDataListModel
        
        let height: CGFloat! = NewsTelegraphListCell.heightForModel(model)
        return height
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teleCell") as! NewsTelegraphListCell
        let data = dataArray.object(at: indexPath.section) as! [LJNewsRollListDataListModel]
        let model = (data as NSArray).object(at: indexPath.row) as! LJNewsRollListDataListModel
        cell.typeId = String.init(describing: typeId)
        cell.updateWithModel(model , hideLine:indexPath.row == data.count - 1)
        cell.shareButtonClick = showShareView
        cell.toTelegraphDetail = toTelegraphDetailView
        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = dataArray.object(at: indexPath.section) as! [LJNewsRollListDataListModel]
        let model = (data as NSArray).object(at: indexPath.row) as! LJNewsRollListDataListModel


        let cell = self.tableView.cellForRow(at: indexPath)
        if model.isShowAll && (cell?.height)! > UIScreen.main.bounds.height - 64 {
            self.tableView.scrollToRow(at: indexPath , at:.top,animated:false)

        }
        model.isShowAll = !model.isShowAll

        if model.isShowAll {
            choosedArray.add(model.nid ?? "")
            MobClick.event("Roll_List_ShowAll", attributes: ["typeId":typeId,"hasImg":model.hasImg ?? ""])
        }else{
            model.isRead = true
        }
        
        
        var reloadRows = [IndexPath]()
        if  let spath =  selectedIndexPath  {
            
            let datas = dataArray.object(at: spath.section) as! [LJNewsRollListDataListModel]
            
            if spath.row < datas.count {
                let smodel = datas[spath.row]
                if !smodel.isRead {
                    smodel.isRead = true
                }
            }
            
            reloadRows.append(spath)
            
        }
        
        if selectedIndexPath != indexPath {
            reloadRows.append(indexPath)
        }
        
        selectedIndexPath = indexPath
        
        if #available(iOS 9.0, *) {
            self.tableView.reloadRows(at: reloadRows, with: .automatic)

        }else{
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = NewsTelegraphSectionHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 25))
        let data = dataArray.object(at: section) as! [LJNewsRollListDataListModel]
        let model = (data as NSArray).firstObject as! LJNewsRollListDataListModel
        view.time = model.ctime ?? ""
        
        return view
        
    }

    private func tryLoadCache(_ typeid : String){
        
        let cache = TMCache.shared()
        
        var typeKey = self.catCacheKey(typeid)
        
        cache?.object(forKey: typeKey , block: { (cache, key, models) -> Void in
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                if  let dataModels = models as? [Any] {
                    
                    self.dataArray.addObjects(from: dataModels)
                    if let tView = self.tableView {
                        tView.reloadData()
                    }
                }
            })
        })
        
        typeKey = self.catReadedCacheKey(typeid)
        
        cache?.object(forKey: typeKey , block: { (cache, key, models) -> Void in
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                if  let chooseModels = models as? [Any] {
                    
                    self.choosedArray.addObjects(from: chooseModels)

                }
            })
        })
        
    }


    private func catCacheKey(_ typeid : String) -> String {
        
        return "news_roll_\(typeId)"
    }
    
    private func catReadedCacheKey(_ typeid : String) -> String {
        
        return "news_readed_roll_\(typeId)"
    }
    
    private func saveCache(_ typeid : String){
        
        if self.dataArray.count > 0 {
            
            let cache = TMCache.shared()
            
            var typeKey = self.catCacheKey(typeid)
            
            var models = dataArray
            
            cache?.setObject(models as NSCoding!, forKey: typeKey, block: { (cache, key, object) -> Void in
                
            })
            
            if self.choosedArray.count > 0 {
                
                typeKey = self.catReadedCacheKey(typeid)
                
                models = choosedArray
                
                cache?.setObject(models as NSCoding!, forKey: typeKey, block: { (cache, key, object) -> Void in
                    
                })
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
