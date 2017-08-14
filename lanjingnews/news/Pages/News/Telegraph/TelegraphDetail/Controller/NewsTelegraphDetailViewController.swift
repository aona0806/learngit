//
//  NewsTelegraphDetailViewController.swift
//  news
//
//  Created by wxc on 2017/1/4.
//  Copyright © 2017年 lanjing. All rights reserved.
//

import UIKit

class NewsTelegraphDetailViewController: NewsDetailBaseViewController ,ShareViewProtocol{
    
    var fromPush:Bool = false
    var typeId:String!
    
    private var detailHeaderView:NewsTelegraphDetailHeaderView!
    
    private var newsDetailModel:LJNewsTelegraphDetailModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubViews()
        self.setNavgationBar()
        
        self.loadNewsData(fromPush: fromPush)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UIDevice.current.systemVersion.hasPrefix("8") {
            detailHeaderView.imagesTableView.reloadData()
        }
    }
    
    func setupSubViews() {
        let rect = CGRect(x: 0, y: 0, width: self.view.width, height: 0)
        detailHeaderView = NewsTelegraphDetailHeaderView(frame:rect)
        
        detailHeaderView.praiseButtonAction = {[weak self] sender in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.newsDetailHeaderViewPraiseButtonClick(headerView: strongSelf.detailHeaderView,button: sender)
        }
    }
    
    func setNavgationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.createItem(withTarget: self, action: #selector(shareButtonClick), image: "newsdetail_share")
    }
    
    func loadNewsData(fromPush:Bool) {
        
        let hud = self.showLoadingGif()
        isLoadingFinished = false
        
        TKRequestHandler.sharedInstance().getNewsTelegraphDetail(withNewsId: self.newsId, fromPush: fromPush) { [weak self] (sessionDataTask, model, error) in
            
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.isLoadingFinished = true
            hud.hide(animated: true)
            
            if error == nil && model != nil  {
                
                strongSelf.newsDetailModel = model
                strongSelf.detailHeaderView.setHeaderView(model: strongSelf.newsDetailModel?.data)
                strongSelf.commentTableView.tableHeaderView = strongSelf.detailHeaderView
                strongSelf.inputbar.isHidden = false
                strongSelf.loadCommentList()
                
                let heightForCommentTableView = UIScreen.main.bounds.height - 64 - strongSelf.inputbar.height
                strongSelf.commentTableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:heightForCommentTableView)
                
                strongSelf.addFooterRefreshView(strongSelf.commentTableView) {() -> Void in
                    strongSelf.footRefreshAction()
                }
                strongSelf.commentTableView.footer?.bottom = strongSelf.commentTableView.contentSize.height
                
            }else{
                
                if model == nil {
                    strongSelf.showNetErrorView(nil)
                } else {
                    if error?._code == 21403 {
                        //文章被删除
                        if (error?._domain.length())! > 0 {
                            _ = strongSelf.showToastHidenDefault(error?._domain)
                        }
                        
//                        if !fromPush {
//                            return
//                        }
                        
                        let version = UIDevice.current.systemVersion
                        if version.hasPrefix("7") {
                            //7.x下需要延迟一会，一点ui完全OK了
                            let time = DispatchTime.now() + Double(Int64(1*NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
                            DispatchQueue.main.asyncAfter(deadline: time, execute: {
                                strongSelf.finish()
                            })
                        }else{
                            strongSelf.finish()
                        }
                    } else if error?._code == -1009 {
                        strongSelf.showNetErrorView(nil)
                    } else {
                        strongSelf.showNoResultView(nil)
                    }
                }
            }
        }
    }
    
    /**
     *  点赞
     */
    func newsDetailHeaderViewPraiseButtonClick(headerView: NewsTelegraphDetailHeaderView, button: UIButton) {
        
        let isZan = newsDetailModel?.data?.isZan ?? ""
        let isZanNum = Int(isZan) ?? 0
        if isZanNum == 1 {
            _ = showToastHidenDefault("已赞")
            return
        }
        
        if self.checkLoginAction() && newsDetailModel != nil{
            TKRequestHandler.sharedInstance().zanNewsDetail(withNewsId: newsDetailModel?.data?.nid) { [weak self](sessionDataTask, model, error) -> Void in
                guard let strongSelf = self else {
                    return
                }
                if error == nil {
                    button.setTitle(" \((model?.data?.num)!)", for: UIControlState.normal)
                    button.setTitle(" \((model?.data?.num)!)", for: UIControlState.selected)
                    button.isSelected = true
                    strongSelf.detailHeaderView.adjustPraiseButton()
                    strongSelf.newsDetailModel?.data?.isZan = "1"
                }else{
                    _ = strongSelf.showToastHidenDefault(error?._domain)
                }
            }
        }
    }
    
    override func addCommentNum() {
        self.detailHeaderView.addCommentNum()
        
        NotificationCenter.default.post( name: NSNotification.Name(rawValue: GlobalConsts.kRollCommentSuccess), object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func refreshAction (){
        self.loadNewsData(fromPush: fromPush)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //MARK: 分享
    /**
     分享
     */
    func shareButtonClick(){
        if self.isLoadingFinished && newsDetailModel != nil {
            let shareView = ShareView(delegate: self, shareObj: nil, hideLanjing: true)
//            if AccountManager.sharedInstance.verified() == "1"{
//                shareView = ShareView(delegate: self, shareObj: nil, hideLanjing: false)
//            }
            
            let window = UIApplication.shared.keyWindow
            shareView.show(window, animated: true)
            MobClick.event("Roll_List_Share", attributes: ["typeId":typeId])

        }
    }

    func shareAction(_ type: ShareType, shareView: ShareView, shareObj: AnyObject?) {
//        //分享
        if self.isLoadingFinished && newsDetailModel?.data != nil {
            ShareAnalyseManager.sharedInstance().shareTelegraphNewsDetail(type, info: newsDetailModel!.data, presentController: self, completion: { [weak self](success, error) -> () in
                
                if success {
                    _ = self?.showToastHidenDefault("分享成功")
                } else {
                    _ = self?.showToastHidenDefault("分享失败")
                }
            })
        }
    }

}
