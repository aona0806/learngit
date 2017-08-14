//
//  NewsActivitySignupViewController.swift
//  news
//
//  Created by 陈龙 on 16/1/9.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class NewsActivitySignupViewController: LJBaseViewController {
    
    struct Consts {
        
        static let ContentMarginTopSpace: CGFloat = 13.0
        static let ContentMarginLeftSpace: CGFloat = 26.5
        static let ContentMarginRightSpace: CGFloat = 26.5
        static let ContentMarginBottomSpace: CGFloat = 13.0
        
        static let TopLabelHeight: CGFloat = 10.75
        static let TimeTopSpace: CGFloat = 9.0
        static let TopViewHeight: CGFloat = 56.5
        static let TopFont: UIFont! = UIFont.systemFont(ofSize: 12)
        static let TopColor: UIColor! = UIColor.rgb(0x323232)
        
        static let BottomLabelHeight: CGFloat = 23.0
        
        static let TitleLabelWidth: CGFloat = 100.0
        
        static let bottonTopSpace: CGFloat = 41.0
        static let bottonBottomSpace: CGFloat = 60.0
        static let SubmitSize: CGSize = CGSize(width: 250, height: 40)
        
        static let BottomLabelFont: UIFont = UIFont.systemFont(ofSize: 17)

    }

    private var info: NewsActivityDetailDataModel!
    private let scrollView = UIScrollView()
    private let sponerLabel = UILabel()
    private let timeLabel = UILabel()
    private let nameTitleLabel = UILabel()
    private let nameLabel = UILabel()
    private let phoneTitleLabel = UILabel()
    private let phoneTextField = UITextField()
    
    private let remarkTitleLabel = UILabel()
    private let remarkLabel = UILabel()
    
    private let topView: LJSeperateLineView = LJSeperateLineView(type: .bottom)
    private let bottomView: LJSeperateLineView = LJSeperateLineView(type: .both)
    private let nameLineSeperateView = UIView()
    private let phoneLineSeperateView = UIView()
    
    private let confirmButton = UIButton()
    
    // MARK: - Lifecycle
    
    init(info: NewsActivityDetailDataModel!) {
        
        super.init(nibName: nil, bundle: nil)
        self.info = info
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buildView()
        self.view.backgroundColor = UIColor.white
        
        self.view.setNeedsUpdateConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewsActivitySignupViewController.keyboardChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        self.title = "活动报名"
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        
        scrollView.snp.remakeConstraints { (make) -> Void in
            make.edges.equalTo(self.view).inset(UIEdgeInsets.zero)
            make.bottom.equalTo(self.confirmButton.snp.bottom).offset(Consts.bottonBottomSpace)
        }
        
        topView.snp.remakeConstraints { (make) -> Void in
            make.top.equalTo(self.scrollView.snp.top)
            make.width.equalTo(GlobalConsts.screenWidth)
            make.left.equalTo(self.scrollView.snp.left)
            let height = self.getTopHeight()
            make.height.equalTo(height)
        }
        
        sponerLabel.snp.remakeConstraints { (make) -> Void in
            make.top.equalTo(topView.snp.top).offset(Consts.ContentMarginTopSpace)
            make.left.equalTo(topView.snp.left).offset(Consts.ContentMarginLeftSpace)
            make.right.equalTo(topView.snp.right).offset(-Consts.ContentMarginRightSpace)
            make.height.equalTo(Consts.TopLabelHeight)
        }
        
        timeLabel.snp.remakeConstraints { (make) -> Void in
            make.top.equalTo(sponerLabel.snp.bottom).offset(Consts.TimeTopSpace)
            make.left.equalTo(sponerLabel.snp.left)
            make.right.equalTo(sponerLabel.snp.right)
            make.height.equalTo(sponerLabel.snp.height)
        }
        
        bottomView.snp.remakeConstraints { (make) -> Void in
            make.left.equalTo(self.scrollView)
            make.top.equalTo(self.topView.snp.bottom).offset(10)
            make.width.equalTo(self.view.snp.width)
            let bottomHeight = getBottomHeight()
            make.height.equalTo(bottomHeight)
        }
        
        nameTitleLabel.snp.remakeConstraints { (make) -> Void in
            make.top.equalTo(self.bottomView.snp.top).offset(Consts.ContentMarginTopSpace)
            make.left.equalTo(self.bottomView.snp.left).offset(Consts.ContentMarginLeftSpace)
            make.width.equalTo(Consts.TitleLabelWidth)
            make.height.equalTo(Consts.BottomLabelHeight)
        }
        
        nameLabel.snp.remakeConstraints { (make) -> Void in
            make.left.equalTo(nameTitleLabel.snp.right).offset(0)
            make.right.equalTo(bottomView.snp.right).offset(-Consts.ContentMarginRightSpace)
            make.top.equalTo(nameTitleLabel.snp.top)
            make.bottom.equalTo(nameTitleLabel.snp.bottom)
        }
        
        nameLineSeperateView.snp.remakeConstraints { (make) -> Void in
            make.left.equalTo(self.bottomView.snp.left).offset(13)
            make.right.equalTo(self.bottomView.snp.right)
            make.top.equalTo(nameTitleLabel.snp.bottom).offset(Consts.ContentMarginBottomSpace)
            make.height.equalTo(0.5)
        }
        
        phoneTitleLabel.snp.remakeConstraints { (make) -> Void in
            make.left.equalTo(self.nameTitleLabel.snp.left)
            make.width.equalTo(Consts.TitleLabelWidth)
            make.top.equalTo(self.nameLineSeperateView.snp.bottom).offset(Consts.ContentMarginTopSpace)
            make.height.equalTo(Consts.BottomLabelHeight)
        }
        
        phoneTextField.snp.remakeConstraints { (make) -> Void in
            make.left.equalTo(phoneTitleLabel.snp.right).offset(0)
            make.right.equalTo(bottomView.snp.right).offset(-Consts.ContentMarginRightSpace)
            make.bottom.equalTo(phoneTitleLabel.snp.bottom)
            make.top.equalTo(phoneTitleLabel.snp.top)
        }
        
        phoneLineSeperateView.snp.remakeConstraints { (make) -> Void in
            make.left.equalTo(self.bottomView.snp.left).offset(13)
            make.right.equalTo(self.bottomView.snp.right)
            make.top.equalTo(phoneTitleLabel.snp.bottom).offset(Consts.ContentMarginTopSpace)
            make.height.equalTo(0.5)
        }
        
        remarkTitleLabel.snp.remakeConstraints { (make) -> Void in
            make.top.equalTo(phoneLineSeperateView.snp.bottom).offset(Consts.ContentMarginTopSpace)
            make.left.equalTo(nameTitleLabel.snp.left)
            make.height.equalTo(Consts.BottomLabelHeight)
            make.width.equalTo(Consts.TitleLabelWidth)
        }
        
        remarkLabel.snp.remakeConstraints { (make) -> Void in
            make.left.equalTo(remarkTitleLabel.snp.left)
            make.right.equalTo(bottomView.snp.right).offset(-Consts.ContentMarginRightSpace)
            make.top.equalTo(remarkTitleLabel.snp.bottom)
            let remarkWidth = GlobalConsts.screenWidth - Consts.ContentMarginLeftSpace - Consts.ContentMarginRightSpace
            let remark = info.remark ?? ""
            let remarkHeight = remark.size(withMaxWidth: remarkWidth, font: Consts.BottomLabelFont).height + 1
            make.height.equalTo(remarkHeight)
        }
        
        confirmButton.snp.remakeConstraints { (make) -> Void in
            make.top.equalTo(bottomView.snp.bottom).offset(41)
            make.centerX.equalTo(bottomView.snp.centerX)
            make.width.equalTo(Consts.SubmitSize.width)
            make.height.equalTo(Consts.SubmitSize.height)
        }
    }

    // MARK: - private
    
    private func buildView() {
        
        let remarkWidth = GlobalConsts.screenWidth - Consts.ContentMarginLeftSpace - Consts.ContentMarginRightSpace
        let remark = info.remark ?? ""
        let remarkHeight = remark.size(withMaxWidth: remarkWidth, font: NewsConfig.DetailContentFont).height + 1
        let height = Consts.TopViewHeight + Consts.ContentMarginTopSpace * 3 + Consts.ContentMarginBottomSpace * 3 + Consts.BottomLabelHeight * 3 + 1 + remarkHeight + Consts.bottonTopSpace + Consts.SubmitSize.height + Consts.bottonBottomSpace
        self.scrollView.contentSize = CGSize(width: GlobalConsts.screenWidth, height: height)
        self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        self.scrollView.backgroundColor = UIColor.rgb(0xe8e8e8)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewsActivitySignupViewController.tapAction(_:)))
        self.scrollView.addGestureRecognizer(tapGesture)
        self.view.addSubview(scrollView)
        
        topView.backgroundColor = UIColor.white
        topView.borderColor = NewsConfig.SeperateLineColor.cgColor
        self.scrollView.addSubview(topView)
        
        sponerLabel.backgroundColor = UIColor.clear
        sponerLabel.numberOfLines = 1
        sponerLabel.textColor = Consts.TopColor
        sponerLabel.font = Consts.TopFont
        sponerLabel.text = "主办方：" + (info.sponsor ?? "")
        topView.addSubview(sponerLabel)
        
        timeLabel.backgroundColor = UIColor.clear
        timeLabel.numberOfLines = 1
        let timeStartString = info?.timeStart ?? ""
        let timeStart = Double(timeStartString)
        let timeDate = Date(timeIntervalSince1970: timeStart ?? Double(0))
        let timeString = TKCommonTools.dateString(withFormat: "MM月dd日 HH:mm", date: timeDate) ?? ""
        let timeAttributes = [NSForegroundColorAttributeName:Consts.TopColor, NSFontAttributeName: Consts.TopFont] as [String : Any]
        let timeStrings = "时时间：" + timeString
        let timeStringAttribute = NSMutableAttributedString(string: timeStrings, attributes: timeAttributes)
        timeStringAttribute.addAttribute(NSForegroundColorAttributeName, value: UIColor.clear, range: NSMakeRange(1, 1))
        timeLabel.attributedText = timeStringAttribute
        
        topView.addSubview(timeLabel)
        
        bottomView.backgroundColor = UIColor.white
        bottomView.borderColor = NewsConfig.SeperateLineColor.cgColor
        self.scrollView.addSubview(bottomView)
        
        nameTitleLabel.textColor = UIColor.rgb(0x999999)
        nameTitleLabel.font = Consts.BottomLabelFont
        nameTitleLabel.backgroundColor = UIColor.clear
        nameTitleLabel.numberOfLines = 1
        nameTitleLabel.textAlignment = .left
        nameTitleLabel.text = "姓名"
        bottomView.addSubview(nameTitleLabel)
        
        nameLabel.textColor = UIColor.rgb(0x020202)
        nameLabel.font = Consts.BottomLabelFont
        nameLabel.backgroundColor = UIColor.clear
        nameLabel.numberOfLines = 1
        
        nameLabel.text = AccountManager.sharedInstance.userName()
        bottomView.addSubview(nameLabel)
        
        nameLineSeperateView.backgroundColor = NewsConfig.SeperateLineColor
        bottomView.addSubview(nameLineSeperateView)
        
        phoneTitleLabel.textColor = UIColor.rgb(0x999999)
        phoneTitleLabel.font = Consts.BottomLabelFont
        phoneTitleLabel.backgroundColor = UIColor.clear
        phoneTitleLabel.numberOfLines = 1
        phoneTitleLabel.text = "联系电话"
        bottomView.addSubview(phoneTitleLabel)
        
        phoneTextField.textColor = UIColor.rgb(0x020202)
        phoneTextField.font = Consts.BottomLabelFont
        phoneTextField.backgroundColor = UIColor.clear
        phoneTextField.keyboardType = .phonePad
        phoneTextField.placeholder = "请输入手机号码"
        phoneTextField.text = AccountManager.sharedInstance.getUserInfo()?.uname
//        phoneTextField.becomeFirstResponder()
        
        bottomView.addSubview(phoneTextField)
        
        phoneLineSeperateView.backgroundColor = NewsConfig.SeperateLineColor
        bottomView.addSubview(phoneLineSeperateView)
        
        remarkTitleLabel.textColor = UIColor.rgb(0x999999)
        remarkTitleLabel.font = Consts.BottomLabelFont
        remarkTitleLabel.backgroundColor = UIColor.clear
        remarkTitleLabel.numberOfLines = 1
        remarkTitleLabel.text = "说明"
        bottomView.addSubview(remarkTitleLabel)
        
        remarkLabel.textColor = UIColor.rgb(0x020202)
        remarkLabel.numberOfLines = 0
        remarkLabel.font = Consts.BottomLabelFont
        remarkLabel.backgroundColor = UIColor.clear
        remarkLabel.textAlignment = .left
        remarkLabel.text = info.remark ?? ""
        bottomView.addSubview(remarkLabel)
        
        confirmButton.setBackgroundImage(UIImage(named: "news_activity_signup_confirmbutton_back"), for: UIControlState())
        confirmButton.setTitle("提交", for: UIControlState())
        confirmButton.addTarget(self, action: #selector(NewsActivitySignupViewController.confrimrAction(_:)), for: .touchUpInside)
        self.scrollView.addSubview(confirmButton)
    }
    
    func getBottomHeight() -> CGFloat {
        
        let remarkWidth = GlobalConsts.screenWidth - Consts.ContentMarginLeftSpace - Consts.ContentMarginRightSpace
        let remark = info.remark ?? ""
        let remarkHeight = remark.size(withMaxWidth: remarkWidth, font: Consts.BottomLabelFont).height + 1
        let bottomHeight = Consts.ContentMarginTopSpace * 3 + Consts.ContentMarginBottomSpace * 3 + Consts.BottomLabelHeight * 3 + 1 + remarkHeight
        return bottomHeight
    }
    
    func getTopHeight() -> CGFloat {
        
        let topHeight = Consts.ContentMarginTopSpace + Consts.TopLabelHeight + Consts.TimeTopSpace + Consts.TopLabelHeight + Consts.ContentMarginBottomSpace
        return topHeight
    }
    
    // MARK: - action
    
    func cancelAction(_ button: UIButton) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func confrimrAction(_ button: UIButton) {
        
        let phone: String? = self.phoneTextField.text
        
        if phone?.isEmpty ?? false{
            _ = self.showHud("请输入手机号码", hideDelay: 0.7)
            return
        }
        
        if phone?.length() != 11 {
            _ = self.showHud("手机号码位数不对，请重新输入", hideDelay: 0.7)
            return
        }
        
        self.postSubscribe(self.info.id ?? "0", phone: phone!)
    }
    
    
    // MARK: - action
    
    func tapAction(_ gesture: UIGestureRecognizer) {
        
        self.view.endEditing(true)
    }
    
    /**
    活动报名
    
    - parameter id:    活动id
    - parameter phone: 手机号码
    */
    private func postSubscribe(_ id: String, phone: String) {
        
        if !AccountManager.sharedInstance.isLogin() {
            
            let loginRegisteVc = LoginRegistViewController()
            self.navigateTo(loginRegisteVc)
            return
        }
        
        let name = self.nameLabel.text;
        TKRequestHandler.sharedInstance().postActivitySubscribe(withName: name!, phone: phone, aid: id) { [weak self](sessionDataTask, model, error) -> Void in
            
            guard let strongSelf = self else {
                return
            }
            if error == nil {
                if model?.dErrno == "0" {
                    _ = strongSelf.navigationController?.popViewController(animated: true)
                } else {
                    _ = strongSelf.showToastHidenDefault(model!.msg)
                }
            } else {
                _ = strongSelf.showToastHidenDefault(error?._domain)
            }
        }
    }
    
    // MARK: - keyboard notification
    
    func keyboardChangeFrame(_ n: Notification) {
        
        let frame = ((n as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        self.scrollView.snp.updateConstraints { (make) -> Void in
            var height: CGFloat! = frame?.size.height ?? 0
            let y = frame?.origin.y
            if y == GlobalConsts.screenHeight {
                height = 0
            }
            
            make.edges.equalTo(self.view).inset(UIEdgeInsets.init(top: 0, left: 0, bottom: height, right: 0))

        }
    }
}
