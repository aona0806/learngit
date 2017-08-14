//
//  TweetOperationDelegate.swift
//  news
//
//  Created by chunhui on 15/12/29.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import Foundation

class TweetOperationDelegate: NSObject , ShareViewProtocol {

    weak var controller : UIViewController?
    var photoBrowser : FSPhotoBrowserHelper?
    var shareLanjing : ((_ tweet : LJTweetDataContentModel)->())?
    var from : String = ""
    
    init(controller: UIViewController) {
        self.controller = controller
        super.init()
    }
    
    func tapCellAction(_ cell : TweetTableViewCell , info : LJTweetDataContentModel , type : TweetTapTap  , extra : Any? ){
        
        switch type {
        case .author:
            
            self.showAuthor(info)
            
        case .forwardAuthor:
            
            showForwardAuthor(info)
            
        case .image:
            
            self.showImage(info , imgInfo:extra as? Dictionary<String , AnyObject>)
            
        case .forward:
            forwardTweet(info)
            
        case .urlLink:
            
            let url = extra as? String
            if (url?.length())! > 0 {
                showLinkUrl(url!)
            }
            
        case .atAuthor:
            
            let uid = extra as? String
            if (uid?.length())! > 0 {
                showAtAuthor(uid!)
            }
            
        case .jump:
            
            showJumInfo(info)
            
        default:
            break
            
        }
        
    }
    
    func praiseTweet(_ info :LJTweetDataContentModel , completion:((_ success : Bool , _ errMsg : String?)->())?){
        
        TKRequestHandler.sharedInstance().praise(!info.praise!.flag, withTid: info.tid) { (taks, success, error) -> Void in
            
            completion?(success, error?._domain)
            
        }
    }
    
    
    private func showForwardAuthor(_ info : LJTweetDataContentModel){
        
        self.showUserInfo(info.originTopic?.uid ?? "")
    }
    
    private func showAuthor(_ info : LJTweetDataContentModel){
        
        self.showUserInfo(info.uid ?? "")
        
    }
    
    private func showAtAuthor(_ uid : String){
        
        self.showUserInfo(uid)
        
    }
    
    private func showImage(_ info: LJTweetDataContentModel , imgInfo: Dictionary<String , AnyObject>!){
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { 
            MobClick.event(self.from + "_photos")
        }
        
        if photoBrowser == nil {
            photoBrowser = FSPhotoBrowserHelper()
        }
        
        if imgInfo != nil {

            var index = 0
            var liftImageView : UIImageView? = nil
            var placeholders = [UIImage]()
            
            index = imgInfo["index"] as! Int
            liftImageView = imgInfo["imageView"] as? UIImageView
            if let imgs = imgInfo["imgs"] as? Array<UIImage> {
                placeholders.append(contentsOf: imgs)
            }
            
            photoBrowser?.currentIndex = Int32(index)
            photoBrowser?.liftImageView = liftImageView
            photoBrowser?.placeHolderImages = placeholders
            
            photoBrowser?.images = info.img
            
            photoBrowser?.show()
        }
        
        
    }
    
    private func forwardTweet(_ info :LJTweetDataContentModel){
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            MobClick.event(self.from + "_share")
        }
        let shareView = ShareView(delegate: self, shareObj: info)
        let window = UIApplication.shared.keyWindow
        shareView.show(window, animated: true)
        
    }
    
    private func commentTweet(_ info:LJTweetDataContentModel){
        
    }
    
    private func showJumInfo(_ info: LJTweetDataContentModel){
        
        let extends = info.extends
        
        let data = extends?.data(using: String.Encoding.utf8)
        do{
            let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? NSDictionary
            
            if let jmp = json!["jump"] as? String {
                
                PushManager.sharedInstance.handleOpenUrl(jmp)
                
            }else{
                
                var timeInterval : Double? = nil
                
                if  let time = json!["time"] as? String {
                    
                     timeInterval = Double(time)
                
                }else if let time = json!["time"] as? NSNumber {
                    
                    timeInterval = time.doubleValue
                }
                
                if timeInterval != nil  {
                    
                    let date = Date(timeIntervalSince1970: timeInterval!)
                    
                    let timeController = LJTimeAxisTableViewController()
                    timeController.date = date
                    timeController.hidesBottomBarWhenPushed = true
                    self.controller?.navigateTo(timeController)
                }
            }
            
        } catch let error {
            
            print("exception is: \(error)\n\n")
            
        }
        
    }
    
    private func showLinkUrl(_ url : String){
        
        let moduleWebView = self.controller?.moduleWebView(withUrl: url)
        self.controller?.navigateTo(moduleWebView!);
    }
    
    
    private func showUserInfo(_ uid : String){
        //跳转用户信息页面
        var str = ""
        if from == "News"{
            str = "News_userdetail"
        }else if from == "Comm"{
            str = "Comm_detail"
        }
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            MobClick.event(str)
        }
        
        let userInfoController = LJUserDeltailViewController.init()
        userInfoController.uid = uid
        userInfoController.hidesBottomBarWhenPushed = true
        self.controller?.navigateTo(userInfoController)
        
    }
    
    // MARK: - share delegate
    func shareAction(_ type : ShareType , shareView:ShareView , shareObj: AnyObject?) -> Void {
        
        let tweet = shareObj as? LJTweetDataContentModel
        
        ShareAnalyseManager.sharedInstance().shareTweet( type, tweet: tweet! , presentController: self.controller!) { (success, error) -> () in
            
            _ = self.controller?.showShareCoinToast(type, isSuccess: success, type: .tweet, error: error)
        }
        
    }
    
}
