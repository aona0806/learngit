//
//  NewsTelegraphDetailHeaderView.swift
//  news
//
//  Created by wxc on 2017/1/4.
//  Copyright © 2017年 lanjing. All rights reserved.
//

import UIKit

class NewsTelegraphDetailHeaderView: UIView, UITableViewDelegate, UITableViewDataSource, ZLPhotoPickerBrowserViewControllerDataSource, ZLPhotoPickerBrowserViewControllerDelegate{
    
    struct Consts {
        
        static let contentEdge = CGFloat(15)
        static let contentTop = CGFloat(23)
        static let contentFont = UIFont.systemFont(ofSize: 16)
        
        static let timeFont = UIFont.systemFont(ofSize: 12)
        static let BottomViewHeight:CGFloat = 40
    }
    
    var praiseButtonAction:((UIButton)->Void)?
    
    var detailModel:LJNewsTelegraphDetailDataModel?
    
    private var topView: UIView = UIView()//内容，时间
    private var bottomView: UIView = UIView()//底部的view，标签点赞等
    
    // 顶部视图及子视图
    private var contentLabel:UILabel = UILabel()
    var imagesTableView = UITableView.init(frame: .zero, style: .plain)
    private var timeLabel:UILabel = UILabel()
    
    // 底部视图及子视图
    var praiseButton = UIButton()          //点赞按钮
    var commentButton = UIButton()        //评论按钮
    var commentImageView: UIImageView = UIImageView()   //评论
    var commentLabel: UILabel = UILabel()          //最新评论

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initView() {
        self.addSubview(topView)
        self.addSubview(bottomView)
        
        self.backgroundColor = UIColor.rgb(0xeeeeee)
        
        topView.addSubview(contentLabel)
        contentLabel.font = Consts.contentFont
        contentLabel.numberOfLines = 0;
        
        imagesTableView.frame = CGRect.init(x: 0, y: 0, width: self.width, height: 0)
        topView.addSubview(imagesTableView)
        imagesTableView.delegate = self
        imagesTableView.dataSource = self
        imagesTableView.separatorStyle = .none
        
        topView.backgroundColor = UIColor.white
        
        let longTap = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressAction(_:)))
        topView.addGestureRecognizer(longTap)
        
        topView.addSubview(timeLabel)
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textColor = UIColor.rgb(0x9c9da1)
        
        bottomView.backgroundColor = UIColor.white
        bottomView.addSubview(praiseButton)
        bottomView.addSubview(commentLabel)
        bottomView.addSubview(commentButton)
        bottomView.addSubview(commentImageView)
        
        praiseButton.addTarget(self, action: #selector(praiseButtonClick(_:)), for: .touchUpInside)
        praiseButton.setImage(UIImage.init(named: "newsdetail_unpraise"), for: UIControlState.normal)
        praiseButton.setImage(UIImage.init(named: "newsdetail_praise"), for: UIControlState.selected)
        praiseButton.setTitle(" 0", for: UIControlState.normal)
        praiseButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        praiseButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
        bottomView.addSubview(praiseButton)
        
        commentButton.setImage(UIImage.init(named: "newsdetail_comment"), for: UIControlState.normal)
        commentButton.setTitle(" 0", for: UIControlState.normal)
        commentButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
        commentButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        bottomView.addSubview(commentButton)
        
        commentLabel.text = "最新评论"
        commentLabel.textColor = UIColor.rgb(0x008dfc)
        commentLabel.font = UIFont.systemFont(ofSize: 15.0)
        commentLabel.backgroundColor = UIColor.white
        bottomView.addSubview(commentLabel)
        
        commentImageView = UIImageView(frame:CGRect(x: 0, y: 0, width: 5, height: 15))
        commentImageView.contentMode = .scaleAspectFill
        commentImageView.clipsToBounds = true
        commentImageView.image = UIImage(named: "newsdetail_commentblock")
        bottomView.addSubview(commentImageView)
    }
    
    func adjustSubviews() {
        
        topView.frame = CGRect.init(x: 0, y: 0, width: self.width, height: 0)
        
        contentLabel.frame = CGRect.init(x: Consts.contentEdge, y: Consts.contentTop, width: self.width - 2*Consts.contentEdge, height: 0)
        contentLabel.size = contentLabel.sizeThatFits(contentLabel.size)
        
        imagesTableView.reloadData()
        
        imagesTableView.top = contentLabel.bottom + 14
        imagesTableView.height = imagesTableView.contentSize.height
        
        timeLabel.sizeToFit()
        timeLabel.left = Consts.contentEdge
        timeLabel.top = imagesTableView.bottom + 7
        
        topView.height = timeLabel.bottom + 7
        
        bottomView.frame = CGRect.init(x: 0, y: topView.bottom + 7, width: self.width, height: Consts.BottomViewHeight)
        
        commentImageView.centerY = bottomView.height / 2
        
        commentLabel.sizeToFit()
        commentLabel.left = 10 + commentImageView.right
        commentLabel.centerY = commentImageView.centerY
        
        self.adjustCommentButton()
        self.adjustPraiseButton()
        
        self.height = bottomView.bottom
    }
    
    func adjustCommentButton() {
        commentButton.sizeToFit()
        commentButton.centerY = commentImageView.centerY
        commentButton.right = self.width - 15
    }
    
    func adjustPraiseButton() {
        praiseButton.sizeToFit()
        praiseButton.centerY = commentImageView.centerY
        praiseButton.right = commentButton.left - 37
    }
    
    func setHeaderView(model:LJNewsTelegraphDetailDataModel?) {
        
        guard (model != nil) else {
            return
        }
        detailModel = model
        
        var content:String = model?.content ?? ""
        if model?.title != nil && model?.title.isEmpty == false {
            content = "【"+(model?.title)!+"】"+content
        }
        
        let attributedContent = NSMutableAttributedString.init(string:content)
        
        let paragraph = NSMutableParagraphStyle.init()
        paragraph.lineSpacing = 7
        
        var color = UIColor.rgb(0x47484e)
        if detailModel?.marked == "1"{
            color = UIColor.rgb(0xe1473c)
        }
        
        attributedContent.addAttributes([NSFontAttributeName:Consts.contentFont,NSParagraphStyleAttributeName:paragraph,NSForegroundColorAttributeName:color], range: NSRange.init(location: 0, length: attributedContent.length))
        
        contentLabel.attributedText = attributedContent
        
        timeLabel.text = DateFormatter.dayTimeZhunHuan(model!.ctime ?? "0", withFormat:"yyyy-MM-dd HH:mm")
        
        let isZan = model?.isZan ?? "0"
        let isZanNumber = Int(isZan)
        if isZanNumber != nil && isZanNumber == 1 {
            praiseButton.isSelected = true
        }else{
            praiseButton.isSelected = false
        }
        
        var zanNum = " 0"
        var commentNum = " 0"
        
        let zanNum1 = model?.zanNum ?? "0"
        let zanNumber = Int(zanNum1)
        if zanNumber != nil && zanNumber! > 0 {
            zanNum = " \(zanNum1)"
        }
        
        let commentNum1 = model?.commentNum ?? "0"
        let commentNumber = Int(commentNum1)
        if commentNumber != nil && commentNumber! > 0 {
            commentNum = " \(commentNum1)"
        }
        
        praiseButton.setTitle(zanNum, for: .normal)
        praiseButton.setTitle(zanNum, for: .selected)
        commentButton.setTitle(commentNum, for: .normal)
        
        self.adjustSubviews()
    }
    
    func praiseButtonClick(_ sender:UIButton){
        if praiseButtonAction != nil{
            praiseButtonAction!(sender)
        }
    }
    
    func addCommentNum(){
        let num:NSString = commentButton.title(for: .normal)! as NSString
        let numInt = num.integerValue + 1
        let numComment = NSNumber.init(value: numInt)
        commentButton.setTitle(" \(numComment.stringValue)", for: .normal)
        commentButton.setTitle(" \(numComment.stringValue)", for: .selected)
        
        self.adjustCommentButton()
        self.adjustPraiseButton()
    }
    
    func longPressAction(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began{
            let board = UIPasteboard.general
            
            let time = DateFormatter.dayTimeZhunHuan(detailModel?.ctime ?? "0", withFormat:"HH:mm")
            
            board.string = time!+" "+contentLabel.attributedText!.string + "(来自蓝鲸财经|垂直行业信息电报)"
            
            let hud  = MBProgressHUD.showAdded(to: self.window!, animated:true)
            hud.mode = .text
            hud.label.text = "复制成功"
            hud.hide(animated: true, afterDelay: 0.5)
            
            MobClick.event("Roll_List_Copy")

        }
        
    }
    
// MARK:tableView Delegate DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if detailModel?.rollImgs != nil {
            return detailModel?.rollImgs?.count ?? 0
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imgModel = detailModel?.rollImgs[indexPath.row] as! LJNewsTelegraphDetailDataImgsModel
        if imgModel.thumb == nil {
            return 0;
        }
        
        return NewsTelegraphDetailImageTableViewCell.heightWith(model:imgModel.thumb)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let imgModel = detailModel?.rollImgs[indexPath.row] as! LJNewsTelegraphDetailDataImgsModel
        
        let cell = NewsTelegraphDetailImageTableViewCell.init(style: .default, reuseIdentifier: "NewsTelegraphDetailImageTableViewCell")
        cell.setCellImage(model:imgModel.thumb)
        
        cell.imageTapAtCell = {
            [weak self] cell in
            let index = tableView.indexPath(for: cell)?.row
            if index != nil {
                self?.browseImages(index: index!)
            }
        }
        
        return cell
    }
    
    func browseImages(index:Int) {
        let controller = ZLPhotoPickerBrowserViewController()
        controller.currentIndexPath = IndexPath.init(row: index, section: 0)
        let version = UIDevice.current.systemVersion
        if version.hasPrefix("8") {
            controller.status = .fade
        }else{
            controller.status = .zoom
        }
        controller.delegate = self
        controller.dataSource = self
        controller.show()
    }
    
// MARK: browser
    func numberOfSectionInPhotos(inPickerBrowser pickerBrowser: ZLPhotoPickerBrowserViewController!) -> Int {
        let count = 1
        return count
    }
    
    /**
     *  每个组多少个图片
     */
    func photoBrowser(_ photoBrowser: ZLPhotoPickerBrowserViewController!, numberOfItemsInSection section: UInt) -> Int {
        if detailModel?.rollImgs != nil {
            return detailModel?.rollImgs?.count ?? 0
        }else{
            return 0
        }
    }

    /**
     *  每个对应的IndexPath展示什么内容
     */
    func photoBrowser(_ pickerBrowser: ZLPhotoPickerBrowserViewController!, photoAt indexPath: IndexPath!) -> ZLPhotoPickerBrowserPhoto! {
        
        let fromView:NewsTelegraphDetailImageTableViewCell = imagesTableView.cellForRow(at: indexPath) as! NewsTelegraphDetailImageTableViewCell
        
        let imgModel = detailModel?.rollImgs[indexPath.row] as! LJNewsTelegraphDetailDataImgsModel
        let photo = ZLPhotoPickerBrowserPhoto()
        photo.photoURL = URL.init(string: imgModel.org.url ?? "")
        photo.thumbImage = fromView.imgView.imageView.image
        photo.toView = fromView.imgView.imageView
        
        return photo
    }
}
