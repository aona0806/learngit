//
//  NewsDetailTableViewController.swift
//  news
//
//  Created by wxc on 16/1/5.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit
import JavaScriptCore

class NewsDetailTableViewController: NewsDetailBaseViewController, UIWebViewDelegate, ShareViewProtocol ,NewsDetailHeaderViewDelegate, PhotoBrowerScrollImageViewDataSource{

    var collectListModel:LJNewsListDataListModel? = nil
    var fromSubId: String?  //用来标记是从哪个页面进入
    var isFromPush = false
    
    //MARK: 子控件
    private var collectionItem:UIBarButtonItem!
    private var headerView:NewsDetailHeaderView!
    
    //MARK: TKWebSDK
    private var jsHelper: TKWebSDK?
    private var photoBrowser: FSPhotoBrowserHelper?
    
    //MARK: 导航栏右键
    private var rightBarButtonItem: UIBarButtonItem?
    
    //MARK: 数据相关
    private var collectionState:Bool! = false       //收藏状态
    private var newsDetailModel:LJNewsDetailModel? = nil   //当前新闻详情数据
    
    //MARK:- 控制器相关
    override func viewDidLoad(){
        super.viewDidLoad()
        self.setupAllSubviews()
        self.setupNavigationbar()
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        
        self.loadNewsDetail()
        //self.initJsHelper()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    deinit{
        headerView.headerWebView.cleanForDealloc()
        headerView.headerWebView = nil
        
    }
    
    func setupNavigationbar(){
        
//        let leftItem = UIBarButtonItem.defaultLeftItem(withTarget: self, action: #selector(NewsDetailTableViewController.backAction))

        
        
        let rightItem = UIBarButtonItem.createItem(withTarget: self, action: #selector(NewsDetailTableViewController.shareButtonClick), image: "newsdetail_share")
        self.navigationItem.rightBarButtonItem = rightItem!
        
        self.title = "资讯详情"
    }
    
    func resetNavigationRightBarItem() {
        
        
        let shareButton = UIButton.init(type: .custom)
        
        shareButton.frame = CGRect(x: 35, y: 0, width: 35, height: 21)
        let image = UIImage.init(named: "newsdetail_share")
        shareButton.setImage(image, for: .normal)
        shareButton.setImage(image, for: .highlighted)
//        shareButton.sizeToFit()
        shareButton.addTarget(self, action: #selector(NewsDetailTableViewController.shareButtonClick), for: .touchUpInside)
        
        
        let collectionButton = UIButton.init(type: .custom)
        collectionButton.frame = CGRect(x: 0, y: 0, width: 21, height: 21)
        let image1 = UIImage.init(named: "news_collect_hollowstar")
        collectionButton.setBackgroundImage(image1, for: .normal)
        collectionButton.setBackgroundImage(image1, for: .highlighted)
        collectionButton.sizeToFit()
        collectionButton.addTarget(self, action: #selector(NewsDetailTableViewController.collectionButtonClick(_:)), for: .touchUpInside)
        
        let rightView = UIView.init(frame:CGRect(x: 0, y: 0, width: 70, height: 21))
        rightView.addSubview(shareButton)
        rightView.addSubview(collectionButton)
        
        rightBarButtonItem = UIBarButtonItem.init(customView: rightView)
        
        //self.navigationItem.rightBarButtonItems = [shareItem,collectionItem]
        self.navigationItem.rightBarButtonItem = rightBarButtonItem!

    }
    
    /**
     收藏
     */
    func collectionButtonClick(_ sender:UIBarButtonItem){
        
        self.hideKeyboard()
        
        if self.checkLoginAction() && newsDetailModel != nil{
            //收藏状态
            if collectionState == true {
                TKRequestHandler.sharedInstance().cancelFavorite(withType: newsDetailModel!.data!.favType!, aid: newsDetailModel!.data!.nid!, finish: { [weak self](sessionDataTask, model, error) -> Void in
                    
                    guard let strongSelf = self else {
                        return
                    }
                    
                    if error == nil {
                        
                        strongSelf.setCollectionState(false)
                        _ = strongSelf.showToastHidenDefault("取消收藏")
                        //                            strongSelf.collectListModel?.favTime = model.dtime
                        //                            strongSelf.collectListModel?.favStatus = NSNumber.init(integer: 0)
                        
                        let userInfo:[String:AnyObject] = [GlobalConsts.kNewsCollectId:(strongSelf.newsDetailModel?.data?.nid)! as AnyObject]
                        //                            if strongSelf.collectListModel != nil {
                        //                                userInfo[GlobalConsts.kNewsCollectInfo] = strongSelf.collectListModel!
                        //                            }
                        NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConsts.kNewsCollectNotification), object: nil, userInfo: userInfo)

                    }else {
                        _ = strongSelf.showToastHidenDefault(error!._domain)
                    }
                })
            } else {
                
                TKRequestHandler.sharedInstance().createFavorite(withType: newsDetailModel!.data!.favType!, aid: newsDetailModel!.data!.nid!, finish: {[weak self] (sessionDataTask, model, error) -> Void in
                    
                    guard let strongSelf = self else {
                        return
                    }
                    
                    if error == nil {
                        
                        strongSelf.setCollectionState(true)
                        
                        _ = strongSelf.showToastHidenDefault("已收藏")
                        //                            strongSelf.collectListModel?.favTime = model.dtime
                        //                            strongSelf.collectListModel?.favStatus = NSNumber.init(integer: 1)
                        //                            if strongSelf.collectListModel != nil {
                        //                                NSNotificationCenter.defaultCenter().postNotificationName(GlobalConsts.kNewsCollectNotification, object: nil, userInfo: [GlobalConsts.kNewsCollectInfo:strongSelf.collectListModel!])
                        //                            }

                        
                    }else {
                        if error?._code == 21401 {
                            self?.setCollectionState(true)
                        } else {
                        _ = strongSelf.showToastHidenDefault(error!._domain)
                        }
                    }
                })
            }
        }
    }
    
    
    private func setCollectionState(_ state:Bool){
        collectionState = state
        if collectionState == true {
            self.setCollectionImage("news_collect_solidstar")
        }else {
            self.setCollectionImage("news_collect_hollowstar")
        }
    }
    
    private func setCollectionImage(_ imageName: String) {
        let shareButton = UIButton.init(type: .custom)
        shareButton.frame = CGRect(x: 35, y: 0, width: 35, height: 21)
        let image = UIImage.init(named: "newsdetail_share")
        shareButton.setImage(image, for: .normal)
        shareButton.setImage(image, for: .highlighted)
//        shareButton.sizeToFit()
        shareButton.addTarget(self, action: #selector(NewsDetailTableViewController.shareButtonClick), for: .touchUpInside)
        
        
        let collectionButton = UIButton.init(type: .custom)
        collectionButton.frame = CGRect(x: 0, y: 0, width: 21, height: 21)
        let image1 = UIImage.init(named: imageName)
        collectionButton.setBackgroundImage(image1, for: .normal)
        collectionButton.setBackgroundImage(image1, for: .highlighted)
        collectionButton.sizeToFit()
        collectionButton.addTarget(self, action: #selector(NewsDetailTableViewController.collectionButtonClick(_:)), for: .touchUpInside)
        
        let rightView = UIView.init(frame:CGRect(x: 0, y: 0, width: 70, height: 21))
        rightView.addSubview(shareButton)
        rightView.addSubview(collectionButton)
        
        rightBarButtonItem = UIBarButtonItem.init(customView: rightView)
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem!
    }
    
    
    /**
     分享
     */
    func shareButtonClick(){
        if self.newsDetailModel?.data?.isAd == nil || self.newsDetailModel?.data?.isAd == "0" {

            self.hideKeyboard()
        }
        
        if isLoadingFinished {
            var shareView = ShareView(delegate: self, shareObj: nil, hideLanjing: true)
            if AccountManager.sharedInstance.verified() == "1"{
                shareView = ShareView(delegate: self, shareObj: nil, hideLanjing: false)
            }
            
            let window = UIApplication.shared.keyWindow
            shareView.show(window, animated: true)
        }
    }

    func shareAction(_ type: ShareType, shareView: ShareView, shareObj: AnyObject?) {
        //分享
        if self.newsDetailModel != nil {
            ShareAnalyseManager.sharedInstance().shareNewsDetail(type, info: newsDetailModel?.data, presentController: self, completion: { [weak self](success, error) -> () in
                
                if success {
                    _ = self?.showToastHidenDefault("分享成功")
                } else {
                    _ = self?.showToastHidenDefault("分享失败")
                }
            })
        }
    }
    
    /**
     返回按钮
     */
    override func backAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //初始化布局
    private func setupAllSubviews(){
        
        let rect = CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height)
        headerView = NewsDetailHeaderView(frame: rect)
        headerView.delegate = self
        headerView.headerWebView.scrollView.scrollsToTop = false
        headerView.headerWebView.delegate = self
    }
    
    //MARK: TKWebSDK相关
    private func initJsHelper() {
        jsHelper = TKWebSDK.init(webView: self.headerView.headerWebView, controller: self)
        jsHelper!.showImage = {[weak self] (imageData, imageUrl) -> Void in
            guard let strongSelf = self else {
                return
            }
            let allImages = strongSelf.jsHelper?.allImageUrls()
            let img = UIImage.init(data: imageData!)
            if (allImages?.count)! > 0 && (imageUrl?.length())! > 0 {
                if strongSelf.photoBrowser == nil {
                    strongSelf.photoBrowser = FSPhotoBrowserHelper()
                    strongSelf.photoBrowser?.dataSource = strongSelf
                }
                
                var index = 0
                var liftImageView: UIImageView? = nil
                let placeHolderImage: [UIImage] = Array.init(repeating: img!, count: (allImages?.count)!)
                
                for url in allImages! {
                    if url as! String == imageUrl! {
                        break
                    }
                    index += 1
                }
                
                liftImageView = UIImageView.init(image: img)
                
                strongSelf.photoBrowser?.currentIndex = Int32(index)
                strongSelf.photoBrowser?.liftImageView = liftImageView!
                strongSelf.photoBrowser?.images = allImages
                strongSelf.photoBrowser?.placeHolderImages = placeHolderImage
                strongSelf.photoBrowser?.show()
            }
        }
    }
    
    // 有问题，待修改，未添加图片缓存
    func imagePhotoPlaceHolder(_ browser: FSPhotoBrowser!, at index: Int) -> UIImage! {
        let url = self.photoBrowser?.images[index]
        let data = try? Data.init(contentsOf: URL.init(string: url as! String)!)
        let image = UIImage.init(data: data!)
        return image!
    }
    
    
    func photoBrowser(_ browser: FSPhotoBrowser!, requestDataWith type: PhotoBrowerScrollRequestDataType, at index: Int) -> NSObject! {
        let url = self.photoBrowser?.images[index]
        let data = try? Data.init(contentsOf: URL.init(string: url as! String)!)
        let object = UIImage.init(data: data!)
        return object!
    }
    
    
    private func registerWebJsHandler() {
        let path = Bundle.main.path(forResource: "news.js", ofType: nil)
        var js: String?
        do {
            js = try String.init(contentsOfFile: path!, encoding: String.Encoding.utf8)
        } catch {
            
        }
        
        if js != nil {
            _ = self.jsHelper?.execute(js!)
        
        }
    }
    
    
    
    //MARK: 网络请求相关
    private func loadNewsDetail(){
        
        let hud = self.showLoadingGif()
        isLoadingFinished = false
        
        TKRequestHandler.sharedInstance().getNewsDetail(withNewsId: newsId, fromSubId: fromSubId, finish:{[weak self] (sessionDataTask, model, error) -> Void in
            
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.isLoadingFinished = true
            hud.hide(animated: true)
            
            if error == nil && model != nil  {
                
                strongSelf.newsDetailModel = model
                
                if strongSelf.newsDetailModel?.data?.isAd != nil && strongSelf.newsDetailModel?.data?.isAd == "1" {
                    
                    strongSelf.heightForCommentTableView = UIScreen.main.bounds.height - 64
                    strongSelf.commentTableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: strongSelf.heightForCommentTableView)
                    
                    strongSelf.headerView.setValueWithModel(model)
                } else {
                    strongSelf.resetNavigationRightBarItem()
            
                    strongSelf.inputbar.isHidden = false
                    
                    strongSelf.heightForCommentTableView = UIScreen.main.bounds.height - 64 - strongSelf.inputbar.height// + strongSelf.inputbar.top
                    strongSelf.commentTableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: strongSelf.heightForCommentTableView)
                    
                    let favStatus = model?.data?.favStatus ?? ""
                    let favStatusNum = Int(favStatus) ?? 0
                    strongSelf.setCollectionState(favStatusNum == 1)
                    strongSelf.headerView.setValueWithModel(model)
                    
                }
                
            }else{
                
                if model == nil {
                    strongSelf.showNetErrorView(nil)
                } else {
                    if error?._code == 21403 {
                        //文章被删除
                        if (error?._domain.length())! > 0 {
                            _ = strongSelf.showToastHidenDefault(error?._domain)
                        }
                        
//                        if !strongSelf.isFromPush {
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
        })
    }
    
    //MARK: - webView相关
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        //用户选择
        let jsSelect = "document.documentElement.style.webkitUserSelect='none';"
        webView.stringByEvaluatingJavaScript(from: jsSelect)
        //用户长按
        let jsTouch = "document.documentElement.style.webkitTouchCallout='none';"
        webView.stringByEvaluatingJavaScript(from: jsTouch)
        
        var height = CGFloat(0.0)
        webView.height = height
        if let docHeightString = webView.stringByEvaluatingJavaScript(from: "document.body.scrollHeight") {
            let docHeight = Float(docHeightString) ?? 0
            height = CGFloat(docHeight) + 10
            
            //重新check 对比一下
            let time = DispatchTime.now() + Double(Int64(1*NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: time, execute: { 
                self.headerView.headerWebView.height = 1
                let nheight = webView.stringByEvaluatingJavaScript(from: "document.body.scrollHeight")
                if (nheight != docHeightString){
                    
                    height = CGFloat(NSString(string: nheight!).floatValue + 10)
                    self.headerView.webViewheight = height
                    
                    
                    let headerViewHeight = self.headerView.heightForCell(height, model: self.newsDetailModel)
                    
                    self.headerView.frame = CGRect(x: 0, y: 0, width: self.headerView.size.width, height: headerViewHeight)
                    self.headerView.setNeedsUpdateConstraints()
                    
                    
                    self.commentTableView.tableHeaderView = self.headerView
                    
                }else{
                    self.headerView.headerWebView.height = CGFloat(height)
                    self.headerView.setNeedsUpdateConstraints()
                }

            })
            
        }
        
        headerView.webViewheight = height
        let headerHeight = self.headerView.heightForCell(CGFloat(height), model: self.newsDetailModel)
        headerView.frame = CGRect(x: 0, y: 0, width: headerView.size.width, height: headerHeight)
        if #available(iOS 8.0, *) {
        } else {
            headerView.setNeedsUpdateConstraints()
        }

        
        commentTableView.tableHeaderView = headerView
        
        if self.newsDetailModel?.data?.isAd != nil && self.newsDetailModel?.data?.isAd == "1" {
            
        } else {
            self.loadCommentList()
            
            self.addFooterRefreshView(commentTableView) {[weak self] () -> Void in
                self?.footRefreshAction()
            }
            self.commentTableView.footer?.bottom = self.commentTableView.contentSize.height
        }
        
        
        //self.registerWebJsHandler()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if navigationType == .linkClicked {
            let urlString: String! = request.url?.absoluteString ?? ""
            
            if urlString.range(of: "static.lanjinger.com/data/page/aboutUs") == nil {
                self.event(forName: "AD_newsdetail_click", attr: nil)
            }
            
            PushManager.sharedInstance.handleOpenUrl(urlString)
            return false
        }
        return true
    }
    
    /**
    *  点赞
    */
    @objc func newsDetailHeaderViewPraiseButtonClick(headerView: NewsDetailHeaderView, button: UIButton) {
        
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
                    strongSelf.newsDetailModel?.data?.isZan = "1"
                }else{
                    _ = strongSelf.showToastHidenDefault(error?._domain)
                }
            }
        }
    }
    
    override func addCommentNum() {
         self.headerView.addCommentNum()
    }
    
    override func refreshAction (){
        self.loadNewsDetail()
    }
}
