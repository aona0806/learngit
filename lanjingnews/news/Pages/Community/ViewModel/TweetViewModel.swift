//
//  TwitterViewModel.swift
//  news
//
//  Created by 陈龙 on 16/5/5.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit


class TweetViewModel: NSObject, UITableViewDelegate, UITableViewDataSource{
    enum TweetType {
        case communityType
        case hotNewsType
    }
    
    private var tableView: UITableView!
    private var tweetList: [LJTweetDataContentModel]! = [LJTweetDataContentModel]()
    private var tweetOperate: TweetOperationDelegate? = nil
    private var viewController: LJBaseViewController!
    private var type: TweetType = .communityType
    
    private var bannerCell: NewsBannerCell?
    
    
    internal var shareLanjing: ((LJTweetDataContentModel) -> ())!
    internal var advItems: [LJAdDataModel]! = []
    
    // MARK: -  lifecycle
    
    required init(type: TweetType!, tableView: UITableView!, tweetList: [LJTweetDataContentModel]?, viewContrller: LJBaseViewController!) {
        
        super.init()
        self.tableView = tableView
        self.tweetList = tweetList ?? [LJTweetDataContentModel]()
        self.viewController = viewContrller
        self.type = type
        
        if tweetOperate == nil {
            tweetOperate = TweetOperationDelegate(controller: viewContrller)
            tweetOperate?.from = type == .communityType ? "Comm" : "News"
            tweetOperate?.shareLanjing = { [weak self] (tweet : LJTweetDataContentModel)->Void in
                self?.shareLanjing(tweet)
            }
        }
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }

    // MARK: - private
    
    private func showTweetDetail(_ tweet : LJTweetDataContentModel){
        let controller = TweetDetailViewController()
        controller.tid = tweet.tid
        controller.hidesBottomBarWhenPushed = true
        self.viewController.navigateTo(controller)
    }
    
    // MARK: - public

    /**
     更新微博数据
     
     - parameter tweetList: <#tweetList description#>
     */
    internal func updateDate(_ tweetList: [LJTweetDataContentModel]!) {
        
        self.tweetList = tweetList
        self.tableView.reloadData()
    }
    
    /**
     更新广告
     
     - parameter advItems: 广告想数据
     */
    internal func updateAdData(_ advItems: [LJAdDataModel]?) {
        self.advItems = advItems
        let indexSet = IndexSet(integer: 0)
        self.tableView.reloadSections(indexSet, with: .none)
    }
    
    /**
     开始广告滚动
     */
    func startScroll(){
        if self.bannerCell != nil {
            self.bannerCell!.startScroll()
        }
    }
    
    /**
     停止广告滚动
     */
    func stopScroll(){
        if self.bannerCell != nil {
            self.bannerCell!.stopScroll()
        }
    }
    
    // MARK: -  TweetOperationDelegate
    
    func tapCellAction(_ cell : TweetTableViewCell , info : LJTweetDataContentModel , type : TweetTapTap  , extra : Any? ){
        
        switch type {
        case .praise:
            praiseTweet(info , cell : cell )
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async(execute: {
                MobClick.event("Comm_zan", attributes: nil)
            })
            return
        case .comment:
            commentTweet(info)
            return
        default:
            break
            
        }
        
        self.tweetOperate?.tapCellAction(cell, info: info, type: type, extra: extra)
    }
    
    private func praiseTweet(_ info :LJTweetDataContentModel , cell : TweetTableViewCell ){
        
        
        weak var weakSelf = self
        self.tweetOperate?.praiseTweet(info, completion: { (success, errMsg) -> () in
            if success {
                
                let myInfo = AccountManager.sharedInstance.getUserInfo()
                
                var num = Int(info.praise?.num ?? "0") ?? 0
                
                guard let praise = info.praise else {
                    return
                }
                
                if praise.flag {
                    //取消赞
                    num -= 1
                    for  i  in 0..<praise.user!.count {
                        let user = praise.user?[i]
                        if (user as AnyObject).uid! == myInfo!.uid {
                            praise.user?.remove(at: i)
                            break
                        }
                    }
                }else{
                    //点赞
                    
                    var praised = false
                    if let users = praise.user {
                        for user in users {
                            if (user as AnyObject).uid == myInfo!.uid{
                                praised = true
                                break
                            }
                        }
                    }
                    
                    if !praised {
                        
                        let user = LJTweetDataContentPraiseUserModel()
                        
                        user.sname = myInfo!.sname
                        user.uid   = myInfo!.uid
                        praise.user?.append(user)
                    }
                    num += 1
                }
                
                praise.flag = !praise.flag
                
                praise.num = num.description
                
                weakSelf?.tableView?.reloadData()
                
            }
        })
        
        
    }
    
    private func commentTweet(_ info:LJTweetDataContentModel){
        
        MobClick.event("Comm_comment", attributes: nil)

        self.showTweetDetail(info)
    }
    
    private func showUserInfo(_ uid : String){
        //跳转用户信息页面
        
        let controller = LJUserDeltailViewController.init()
        controller.uid = uid
        self.viewController.navigateTo(controller)
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        let count: Int = self.type == .hotNewsType ? 2 : 1
        
        return count
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count: Int!
        switch self.type {
        case .hotNewsType:
            if section == 0 {
                count = 1
            } else {
                count = self.tweetList.count
            }
            break
        case .communityType:
            count = self.tweetList.count
            break
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        
        var cell : UITableViewCell!
        if (indexPath as NSIndexPath).section == 0 && self.type == .hotNewsType {
            //banner
            let bannerId = NewsBannerCell.Identify
            var bcell = tableView.dequeueReusableCell(withIdentifier: bannerId) as? NewsBannerCell
            if bcell == nil {
                bcell = NewsBannerCell(style: .default, reuseIdentifier: bannerId)
            }
            self.bannerCell = bcell
            cell = bcell!
            bcell?.updatBanners(self.advItems)
            bcell?.contentView.backgroundColor = UIColor.green
            
        }else{
            
            let tcellId  = TweetTableViewCell.Identify
            var tcell = tableView.dequeueReusableCell(withIdentifier: tcellId) as? TweetTableViewCell
            if tcell == nil {
                tcell = TweetTableViewCell(style: .default, reuseIdentifier: tcellId)
                
                tcell?.tapAction = { [weak self](cell : TweetTableViewCell , info : LJTweetDataContentModel , type : TweetTapTap  , extra : Any? ) -> Void in
                    self?.tapCellAction(cell, info: info, type: type, extra: extra)
                }
                
            }
            
            let model = self.tweetList[(indexPath as NSIndexPath).row]
            tcell?.info = model
            
            cell = tcell!
        }
        

        return cell
        
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height: CGFloat!
        if (indexPath as NSIndexPath).section == 0 && self.type == .hotNewsType {
            height = NewsBannerCell.fitHeight()
        } else {
            let info = self.tweetList[(indexPath as NSIndexPath).row]
            height = TweetTableViewCell.heightForInfo(info)
        }
        return height
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        //用于隐藏顶部的空白
        if section == 0 {
            if let navController = self.viewController.navigationController  {
                return navController.navigationBar.bottom - GlobalConsts.NormalNavbarHeight
            }
        }
        return CGFloat.leastNormalMagnitude
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let info = self.tweetList[(indexPath as NSIndexPath).row]
        MobClick.event("Comm_detail", attributes: nil)
        showTweetDetail(info)
    }
}
