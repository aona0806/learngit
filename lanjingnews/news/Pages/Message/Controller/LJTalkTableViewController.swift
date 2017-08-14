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
    private var sendMessageTaskArray: [NSURLSessionDataTask]! = []
    
    var isPopToRoot = false

    //MARK: - lifcycle
    
    init(){
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
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.initNavbar()
        
        let frame = self.view.frame
        self.backImageView.frame = frame
        let backImage : UIImage? = UIImage(named: "xiaomishu_background")
        self.backImageView.image = backImage
        self.view.addSubview(backImageView)
        
        self.parentView.frame = frame
        parentView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(parentView)
        
        self.tableView.frame = frame
        parentView.addSubview(self.tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorColor = UIColor.clearColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = UIColor.clearColor()
        
        self.tableView.allowsSelection = false;
        
        tableView.backgroundColor = UIColor.clearColor()
        self.view.bringSubviewToFront(parentView)
        
        let gesture = UITapGestureRecognizer(target: self, action: "hideKeyboard:")
        gesture.cancelsTouchesInView = false;
        tableView.addGestureRecognizer(gesture)
        
        self.addHeaderRefreshView(self.tableView) { () -> Void in
            self.headerBeginRefresh(false)
        }
        
        headerBeginRefresh(true)
        
        self.keyboard = LYKeyBoardView(delegate: self, superView: self.view, andIsShowPic: false)
        self.keyboard?.inputText.placeholder = "请输入发送消息"
        
        refreshRedDot()
        
        self.view.setNeedsUpdateConstraints()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = talkUserName
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messageShowAction:", name: GlobalConsts.Notification_MessageNew, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.keyboard != nil && self.keyboard!.inputText.isFirstResponder(){
            self.keyboard!.inputText.resignFirstResponder()
        }
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        super.viewDidDisappear(animated)
    }
    
    override func updateViewConstraints() {
        
        super.updateViewConstraints()
        
        self.backImageView.snp_remakeConstraints { (make) -> Void in
            make.edges.equalTo(self.tableView)
        }
        
        var topOffset = CGFloat(0)
        if(self.navigationController?.navigationBar != nil && CGRectGetHeight(self.navigationController!.navigationBar.frame) > 44){
            topOffset = CGRectGetHeight(self.navigationController!.navigationBar.frame) - 44
        }
        
        self.parentView.snp_remakeConstraints { (make) -> Void in
            make.right.left.equalTo(self.view)
            make.top.equalTo(self.view.snp_top).offset(topOffset)
            make.bottom.equalTo(self.view.snp_bottom).offset(-50)
        }
        
        self.tableView.snp_remakeConstraints { (make) -> Void in
            make.edges.equalTo(self.parentView)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - private
    
    func initNavbar(){
        self.navigationController?.navigationBar.topItem?.title = " "
        
        let rightButtonItem = UIBarButtonItem(image: UIImage(named: "human_button"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("onMessageAvatarTap"))
        self.navigationItem.rightBarButtonItem = rightButtonItem
        let backButtonItem = UIBarButtonItem(image: UIImage(named: "navi_back"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("backAction:"))
        self.navigationItem.leftBarButtonItem = backButtonItem
        
        self.title = talkUserName
    }
    
    func scrolltableViewToBottom() {
        
        if self.messages.count > 0 {
            
            let last = NSIndexPath(forRow: self.tableView.numberOfRowsInSection(0) - 1 , inSection: 0)
            self.tableView.scrollToRowAtIndexPath(last, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
        }
    }
    
    func refreshRedDot(){
        
        let redDotManager = RedDotManager.sharedInstance
        let strTalkUid = self.talkingUserId.description
        
        for var i = 0 ; i < redDotManager.talkRedDot.count ; i++ {
            let uid = redDotManager.talkRedDot[i]
            if uid == strTalkUid {
                redDotManager.talkRedDot.removeAtIndex(i)
            }
        }
        redDotManager.save()
        
        if !redDotManager.hasMessageRedDot() {
            
            NSNotificationCenter.defaultCenter().postNotificationName(GlobalConsts.Notification_MainTabbarMessage,
                object: nil)
        }
    }
    
    func messageShowAction(notification:NSNotification) {
        
        footerRefresh()
        
    }
    
    func showUserInfo(uid : String){
        
        let controller = LJUserDeltailViewController()
        controller.uid = uid
        navigateTo(controller)
    }
    
    func headerBeginRefresh(showHud: Bool)
    {
        var lastReadMid: String = "-1"
        if self.messages.count > 0 {
            lastReadMid = self.messages.first!.mid
        }
        self.getMessagesList(isNew:false, msgUid: self.talkingUserId.description, lastMid: lastReadMid, showHud: false)
    }
    
    func footerRefresh(){
        
        var lastReadMid: String = "-1"
        if self.messages.count > 0 {
            lastReadMid = self.messages.last!.mid
        }
        
        self.getMessagesList(isNew:true, msgUid: self.talkingUserId.description, lastMid: lastReadMid, showHud: false)
        
    }
    
    //MARK: - download
    
    private func getMessagesList(isNew isNew: Bool, msgUid: String, lastMid: String, showHud: Bool) -> () {
        
        // 显示等待的菊花
        var hud: MBProgressHUD?
        if showHud {
            self.stopRefresh(self.tableView)
            hud = showEmptyHud()
        }
        
        TKRequestHandler.sharedInstance().getMessageTypeIsNew(isNew, msgUid: msgUid, lastmid: lastMid) { (sessionDataTask, model, err) -> Void in
            
            if err != nil  {
                
                if showHud {
                    hud?.hide(true) // 隐藏菊花
                }
                self.showToast("加载失败", hideDelay: 1)
                return
            } else {
                
                self.stopRefresh(self.tableView)
                
                if isNew {
                    
                    if model.dErrno.integerValue == 0 {
                        
                        let messageList: [LJMessageTalkDataContentModel]! = model.data?.content as? [LJMessageTalkDataContentModel] ?? []
                        self.messages = self.messages + messageList
                        
                        self.stopRefresh(self.tableView)
                        self.tableView.reloadData()
                        self.scrolltableViewToBottom()
                        
                    }
                    
                } else {
                    
                    if model.dErrno.integerValue == 0 {
                        
                        self.title = model.data.chatting
                        
                        if showHud {
                            hud?.hide(true) // 隐藏菊花
                        }
                        
                        let messageList: [LJMessageTalkDataContentModel]! = model.data?.content as? [LJMessageTalkDataContentModel] ?? []
                        if self.messages.count == 0 {
                            self.messages = messageList
                        } else {
                            if self.messages.first?.mid > messageList.last?.mid {
                                self.messages = messageList + self.messages
                            }
                        }
                        self.tableView.reloadData()

                    }
                }
                
                self.refreshRedDot()
            }
        }
    }
    
    func sendMessage(message: String){
        
        let task = TKRequestHandler.sharedInstance().postMessageToUid(self.talkingUserId.description, content: message, isNotify: true) { (sessionDataTask, model, err) -> Void in
            
            if err == nil {
                if model.dErrno.integerValue == 802 {
                    let alertView = UIAlertView(title: "温馨提示", message: "需先成为好友，才能进行聊天", delegate: self, cancelButtonTitle: "取消")
                    alertView.show()
                } else if model.dErrno.integerValue == 0 {
                    
                    let uid = AccountManager.sharedInstance.uid()
                    
                    let info = LJMessageTalkDataContentModel()
                    info.fromUid = uid
                    info.toUid   = self.talkingUserId.description
                    info.content = message
                    info.avatar = AccountManager.sharedInstance.getUserInfo()?.avatar
                    
                    for msg in self.messages {
                        if msg.fromUid == uid {
                            info.avatar = msg.avatar
                            break
                    }
                    
                    self.messages.append(info)
                    self.tableView.reloadData()
                    
                    self.scrolltableViewToBottom()
                    }
                }
                
                let index = self.sendMessageTaskArray.indexOf(sessionDataTask)
                self.sendMessageTaskArray.removeAtIndex(index!)
            }
        }
        self.sendMessageTaskArray.append(task)

    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //#warning Incomplete method implementation.
        // Return the number of rows in the section.
        let count = self.messages.count
        return count;
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        var message: LJMessageTalkDataContentModel? = nil
        message = self.messages[indexPath.row]
        
        if message?.fromUid != "25" {
            var cell: LJTalkLeftTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellLeftReuseIdentifier) as? LJTalkLeftTableViewCell
            if cell == nil {
                cell = LJTalkLeftTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellLeftReuseIdentifier)
            }
        
            cell?.onOtherHeadTap = self.otherHeadTap
            cell!.info = message
            
            return cell!;
        } else {
            
            var cell: LJTalkRightTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellRightReuseIdentifier) as? LJTalkRightTableViewCell
            if cell == nil {
                cell = LJTalkRightTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellRightReuseIdentifier)
            }
            cell?.onMyHeadTap = self.myHeadTap
            cell!.info = message
            
            return cell!;
        }
    }
    
    // MARK - UITableViewDeletage
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let message : LJMessageTalkDataContentModel! = messages[indexPath.row]
        let height = LJTalkBaseTableViewCell.calculateCommentListHeight(message)
        return height
    }
    
    //MARK: - UIAlertViewDelegate
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        switch buttonIndex {
        case 0:
            self.navigationController?.popViewControllerAnimated(true)
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
        imagePicker!.sourceType = UIImagePickerControllerSourceType.Camera
    }
    
    func initImagePickerOfPhotoLibraryIfNot()
    {
        if imagePicker == nil {
            imagePicker = UIImagePickerController()
            imagePicker!.delegate = self
        }
        imagePicker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    }
    
    // MARK: - LYKeyBoardViewDelegate
    
    func keyBoardView(keyBoard: LYKeyBoardView!, changeKeyBoardHeight height: CGFloat) {
        
        UIView.animateWithDuration(Double(0.7), animations: { () -> Void in
            
            self.parentView.snp_updateConstraints { (make) -> Void in
                make.bottom.equalTo(self.view.snp_bottom).offset(-height-50)
                
            }
            }) { (Bool) -> Void in
                self.scrolltableViewToBottom()
        }
    }
    
    func keyBoardView(keyBoard: LYKeyBoardView!, sendMessage message: String!) {
        
        if self.sendMessageTaskArray.count > 0 {
            return
        }
        self.sendMessage(message)
    }
    
    func keyBoardView(keyBoard: LYKeyBoardView!, imgPicType sourceType: UIImagePickerControllerSourceType) {
        
        switch sourceType{
        case UIImagePickerControllerSourceType.PhotoLibrary:
            initImagePickerOfPhotoLibraryIfNot()
            self.view.addSubview(imagePicker!.view)
            presentViewController(imagePicker!, animated:true, completion:nil);
            break;
        case UIImagePickerControllerSourceType.Camera:
            initImagePickerOfCameraIfNotInit()
            self.view.addSubview(imagePicker!.view)
            presentViewController(imagePicker!, animated:true, completion:nil);
            break;
        default :
            break;
        }
    }
    
    //MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        dismissViewControllerAnimated(true, completion: {
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
    
    func backAction(sender: AnyObject!) {
        if isPopToRoot {
            let count = self.navigationController?.viewControllers.count
            if count > 2 {
                let viewController: UIViewController = (self.navigationController?.viewControllers[count! - 3])!
                self.navigationController?.popToViewController(viewController, animated: true)
            }
            
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }

    func hideKeyboard(g:UITapGestureRecognizer) {
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
}
