//
//  NormalUserInfoConfigTableViewController.swift
//  news
//
//  Created by 奥那 on 16/1/4.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class NormalUserInfoConfigTableViewController: LJBaseTableViewController {

    private let titleList = ["昵称","性别","邮箱","所在城市","绑定手机"]
    private let infoConfig = "MyInfoConfig"
    var userInfo = LJUserInfoModel()
    var dataList : NSArray? = nil
    
    private var nicknameTextField = UITextField()
    private var sexTextField = UITextField()
    private var emailTextField = UITextField()
    private var cityTextField = UITextField()
    
    private var pickerControllers = Array<MyInfoPickerViewController>()
    var districtData : Array<Dictionary<String , Array<String>>>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的资料"
        
        self.view.backgroundColor = UIColor.rgb(0xe8e8e8)
        self.tableView.tableFooterView = UIView()
        
        customNavigationItem()
        registerCell()
        
        if userInfo.uid != nil{
           dataList = self.userInfo.toNormalUserModifyArray() as NSArray? 
        }
        
        endEditWhenTouch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     注册cell
     */
    func registerCell(){
        self.tableView.register(UINib.init(nibName: "MyInfoConfigCell", bundle: nil), forCellReuseIdentifier: infoConfig)
    }
    
    /**
     自定义Navigation
     */
    func customNavigationItem(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.done, target: self, action: #selector(NormalUserInfoConfigTableViewController.saveAction))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.defaultLeftItem(withTarget: self, action: #selector(NormalUserInfoConfigTableViewController.backAction))
    }
    
    override func backAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    /**
     保存
     */
    func saveAction(){
        self.view.endEditing(true)
        let result = checkInput()
        if result.length() != 0{
            _ = self.showToastHidenDefault(result)
            return
        }

        TKRequestHandler.sharedInstance().postNormalUserInfo(with: userInfo) { [weak self](sessionDataTask, response, error) -> Void in
            
            guard let strongSelf = self else {
                return
            }
            
            if error != nil{
                _ = strongSelf.showToastHidenDefault(error!._domain)
                return
            } else {
                let msg = "修改成功"
                _ = strongSelf.showPopHud(msg, hideDelay: LJUtil.toastInterval(msg))
                AccountManager.sharedInstance.updateAccountInfo(strongSelf.userInfo)
                _ = strongSelf.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    /**
     点击任意处结束编辑
     */
    func endEditWhenTouch(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(NormalUserInfoConfigTableViewController.endEdit))
        self.view.addGestureRecognizer(tap)
    }
    func endEdit(){
        self.view.endEditing(true)
    }
    
    /**
     验证输入
     */
    func checkInput() -> (String){
        
        let nickName = nicknameTextField.text
        let email = NSString(string: emailTextField.text!)
        if !userInfo.checkNickName(nickName){
            return ("昵称2-16个字，支持英文、下划线")
        }
        
        if email.length != 0 && email != "暂无" && email.range(of: "@").location == NSNotFound {
            return ("输入email格式错误")
        }
        
        userInfo.nickname = nickName
        userInfo.sex = sexTextField.text
        userInfo.uemail = email as String
        userInfo.city = cityTextField.text
        
        return ("")
    }
    
    func initInputView(_ name: String ,textField: UITextField){
        switch name{
        case "昵称":
            nicknameTextField = textField
            break
        case "邮箱":
            textField.placeholder = "暂无"
            textField.setValue(UIColor.black, forKeyPath: "_placeholderLabel.textColor")
            emailTextField = textField
            break
        case "性别":
            sexTextField = textField
            let data = ["女","男","保密"]
            makePicker(textField, data: data, mulData: nil)
        
        case "所在城市":
            textField.placeholder = "暂无"
            textField.setValue(UIColor.black, forKeyPath: "_placeholderLabel.textColor")
            cityTextField = textField
            if self.districtData == nil {
                let path = Bundle.main.path(forResource: "district.json", ofType: nil)
                if path != nil {
                    let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
                    self.districtData  = (try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)) as! Array<Dictionary<String , Array<String>>>?
                }
            }
            makePicker(textField, data: nil, mulData: self.districtData)
         default:
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 3
        }
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: infoConfig) as! MyInfoConfigCell
        cell.isMyInfo = "myInfo"
        
        let count = (indexPath as NSIndexPath).section * 3 + (indexPath as NSIndexPath).row
        let text = titleList[count]
        cell.titleLB.text = text
        cell.titleLB.textAlignment = NSTextAlignment.left
        if dataList != nil{
            cell.inputContent.text = dataList![count] as? String
        }
        
        initInputView(text, textField: cell.inputContent)
        
        if count == 4{
            cell.inputContent.isUserInteractionEnabled = false
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            if let navContoller = self.navigationController {
                return navContoller.navigationBar.bottom - GlobalConsts.NormalNavbarHeight
            }
        }
        
        if section == 1{
            return 14
        }
        return 0
    }


}
