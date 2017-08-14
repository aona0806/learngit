//
//  MyInfoConfigTableViewController.swift
//  news
//
//  Created by 奥那 on 15/12/8.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

class MyInfoConfigTableViewController: LJBaseTableViewController , UITextViewDelegate{
    
    private let rowNum = [4,4,3,1]
    private let data = [["真实姓名","性别","身份认证","报道条线"],["手机号","邮箱","所在城市","权限"],["所在公司","职务","时间"]]
    
    private let MyInfoConfig = "MyInfoConfig"
    private let introduceCell = "introduceCell"
    private var pickerControllers = Array<MyInfoPickerViewController>()
    var districtData : Array<Dictionary<String , Array<String>>>? = nil
    
    var sexTextField = UITextField()
    var industryTextField = UITextField()
    var companyTextField = UITextField()
    var companyJobTextField = UITextField()
    var companyJoinTimeTextField = UITextField()
    var emailTextField = UITextField()
    var cityTextField = UITextField()
    var privacyTextField = UITextField()
    var introduceTextView = UITextView()
    
    var myInfo = LJUserInfoModel()
    var industryStr = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "我的资料"
        
        self.initNavigationbar()
        
        registerCell()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MyInfoConfigTableViewController.refreshIndustry(_:)), name: NSNotification.Name(rawValue: GlobalConsts.Notification_MyCenterIndustryDidChanged), object: nil)
    }
    
    init(){
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit{
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
     
    func refreshIndustry(_ sender : Notification){

        let arr = (sender.object) as! Array<String>
        let industry = NSArray(array: arr)
        
        var inArray = [LJUserInfoIndustryModel]()
        for title in arr {
            let model = LJUserInfoIndustryModel()
            model.title = title
            inArray.append(model)
        }
        
        myInfo.followIndustry = inArray
        self.industryTextField.text = industry.componentsJoined(by: " | ")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     自定义Navigation
     */
    private func initNavigationbar(){
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.done, target: self, action: #selector(MyInfoConfigTableViewController.saveAction))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.defaultLeftItem(withTarget: self, action: #selector(MyInfoConfigTableViewController.backAction))

    }

    override func backAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func registerCell(){
        
        self.tableView.register(UINib.init(nibName: "MyInfoConfigCell", bundle: nil), forCellReuseIdentifier: MyInfoConfig)

        self.tableView.register(UINib.init(nibName: "IntroduceMyselfCell", bundle: nil), forCellReuseIdentifier: introduceCell)
    }
    
    /**
     保存
     */
    func saveAction(){
        
        self.tableView.endEditing(true)
        
        changeMyInfo()
        
        if !checkSavedCondition(){
            return
        }
        
        TKRequestHandler.sharedInstance().postUserInfo(with: myInfo) { (responses , error) -> Void in

            if error == nil {
                _ = self.showPopHud("保存成功", hideDelay: 0.5)
                _ = self.navigationController?.popViewController(animated: true)
            }else{
                let message: String = error!._domain
                _ = self.showToastHidenDefault(message)
            }
        }
        
    }
    
    func changeMyInfo (){
    
        myInfo.sex = sexTextField.text
        myInfo.followIndustry = myInfo.convertIndustry(toLJUserInfoIndustryModel:industryTextField.text!) //convertIndustry(to: industryTextField.text!)
        myInfo.company = companyTextField.text
        myInfo.companyJionTime = companyJoinTimeTextField.text
        myInfo.uemail = emailTextField.text
        myInfo.city = cityTextField.text
        myInfo.privacy = privacyTextField.text
        myInfo.companyJob = companyJobTextField.text

        myInfo.intro = introduceTextView.text
        
    }
    
    func itemIsEditable(_ name: String) -> Bool {
        switch name {
            case "真实姓名","身份认证","手机号","报道条线":
                return false
        default:
            return true
        }
    }

    func initInputView(_ name: String ,textField: UITextField){
        switch name{
        case "性别":
            let data = ["女","男","保密"]
            makePicker(textField, data: data, mulData: nil)
        case "时间":
            makeDatePicker(textField)
        case "所在城市":
            if self.districtData == nil {
                let path = Bundle.main.path(forResource: "district.json", ofType: nil)
                if path != nil {
                    let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
                    self.districtData  = (try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)) as! Array<Dictionary<String , Array<String>>>?
                }
            }
            makePicker(textField, data: nil, mulData: self.districtData)
        case "权限":
            let data = ["所有人可见","好友可见","花费蓝鲸币"]
            makePicker(textField, data: data, mulData: nil)        default:
            return
        }
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
        
        let rightItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(MyInfoConfigTableViewController.chooseDate))
        let leftItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(MyInfoConfigTableViewController.cancelChooseDate))
        let paddingItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([leftItem,paddingItem,rightItem], animated: false)
        
        textField.inputAccessoryView = toolbar
    }
    
    func updateMyInfo(_ name: String , textField: UITextField){
        switch name{
        case "真实姓名":
             textField.text = myInfo.sname
        case "性别":
            textField.text = myInfo.convertSex(myInfo.sex)
            sexTextField = textField
        case "身份认证":
            textField.text = myInfo.convertUkindVerify(myInfo.ukind)
        case "报道条线":
            textField.text = myInfo.convertIndustry(myInfo.followIndustry)
            industryTextField = textField
        case "所在公司":
            textField.text = myInfo.company
            companyTextField = textField
        case "职务":
            textField.text = myInfo.companyJob
            companyJobTextField = textField
        case "时间":
            textField.text = myInfo.companyJionTime
            companyJoinTimeTextField = textField
        case "手机号":
            textField.text = myInfo.uname
            break
        case "邮箱":
            textField.text = myInfo.uemail
            emailTextField = textField
        case "所在城市":
            textField.text = myInfo.city
            cityTextField = textField
        case "权限":
            textField.text = myInfo.convertPrivacy(myInfo.privacy)
            privacyTextField = textField
        default:
            return
        }
    }
    
    /**
     验证邮箱是否符合标准
    */
    func checkSavedCondition() -> Bool{
        let mail: String! = self.emailTextField.text
        let mailString: NSString = mail as NSString
        
        if mailString.length != 0 && mailString.range(of: "@").location == NSNotFound {
            
            _ = self.showToastHidenDefault("输入email格式错误")
            return false
        }
        return true
    }
    
    
    //MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return rowNum.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowNum[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath as NSIndexPath).section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: introduceCell) as! IntroduceMyselfCell
            cell.introduceTextView?.delegate = self
            cell.introduce = self.myInfo.intro
            self.introduceTextView = cell.introduceTextView
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: MyInfoConfig) as! MyInfoConfigCell
            cell.isMyInfo = "myInfo"
            let text = data[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
            cell.titleLB?.text = text
            cell.inputContent?.isUserInteractionEnabled = itemIsEditable(text)
            
            initInputView(text, textField: cell.inputContent!)
            updateMyInfo(text, textField: cell.inputContent)
            
            return cell
        }
    }
    
    //MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        var height = CGFloat(10.0)
        
        if section == 0 {
            if let navContoller = self.navigationController {
                height += navContoller.navigationBar.bottom - GlobalConsts.NormalNavbarHeight
            }
        }
        
        return height
        
    }
    

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 3 {
            return 100
        }
        return 44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 3{
            self.view.endEditing(true)
            let controller = SelectIndustryTableViewController()
            controller.industryArr = myInfo.convertIndustry(to: myInfo.followIndustry) as! Array<String>
            controller.hidesBottomBarWhenPushed = true
            navigateTo(controller)
        }
    }

    // MARK: - UIScrollViewDelegate
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate dxecelerate: Bool) {
        self.tableView.endEditing(true)
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        if  textView.markedTextRange  == nil{
            
            if textView.text.length() > 50{
               textView.text = textView.text.substring(to: textView.text.index(textView.text.startIndex, offsetBy: 50))
                _ = self.showHud("自我介绍内容需少于50字", hideDelay: 1.3)
                textView.contentOffset.y = 0
            }
        }
    }

    //MARK: - date picker delegate
    func chooseDate(){
        
        let picker = companyJoinTimeTextField.inputView  as! UIDatePicker
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日"
        companyJoinTimeTextField.text = formatter.string(from: picker.date)+"    至今"
        companyJoinTimeTextField.endEditing(true)
    }
    
    func cancelChooseDate(){
        companyJoinTimeTextField.endEditing(true)
    }

}


