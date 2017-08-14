//
//  NewsDetailBaseViewController.swift
//  news
//
//  Created by wxc on 2016/12/27.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class NewsDetailBaseViewController: LJBaseViewController,UITableViewDelegate,UITableViewDataSource,TKInputBarDelegate {
    //MARK: 输入框相关
    var inputbar : TKInputBar!
    var kMaxInputCount = 200//字数限制，默认为200
    
    //相关信息
    var newsId:String?  //新闻id，请求评论列表
    var isLoadingFinished:Bool = false  //新闻详情是否加载完毕
    var commentTableView:UITableView!
    //tableView高度
    var heightForCommentTableView:CGFloat = UIScreen.main.bounds.height - 64
    
    //MARK: 手势
    private var tapGesture : UITapGestureRecognizer?//隐藏键盘
    
    private var isLoadFirstPage:Bool = true         //是否请求第一页
    private var lastId:String?                      //用于请求下一页评论
    
    private var task:URLSessionDataTask?
    
    //数组展示
    private var commentArray:[LJCommentDataListModel] = []//评论列表数据
    private var heightArray:[CGFloat] = []                 //评论cell高度
    
    //view
    private var noResultLabel:UILabel!//展示暂无评论
    private var checkLoginButton:UIButton = UIButton.init()
    
    private var isSendComment:Bool = false   //是否发送评论

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        setupAllSubviews()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if AccountManager.sharedInstance.isLogin() {
            checkLoginButton.isHidden = true
        }else {
            checkLoginButton.isHidden = false
        }
    }
    
    //初始化布局
    private func setupAllSubviews(){
        //输入框
        inputbar = TKInputBar.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0), barMode: .default)
        inputbar.maxInputCount = UInt(kMaxInputCount)
        inputbar.top = self.view.height - 64 - inputbar.height
        inputbar.delegate = nil
        inputbar.sendBgColor = UIColor.rgba(24, green: 161, blue: 133, alpha: 1)
        inputbar.placeholder = "请输入要评论的内容"
        
        weak var weakSelf = self
        inputbar.updateModeBlock = { (mode) in
            
        }
        
        inputbar.inputOverLimitBlock = { (currentInputCount) -> Void in
            guard let strongSelf = weakSelf else {
                return
            }
            strongSelf.showToastHidenDefault("评论内容限\(strongSelf.kMaxInputCount)字\n已超出\(currentInputCount - strongSelf.kMaxInputCount)字")
        }
        inputbar.isHidden = true
        inputbar.delegate = self
        
        //评论列表
        commentTableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: heightForCommentTableView), style: UITableViewStyle.grouped)
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTableView.backgroundColor = UIColor.clear
        commentTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        commentTableView.scrollsToTop = true
        
        //手势
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapBlankAction(_:)))
        
        self.view.addSubview(commentTableView)
        
        noResultLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 0))
        noResultLabel.textAlignment = .center
        noResultLabel.text = "暂无评论"
        noResultLabel.textColor = UIColor.themeGrayColor()
        noResultLabel.alpha = 0
        
        self.view.addSubview(inputbar)
        
        checkLoginButton.frame = inputbar.frame
        self.view.addSubview(checkLoginButton)
        checkLoginButton.addTarget(self, action: #selector(NewsDetailTableViewController.checkLoginButtonClick), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func showNoResultLabel() {
        if noResultLabel.alpha == 0{
            noResultLabel.alpha = 1
            noResultLabel.height = 50
            commentTableView.tableFooterView = noResultLabel
        }
    }
    
    private func hideNoResultLabel() {
        if noResultLabel.alpha == 1 {
            noResultLabel.height = 0
            noResultLabel.alpha = 0
            commentTableView.tableFooterView = noResultLabel
        }
    }
    
    func loadCommentList(){
        
        if commentArray.count > 0 {
            lastId = commentArray.last?.cid
        }
        
        task?.cancel()
        
        task = TKRequestHandler.sharedInstance().getCommentListl(withInfoId: newsId, lastId: lastId, rn: nil, refreshType: isLoadFirstPage) {[weak self] (sessionDataTask, model, error) -> Void in
            
            guard let strongSelf = self else {
                return
            }
            
            if error == nil && model != nil/*有数据无错误信息*/{
                if model?.dErrno == "0" {
                    
                    if let list = model?.data?.list as? [LJCommentDataListModel] {
                        
                        strongSelf.commentArray += list
                        
                        strongSelf.commentTableView.reloadData()
                        strongSelf.commentTableView.setNeedsLayout()
                        
                    }
                    
                    if strongSelf.commentArray.count > 0 {
                        strongSelf.isLoadFirstPage = false
                    }
                    
                    if strongSelf.commentArray.count == 0 {
                        strongSelf.noResultLabel.text = "暂无评论"
                        strongSelf.showNoResultLabel()
                    }else if strongSelf.commentArray.count != 0 &&  model?.data?.list?.count == 0{
                        strongSelf.noResultLabel.text = "没有更多内容"
                        strongSelf.showNoResultLabel()
                    }else{
                        strongSelf.hideNoResultLabel()
                    }
                }else{
                    _ = strongSelf.showToastHidenDefault(model?.msg ?? "请求失败")
                }
            }else {
                
                strongSelf.commentTableView.reloadData()
                _ = strongSelf.showToastHidenDefault(error?._domain)
                
            }
            
            strongSelf.stopRefresh(strongSelf.commentTableView)
        }
    }
    
    
    //MARK: 上拉加载
    override func footRefreshAction() {
        if isLoadFirstPage == false && isLoadingFinished{
            loadCommentList()
        }else{
            self.stopRefresh(commentTableView)
        }
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return commentArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = "CommentTableViewCell"
        var cell:CommentTableViewCell? = nil
        let model = commentArray[(indexPath as NSIndexPath).row]
        cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? CommentTableViewCell
        if cell == nil {
            cell = CommentTableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: cellId)
        }
        cell!.setValueWithModel(model)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if heightArray.count <= (indexPath as NSIndexPath).row {
            let model = commentArray[(indexPath as NSIndexPath).row]
            heightArray.append(CommentTableViewCell.heightForCellWithModel(model))
        }
        
        return heightArray[(indexPath as NSIndexPath).row]
    }
    
    
    // MARK: - keyboard
    func inputBarWillStartEditing(_ inputBar: TKInputBar!, with mode: TKKeyboardMode) -> Bool {
        return true
    }
    func inputBarDidEndEditing(_ inputBar: TKInputBar!) {
        
    }
    func inputBar(_ inputBar: TKInputBar!, willChangeToFrame frame: CGRect, withDuration duration: TimeInterval) {
        
        UIView.animate(withDuration: 0.2 , animations: { () -> Void in
            
            self.commentTableView?.height = frame.origin.y - self.commentTableView!.top
            
        })
        
        if frame.height > 0 && self.tapGesture?.view == nil {
            
            self.commentTableView?.addGestureRecognizer(self.tapGesture!)
        }
    }
    func inputBarShouldReturn(_ inputBar: TKInputBar!) -> Bool {
        let message = inputbar.toSendText()
        
        if message?.length() == 0 || !isLoadingFinished{
            return false
        }
        
        //评论正在发送，返回
        if isSendComment {
            return false
        }
        
        isSendComment = true
        
        //发送评论
        weak var hud = self.showEmptyHud()
        TKRequestHandler.sharedInstance().submitComment(withInfiId: newsId, replyCid: nil, replyUid: nil, content: message) { [weak self](sessionDataTask, model, error) -> Void in
            
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.isSendComment = false
            
            hud?.hide(animated: true)
            if error == nil && model != nil && model?.data != nil{
                
                strongSelf.commentArray.insert((model?.data!)!, at: 0)
                _ = strongSelf.showToastHidenDefault("评论成功")
                
                strongSelf.isLoadFirstPage = false
                strongSelf.heightArray.removeAll()
                strongSelf.commentTableView.reloadData()
                
                var allCellHeigth:CGFloat = 0
                for height in strongSelf.heightArray {
                    allCellHeigth += height
                }
                
                if allCellHeigth > strongSelf.heightForCommentTableView {
                    let offsetY:CGFloat = (strongSelf.commentTableView.tableHeaderView?.bounds.height)!
                    strongSelf.commentTableView.setContentOffset(CGPoint.init(x: 0, y: offsetY - 10), animated: true)
                }else {
                    var offsetY:CGFloat = (strongSelf.commentTableView.tableHeaderView?.bounds.height)!  + allCellHeigth + 30 - strongSelf.heightForCommentTableView
                    if offsetY < 0 {
                        offsetY = 0
                    }
                    
                    strongSelf.commentTableView.setContentOffset(CGPoint.init(x: 0, y: offsetY), animated: true)
                }
                
                strongSelf.hideNoResultLabel()
                strongSelf.addCommentNum()
                strongSelf.hideKeyboard()
                strongSelf.inputbar.setText("")
                
            }else {
                _ = strongSelf.showToastHidenDefault(error?._domain)
                if error?._code == 21509{
                    strongSelf.inputbar.setText("")
                    
                }else{
                    strongSelf.inputbar.setText(message)
                }
            }
        };
        return true
    }
    
    func tapBlankAction(_ geture : UITapGestureRecognizer){
        
        self.hideKeyboard()
        self.commentTableView?.removeGestureRecognizer(self.tapGesture!)
    }
    
    func hideKeyboard() {
        self.inputbar.resignFirstResponder()
    }
    
    //检查登陆状态
    func checkLoginAction() -> Bool{
        if !AccountManager.sharedInstance.isLogin() {
            self.checkLoginButtonClick()
            return false
        }
        
        return true
    }
    
    func checkLoginButtonClick(){
        let loginRegisteVc = LoginRegistViewController()
        self.navigationController?.pushViewController(loginRegisteVc, animated: true)
    }
    
    //评论数加1
    func addCommentNum(){
        
    }
}
