//
//  MyFavoriteViewController.swift
//  news
//
//  Created by wxc on 16/1/7.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

enum FavoriteViewContollerType {
    case myFavorite
    case myActivity
}

class MyFavoriteViewController: LJBaseViewController, UITableViewDelegate, UITableViewDataSource{
    
    //view
    private var favoriteTableView:UITableView!
    private var noResultView:UILabel!
    private var noResultLabel:UILabel!
    
    internal var type: FavoriteViewContollerType = FavoriteViewContollerType.myFavorite
    
    //data
    
    var favoriteArray:NSMutableArray!
    var isLoadFirstPage:Bool = true
    var lastCtime:String? = nil
    private var heightArray:[CGFloat] = []
    
    //MARK: -  lifecycle
    
    init(type: FavoriteViewContollerType) {
        super.init()
        
        self.type = type

    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: GlobalConsts.kNewsCollectNotification), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: GlobalConsts.KCancelConferenceNotication), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: GlobalConsts.KJoinConferenceNotication), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        favoriteTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.type == FavoriteViewContollerType.myFavorite ? "我的收藏" : "我的活动"
        self.setupSubviews()
        self.startHeadRefresh(favoriteTableView)
        self.favoriteArray = NSMutableArray()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MyFavoriteViewController.collectNotificationHundel(_:)), name: NSNotification.Name(rawValue: GlobalConsts.kNewsCollectNotification), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(MyFavoriteViewController.updateConferenceNotification(_:)), name: NSNotification.Name(rawValue: GlobalConsts.KCancelConferenceNotication), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MyFavoriteViewController.updateConferenceNotification(_:)), name: NSNotification.Name(rawValue: GlobalConsts.KJoinConferenceNotication), object: nil)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        favoriteTableView.reloadData()
    }
    
    override func headRefreshAction() {
        isLoadFirstPage = true
        lastCtime = nil
        heightArray.removeAll()
        loadDataList(type)
    }
    
    override func footRefreshAction() {
        loadDataList(type)
    }
    
    override func refreshAction() {
        
        loadDataList(type)
    }
    
    //MARK: - private
    
    private func setupSubviews(){
        favoriteTableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: self.view.size.width, height: self.view.size.height - 64))
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        favoriteTableView.separatorStyle = .none
        self.view.addSubview(favoriteTableView)
        
        self.addHeaderRefreshView(favoriteTableView) {[weak self] () -> Void in
            self?.headRefreshAction()
        }
        
        self.addFooterRefreshView(favoriteTableView) {[weak self] () -> Void in
            self?.footRefreshAction()
        }
        
        noResultView = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height * 0.6))
        noResultView.text = "暂无收藏"
        noResultView.textAlignment = .center
        noResultView.textColor = UIColor.themeGrayColor()
        
        noResultLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 0))
        noResultLabel.textAlignment = .center
        noResultLabel.text = "没有更多内容"
        noResultLabel.textColor = UIColor.themeGrayColor()
        noResultLabel.alpha = 0
    }
    
    private func showNoResultLabel() {
        if noResultLabel.alpha == 0{
            noResultLabel.alpha = 1
            noResultLabel.height = 50
            favoriteTableView.tableFooterView = noResultLabel
        }
    }
    
    private func hideNoResultLabel() {
        if noResultLabel.alpha == 1 {
            noResultLabel.height = 0
            noResultLabel.alpha = 0
            favoriteTableView.tableFooterView = noResultLabel
        }
    }
    
    //MARK: - download
    
    func loadDataList(_ type: FavoriteViewContollerType) -> Void {
        
        switch type {
        case .myFavorite:
            loadMyFavoriteLiseData()
        case .myActivity:
            loadActivityFavoriteLiseData()
        }
    }
 
    private func loadMyFavoriteLiseData(){
        self.hideNoResultView(noResultView)
        if favoriteArray.count > 0 {
            let lastModel = favoriteArray[favoriteArray.count - 1] as! LJFavoriteDataModel
            lastCtime = lastModel.ctime?.stringValue
        }
        
        TKRequestHandler.sharedInstance().getmyFavorite(withRefreshType: isLoadFirstPage, lastTime: lastCtime) { [weak self](sessionDataTask, model, error) -> Void in
            
            guard let strongSelf = self else {
                return
            }
            
            if error == nil{
                if model.dErrno?.intValue == 0{
                    if strongSelf.isLoadFirstPage == true{
                        strongSelf.favoriteArray.removeAllObjects()
                    }
                    strongSelf.favoriteArray.addObjects(from: model.data!)
                    strongSelf.favoriteTableView.reloadData()
                    
                    if strongSelf.favoriteArray.count > 0 {
                        strongSelf.isLoadFirstPage = false
                    }
                    
                    if strongSelf.favoriteArray.count == 0 {
                        strongSelf.showNoResultView(strongSelf.noResultView)
                    }else if strongSelf.favoriteArray.count != 0 &&  model.data?.count == 0{
                        strongSelf.showNoResultLabel()
                    }else{
                        strongSelf.hideNoResultLabel()
                    }
                }else{
                    let hud  = MBProgressHUD.showAdded(to: strongSelf.view, animated:true)
                    hud.mode = .text
                    hud.label.text = model.msg
                    hud.hide(animated: true, afterDelay: 0.5)
                    
                    if strongSelf.favoriteArray.count < 1 {
                        strongSelf.showNoResultView(nil)
                    }
                }
            }else{
                let hud  = MBProgressHUD.showAdded(to: strongSelf.view, animated:true)
                hud.mode = .text
                hud.label.text = (error?._domain)!
                hud.hide(animated: true, afterDelay: 0.5)
                
                if strongSelf.favoriteArray.count < 1 {
                    if error!._code == -1009{
                    strongSelf.showNetErrorView(nil)
                    }else {
                    strongSelf.showNoResultView(nil)
                    }
                }
            }
            strongSelf.stopRefresh(strongSelf.favoriteTableView)
        }
    }
    
    
    /**
      5.1.1 添加活动收藏接口
     */
    private func loadActivityFavoriteLiseData(){
        self.hideNoResultView(noResultView)
        if favoriteArray.count > 0 {
            let lastModel = favoriteArray[favoriteArray.count - 1] as! LJFavoriteDataModel
            lastCtime = lastModel.ctime?.stringValue
        }
        
        TKRequestHandler.sharedInstance().getActivityFavorite(withRefreshType: isLoadFirstPage, lastTime: lastCtime) { [weak self](sessionDataTask, model, error) -> Void in
            
            guard let strongSelf = self else {
                return
            }
            
            if error == nil{
                if model.dErrno?.intValue == 0{
                    if strongSelf.isLoadFirstPage == true{
                        strongSelf.favoriteArray.removeAllObjects()
                    }
                    strongSelf.favoriteArray.addObjects(from: model.data!)
                    strongSelf.favoriteTableView.reloadData()
                    
                    if strongSelf.favoriteArray.count > 0 {
                        strongSelf.isLoadFirstPage = false
                    }
                    
                    if strongSelf.favoriteArray.count == 0 {
                        strongSelf.showNoResultView(strongSelf.noResultView)
                    }else if strongSelf.favoriteArray.count != 0 &&  model.data?.count == 0{
                        strongSelf.showNoResultLabel()
                    }else{
                        strongSelf.hideNoResultLabel()
                    }
                }else{
                    let hud  = MBProgressHUD.showAdded(to: strongSelf.view, animated:true)
                    hud.mode = .text
                    hud.label.text = model.msg
                    hud.hide(animated: true, afterDelay: 0.5)
                    
                    if strongSelf.favoriteArray.count < 1 {
                        strongSelf.showNoResultView(nil)
                    }
                }
            }else{
                let hud  = MBProgressHUD.showAdded(to: strongSelf.view, animated:true)
                hud.mode = .text
                hud.label.text = (error?._domain)!
                hud.hide(animated: true, afterDelay: 0.5)
                
                if strongSelf.favoriteArray.count < 1 {
                    if error!._code == -1009{
                        strongSelf.showNetErrorView(nil)
                    }else {
                        strongSelf.showNoResultView(nil)
                    }
                }
            }
            strongSelf.stopRefresh(strongSelf.favoriteTableView)
        }
    }
    
    //MARK: tableview相关
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat! = 0
        if heightArray.count > (indexPath as NSIndexPath).row {
            height = heightArray[(indexPath as NSIndexPath).row]
        }else{
            
            let favModel:LJFavoriteDataModel = self.favoriteArray[(indexPath as NSIndexPath).row] as! LJFavoriteDataModel
            
            if favModel.info?.imgs != nil && (favModel.info?.imgs!.count)! > 0 {
                 height = FavoriteOneImageCell.heightForInfo(favModel)
            }else {
                height = FavoriteNoneImageCell.heightForInfo(favModel)
            }
            
            heightArray.append(height)
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableCell: UITableViewCell?
        let favModel:LJFavoriteDataModel = self.favoriteArray[(indexPath as NSIndexPath).row] as! LJFavoriteDataModel
        let model:LJNewsListDataListModel = favModel.info!
        
        if model.imgs != nil && model.imgs!.count > 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteOneImageCell") as? FavoriteOneImageCell
            if cell == nil {
                cell = FavoriteOneImageCell(style: .default, reuseIdentifier: "FavoriteOneImageCell")
            }
            
            cell?.setValueWithModel(favModel)
            tableCell = cell
        }else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteNoneImageCell") as? FavoriteNoneImageCell
            if cell == nil {
                cell = FavoriteNoneImageCell(style: .default, reuseIdentifier: "FavoriteNoneImageCell")
            }
            
            cell?.setValueWithModel(favModel)
            tableCell = cell
        }
        
        return tableCell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favoriteArray != nil {
            return favoriteArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favModel:LJFavoriteDataModel = self.favoriteArray[(indexPath as NSIndexPath).row] as! LJFavoriteDataModel
        let model:LJNewsListDataListModel = favModel.info!
        
        let viewController = PushManager.sharedInstance.getNewsDetailViewController(model.jump, model: model)
        if viewController != nil {
            self.navigationController?.pushViewController(viewController!, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            if let navContoller = self.navigationController {
                return navContoller.navigationBar.bottom - GlobalConsts.NormalNavbarHeight
            }
        }
        
        return CGFloat.leastNormalMagnitude
    }
    
    /**
     更改会议预约状态值是更新数据
     
     - parameter notification: <#notification description#>
     */
    func updateConferenceNotification(_ notification: Notification) {
//        NSString *meetIdString = notification.object;

        let meetIdString: String = notification.object as? String ?? ""
        heightArray.removeAll()
        for tmpModel in favoriteArray {
            if meetIdString == (tmpModel as AnyObject).info??.nid {
                favoriteArray.remove(tmpModel)
                break
            }

        }
        
        if favoriteArray.count == 0 {
            self.showNoResultView(noResultView)
            self.hideNoResultLabel()
        }

    }

    func collectNotificationHundel(_ sender:Notification){
        let nid:NSString = (sender as NSNotification).userInfo![GlobalConsts.kNewsCollectId] as! NSString
        
        heightArray.removeAll()
//        if info.favStatus.integerValue == 1 {
            //收藏
//            let favModel:LJFavoriteDataModel = LJFavoriteDataModel.init(info: info)
//            favoriteArray.insertObject(favModel, atIndex: 0)
//        }else {
            //取消收藏
            for tmpModel in favoriteArray {
                if nid as String == (tmpModel as AnyObject).info??.nid! {
                    favoriteArray.remove(tmpModel)
                    break
                }
            }
            
            if favoriteArray.count == 0 {
                self.showNoResultView(noResultView)
                self.hideNoResultLabel()
            }
//        }
    }
}
