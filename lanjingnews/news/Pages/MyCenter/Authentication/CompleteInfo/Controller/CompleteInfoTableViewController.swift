//
//  CompleteInfoTableViewController.swift
//  news
//
//  Created by 奥那 on 16/1/7.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class CompleteInfoTableViewController: LJBaseTableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    private let titleList = ["真实姓名","身份","所在城市","报道条线","所在公司","职务","入职时间"]
    private let indentifier = "MyInfoConfig"
    var userInfo = LJUserInfoModel()
    var dataList:Array<String>? = nil
    private let headerView = CompleteInfoHeaderView()
    
    private var pickerControllers = Array<MyInfoPickerViewController>()
    private var districtData : Array<Dictionary<String , Array<String>>>? = nil
    
    private var nameTextField = UITextField()
    private var kindTextField = UITextField()
    private var cityTextField = UITextField()
    private var industryTextField = UITextField()
    private var companyTextField = UITextField()
    private var jobTextField = UITextField()
    private var timeTextField = UITextField()
    
    override func viewDidLoad() {
        self.customBackItem = true
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.rgb(0xe8e8e8)
        self.title = "完善资料"
        self.tableView.tableFooterView = UIView()
        
        customTableViewHeader()
        registerCell()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CompleteInfoTableViewController.refreshIndustry(_:)), name: NSNotification.Name(rawValue: GlobalConsts.Notification_MyCenterIndustryDidChanged), object: nil)
        
        //获取通讯录
        ReadAllPeoples()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        userInfo = AccountManager.sharedInstance.getUserInfo()!
        if userInfo.sname == nil{
            requestUserInfo()
        }
        updateAvatar()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        if let navContoller = self.navigationController {
            let topOffset = navContoller.navigationBar.bottom - GlobalConsts.NormalNavbarHeight
            
            self.tableView.contentInset = UIEdgeInsetsMake(topOffset, 0, 0, 0)
        }
        
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
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
               strongSelf.dataList = strongSelf.userInfo.toCompleteUserModifyArray() as? Array<String>
                
                strongSelf.tableView.reloadData()
                strongSelf.updateAvatar()
            }
        })
    }
    
    /**
    自定义header
    */
    func customTableViewHeader(){
        
        headerView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: 110)
        headerView.clickAvatar = changeAvatar
        self.tableView.tableHeaderView = headerView
    }
    
    func updateAvatar(){
        if userInfo.avatar != nil{
            headerView.imageView.sd_setImage(with: URL(string: userInfo.avatar!), placeholderImage: UIImage(named: "myInfo_default_headerImage"))
        }
    }
    
    /**
     注册cell
     */
    func registerCell(){
        
        self.tableView.register(UINib.init(nibName: "MyInfoConfigCell", bundle: nil), forCellReuseIdentifier: indentifier)

    }
    
    /**
     点击确认
     */
    func commitAction(){
//        let controller = RecommendFriendsTableViewController()
//        self.navigateTo(controller)
        let result = checkInput()
        if result.length() != 0{
            
            _ = self.showToastHidenDefault(result)
            return
        }
        TKRequestHandler.sharedInstance().postCompleteInfo(with: userInfo) { (sessionDataTask, response, error) -> Void in
            
            if error != nil{
                _ = self.showToastHidenDefault(error?._domain)

                return
            }
            let dic = response as? NSDictionary
            let code = dic!["errno"] as! NSNumber
            if code == 0{
                //提交成功 保存数据
                self.userInfo.token = AccountManager.sharedInstance.token()
                AccountManager.sharedInstance.updateAccountInfo(self.userInfo)
                NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConsts.kUserAvatarDidChanged), object: nil)
                
                let controller = RecommendFriendsTableViewController()
                self.navigateTo(controller)
            }else{
                let msg = (dic!["msg"] as? String) ?? GlobalConsts.NetErrorNetMessage
                _ = self.showToastHidenDefault(msg)
            }
        }
        
    }
    
    /**
     点击头像
     */
    func changeAvatar(_ imageView:UIImageView){
        
        let sheet = UIActionSheet.bk_actionSheet(withTitle: nil) as! UIActionSheet
        weak var weakSelf : CompleteInfoTableViewController? = self
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
                let data = dic["data"] as? NSDictionary
                let url = data!["url"] as? String
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

                    strongSelf.headerView.imageView.image = image
                    
                }else{
                    hud.detailsLabel.text = error?._domain
                }
                hud.hide(animated: true, afterDelay: 1)
            })
            
        })
    }
  
    func initInputView(_ name: String ,textField: UITextField){
        switch name{
        case "真实姓名":
            nameTextField = textField
            
        case "身份":
            let data = ["普通用户","记者","专家"]
            makePicker(textField, data: data, mulData: nil)
            kindTextField = textField

        case "所在城市":
            cityTextField = textField
            if self.districtData == nil {
                let path = Bundle.main.path(forResource: "district.json", ofType: nil)
                if path != nil {
                    let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
                    self.districtData  = (try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)) as! Array<Dictionary<String , Array<String>>>?
                }
            }
            makePicker(textField, data: nil, mulData: self.districtData)
        
        case "报道条线":
            industryTextField = textField
            
        case "所在公司":
            companyTextField = textField
            
        case "职务":
            jobTextField = textField
            
        case "入职时间":
            makeDatePicker(textField)
            timeTextField = textField
        default:
            return
        }
    }
    
    func makeDatePicker(_ textField : UITextField ){
        
        let picker = UIDatePicker()
        picker.datePickerMode = UIDatePickerMode.date
        picker.locale = Locale(identifier: "zh_Hans_CN")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        let date = "2010-01-01"
        let joinDate = formatter.date(from: date)
        if joinDate != nil {
            picker.date = joinDate!
        }
        textField.inputView=picker
        
        let toolbar = UIToolbar()
        var frame = self.view.frame
        frame.size.height = 44
        toolbar.frame = frame
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        
        let rightItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(CompleteInfoTableViewController.chooseDate))
        let leftItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(CompleteInfoTableViewController.cancelChooseDate))
        let paddingItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([leftItem,paddingItem,rightItem], animated: false)
        
        textField.inputAccessoryView = toolbar
    }
    
    func makePicker(_ textField : UITextField , data : Array<String>? , mulData :Array<Dictionary<String , Array<String>>>? ){
        let picker = UIPickerView()
        var frame = self.view.frame
        frame.size.height = 162
        picker.frame = frame
        let pickerController = MyInfoPickerViewController()
        pickerController.dataArray = data
        pickerController.multiDataArray = mulData
        
        pickerController.textField = textField
        picker.backgroundColor = UIColor.clear
        picker.delegate = pickerController
        picker.dataSource = pickerController
        picker.showsSelectionIndicator = true
        textField.inputView=picker
        
        self.pickerControllers.append(pickerController)
        
        let toolbar = UIToolbar()
        frame.size.height = 44
        toolbar.frame = frame
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        
        let rightItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: pickerController, action: #selector(MyInfoPickerViewController.pickerDone))
        let leftItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: pickerController, action: #selector(MyInfoPickerViewController.pickerCancel))
        let paddingItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([leftItem,paddingItem,rightItem], animated: false)
        
        textField.inputAccessoryView = toolbar
    }
    
    func refreshIndustry(_ sender : Notification){
        
        let arr = (sender.object) as! Array<String>
        let industry = NSArray(array: arr)
        self.industryTextField.text = industry.componentsJoined(by: " | ")
        
    }
    
    /**
     设置占位字符
     */
    func setupPlaceholder(_ title: String, textField: UITextField){
        switch title{
        case "真实姓名":
            textField.placeholder = "注册须实名，且填写后无法变更"
        case "身份":
            let placeString = "一旦选择，无法更改"
            let attributedString = NSMutableAttributedString(string: placeString)
            let placeColor = UIColor.rgba(200, green: 20, blue: 20, alpha: 1)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: placeColor, range: NSMakeRange(0, placeString.length()))
            textField.attributedPlaceholder = attributedString
        default:
            break
        }
    }
    
    /**
     检查输入是否符合要求
     */
    func checkInput() -> String{
        
        //默认头像的后缀 /lanjingapp/avatar/20150410/avatar.png
        let isDefault = NSString(string: userInfo.avatar!).range(of: "/lanjingapp/avatar/20150410/avatar.png").location != NSNotFound
        
        if isDefault{
            return "请上传真实头像"
        }
        if nameTextField.text!.length() == 0{
            return "请输入真实姓名"
        }
        if kindTextField.text?.length() == 0{
            return "请选择身份"
        }
        if cityTextField.text?.length() == 0{
            return "请选择所在城市"
        }
        if industryTextField.text?.length() == 0{
            return "请选择报道条线"
        }
        if companyTextField.text!.length() == 0{
            return "请填写所在公司"
        }
        if jobTextField.text?.length() == 0{
            return "请填写职务"
        }

        if timeTextField.text?.length() == 0{
            return "请选择入职时间"
        }

        userInfo.sname = nameTextField.text
        userInfo.ukind = userInfo.convertUkindVerifyBack(kindTextField.text)
        userInfo.company = companyTextField.text
        userInfo.companyJob = jobTextField.text
        userInfo.city = cityTextField.text
        userInfo.companyJionTime = timeTextField.text?.components(separatedBy: " ").first
        userInfo.followIndustry = userInfo.convertIndustry(toLJUserInfoIndustryModel: industryTextField.text)  //userInfo.convertIndustry(toljUserInfoIndustryModel: industryTextField.text)
        
        return ""
    }
    
    func addAccessoryTypeWithTitle(_ title:String) -> Bool{
        switch title{
        case "身份","所在城市","报道条线","入职时间":
            return true
        default:
            return false
        }
    }
    
    //MARK: -UITableViewDelegate UITableDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 4
        }
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: indentifier) as! MyInfoConfigCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.isMyInfo = "myInfo"
        
        let count = (indexPath as NSIndexPath).section * 4 + (indexPath as NSIndexPath).row
        let text = titleList[count]
        cell.titleLB.text = text
        if dataList != nil{
            cell.inputContent.text = dataList![count]
        }
        
        initInputView(text, textField: cell.inputContent)
        setupPlaceholder(text, textField: cell.inputContent)
        
        if addAccessoryTypeWithTitle(text){
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }

        if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 3{
            cell.inputContent.isUserInteractionEnabled = false
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1{
            let view = AppInfoFooterView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 60))
            view.clickAction = commitAction

            view.sender?.setTitle("确认", for: UIControlState())
            return view
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1{
           return 60
        }
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return CGFloat.leastNormalMagnitude
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 3{
            self.view.endEditing(true)
            let controller = SelectIndustryTableViewController()
            controller.hidesBottomBarWhenPushed = true
            navigateTo(controller)
        }
    }
    
    //MARK: - imagepicker delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        picker.dismiss(animated: true, completion: { () -> Void in
            let mediaType = info[UIImagePickerControllerMediaType] as! String
            if (mediaType == "public.image") {
                let photo = info[UIImagePickerControllerEditedImage] as! UIImage
                let minPhoto = ImageHelper.resize(photo, maxWidth: 1024)
                self.headerView.imageView.image = minPhoto
                
                self.updateHeadImageView(minPhoto!)
            }
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: { () -> Void in
            
        })
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.view.endEditing(true)
    }
    
    //MARK: - date picker delegate
    func chooseDate(){
        
        let picker = timeTextField.inputView  as! UIDatePicker
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日"
        timeTextField.text = formatter.string(from: picker.date)+"    至今"
        timeTextField.endEditing(true)
    }
    
    func cancelChooseDate(){
        timeTextField.endEditing(true)
    }
    
    /**
    *  上传用户通讯录
    */
    func ReadAllPeoples(){
        
        TKRequestHandler.sharedInstance().postAddressListFinish { (sessionDataTask, response, error) -> Void in
        
        }
        
    }
    
        
}
