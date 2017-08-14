//
//  NewsPushRemindView.swift
//  news
//
//  Created by wxc on 2017/1/10.
//  Copyright © 2017年 lanjing. All rights reserved.
//

import UIKit

class NewsPushRemindViewCell: UICollectionViewCell {
    
    var titleLabel = UILabel()
    
    struct Consts {
        static let TitleFont = UIFont.systemFont(ofSize: 17)
    }
    
    class func cellWidthForTitle(_ title:String) -> CGFloat {
        
        var offset:CGFloat = 40
        if UIScreen.main.bounds.width < 375  {
            offset = 25
        }
        return title.size(withMaxWidth: 10000 , font: Consts.TitleFont).width + offset
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.font = Consts.TitleFont
        titleLabel.textAlignment = .center
        titleLabel.layer.cornerRadius = self.height / 2
        titleLabel.layer.masksToBounds = true
        self.contentView.addSubview(titleLabel)
    }
    
    func setTitle(title:String) {
        titleLabel.text = title
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = frame
        titleLabel.center = self.contentView.center
        
        if self.isSelected {
            titleLabel.textColor = UIColor.white
            titleLabel.layer.borderWidth = 0
            titleLabel.backgroundColor = UIColor.rgb(0x39b9f7)
        }else {
            titleLabel.textColor = UIColor.rgb(0xcccccc)
            titleLabel.layer.borderWidth = 1
            titleLabel.layer.borderColor = UIColor.rgb(0xcccccc).cgColor
            titleLabel.backgroundColor = UIColor.clear
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class NewsPushRemindView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //页面一 用于设置
    var bgImageView = UIImageView()
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    
    var collectionLayout = UICollectionViewFlowLayout()
    var menuCollectionView:UICollectionView!
    
    var confirmButton = UIButton()
    
    var adjustAlpha:CGFloat = 1
    
    var pushConfirmAction:(()->())?
    
    //data
    var dataArray:[LJPushInfoDataConfigTelegraphModel] = [] {
        didSet {
            menuCollectionView.reloadData()
            for model in dataArray {
                if model.status == "1" {
                    let indexPath = NSIndexPath.init(row: dataArray.index(of: model)!, section: 0) as IndexPath
                    menuCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
                }
            }
            
            checkIsSelected()
        }
    }
    
    var remindString = "如需重新调整推送电报的行业，可以在个人中心——推送设置中打开/关闭各行业信息的推送开关。"
    var netErrorString = "网络连接异常 如需继续设置，可以在个人中心——推送设置中打开/关闭各行业信息的推送开关。"
    
    //页面二 设置成功/失败
    var bgView = UIView()
    var successImageView = UIImageView()
    var successTitleLabel = UILabel()
    var remindLabel = UILabel()
    var knownButton = UIButton()

    init() {
        super.init(frame: UIScreen.main.bounds)
        self.setUpSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpSubViews() {
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        
        bgImageView.image = UIImage.init(named: "news_push_remind_bg")
        bgImageView.sizeToFit()
        
        bgImageView.isUserInteractionEnabled = true
        
        if self.width < 375 {
            bgImageView.width = bgImageView.width * self.width / 375
            bgImageView.height = bgImageView.height * self.width / 375
        }
        adjustAlpha = bgImageView.width / CGFloat(318)
        
        bgImageView.centerX = self.width / 2
        bgImageView.centerY = self.height / 2 + 20
        self.addSubview(bgImageView)
        
        titleLabel.text = "至少勾选一个行业接收"
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textColor = UIColor.black
        titleLabel.sizeToFit()
        titleLabel.centerX = bgImageView.width / 2
        titleLabel.top = 147 * adjustAlpha
        bgImageView.addSubview(titleLabel)
        
        subTitleLabel.text = "或稍后在\"个人中心-推送设置\"中设置"
        subTitleLabel.font = UIFont.systemFont(ofSize: 14)
        subTitleLabel.textColor = UIColor.rgb(0x9c9da1)
        subTitleLabel.sizeToFit()
        subTitleLabel.centerX = titleLabel.centerX
        subTitleLabel.top = titleLabel.bottom + 5
        bgImageView.addSubview(subTitleLabel)
        
        confirmButton.setTitle("确定", for: .normal)
        confirmButton.frame = CGRect.init(x: 0, y: 0, width: 200, height: 40)
        confirmButton.centerX = bgImageView.width / 2
        confirmButton.bottom = bgImageView.height - 24
        confirmButton.layer.cornerRadius = confirmButton.height / 2
        confirmButton.layer.masksToBounds = true
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        confirmButton.backgroundColor = UIColor.rgb(0x008dfc)
        confirmButton.addTarget(self, action: #selector(confirmButtonAction(_:)), for: .touchUpInside)
        bgImageView.addSubview(confirmButton)
        
        collectionLayout.scrollDirection = .vertical
        collectionLayout.minimumInteritemSpacing = 14 * adjustAlpha
        collectionLayout.minimumLineSpacing = 20
        if adjustAlpha < 1{
            collectionLayout.minimumLineSpacing = 10
        }
        
        let collectionViewTop = subTitleLabel.bottom + 14 * adjustAlpha
        menuCollectionView = UICollectionView.init(frame: CGRect.init(x: 25*adjustAlpha, y: collectionViewTop, width: bgImageView.width - 50 * adjustAlpha, height: confirmButton.top - 22*adjustAlpha - collectionViewTop), collectionViewLayout: collectionLayout)
        
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        menuCollectionView.backgroundColor = UIColor.clear
        menuCollectionView.showsVerticalScrollIndicator = false
        menuCollectionView.allowsMultipleSelection = true
        
        menuCollectionView.register(NewsPushRemindViewCell.self, forCellWithReuseIdentifier: "NewsPushRemindViewCell")
        
        bgImageView.addSubview(menuCollectionView)
        
    }
    
    //构建我知道了页面
    func showKnownViews(success:Bool) {
        bgImageView.isHidden = true
        
        bgView.frame = bgImageView.frame
        bgView.layer.cornerRadius = 5
        bgView.layer.masksToBounds = true
        bgView.height = 257*adjustAlpha
        bgView.backgroundColor = UIColor.white
        self.addSubview(bgView)
        
        if success {
            successImageView.image = UIImage.init(named: "news_push_remind_success")
        }else{
            successImageView.image = UIImage.init(named: "news_push_remind_error")
        }
        
        successImageView.sizeToFit()
        
        if success {
            successImageView.left = 98*adjustAlpha
        }else {
            successImageView.left = 77*adjustAlpha
        }
        successImageView.top = 35*adjustAlpha
        bgView.addSubview(successImageView)
        
        successTitleLabel.font = UIFont.systemFont(ofSize: 20)
        if success {
            successTitleLabel.text = "设置完成"
        }else {
            successTitleLabel.text = "行业设置失败"
        }
        successTitleLabel.sizeToFit()
        successTitleLabel.left = successImageView.right + 8*adjustAlpha
        successTitleLabel.centerY = successImageView.centerY
        bgView.addSubview(successTitleLabel)
        
        remindLabel.frame = CGRect.init(x: 27 * adjustAlpha, y: successImageView.bottom + 20 * adjustAlpha, width: bgView.width - 54 * adjustAlpha, height: 0)
        remindLabel.numberOfLines = 0
        
        var content = NSMutableAttributedString.init(string: remindString)
        
        if !success{
            content = NSMutableAttributedString.init(string: netErrorString)
        }
        
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 10
        
        content.addAttributes([NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:UIFont.systemFont(ofSize: 17),NSForegroundColorAttributeName:UIColor.rgb(0x47484e)], range: NSRange.init(location: 0, length: content.length))
        
        remindLabel.attributedText = content;
        remindLabel.size = remindLabel.sizeThatFits(remindLabel.size)
        bgView.addSubview(remindLabel)
        
        knownButton.setTitle("我知道了", for: .normal)
        knownButton.frame = CGRect.init(x: 0, y: 0, width: 200, height: 40)
        knownButton.centerX = bgView.width / 2
        knownButton.top = remindLabel.bottom + 35
        knownButton.layer.cornerRadius = knownButton.height / 2
        knownButton.layer.masksToBounds = true
        knownButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        knownButton.backgroundColor = UIColor.rgb(0x008dfc)
        knownButton.addTarget(self, action: #selector(knownButtonAction(_:)), for: .touchUpInside)
        bgView.addSubview(knownButton)
        
        bgView.height = knownButton.bottom + 24
    }
    
    func confirmButtonAction(_ sender:UIButton) {
        //确认
        if pushConfirmAction != nil {
            pushConfirmAction!()
        }
    }
    
    private func checkIsSelected() {
        let indexs = menuCollectionView.indexPathsForSelectedItems?.count ?? 0
        if indexs > 0{
            confirmButton.isEnabled = true
            confirmButton.backgroundColor = UIColor.rgb(0x008dfc)
        }else {
            confirmButton.isEnabled = false
            confirmButton.backgroundColor = UIColor.rgb(0xcccccc)
        }
    }
    
    func knownButtonAction(_ sender:UIButton) {
        self.removeFromSuperview()
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:NewsPushRemindViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsPushRemindViewCell", for: indexPath) as! NewsPushRemindViewCell
        let model = dataArray[indexPath.row]
        cell.setTitle(title: model.name ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let model = dataArray[indexPath.row]
        return CGSize(width: NewsPushRemindViewCell.cellWidthForTitle(model.name ?? ""), height: 30)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataArray[indexPath.row]
        model.status = "1"
        let cell:NewsPushRemindViewCell = collectionView.cellForItem(at: indexPath) as! NewsPushRemindViewCell
        cell.setNeedsLayout()
        
        checkIsSelected()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let model = dataArray[indexPath.row]
        model.status = "0"
        let cell:NewsPushRemindViewCell = collectionView.cellForItem(at: indexPath) as! NewsPushRemindViewCell
        cell.setNeedsLayout()
        
        checkIsSelected()
    }
    
}
