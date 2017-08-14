//
//  NewsPushRemindViewController.swift
//  news
//
//  Created by wxc on 2017/1/11.
//  Copyright © 2017年 lanjing. All rights reserved.
//

import UIKit

class NewsPushRemindViewController: LJBaseViewController {
    let NewsPushRemindKey = "_NewsPushRemindKey"
    
    var remindView = NewsPushRemindView()
    var isLoadSuccess = false
    
    var pushArray:[LJPushInfoDataConfigTelegraphModel]?
    
    var pushModel:LJPushInfoDataConfigModel?
    
    var isHomePage = false //是否为首页
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = remindView
        
        remindView.pushConfirmAction = {
            [weak self] in
            self?.updatePushInfo()
            self?.event(forName: "News_Record_comfire", attr: nil)

        }
    }
    
    func checkNeedPushRemind() {
        if !UserDefaults.standard.bool(forKey: NewsPushRemindKey){
            isHomePage = true
            if pushArray != nil && pushArray!.count > 0 {
                self.showRemind()
            }else{
                self.loadRemindData()
            }
        }
    }
    
    func cancelShowNeedPushRemind(){
        isHomePage = false
    }
    
    //拉取设置信息
    func loadRemindData() {
        TKRequestHandler.sharedInstance().getPushInfo {[weak self] (sessionDataTask, model, error) -> Void in
            guard self != nil else {
                return
            }
            
//            if error != nil || model?.data?.config?.telegraph == nil{
//                return
//            }else{
//                if model?.data?.config?.telegraph!.count == 0{
//                    return
//                }
//                strongSelf.isLoadSuccess = true
//                strongSelf.pushModel = model?.data?.config
//                strongSelf.pushArray = model?.data?.config?.telegraph as? [LJPushInfoDataConfigTelegraphModel]
//                strongSelf.showRemind()
//            }
        }
    }
    
    func showRemind() {
        if isHomePage {
            remindView.dataArray = pushArray!
            AppDelegate.mainController().view.addSubview(self.view)
            UserDefaults.standard.set(true, forKey: NewsPushRemindKey)
        }
    }
    
    func updatePushInfo() {
//        pushModel!.telegraph = remindView.dataArray
        
        let hud = MBProgressHUD.showAdded( to: self.view ,animated:true)
        TKRequestHandler.sharedInstance().syncPushInfoConfig(pushModel!) {[weak self] (sessiomDataTask, response, error) -> Void in
            
            hud.hide(animated: true)
            
            guard let strongSelf = self else {
                return
            }
            if error == nil {
                strongSelf.remindView.showKnownViews(success: true)
            }else {
                strongSelf.remindView.showKnownViews(success: false)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
