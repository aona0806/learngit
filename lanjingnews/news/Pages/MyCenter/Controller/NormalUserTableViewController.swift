//
//  NormalUserTableViewController.swift
//  news
//
//  Created by 奥那 on 16/1/4.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class NormalUserTableViewController: LJBaseTableViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    let headerCellIdentifier = "normalInfo"
    let cellIdentifier = "cell"
    let titleList = [["我的资料","我的收藏","记者认证通道", "我的活动"], ["应用设置","推送设置"]]
    let iconList = [["myInfo_info","myInfo_collection","myInfo_authentication", "myInfo_activity"],["myInfo_appSetting","myInfo_pushset"]]
    var userInfo = LJUserInfoModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.rgb(0xe8e8e8)
        self.tableView.tableFooterView = UIView()
        self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0)
        
        registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.userInfo = AccountManager.sharedInstance.getUserInfo()!
        requestUserInfo()
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     注册cell
     */
    func registerCell(){
        
        self.tableView.register(UINib(nibName: "NormalUserInfoHeaderCell", bundle: nil), forCellReuseIdentifier: headerCellIdentifier)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    /**
     返回
     */
    override func backAction(){
        _ = self.navigationController?.popViewController(animated: true)
        _ = self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    /**
     请求个人资料
     */
    func requestUserInfo(){
        
        let uid = AccountManager.sharedInstance.uid()
        TKRequestHandler.sharedInstance().getUserInfo(withUid: uid , finish:  { [weak self](task, model, error) -> Void in
            
            guard let strongSelf = self else {
                return
            }
            
            if error != nil{
                _ = strongSelf.showToastHidenDefault(error!._domain)
                return
            }else if model != nil{
                
                if model?.dErrno.intValue != 0{
                    return
                }
                strongSelf.userInfo = (model?.data)!
                strongSelf.userInfo.token = AccountManager.sharedInstance.token();
                AccountManager.sharedInstance.updateAccountInfo(strongSelf.userInfo)
                strongSelf.tableView.reloadData()
            }
        })
    }
    
    /**
     点击头像
    */
    func clickAvatar(){

        let sheet = UIActionSheet.bk_actionSheet(withTitle: nil) as! UIActionSheet
        weak var weakSelf : NormalUserTableViewController? = self
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
    
    /**
     更新头像
     */
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
                }
                hud.hide(animated: true, afterDelay: 1)
            }
        }
    }
    
    /**
     更新用户信息
     */
    func updateUserInfo(_ image : UIImage , hud :MBProgressHUD){
        
        TKRequestHandler.sharedInstance().postUserInfo(with: self.userInfo, finish: { [weak self](response, error) -> Void in
            
            DispatchQueue.main.async(execute: {
                
                guard let strongSelf = self else {
                    return
                }
                
                if error == nil {
                    hud.label.text = "同步成功"
                    
                    let cell = strongSelf.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! NormalUserInfoHeaderCell
                    cell.avatarImage.image = image
                    
                }else{
                    hud.detailsLabel.text = error!._domain
                }
                hud.hide(animated: true, afterDelay: 1)
            })
            
        })
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
        if section != 0 {
            count = titleList[section - 1].count
        }
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath as NSIndexPath).section == 0{

            let cell = tableView.dequeueReusableCell(withIdentifier: headerCellIdentifier) as! NormalUserInfoHeaderCell
            cell.backClick = backAction
            cell.imageClick = clickAvatar
            cell.model = userInfo
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)! as UITableViewCell
            cell.textLabel?.text = titleList[(indexPath as NSIndexPath).section - 1][(indexPath as NSIndexPath).row]
            cell.imageView?.image = UIImage(named: iconList[(indexPath as NSIndexPath).section - 1][(indexPath as NSIndexPath).row])
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var controller:UIViewController? = nil
        if (indexPath as NSIndexPath).section == 1{
            
            switch (indexPath as NSIndexPath).row{
                
            case 0:
                let vc = NormalUserInfoConfigTableViewController()
                if userInfo.uid != nil{
                   vc.userInfo = userInfo.copy() as! LJUserInfoModel
                }
                
                controller = vc
                
            case 1:

                let vc = MyFavoriteViewController(type: FavoriteViewContollerType.myFavorite)
                controller = vc
            case 2:
                
                let bindCode = userInfo.bind_invite_code! as NSNumber
                if bindCode == 0{
                    controller = AuthenticationTableViewController()
                }else{
                    controller = CompleteInfoTableViewController(style:.grouped)
                }
            case 3:
                let vc = MyFavoriteViewController(type: FavoriteViewContollerType.myActivity)
                controller = vc
            default :
                break
            }
        }else if (indexPath as NSIndexPath).section == 2{
            
            switch (indexPath as NSIndexPath).row{
            case 0://应用设置
                let vc = AppSettingTableViewController()
                vc.isNormal = false
                controller = vc
                
            case 1://推送设置
                self.event(forName: "UserCenter_PushSet_Click", attr: nil)
                controller = RollPushSetController()
                
            default:
                return
            }
        }
        
        if controller != nil{
            controller!.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller!, animated: true)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 10;
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(0xe8e8e8)
        return view
    }
    
    //MARK: - imagepicker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        picker.dismiss(animated: true, completion: { () -> Void in
            let mediaType = info[UIImagePickerControllerMediaType] as! String
            if (mediaType == "public.image") {
                let photo = info[UIImagePickerControllerEditedImage] as! UIImage
                let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! NormalUserInfoHeaderCell
                
                let minPhoto = ImageHelper.resize(photo, maxWidth: 1024)
                cell.avatarImage.image = minPhoto
                
                self.updateHeadImageView(minPhoto!)
            }
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: { () -> Void in
            
        })
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
