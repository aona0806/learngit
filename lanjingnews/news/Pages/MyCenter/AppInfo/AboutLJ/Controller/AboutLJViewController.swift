//
//  AboutLJViewController.swift
//  news
//
//  Created by 奥那 on 15/12/9.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

class AboutLJViewController: LJBaseViewController , UIWebViewDelegate {
    
    var aboutView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "关于蓝鲸财经"
        self.setupNavigationbarRightItem()
        aboutView = UIWebView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-64))
        aboutView.delegate = self
        self.view.addSubview(aboutView)
        
        var path = ""
        let status = TKNetworkManager.sharedInstance()!.networkStatus() as NetworkStatus
        switch status {
        case NotReachable:
            path = Bundle.main.path(forResource: "About.html", ofType: nil)!
            break;
        default:
            path = "https://static.lanjinger.com/data/page/aboutUsApp.html"
            break;
        }
        
        let request = NSURLRequest(url: NSURL(string: path)! as URL , cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData , timeoutInterval: 60)
        aboutView.loadRequest(request as URLRequest)
        
    }
    
    func setupNavigationbarRightItem(){
        let rightItem = UIBarButtonItem.createItem(withTarget: self, action: #selector(NewsDetailTableViewController.shareButtonClick), image: "newsdetail_share")
        self.navigationItem.rightBarButtonItem = rightItem!
    }
    
    func shareButtonClick() {
        var shareView = ShareView(delegate: nil, shareObj: nil, hideLanjing: true)
        // 关于我们 web分享 只向外分享
        if AccountManager.sharedInstance.verified() == "1"{
            shareView = ShareView(delegate: nil, shareObj: nil, hideLanjing: true)
        }
        
        
        shareView.shareTapAction = {[weak self](type, shareView, shareObj) in
            guard let strongSelf = self else {
                return
            }
            //分享内容，PM确定
            let shareContent : String = "提供中国最专业的财经记者工作平台，以及基于平台交互产生的原创财经新闻。"
            let urlString = "https://static.lanjinger.com/data/page/aboutUsApp.html"
            let title = "关于蓝鲸财经"
            ShareAnalyseManager.sharedInstance().shareWeb(type, presentController: strongSelf, shareUrl: urlString, shareTitle: title, shareContent: shareContent,  completion: { (success, error) in
                if success {
                    strongSelf.showToastHidenDefault("分享成功")
                } else {
                    strongSelf.showToastHidenDefault("分享失败")
                }
            })
        }
        
        let window = UIApplication.shared.keyWindow
        shareView.show(window, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        let url = NSURL.init(string:Bundle.main.path(forResource: "About.html", ofType: nil)!)
        webView.loadRequest(NSURLRequest.init(url: url! as URL) as URLRequest)
    }
    
}
