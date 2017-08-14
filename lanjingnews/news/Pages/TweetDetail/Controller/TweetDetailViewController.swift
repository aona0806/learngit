//
//  TweetDetailViewController.swift
//  news
//
//  Created by chunhui on 15/12/7.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

class TweetDetailViewController: BaseViewController , UITableViewDelegate,UITableViewDataSource , LYKeyBoardViewDelegate {
    
    private var tableview : UITableView?
    private var tweetDetail : LJTweetDataContentModel?
    private var commentList = Array<LJTweetCommentDataContentModel>()
    private var replayComment : LJTweetCommentDataContentModel?
    
    private var inputbar : LYKeyBoardView!
    private var loadingTweet = false
    private var loadingComment = false
//    private var
    private var commentHeaderView : TweetCommentHeaderView?
    
    private var tapGesture : UITapGestureRecognizer?
    
    private var tweetOperate : TweetOperationDelegate? = nil
    
    private var isFirstLoading: Bool = true
    
    var tid : String? = nil
        
    private var placeHolder : String? {
        didSet{
            inputbar.inputText.placeholder = self.placeHolder
        }
    }
    
    private func initNavbar(){
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.defaultLeftItem(withTarget: self, action: #selector(TweetDetailViewController.backAction))
    }
    
    override func backAction(){
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "讨论详情"
        self.initNavbar()
        
        tableview = UITableView(frame: self.view.bounds , style: .grouped)
        tableview?.delegate = self
        tableview?.dataSource = self
        tableview?.separatorStyle = .none
        
        tableview?.register(TweetDetailTableViewCell.classForCoder(), forCellReuseIdentifier: TweetDetailTableViewCell.Identify)
        tableview?.register(TweetCommentTableViewCell.classForCoder(), forCellReuseIdentifier: TweetCommentTableViewCell.Identify)
        
        self.view.addSubview(tableview!)
        
        inputbar = LYKeyBoardView(delegate: self, superView: self.view, type: .emojiOnlyRight)
        
        self.placeHolder = "评论并转发，返回APP领蓝鲸币"
        self.view.addSubview(inputbar)
        
        self.initConstraints()
        
        //load data
        self.isFirstLoading = true
        self.loadTweetDetail()
        self.loadComment(true)
        
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(TweetDetailViewController.tapBlankAction(_:)))
        
        self.addRefreshView(self.tableview)
        
        if tweetOperate == nil {
            tweetOperate = TweetOperationDelegate(controller: self)
            tweetOperate?.shareLanjing = {[weak self](tweet : LJTweetDataContentModel)->Void in
                self?.shareLanjing(tweet)
            }
            //shareLanjing
        }
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func initConstraints() {
        weak var weakSelf = self
        self.tableview?.snp.makeConstraints({ (make) -> Void in
            make.left.equalTo(weakSelf!.view.snp.left)
            make.right.equalTo(weakSelf!.view.snp.right)
            let offset = weakSelf!.navigationController!.navigationBar.bottom - GlobalConsts.NormalNavbarHeight
            make.top.equalTo(weakSelf!.view.snp.top).offset(offset)
            make.bottom.equalTo(inputbar.topView.snp.top)
        })
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
        if let navController = self.navigationController {
            weak var weakSelf = self
            self.tableview?.snp.updateConstraints({ (make) -> Void in
                let offset = navController.navigationBar.bottom - GlobalConsts.NormalNavbarHeight

                make.top.equalTo( weakSelf!.view.snp.top).offset(offset)
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func headRefreshAction() {
        
        self.loadComment(true)
    }
    
    override func footRefreshAction() {
        
        self.loadComment(false)
        
    }
    
    // MARK: - load data
    func loadTweetDetail(){
        
        if self.loadingTweet {
            return
        }
        
        self.loadingTweet = true
        
        var hud: MBProgressHUD? = nil
        if isFirstLoading {
            hud = self.showLoadingGif()
            isFirstLoading = false
        }
        
        TKRequestHandler.sharedInstance().getTweetDetail(withTid: tid!) { [weak self](sessionDataTask, model, error) -> Void in
            
            if hud != nil {
                hud!.hide(animated: true)
            }
            
            if let strongSelf = self {
                
                strongSelf.loadingTweet = false
                if !strongSelf.loadingComment {
                    strongSelf.stopRefresh(strongSelf.tableview)
                }
                
                if model != nil && error == nil {
                    
                    strongSelf.tweetDetail = model?.data.content
                    strongSelf.tableview?.reloadData()
                    
                    if strongSelf.tweetDetail!.uid == AccountManager.sharedInstance.uid() {
                        //my tweet
                        var image = UIImage(named:"navi_delete")
                        image = image?.withRenderingMode(.alwaysOriginal)
                        strongSelf.navigationItem.rightBarButtonItem = UIBarButtonItem(image:image, style: .plain , target: self, action: #selector(TweetDetailViewController.showDeleteTweet))
                    }
                } else {
                    
                    let msg = error?._domain ?? GlobalConsts.NetErrorNetMessage
                    _ = strongSelf.showToastHidenDefault(msg)
                    
                }
            }
        }
    }
    
    func loadComment(_ refresh : Bool){

        if self.loadingComment {
            return
        }
        
        self.loadingComment = true
        
        var lastCid = ""
        if !refresh && commentList.count > 0 {
            lastCid =  commentList.last!.cid
        }
        
        TKRequestHandler.sharedInstance().getTweetComments(withTid: tid!, isNew: refresh, lastCId: lastCid) {[weak self] (sessionDataTask, model, error) -> Void in
            
            if let strongSelf = self {
                
                strongSelf.loadingComment = false
                if !strongSelf.loadingTweet {
                    strongSelf.stopRefresh(strongSelf.tableview)
                }
                if model != nil && error == nil && model?.dErrno.intValue == 0{
                    if refresh {
                        strongSelf.commentList.removeAll()
                    }
                    
                    if model?.data != nil && (model?.data.content.count)! > 0 {
                        strongSelf.commentList.append(contentsOf: model?.data.content as! [LJTweetCommentDataContentModel])
                    }
                    
                    strongSelf.tableview?.reloadData()
                }
            }
            
        }
    }
    
    
    
    // MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if tweetDetail != nil {
                return 1
            }else{
                return 0
            }
        }
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath as NSIndexPath).section == 0 {
            return TweetDetailTableViewCell.heightForInfo(tweetDetail!, showCommentList: false)
        }
        let comment = commentList[(indexPath as NSIndexPath).row]
        return TweetCommentTableViewCell.cellHeightForComment(comment)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell? = nil
        if indexPath.section == 0 {
            //tweet detail
            
            let detailCell = tableview?.dequeueReusableCell(withIdentifier: TweetDetailTableViewCell.Identify) as? TweetDetailTableViewCell
            detailCell?.showCommentList = false
            detailCell?.selectionStyle = .none
            detailCell?.hideBottomline = true
            
            detailCell?.info = tweetDetail
            
            detailCell?.tapAction = { [weak self](cell : TweetTableViewCell , info : LJTweetDataContentModel , type : TweetTapTap  , extra : Any? ) -> Void in
                self?.tapCellAction(cell, info: info, type: type, extra: extra)
            }
            
            cell = detailCell
            
        }else{
            //comment
            let commentCell = tableview?.dequeueReusableCell(withIdentifier: TweetCommentTableViewCell.Identify) as? TweetCommentTableViewCell
                        
            if commentCell?.tapAvatarAction == nil {
                commentCell?.tapAvatarAction = {[weak self] (comment:LJTweetCommentDataContentModel)->Void in
                    self?.tapCommentAvatar(comment)
                }
                
            }
            
            if commentCell?.tapFromUserAction == nil {
                commentCell?.tapFromUserAction = { [weak self](comment:LJTweetCommentDataContentModel)->Void in
                    self?.tapCommentFromUser(comment)
                }
                
            }
            if commentCell?.tapToUserAction == nil {
                commentCell?.tapToUserAction = { [weak self](comment:LJTweetCommentDataContentModel)->Void in
                    self?.tapCommentToUser(comment)
                }
                
            }
            
            let comment = commentList[(indexPath as NSIndexPath).row]
            commentCell?.comment = comment
            
            cell = commentCell
        
        }
        
        return cell!
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            if commentList.count > 0 {
                if commentHeaderView == nil {
                    commentHeaderView = TweetCommentHeaderView(frame: CGRect.zero)
                }
                return commentHeaderView
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 20
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return CGFloat.leastNormalMagnitude
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath as NSIndexPath).section == 1 {
            self.onCommentClick((indexPath as NSIndexPath).row)
            self.event(forName: "Tweet_reply", attr: nil)
        }
        
    }

    func showDeleteTweet(){
        
        let action = UIActionSheet.bk_actionSheet(withTitle: nil) as! UIActionSheet
        weak var weakSelf = self

        action.bk_setDestructiveButton(withTitle: "删除" , handler: { () -> Void in
            weakSelf?.deleteTweet()
        })
        
        action.bk_setCancelButton(withTitle: "取消" , handler:  { () -> Void in
            
        })
        
        action.show(in: self.view)
        
    }
    
    func deleteTweet(){
        
        let tweet = self.tweetDetail!
        
        TKRequestHandler.sharedInstance().deleteTweet(withTid: self.tid!) { [weak self](task, isOK, error) -> Void in
            
            guard let strongSelf = self else {
                return
            }
            if isOK {
                NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConsts.kTweetDeleteNotification), object: tweet)
                
                _ = strongSelf.navigationController?.popViewController(animated: true)
                
            }else{
                var msg = ""
                if error != nil && (error?._domain.length())! > 0  {
                    msg = (error?._domain)!
                }else{
                    msg = "删除失败"
                }
                _ = strongSelf.showToastHidenDefault(msg)
            }
            
        }
        
    }
    
    func onCommentClick(_ index : Int)
    {
        
        let comment = self.commentList[index]
        if let uid = comment.uid {
            let myUid = AccountManager.sharedInstance.uid()
            if uid == myUid { // 对自己的评论，展示ActionSheet
                
                self.inputbar?.inputText.resignFirstResponder()
                let sheet = UIActionSheet.bk_actionSheet(withTitle: nil)
                weak var weakSelf = self
                _ = (sheet as AnyObject).bk_setCancelButton(withTitle: "取消", handler: { () -> Void in
                    
                })
                
                _ = (sheet as AnyObject).bk_addButton(withTitle: "删除", handler: { () -> Void in
                    weakSelf?.deleteComment(comment , index: index)
                })
                
                (sheet as AnyObject).show(in: self.view)
                self.placeHolder = "评论并转发，返回APP领蓝鲸币"
                self.replayComment = nil
                
            } else {
                if  let name = comment.sname {
                    self.placeHolder = "回复：" + name
                }
                self.replayComment = comment
                if !self.inputbar.inputText.isFirstResponder {
                    self.inputbar.inputText.becomeFirstResponder()
                }
            }
        }
        
    }
    
    private func deleteComment(_ comment : LJTweetCommentDataContentModel , index : Int) {
        
        TKRequestHandler.sharedInstance().deleteComment(withCid: comment.cid) { [weak self](task, isOK, error) -> Void in
            
            if let strongSelf  = self {
                
                if isOK {
                    
                    guard let idx = strongSelf.commentList.index(of: comment) else{
                        //因网络原因等多次请求已经删除了
                        return
                    }
                    
                    strongSelf.commentList.remove(at: idx)
                    strongSelf.tableview!.reloadData()
                    
                    if let list = (strongSelf.tweetDetail?.comment?.list as? [LJTweetDataContentCommentListModel]) {
                        
                        var changeTweet = false
                        var commentIndex = 0
                        for model in list {
                            
                            if model.sname == comment.sname {
                                
                                changeTweet = true
                                
                                break
                            }
                            commentIndex += 1
                        }
                        
                        if changeTweet {
                            let num = Int(strongSelf.tweetDetail?.comment?.num ?? "")
                            if num != nil {
                                strongSelf.tweetDetail?.comment?.num = (num! - 1).description
                            }
                            strongSelf.tweetDetail?.comment?.list?.remove(at: commentIndex)
                            NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConsts.kTweetInfoChangeNotification), object: strongSelf.tweetDetail!)
                        }
                        
                    }
                }
            }
                        
        }
    }
    
    
    // MARK: - keyboard
    func keyBoardView(_ keyBoard: LYKeyBoardView!, changeKeyBoardHeight height: CGFloat) {
        
        UIView.animate(withDuration: 0.2 , animations: { () -> Void in
            
            self.tableview?.height = keyBoard.top - self.tableview!.top
            
        })
        
        if height > 0 && self.tapGesture?.view == nil {
            
            self.tableview?.addGestureRecognizer(self.tapGesture!)
        }
        
    }
    
    func keyBoardView(_ keyBoard: LYKeyBoardView!, sendMessage message: String!) {
        
        if message.length() == 0 {
            
            return
            
        }
        
        var replyCid : String? = nil
        var replyUid : String? = nil
        if replayComment != nil {
            replyCid = replayComment!.cid
            replyUid = replayComment!.uid
        }
        
        TKRequestHandler.sharedInstance().postComment(withTid: tid, content: message, replayCid: replyCid, replayUid: replyUid) { [weak self](sessionDataTask, cid, error) -> Void in
            
            if let strongSelf = self {
                if (cid?.length())! > 0 && error == nil {
                    
                    let comment = LJTweetCommentDataContentModel()
                    
                    let userInfo = AccountManager.sharedInstance.getUserInfo()
                    
                    comment.sname = userInfo?.sname
                    comment.avatar = userInfo?.avatar
                    comment.uid = userInfo?.uid
                    
                    comment.cid = cid
                    comment.tid = strongSelf.tid
                    comment.content = message
                    if strongSelf.replayComment != nil {
                        comment.replySname = strongSelf.replayComment?.sname
                        comment.replyUid   = strongSelf.replayComment?.uid
                        comment.replyCid   = strongSelf.replayComment?.cid
                    }
                    
                    comment.ctime = TKCommonTools.dateDesc(for: Date())
                    
                    strongSelf.commentList.insert(comment, at: 0)
                    
                    let sections = IndexSet(integer: 1)
                    strongSelf.tableview?.reloadSections(sections, with: .automatic)
                    
                    strongSelf.placeHolder = "评论并转发，返回APP领蓝鲸币"
                    strongSelf.replayComment = nil
                    
                    //hide key board
                    strongSelf.inputbar.tapAction()
                    
                }else{
                    
                    _ = strongSelf.showToastHidenDefault(error?._domain)
                    
                }
            }
        }
    }
    
    
    // MARK: - tap comment
    func tapCommentAvatar(_ comment: LJTweetCommentDataContentModel){
        
        self.showUserInfo(comment.uid)
    }
    
    func tapCommentFromUser(_ comment: LJTweetCommentDataContentModel){
        
        self.showUserInfo(comment.uid)
    }
    
    func tapCommentToUser(_ comment: LJTweetCommentDataContentModel){
        
        self.showUserInfo(comment.replyUid)
        
    }
    
    
    func showUserInfo(_ uid: String){
        //跳转用户信息页面
        
        let controller = LJUserDeltailViewController.init()
        controller.uid = uid
        self.event(forName: "Tweet_userdetail", attr: nil)
        navigateTo(controller)
    }
    
    func tapBlankAction(_ geture : UITapGestureRecognizer){
        
        self.inputbar.tapAction()
        self.tableview?.removeGestureRecognizer(self.tapGesture!)
    }
    
    // MARK: - tweet opeartion
    
    // MARK : 分享蓝鲸完成回调
    func shareLanjing(_ tweet : LJTweetDataContentModel){
        
        let count = Int(tweet.forward?.num ?? "0")!+1
        tweet.forward?.num = "\(count)"
        let user = LJTweetDataContentForwardUserModel()
        let myInfo = AccountManager.sharedInstance.getUserInfo()
        user.sname = AccountManager.sharedInstance.userName()
        user.uid   = myInfo!.uid
        tweet.forward?.user?.append(user)
        weak var weakSelf = self
        self.invokeOnUIThread({ () -> Void in
            
            let sections = IndexSet(integer: 0)
            weakSelf?.tableview?.reloadSections(sections, with: .none)
            
        })
        
    }
    
    // MARK: tweet share ops
    func tapCellAction(_ cell : TweetTableViewCell , info : LJTweetDataContentModel , type : TweetTapTap  , extra : Any? ){
        
        self.inputbar.tapAction()
        
        switch type {
        case .praise:
            praiseTweet(info , cell : cell )
            return
        case .comment:
            
            self.placeHolder = "评论并转发，返回APP领蓝鲸币"
            self.replayComment = nil
            self.inputbar.inputText.becomeFirstResponder()
            
            return
        default:
            break
            
        }
        
        self.tweetOperate?.tapCellAction(cell, info: info, type: type, extra: extra)
    }
    
    
    private func praiseTweet(_ info :LJTweetDataContentModel , cell : TweetTableViewCell ){
        
        weak var weakSelf = self
        self.tweetOperate?.praiseTweet(info, completion: { (success, errMsg) -> () in
            if success {
                
                let myInfo = AccountManager.sharedInstance.getUserInfo()
                
                var num = Int(info.praise?.num ?? "") ?? 0
                let flag = info.praise?.flag ?? false
                if flag {
                    //取消赞
                    num -= 1
                    for  i  in 0..<(info.praise?.user?.count  ?? 0){
                        let user = info.praise?.user?[i]
                        if (user as AnyObject).uid! == myInfo!.uid {
                            info.praise?.user?.remove(at: i)
                            break
                        }
                    }
                }else{
                    //点赞
                    
                    var praised = false
                    if let users = info.praise?.user {
                        for user in users {
                            
                            if let u = user as? LJTweetDataSocialUserModel {
                                if  u.uid != nil &&  myInfo!.uid == u.uid  {
                                    praised = true
                                    break
                                }
                            }
                        }
                    }
                    if !praised {
                        
                        let user = LJTweetDataContentPraiseUserModel()
                        
                        user.sname = myInfo!.sname
                        user.uid   = myInfo!.uid
                        info.praise?.user?.append(user)
                    }
                    num += 1
                }
                
                info.praise?.flag = !flag
                
                info.praise?.num = num.description
                
                DispatchQueue.main.async {
                    weakSelf?.tableview?.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
                }
                
            }else{
              
                let msg = errMsg ?? "请求失败"
                let _ = weakSelf?.showToast(msg , hideDelay: 0.7)
            }
        })
        
        
    }
}
