//
//  LJtableViewController.swift
//  news
//
//  Created by 陈龙 on 15/12/10.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

class LJTalkTableViewController: LJBaseViewController, UITableViewDelegate, UITableViewDataSource, LYKeyBoardViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    let cellLeftReuseIdentifier: String = "leftCellReuseIdentifier"
    let cellRightReuseIdentifier: String = "rightCellReuseIdentifier"

    internal var talkUserName : String! = "..."
    var talkingUserId: Int = 2
    
    // view init
    private var backImageView: UIImageView!
    private var tableView: UITableView!
    private var parentView: UIView!
    private var imagePicker: UIImagePickerController? = nil
    /// 表情键盘
    private var keyboard : LYKeyBoardView?
    
    private var messages = [LJMessageTalkDataContentModel]()
    private var sendMessageTaskArray: [URLSessionDataTask]! = []
    
    var isPopToRoot = false

    //MARK: - lifcycle
    
    override init(){
        super.init(nibName: nil, bundle: nil)
        
        self.hidesBottomBarWhenPushed = true
        
        self.backImageView = UIImageView()
        self.tableView = UITableView()
        self.parentView    = UIView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        self.edgesForExtendedLayout = UIRectEdge()
        
        self.initNavbar()
        
        let frame = self.view.frame
        self.backImageView.frame = frame
        let backImage : UIImage? = UIImage(named: "xiaomishu_background.jpg")
        self.backImageView.image = backImage
        self.view.addSubview(backImageView)
        
        self.parentView.frame = frame
        parentView.backgroundColor = UIColor.clear
        self.view.addSubview(parentView)
        
        self.tableView.frame = frame
        parentView.addSubview(self.tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorColor = UIColor.clear
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.backgroundColor = UIColor.clear
        
        self.tableView.allowsSelection = false;
        
        tableView.backgroundColor = UIColor.clear
        self.view.bringSubview(toFront: parentView)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(LJTalkTableViewController.hideKeyboard(_:)))
        gesture.cancelsTouchesInView = false;
        tableView.addGestureRecognizer(gesture)
        
        weak var weakSelf = self
        self.addHeaderRefreshView(self.tableView) { () -> Void in
            weakSelf?.headerBeginRefresh(false)
        }
        
        footerRefresh()
        
        self.keyboard = LYKeyBoardView(delegate: self, superView: self.view, andIsShowPic: false)
        self.keyboard?.inputText.placeholder = "请输入发送消息"
        refreshRedDot()
        
        self.view.setNeedsUpdateConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = talkUserName
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LJTalkTableViewController.messageShowAction(_:)), name: NSNotification.Name(rawValue: GlobalConsts.Notification_MessageNew), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.keyboard != nil && self.keyboard!.inputText.isFirstResponder{
            self.keyboard!.inputText.resignFirstResponder()
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    override func updateViewConstraints() {
        
        super.updateViewConstraints()
        
        self.backImageView.snp.remakeConstraints { (make) -> Void in
            make.edges.equalTo(self.tableView)
        }
        
        var topOffset = CGFloat(0)
        if(self.navigationController?.navigationBar != nil && self.navigationController!.navigationBar.frame.height > 44){
            topOffset = self.navigationController!.navigationBar.frame.height - 44
        }
        
        self.parentView.snp.remakeConstraints { (make) -> Void in
            make.right.left.equalTo(self.view)
            make.top.equalTo(self.view.snp.top).offset(topOffset)
            make.bottom.equalTo(self.view.snp.bottom).offset(-50)
        }
        
        self.tableView.snp.remakeConstraints { (make) -> Void in
            make.edges.equalTo(self.parentView)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - private
    
    func initNavbar(){
        
        var navImage = UIImage(named: "Logout_defaultAvatar")
        navImage = navImage?.withRenderingMode(.alwaysOriginal)
        let rightButtonItem = UIBarButtonItem(image: navImage , style: UIBarButtonItemStyle.plain, target: self, action: #selector(LJTalkTableViewController.onMessageAvatarTap))
        self.navigationItem.rightBarButtonItem = rightButtonItem
        var backImage = UIImage(named:"navi_back")
        backImage = backImage?.withRenderingMode(.alwaysOriginal)
        let backButtonItem = UIBarButtonItem(image: backImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(LJTalkTableViewController.backAction(_:)))
        self.navigationItem.leftBarButtonItem = backButtonItem
        
        self.title = talkUserName
    }
    
    func scrolltableViewToBottom() {
        
        if self.messages.count > 0 {
            let last = IndexPath(row: self.tableView.numberOfRows(inSection: 0) - 1 , section: 0)
            self.tableView.scrollToRow(at: last, at: .bottom, animated: false)
        }
    }
    
    func refreshRedDot(){
        
        let redDotManager = RedDotManager.sharedInstance
        let strTalkUid = self.talkingUserId.description
        
        if redDotManager.redDotModel?.pmsg != nil{
            
            let max: Int! = redDotManager.redDotModel?.pmsg.fromUid.count ?? 0
            for i in 0..<max {
                let uid = redDotManager.redDotModel!.pmsg.fromUid[i]
                if uid == strTalkUid {
                    redDotManager.redDotModel!.pmsg.fromUid.remove(at: i)
                    break
                }
            }
        }
        
        
        if !redDotManager.hasMessageRedDot() {
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConsts.Notification_MainTabbarMessage),
                object: nil)
        }
    }
    
    func messageShowAction(_ notification:Notification) {
        
        footerRefresh()
        
    }
    
    func showUserInfo(_ uid : String){
        
        let controller = LJUserDeltailViewController()
        controller.uid = uid
        navigateTo(controller)
    }
    
    func headerBeginRefresh(_ showHud: Bool)
    {
        var lastReadMid: String = "-1"
        if self.messages.count > 0 {
            lastReadMid = self.messages.first!.mid
        }
        self.getMessagesList(type: .loadMore, msgUid: self.talkingUserId.description, lastMid: lastReadMid, showHud: false)
    }
    
    func footerRefresh(){
        
        var lastReadMid : String = "-1"
        if self.messages.count > 0 {
            lastReadMid = self.messages.last!.mid
        }
        
        self.getMessagesList(type: .refresh, msgUid: self.talkingUserId.description, lastMid: lastReadMid, showHud: false)
        
    }
    
    //MARK: - download
    
    private func getMessagesList(type: TKDataFreshType, msgUid: String, lastMid: String, showHud: Bool) -> () {
        
        // 显示等待的菊花
        var hud: MBProgressHUD?
        if showHud {
            self.stopRefresh(self.tableView)
            hud = showEmptyHud()
        }
        
        TKRequestHandler.sharedInstance().getMessageTypeType(type, msgUid: msgUid, lastmid: lastMid) {[weak self] (sessionDataTask, model, err) -> Void in
            
            if let strongSelf = self {
                
                if err != nil  {
                    
                    if showHud {
                        hud?.hide(animated: true) // 隐藏菊花
                    }
                    _ = strongSelf.showToastHidenDefault(err?._domain);
                    return
                } else {
                    
                    strongSelf.stopRefresh(strongSelf.tableView)
                    
                    switch type {
                    case .loadMore:
                        
                        if model?.dErrno.intValue == 0 {
                            
                            let messageList: [LJMessageTalkDataContentModel]! = model!.data?.content as? [LJMessageTalkDataContentModel] ?? []
                            strongSelf.messages = messageList + strongSelf.messages
                            
                            strongSelf.stopRefresh(strongSelf.tableView)
                            strongSelf.tableView.reloadData()
                        } else {
                            let msg = model?.msg ?? GlobalConsts.NetRequestNoResult
                            _ = strongSelf.showToastHidenDefault(msg);
                        }
                        break
                        
                    case .refresh:
                        
                        if model?.dErrno.intValue == 0 {
                            
                            strongSelf.title = model?.data.chatting
                            
                            if showHud {
                                hud?.hide(animated: true) // 隐藏菊花
                            }
                            
                            let messageList: [LJMessageTalkDataContentModel]! = model!.data?.content as? [LJMessageTalkDataContentModel] ?? []
                            if strongSelf.messages.count == 0 {
                                strongSelf.messages = messageList
                            } else {
                                let currentMinMid = Int(strongSelf.messages.first?.mid ?? "0")
                                let maxMid = Int(messageList.last?.mid ?? "0")
                                if currentMinMid! < maxMid! {
                                    strongSelf.messages = strongSelf.messages + messageList
                                }
                            }
                            strongSelf.tableView.reloadData()
                            strongSelf.scrolltableViewToBottom()
                        } else {
                            
                            let msg = model?.msg ?? GlobalConsts.NetRequestNoResult
                            _ = strongSelf.showToastHidenDefault(msg)
                            
                        }
                        break
                    }
                    
                    strongSelf.refreshRedDot()
                }
            }
        }
    }
    
    func sendMessage(_ message: String){
        
        let task = TKRequestHandler.sharedInstance().postMessage(toUid: self.talkingUserId.description, content: message, isNotify: true) {[weak self] (sessionDataTask, model, err) -> Void in
            
            if let strongSelf = self {
                
                if err == nil {
                    if model?.dErrno.intValue == 802 {
                        let alertView = UIAlertView(title: "温馨提示", message: "需先成为好友，才能进行聊天", delegate: self, cancelButtonTitle: "取消")
                        alertView.show()
                    } else if model?.dErrno.intValue == 0 {
                        
                        let uid = AccountManager.sharedInstance.uid()
                        
                        let info = LJMessageTalkDataContentModel()
                        info.fromUid = uid
                        info.toUid   = strongSelf.talkingUserId.description
                        info.content = message
                        info.avatar = AccountManager.sharedInstance.getUserInfo()?.avatar
                        info.mid = model?.data.mid
                        
                        for msg in strongSelf.messages {
                            if msg.fromUid == uid {
                                info.avatar = msg.avatar
                                break
                            }
                        }
                        
                        strongSelf.messages.append(info)
                        strongSelf.tableView.reloadData()
                        strongSelf.scrolltableViewToBottom()
                    }
                    
                    let index = strongSelf.sendMessageTaskArray.index(of: sessionDataTask)
                    strongSelf.sendMessageTaskArray.remove(at: index!)
                }
            }
        }
        self.sendMessageTaskArray.append(task!)

    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //#warning Incomplete method implementation.
        // Return the number of rows in the section.
        let count = self.messages.count
        return count;
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        var message: LJMessageTalkDataContentModel? = nil
        message = self.messages[(indexPath as NSIndexPath).row]
        
        let myUid = AccountManager.sharedInstance.uid()
        if message?.fromUid != myUid {
            var cell: LJTalkLeftTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellLeftReuseIdentifier) as? LJTalkLeftTableViewCell
            if cell == nil {
                cell = LJTalkLeftTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellLeftReuseIdentifier)
            }
        
            cell?.onOtherHeadTap = {[weak self] () -> Void in
                self?.otherHeadTap()
            }
            cell?.showUrlDetail = { [weak self] (url :String) ->Void in
               self?.showUrlDetail(url)
            }
            cell!.info = message
            
            return cell!;
        } else {
            
            var cell: LJTalkRightTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellRightReuseIdentifier) as? LJTalkRightTableViewCell
            if cell == nil {
                cell = LJTalkRightTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellRightReuseIdentifier)
            }
            cell?.onMyHeadTap = {[weak self] () -> Void in
                self?.myHeadTap()
            }
            cell?.showUrlDetail = { [weak self] (url :String) ->Void in
                self?.showUrlDetail(url)
            }
            cell!.info = message
            
            return cell!;
        }
    }
    
    // MARK - UITableViewDeletage
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let message : LJMessageTalkDataContentModel! = messages[(indexPath as NSIndexPath).row]
        let height = LJTalkBaseTableViewCell.calculateCommentListHeight(message)
        return height
    }
    
    //MARK: - UIAlertViewDelegate
    
    func alertView(_ alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        switch buttonIndex {
        case 0:
            _ = self.navigationController?.popViewController(animated: true)
            break
        case 1:
            break
        default :
            
            break
            
        }
    }
    
    //MARK: - ImagePicker private method
    
    func initImagePickerOfCameraIfNotInit()
    {
        if imagePicker == nil {
            imagePicker = UIImagePickerController()
            imagePicker!.delegate = self
        }
        imagePicker!.sourceType = UIImagePickerControllerSourceType.camera
    }
    
    func initImagePickerOfPhotoLibraryIfNot()
    {
        if imagePicker == nil {
            imagePicker = UIImagePickerController()
            imagePicker!.delegate = self
        }
        imagePicker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
    }
    
    // MARK: - LYKeyBoardViewDelegate
    
    func keyBoardView(_ keyBoard: LYKeyBoardView!, changeKeyBoardHeight height: CGFloat) {
               
        UIView.animate(withDuration: Double(0.7), animations: { () -> Void in
            
            self.parentView.snp.updateConstraints { (make) -> Void in
                make.bottom.equalTo(self.view.snp.bottom).offset(-height-50)
                
            }
            }) { (Bool) -> Void in
                self.scrolltableViewToBottom()
        }
    }
    
    func keyBoardView(_ keyBoard: LYKeyBoardView!, sendMessage message: String!) {
        
        if self.sendMessageTaskArray.count > 0 {
            return
        }
        self.sendMessage(message)
    }
    
    func keyBoardView(_ keyBoard: LYKeyBoardView!, imgPicType sourceType: UIImagePickerControllerSourceType) {
        
        switch sourceType{
        case UIImagePickerControllerSourceType.photoLibrary:
            initImagePickerOfPhotoLibraryIfNot()
            self.view.addSubview(imagePicker!.view)
            present(imagePicker!, animated:true, completion:nil);
            break;
        case UIImagePickerControllerSourceType.camera:
            initImagePickerOfCameraIfNotInit()
            self.view.addSubview(imagePicker!.view)
            present(imagePicker!, animated:true, completion:nil);
            break;
        default :
            break;
        }
    }
    
    //MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        dismiss(animated: true, completion: {
            //            let photo = info[UIImagePickerControllerOriginalImage] as! UIImage
            //            let minPhoto = ImageHelper.resizeImage(photo, edge: 1024)
        })
    }
    
    //MARK: - Action
    
    func onMessageAvatarTap() {
        
        let controller = LJUserDeltailViewController()
        controller.uid = talkingUserId.description
        navigateTo(controller)
    }
    
    func backAction(_ sender: AnyObject!) {
        
        if isPopToRoot {
            let count = self.navigationController?.viewControllers.count
            if count! > 2 {
                let viewController: UIViewController = (self.navigationController?.viewControllers[count! - 3])!
                _ = self.navigationController?.popToViewController(viewController, animated: true)
            }
        } else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }

    func hideKeyboard(_ g:UITapGestureRecognizer) {
        self.view.endEditing(true)
        
        if (self.keyboard != nil) {
            self.keyboard?.tapAction()
        }
    }
    
    func otherHeadTap(){
        
        self.showUserInfo(talkingUserId.description)
    }
    
    func myHeadTap(){
        let uidString = AccountManager.sharedInstance.uid()
        self.showUserInfo(uidString)
    }
    
    func showUrlDetail(_ url : String) {
        
        let viewController = self.moduleWebView(withUrl: url)
        viewController?.title = "网页链接"
        self.navigateTo(viewController!)
        
        
    }
}
