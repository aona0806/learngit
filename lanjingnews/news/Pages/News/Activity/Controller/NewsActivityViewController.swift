//
//  NewsActivityViewController.swift
//  news
//
//  Created by 陈龙 on 16/1/9.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class NewsActivityViewController: BaseViewController, ShareViewProtocol {

    class Consts: NSObject {
        static let SubmitTopSpace: CGFloat = 40
        static let SubmitBottomSpace: CGFloat = 40.0
        static let SubmitSize: CGSize = CGSize(width: 250, height: 40)
    }

    var fromSubId: String?  //用来标记是从哪个页面进入

    private var scrollView: UIScrollView?
    private var contentView: NewsAcitivityDetailView!
    private var tid: Int! = 0
    private let collectButton = UIButton(type: .custom)
    private let shareButton = UIButton(type: .custom)
    private let submitButton = UIButton()

    var collectListModel: LJNewsListDataListModel?

    // MARK: - Lifecycle
    
    init(tid: Int) {
        super.init(nibName: nil, bundle: nil)
        
        self.tid = tid;
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.buildNavbar()
        self.buildView()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = "活动详情"
        
        getDetail(self.tid, fromSubid: self.fromSubId) // 实时更新
    }
    
    override func refreshAction() {
        
        getDetail(self.tid, fromSubid: self.fromSubId) // 实时更新
    }
    
    
    // MARK: - private
    
    func buildNavbar() {
        
        collectButton.frame = CGRect(x: 0, y: 0, width: NewsConfig.NavbarSize, height: NewsConfig.NavbarSize)
        let collectNormalImage = UIImage(named: "news_collect_hollowstar")
        let collectSelectedImage = UIImage(named: "news_collect_solidstar")
        collectButton.setImage(collectNormalImage, for: UIControlState())
        collectButton.setImage(collectSelectedImage, for: .selected)
        let collectButtonItem = UIBarButtonItem(customView: collectButton)
        collectButton.addTarget(self, action: #selector(NewsActivityViewController.onCollect(_:)), for: .touchUpInside)
        
        shareButton.frame = CGRect(x: 0, y: 0, width: 27, height: 27)
        let shareNormalImage = UIImage(named: "newsdetail_share")
        shareButton.setImage(shareNormalImage, for: UIControlState())
        let shareButtonItem = UIBarButtonItem(customView: shareButton)
        shareButton.addTarget(self, action: #selector(NewsActivityViewController.onShare(_:)), for: .touchUpInside)
        
        let itemArray: [UIBarButtonItem]! = [shareButtonItem, collectButtonItem];
        self.navigationItem.rightBarButtonItems = itemArray
    }
    
    func buildView() {
        
        if self.scrollView == nil {
            let viewSize = self.view.frame.size
            self.scrollView = UIScrollView()
            self.scrollView?.contentSize = viewSize
            self.scrollView?.backgroundColor = UIColor.white
            self.view.addSubview(self.scrollView!)
            self.scrollView?.snp.makeConstraints { (make) -> Void in
                make.edges.equalTo(self.view.snp.edges).inset(UIEdgeInsetsMake(0, 0, 60, 0))
            }
            
            contentView = NewsAcitivityDetailView(frame: CGRect.zero)
            contentView.updateHeight = {[weak self](cell, contentHeight) in
                self!.scrollView?.contentSize = CGSize(width: self!.scrollView!.size.width, height: contentHeight)
                self!.contentView.frame = CGRect(x: 0, y: 0, width: GlobalConsts.screenWidth, height: contentHeight)

            }
            self.scrollView!.addSubview(contentView)
            
            let submitImage = UIImage(named: "news_activity_submit")
            submitButton.setBackgroundImage(submitImage, for: UIControlState())
            submitButton.addTarget(self, action: #selector(NewsActivityViewController.onSubmit(_:)), for: .touchUpInside)
            submitButton.setTitle("我要报名", for: UIControlState())
            submitButton.setTitleColor(NewsConfig.ButtonTextColor, for: UIControlState())
            submitButton.titleLabel?.font = NewsConfig.ButtonTextFont
            
            let submitedImage = UIImage(named: "news_activity_submited")
            submitButton.setBackgroundImage(submitedImage, for: .selected)
            submitButton.setTitle("已报名", for: .selected)
            submitButton.setTitleColor(UIColor.white, for: .selected)
            
            submitButton.setBackgroundImage(submitedImage, for: .disabled)
            submitButton.setTitle("已报名", for: .disabled)
            submitButton.setTitleColor(UIColor.white, for: .disabled)
            submitButton.isHidden = true
            
            self.view.addSubview(submitButton)
            submitButton.snp.makeConstraints { (make) -> Void in
                make.centerX.equalTo(self.view.snp.centerX)
                make.width.equalTo(Consts.SubmitSize.width)
                make.height.equalTo(Consts.SubmitSize.height)
                make.bottom.equalTo(self.view.snp.bottom).offset(-10)
            }
        }
    }
    
    private var info: NewsActivityDetailDataModel? {
        didSet {
            let contentHeight = contentView.heightForCell(info!)
            self.scrollView?.contentSize = CGSize(width: self.scrollView!.size.width, height: contentHeight)
            self.contentView.frame = CGRect(x: 0, y: 0, width: GlobalConsts.screenWidth, height: contentHeight)
            self.contentView.info = info
            
            let favStatus = self.info?.favStatus ?? "0"
            self.collectButton.isSelected = favStatus == "1"
        }
    }
    
    private func notificationCollect(_ isCollected: Bool, ctime: NSNumber) {
        
        if self.info != nil {
            
            var userInfo: [String:AnyObject]! = [GlobalConsts.kNewsCollectId: info!.id! as AnyObject]
            if self.collectListModel != nil {
                self.collectListModel?.favStatus = isCollected ? "1" : "0"
                self.collectListModel?.favTime = String(ctime.doubleValue)
                userInfo[GlobalConsts.kNewsCollectInfo] = self.collectListModel!
            }
            if !isCollected {
                NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConsts.kNewsCollectNotification), object: nil, userInfo: userInfo)
            }

        }
    }
    
    // MARK: action
    
    func onSubmit(_ info: UIButton) {
        
        if !AccountManager.sharedInstance.isLogin() {
            
            let loginRegisteVc = LoginRegistViewController()
            self.navigateTo(loginRegisteVc)
        } else {
            let viewController = NewsActivitySignupViewController(info: self.info)
            self.navigateTo(viewController)
        }
    }
    
    func onCollect(_ button: UIButton) {
        
        if self.info == nil {
            return
        }
        
        if !AccountManager.sharedInstance.isLogin() {
            let viewController = LoginRegistViewController()
            self.navigateTo(viewController)
            return
        }
        
        let favType = self.info?.favType ?? "0"
        let idString = self.info?.id ?? "0"
        if button.isSelected {
            TKRequestHandler.sharedInstance().cancelFavorite(withType: favType,aid: idString, finish: { [weak self](sessionDataTask, model, error) -> Void in
                
                guard let strongSelf = self else {
                    return
                }
                let hud  = MBProgressHUD.showAdded(to: strongSelf.view, animated:true)
                hud.mode = .text
                if error == nil {
                    button.isSelected = false
                    hud.label.text = "取消收藏成功"
                    let time = model.dtime ?? ""
                    var timeNumber:NSNumber? = 0
                    if let number = Double(time) {
                        timeNumber = NSNumber(value:number)
                    }
                    if timeNumber != nil {
                        strongSelf.notificationCollect(false, ctime: timeNumber!)
                    }
                    hud.hide(animated: true, afterDelay: 0.5)
                }else {
                    hud.label.text = error!._domain
                    hud.hide(animated: true, afterDelay: 0.5)
                }
            })
            
        } else {
            TKRequestHandler.sharedInstance().createFavorite(withType: favType, aid: idString) { [weak self](sessionDataType, model, error) -> Void in
                
                guard let strongSelf = self else {
                    return
                }

                let hud  = MBProgressHUD.showAdded(to: strongSelf.view, animated:true)
                hud.mode = .text
                if error == nil {
                    button.isSelected = true
                    
                    let time = model.dtime ?? ""
                    var timeNumber:NSNumber? = 0
                    if let number = Double(time) {
                        timeNumber = NSNumber(value:number)
                    }
                    if timeNumber != nil {
                        strongSelf.notificationCollect(true, ctime: timeNumber!)
                        hud.label.text = "已收藏"
                    }
                    hud.hide(animated: true, afterDelay: 0.5)
                }else {
                    hud.label.text = error!._domain
                    hud.hide(animated: true, afterDelay: 0.5)
                }

            }
        }
    }
    
    func onShare(_ button: UIButton) {
        
        var shareView = ShareView(delegate: self, shareObj: nil, hideLanjing: true)
        if AccountManager.sharedInstance.verified() == "1"{
            shareView = ShareView(delegate: self, shareObj: nil, hideLanjing: false)
        }
        
        let window = UIApplication.shared.keyWindow
        shareView.show(window, animated: true)

    }
    
    // MARK: - ShareViewProtocol
    
    func shareAction(_ type: ShareType, shareView: ShareView, shareObj: AnyObject?) {
        //分享
        
        if self.info != nil {
            ShareAnalyseManager.sharedInstance().shareNewsActivity(type, info: self.info!, presentController: self) { (success, error) -> () in
                if success {
                    _ = self.showToastHidenDefault("分享成功")
                } else {
                    _ = self.showToastHidenDefault(error?._domain)
                }
            }
        }
    }

    // MARK: - download
    
    func getDetail(_ tid: Int, fromSubid: String?) {
        
        TKRequestHandler.sharedInstance().getNewsActivityDetail(tid, fromSubId: fromSubId) {[weak self] (sessionDataTask, model, error) -> Void in
            
            guard let strongSelf = self else {
                return
            }
            
            if error == nil {
                if model?.dErrno == "0" {
                    strongSelf.info = model?.data
                    
                    let inList = strongSelf.info?.inList ?? "0"
                    if inList == "1" {
                        strongSelf.submitButton.isEnabled = false
                        strongSelf.submitButton.setTitle("已报名", for: .selected)
                        strongSelf.submitButton.setTitle("已报名", for: .disabled)
                    } else {
                        let timeStartString = model?.data?.timeStart ?? ""
                        let startTime = Double(timeStartString)
                        if startTime != nil {
                            let timeNow = Date().timeIntervalSince1970
                            if startTime! < timeNow {
                                strongSelf.submitButton.isEnabled = false
                                strongSelf.submitButton.setTitle("截止报名", for: .selected)
                                strongSelf.submitButton.setTitle("截止报名", for: .disabled)
                                
                            } else {
                                strongSelf.submitButton.isEnabled = true
                            }
                        }
                        
                    }
                    strongSelf.submitButton.isHidden = false
                    
                }
            } else {
                let errorString = model?.dErrno ?? ""
                let errorCode = Int(errorString)
                if model != nil && errorCode != nil && errorCode == error?._code {
                    
                    let msg = model?.msg ?? GlobalConsts.NetErrorNetMessage
                    _ = strongSelf.showToastHidenDefault(msg)
                    
                }else{
                    
                    strongSelf.showNetErrorView(nil)
                    
                }
            }
        }
    }
    
}
