//
//  LJMyInfoTableViewController.swift
//  news
//
//  Created by chunhui on 15/11/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

class MyInfoTableViewController: LJBaseTableViewController, LJMyInfoHeaderCellDelegate,ShareViewProtocol,UIActionSheetDelegate ,UIImagePickerControllerDelegate , UINavigationControllerDelegate{

    let titles = [["我的资料","我的收藏","邀请好友","绑定用户","我的讨论","我的活动"], ["应用设置","推送设置"]]
    let images = [["myInfo_info","myInfo_collection","myInfo_recommendfriend","myInfo_binding","myInfo_discuss","myInfo_activity"], ["myInfo_appSetting","myInfo_pushset"]]
    var userInfo = LJUserInfoModel()
    let redView = MyInfoRedView()
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "个人中心"
        
        //注册cell
        self.registerCell()

        self.view.backgroundColor = UIColor.red
        self.tableView.backgroundColor =  UIColor.rgb(0xe8e8e8)

        self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        userInfo = AccountManager.sharedInstance.getUserInfo()!
        requestUserInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func registerCell() {
        self.tableView.register(UINib.init(nibName: "LJMyInfoHeaderCell", bundle: nil), forCellReuseIdentifier: "MyInfoHeader")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "commonCell")
    }
    
    private func takePhoto(_ type : UIImagePickerControllerSourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(type){
            
            let imagepicker = UIImagePickerController()
            imagepicker.sourceType = type
            imagepicker.delegate = self
            imagepicker.allowsEditing = true
            
            self.navigationController?.present(imagepicker, animated: true, completion: { () -> Void in
                
            })
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 1
        if section != 0{
            count = titles[section - 1].count
        }
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).section == 0{
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "MyInfoHeader") as! LJMyInfoHeaderCell
            headerCell.delegate = self
            headerCell.userInfo = userInfo
            return headerCell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "commonCell")! as UITableViewCell
            cell.textLabel?.text = self.titles[(indexPath as NSIndexPath).section - 1][(indexPath as NSIndexPath).row]
            cell.imageView?.image = UIImage(named: self.images[(indexPath as NSIndexPath).section - 1][(indexPath as NSIndexPath).row])
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            return cell
        }
    }
    
    //MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 0{
            return 190
        }
        return 45
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2{
            return 30;
        }
        return 10;
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.rgb(0xe8e8e8)
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var controller : UIViewController? = nil
        if (indexPath as NSIndexPath).section == 1{
            switch (indexPath as NSIndexPath).row{
            case 0://我的资料
                let vc = MyInfoConfigTableViewController()
                controller = vc
                if self.userInfo.uid != nil{
                    vc.myInfo = self.userInfo.copy() as! LJUserInfoModel
                }
                
            case 1://我的收藏

                controller = MyFavoriteViewController(type: FavoriteViewContollerType.myFavorite)
                self.event(forName: "UserCenter_favourite", attr: nil)
            case 2://推荐好友
                let shareView = ShareView(delegate: self, shareObj: nil, hideLanjing: true)
                let window = UIApplication.shared.keyWindow
                shareView.show(window, animated: true)
                self.event(forName: "UserCenter_share", attr: nil)
            case 3://绑定用户
                let claimString: String? = AccountManager.sharedInstance.getUserInfo()?.claim
                if (claimString == "0") {
                    controller = LJOldUserLogViewController()
                    controller?.hidesBottomBarWhenPushed = true
                } else if claimString == "1" {
                    let alertView : UIAlertView! = UIAlertView(title: "温馨提示", message: "您已经绑定老用户，请勿重复绑定", delegate: nil, cancelButtonTitle: "取消")
                    alertView.show()
                    return
                }
                
            case 4://我的讨论
                let vc = MyDiscussTableViewController()
                vc.userId = userInfo.uid!
                controller = vc
                self.event(forName: "UserCenter_talk", attr: nil)
            case 5://我的活动
                controller = MyFavoriteViewController(type: FavoriteViewContollerType.myActivity)
                self.event(forName: "UserCenter_Activity", attr: nil)
            default:
                return
            }
        }else if (indexPath as NSIndexPath).section == 2{
            
            switch (indexPath as NSIndexPath).row{
            case 0://应用设置
                let vc = AppSettingTableViewController()
                vc.isNormal = false
                controller = vc
                
            case 1://推送设置
                controller = RemindSetTableViewController()
                self.event(forName: "UserCenter_PushSet_Click", attr: nil)

            default:
                return
            }
        }

        if controller != nil{
            controller?.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller!, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.rgb(0xe8e8e8)
        return footerView
    }
    
    //MARK: - download
    
    func requestUserInfo(){
        
        let uid = AccountManager.sharedInstance.uid()
        TKRequestHandler.sharedInstance().getUserInfo(withUid: uid , finish:  { [weak self](task, model, error) -> Void in
            
            guard let strongSelf = self else {
                return
            }
            if error != nil{
                
            }else if model != nil{
                
                if model?.dErrno.intValue != 0{
                    return
                }
                strongSelf.userInfo = (model?.data)!
                
                strongSelf.tableView.reloadData()
            }
        })
    }
    
    func updateHeadImageView(_ image : UIImage){
        
        let imageData = ImageHelper.image(toData: image)
        let hud = MBProgressHUD.showAdded( to: self.view ,animated:true)
        TKRequestHandler.sharedInstance().postUserInfoAvator(imageData!) { [weak self](sessionDataTask, response, error) -> Void in
            
            guard let strongSelf = self else {
                return
            }

            if error == nil{
                let dic = response as! NSDictionary
                let tempDic = dic["data"] as! NSDictionary
                let url = tempDic["url"] as? String
                if url != nil{
                    strongSelf.userInfo.avatar = url!
                    AccountManager.sharedInstance.updateAvatar(url!, foUid: strongSelf.userInfo.uid!)
                    NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConsts.kUserAvatarDidChanged), object: nil)
                    strongSelf.updateUserInfo(image,hud: hud)
                }

            }else{
                let errMsg = error?._domain
                if errMsg?.length() != 0{
                    hud.label.text = errMsg
                    hud.hide(animated: true, afterDelay: 1)
                }
            }
        }
    }
    
    func updateUserInfo(_ image : UIImage , hud :MBProgressHUD){
        
        TKRequestHandler.sharedInstance().postUserInfo(with: self.userInfo, finish: { [weak self](response, error) -> Void in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async(execute: {
                
                if error == nil {
                    hud.label.text = "同步成功"
                    
                    let cell = strongSelf.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! LJMyInfoHeaderCell
                    cell.headerImage = image
                    
                }else{
                    hud.detailsLabel.text = error!._domain
                }
                hud.hide(animated: true, afterDelay: 1)
            })
            
        })
    }
    
    //MARK: - LJMyInfoHeaderCellDelegate
    
    func clickHeaderImage() {
        
        let sheet = UIActionSheet.bk_actionSheet(withTitle: nil) as! UIActionSheet
        weak var weakSelf : MyInfoTableViewController? = self
        sheet.bk_addButton(withTitle: "拍照") { () -> Void in
            weakSelf!.takePhoto(UIImagePickerControllerSourceType.camera)
        }
        sheet.bk_addButton(withTitle: "从手机相册选择") { () -> Void in
            weakSelf!.takePhoto(UIImagePickerControllerSourceType.photoLibrary)
        }
        
        sheet.bk_setCancelButton(withTitle: "取消") { () -> Void in
            
        }
        
        let window = UIApplication.shared.keyWindow
        sheet.show(in: window!)
        
    }
    
    func clickNumOfFans() {
        let friendListVC = LJFriendsListController()
        self.event(forName: "UserCenter_friend", attr: nil)
        friendListVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(friendListVC, animated: true)
    }
    
    func clickNumOfDollars() {
        let controller = MyDollarsTableViewController()
        controller.dollars = userInfo.gold!
        self.event(forName: "UserCenter_currency", attr: nil)
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func clickBack() {
        _ = self.navigationController?.popViewController(animated: true)
        _ = self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: - imagepicker delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        picker.dismiss(animated: true, completion: { () -> Void in
            let mediaType = info[UIImagePickerControllerMediaType] as! String
            if (mediaType == "public.image") {
                let photo = info[UIImagePickerControllerEditedImage] as! UIImage
                let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! LJMyInfoHeaderCell
                
                let minPhoto = ImageHelper.resize(photo, maxWidth: 1024)
                cell.headerImage = minPhoto
                
                self.updateHeadImageView(minPhoto!)
            }
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: { () -> Void in
            
        })
    }
    
    //MARK: - share delegate
    func shareAction(_ type: ShareType, shareView: ShareView, shareObj: AnyObject?) {
        //分享
        if(shareObj == nil){
            ShareAppHelper.shareApp(type , self)
        }
    }

    //MARK: - scroll view delegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var offset = scrollView.contentOffset
        if offset.y < 0 {
            offset.y = 0
            scrollView.contentOffset = offset
        }
    }

}
