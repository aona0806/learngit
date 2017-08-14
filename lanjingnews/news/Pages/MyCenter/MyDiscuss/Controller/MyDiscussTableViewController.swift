//
//  MyDiscussTableViewController.swift
//  news
//
//  Created by 奥那 on 15/12/11.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

class MyDiscussTableViewController: LJBaseTableViewController {
    
    var userId = ""
    let identifier = "myDiscuss"
    var discussList = Array<LJTweetDataContentModel>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userId.length() == 0 {
            userId = AccountManager.sharedInstance.uid()
        }
        
        self.title = getTitle();

        self.tableView.tableFooterView = UIView()
        self.tableView.allowsSelection = true
        
        addHeaderFooterRefresh()

        registerMyCell()
        handleRefresh(true)
        customNavigationItem()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MyDiscussTableViewController.discussDidDelete(_:)), name: NSNotification.Name(rawValue: GlobalConsts.kTweetDeleteNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
    
    func registerMyCell(){
        self.tableView.register(UINib(nibName: "MyDiscussCell", bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    private func customNavigationItem(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.defaultLeftItem(withTarget: self, action: #selector(MyDiscussTableViewController.backAction))
        self.navigationItem.rightBarButtonItem = nil
    }
    
    override func backAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    /**
     返回title
     */
    private func getTitle() -> String{
        if userId == AccountManager.sharedInstance.uid()
        {
            return "我的讨论"
        }else{
            return "他的讨论"
        }
    }
    
    private func addHeaderFooterRefresh(){
        // 设置TableView的刷新
        weak var weakSelf : MyDiscussTableViewController? = self
        
        addHeaderRefreshView(self.tableView) { () -> Void in
            weakSelf?.handleRefresh(true)
        }

        addFooterRefreshView(self.tableView) { () -> Void in
            weakSelf?.handleRefresh(false)
        }
        
    }

    private func handleRefresh(_ isHead : Bool){
        // 请求讨论详情数据
        var lastId = "-1"
        if  self.discussList.count > 0 && !isHead {
            var disInfo : LJTweetDataContentModel? = nil

            if isHead{
                 disInfo = self.discussList.first as LJTweetDataContentModel?
            }else{
                 disInfo = self.discussList.last as LJTweetDataContentModel?
            }

            if disInfo != nil {
                
                lastId = disInfo!.originTid! == "0" ? disInfo!.tid! : disInfo!.originTid!
            }
        }
        
        requestData(isHead, lastId: lastId)
    }
    
    /**
     请求数据
     */
    private func requestData(_ isHead:Bool, lastId:String){

        TKRequestHandler.sharedInstance().getDiscussionList(withUid: userId, rn: "10", lastId: lastId, isUprefresh: isHead) { [weak self](sessionDataTask, model, error) -> Void in
            guard let strongSelf = self else {
                return
            }
            if error == nil{
                
                let r = model! as LJMyDiscussModel
                if r.data?.content?.topic == nil || r.data?.content?.topic?.count == 0 {
                    DispatchQueue.main.async(execute: {
                        strongSelf.stopRefresh(strongSelf.tableView)
                        if (isHead){
                            strongSelf.tableView.reloadData()
                            _ = strongSelf.showToastHidenDefault("暂无讨论")
                        }

                    })
                    
                }else{
                    
                    let discusses = r.data?.content?.topic as! Array<LJTweetDataContentModel>
                    
                    if discusses.count > 0{
                        if isHead {
                            strongSelf.discussList = discusses
                        }else{
                            for  dis in discusses  {
                                strongSelf.discussList.append(dis)
                            }
                        }
                        
                        DispatchQueue.main.async(execute: {
                            strongSelf.stopRefresh(strongSelf.tableView)
                            strongSelf.tableView.reloadData()
                        })
                    }
                }
                
            }else{
                _ = strongSelf.showToastHidenDefault(error?._domain)
        
            }
        }
    }
    
    /**
     点击图片
     */
    private func imageClick( _ cell : MyDiscussCell , imageView : UIImageView?){
        
        if imageView?.image == nil {
            return
        }
        let browserHelper = FSPhotoBrowserHelper()
        
        var index = Int32(0)
        if imageView == cell.secondImageView {
            index = 1
        }else if imageView == cell.thirdImageView{
            index = 2
        }
        
        var images = Array<UIImage>()
        if cell.firstImageView!.image != nil {
            images.append(cell.firstImageView!.image!)
        }
        
        if cell.secondImageView!.image != nil {
            images.append(cell.secondImageView!.image!)
            
        }
        if cell.thirdImageView!.image != nil {
            images.append(cell.thirdImageView!.image!)
        }
        
        browserHelper.placeHolderImages = images
        browserHelper.currentIndex = index
        browserHelper.liftImageView = imageView
        browserHelper.images = cell.model?.img
        
        browserHelper.show()
        
    }
    
    func discussDidDelete(_ sender : Notification){
        let discuss = sender.object as! LJTweetDataContentModel
        
        var index = 0
        for dis in discussList {
            if dis.tid == discuss.tid {
                break
            }
            index += 1
        }
        if index < self.discussList.count {
            self.discussList.remove(at: index)
            self.tableView?.reloadData()
        }

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return discussList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! MyDiscussCell
        
        let model = discussList[(indexPath as NSIndexPath).section]
        
        cell.model = model
        cell.imageClick = imageClick
        
        return cell
    }
    
    
    //MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let model = discussList[(indexPath as NSIndexPath).section]
        let controller = TweetDetailViewController()
        controller.tid = model.tid
        controller.hidesBottomBarWhenPushed = true
        navigateTo(controller)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = discussList[(indexPath as NSIndexPath).section]
        
        return MyDiscussCell.CellHeightForModel(model)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            var height = CGFloat(10)
            if let navContoller = self.navigationController {
                height += navContoller.navigationBar.bottom - GlobalConsts.NormalNavbarHeight
            }
            return height
        }
        return 1
    }
    }
