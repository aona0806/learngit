//
//  NewsTelegraphListCell.swift
//  news
//
//  Created by 奥那 on 2016/12/27.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class NewsTelegraphListCell: UITableViewCell ,ZLPhotoPickerBrowserViewControllerDataSource, ZLPhotoPickerBrowserViewControllerDelegate {
    
    struct Consts {
        static let TitleUnReadFont = UIFont.boldSystemFont(ofSize: 16)
        static let TitleFont = UIFont.systemFont(ofSize: 16)
        static let TitleLineSpace:CGFloat = 7
        static let TextMaxNumLine = 3
        static let MaxImgsWidth = UIScreen.main.bounds.width - 30
    }
    var contentLabel : TKTapCharLabel!
    var readNum : UILabel!
    var commentNum : UILabel!
    var lineView : UIView!
    var commentButton : UIButton!
    var shareButton : UIButton!
    var typeId : String!
    var telegraphImagesView : LJTelegraphImagesView!
    var model : LJNewsRollListDataListModel!
    var imageHeight:CGFloat = 0
    var shareButtonClick:((_ model : LJNewsRollListDataListModel)->())?
    var toTelegraphDetail:((_ cell : NewsTelegraphListCell)->())?
    
    class func heightForModel(_ model : LJNewsRollListDataListModel) -> CGFloat {

        let linesNum = model.isShowAll ? 0 : Consts.TextMaxNumLine
        let attStr = self.getContentStyle(model)
        let contentHeight = attStr.size(withMaxWidth: UIScreen.main.bounds.width - 30, font: nil, maxLineNum: linesNum).height
        
        var imgHeight:CGFloat = 0
        if (model.hasImg != nil) && model.hasImg! == "1" && (model.rollImgs != nil) && (model.rollImgs?.count)! > 0 && linesNum != Consts.TextMaxNumLine{
            var width = Consts.MaxImgsWidth
            if model.rollImgs?.count == 1 {
                width = NewsTelegraphListCell.getSingleImage(model.rollImgs as! [LJNewsRollListDataListRollImgsModel])
            }
            
            imgHeight = LJTelegraphImagesView.height(forModel: model.rollImgs, width:width) + 14
            
        }
        
        return contentHeight + 8 + 14 + 15 + 14 + imgHeight
    }
    
    //单图显示宽度
    class func getSingleImage(_ imgs : [LJNewsRollListDataListRollImgsModel]) -> CGFloat{
        
        let imgModel = imgs[0]
        var showWidth = Consts.MaxImgsWidth
        let width = NSString.init(string: (imgModel.thumb?.w)!)
        let height = NSString.init(string: (imgModel.thumb?.h)!)
        let heightWidthRadio = height.floatValue / width.floatValue
        
        let maxHeight = NSString.init(format: "%f", UIScreen.main.bounds.height/3.0 * 2)
        if heightWidthRadio > 2.5 && height.floatValue > maxHeight.floatValue{
            showWidth /= 2
        }
        return showWidth
    }
    
    
    class func getContentStyle(_ model : LJNewsRollListDataListModel) -> NSMutableAttributedString {
        
        var title = ""
        
        let time = NSString.init(string: model.ctime ?? "")
        let timeStr = TKCommonTools.datestring(withFormat: TKDateFormatHHMM, timeStamp: time.doubleValue)
        title += timeStr!
        
        
        if model.title != nil && (model.title?.length())! > 0 {
            title += "【"+model.title!+"】"
        }else{
            title += " "
        }
        title += model.content ?? ""
        
        if title.length() > 0{
            let attStr = NSMutableAttributedString.init(string: title)
            
            let paragraphStyle = NSMutableParagraphStyle.init()
            paragraphStyle.lineSpacing = Consts.TitleLineSpace
            attStr.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attStr.length))
            var textColor = UIColor()
            
            if model.marked == "1"{
                textColor = model.isRead ? UIColor.rgb(0xe1473c) : UIColor.rgb(0xe1473c)
                attStr.addAttribute(NSForegroundColorAttributeName, value: textColor, range: NSMakeRange(0, attStr.length))
                
            }else{
                let timeColor = model.isRead ? UIColor.rgb(0x55a3f6) : UIColor.rgb(0x008dfc)
                attStr.addAttribute(NSForegroundColorAttributeName, value: timeColor, range: NSMakeRange(0, 5))
                
                textColor = model.isRead ? UIColor.rgb(0x47484e): UIColor.rgb(0x47484e)
                attStr.addAttribute(NSForegroundColorAttributeName, value: textColor, range: NSMakeRange(5, attStr.length - 5))
                
            }
            
            let font = model.isRead ? Consts.TitleFont : Consts.TitleUnReadFont
            attStr.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(0, attStr.length))
            let linesNum = model.isShowAll ? 0 : Consts.TextMaxNumLine

            if linesNum == Consts.TextMaxNumLine {
                var charIndex = TKTapCharLabel.charIndex(withAttrString: attStr,widthWidth:UIScreen.main.bounds.width - 30,lineNum:Consts.TextMaxNumLine,lastLinePadding:35,lineBreakMode:.byWordWrapping)
                
                if attStr.length > charIndex + 1{
                    //截断
                    attStr.replaceCharacters(in: NSMakeRange(charIndex, attStr.length - charIndex), with: "... ")
                }else{
                    attStr.replaceCharacters(in: NSMakeRange(attStr.length , 0), with: " ")
                    
                }
                
                if model.hasImg == "1" && model.rollImgs != nil && model.rollImgs?.count != 0{
                    attStr.append(getImgIndicatorAttrStr())
                    var lastIndex = charIndex - 1
                    
                    repeat{
                        charIndex = TKTapCharLabel.charIndex(withAttrString: attStr,widthWidth:UIScreen.main.bounds.width - 30,lineNum:Consts.TextMaxNumLine,lastLinePadding:0,lineBreakMode:.byWordWrapping)
                        if charIndex + 1 < attStr.length {
                            attStr.replaceCharacters(in: NSMakeRange(lastIndex, 1), with: "")
                            lastIndex -= 1
                        }else{
                            break
                        }
                        
                    }while(charIndex >= 0 && lastIndex >= 0)
                    
                }
            }
            
            return attStr
        }
        
        return NSMutableAttributedString.init()
    }
    
    class func getImgIndicatorAttrStr() -> (NSAttributedString){
        
        let image = UIImage.init(named: "icon_pic")
        let attachment = NSTextAttachment.init()
        attachment.image = image
        attachment.bounds = CGRect(x: 0, y: -2, width: 18, height: 16)
        return NSAttributedString.init(attachment: attachment)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.backgroundColor = UIColor.clear
        
        buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }
    
    func buildView() {
        contentLabel = TKTapCharLabel()
        contentView.addSubview(contentLabel)
        
        telegraphImagesView = LJTelegraphImagesView.init()
        weak var weakSelf = self
        telegraphImagesView.tapBlock = {(index : Int,section : Int , imageView:UIImageView?) -> Void in
            weakSelf?.clickImageView(index,section: section, imageView: imageView)
        }
        contentView.addSubview(telegraphImagesView)
        
        readNum = UILabel()
        readNum.font = UIFont.systemFont(ofSize: 12)
        readNum.textColor = UIColor.init(colorLiteralRed: 156/255.0, green: 157/255.0, blue: 161/255.0, alpha: 1)
        contentView.addSubview(readNum)
        
        commentNum = UILabel()
        commentNum.font = UIFont.systemFont(ofSize: 12)
        commentNum.textColor = UIColor.init(colorLiteralRed: 156/255.0, green: 157/255.0, blue: 161/255.0, alpha: 1)
        contentView.addSubview(commentNum)
        
        shareButton = UIButton()
        shareButton.backgroundColor = UIColor.clear
        shareButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        shareButton.setTitleColor(UIColor.init(colorLiteralRed: 156/255.0, green: 157/255.0, blue: 161/255.0, alpha: 1), for: .normal)
        shareButton?.setTitle("分享", for: .normal)
        shareButton.setImage(UIImage.init(named: "tele_list_share"), for: .normal)
        shareButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -25, bottom: 0, right: 0)
        shareButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -55)

        shareButton.addTarget(self, action: #selector(NewsTelegraphListCell.shareAction), for: .touchUpInside)
        contentView.addSubview(shareButton)
        
        commentButton = UIButton()
        commentButton.backgroundColor = UIColor.clear
        commentButton.addTarget(self, action: #selector(NewsTelegraphListCell.toDetail), for: .touchUpInside)
        contentView.addSubview(commentButton)
        
        lineView = UIView()
        lineView.backgroundColor = UIColor.init(colorLiteralRed: 242/255.0, green: 243/255.0, blue: 243/255.0, alpha: 1)
        contentView.addSubview(lineView)
        
        let longPress = UILongPressGestureRecognizer.init(target: self, action:#selector(NewsTelegraphListCell.longPressAction(_:)))
        contentLabel.addGestureRecognizer(longPress)
        contentLabel.isUserInteractionEnabled = true
    
    }
    
    func initConstraints() {
        
        contentLabel.snp.updateConstraints {(make) -> Void in
            make.left.equalTo(contentView.snp.left).offset(15)
            make.right.equalTo(contentView.snp.right).offset(-15)
            make.top.equalTo(contentView.snp.top).offset(8)
            let att = NewsTelegraphListCell.getContentStyle(model)
            let linesNum = model.isShowAll ? 0 : Consts.TextMaxNumLine
            let height: CGFloat! = att.size(withMaxWidth: UIScreen.main.bounds.width - 30, font: nil, maxLineNum: linesNum).height
            make.height.equalTo(height)

        }
        
        telegraphImagesView.snp.updateConstraints {(make) -> Void in
            make.left.equalTo(contentLabel.snp.left)
            var imgWidth:CGFloat = UIScreen.main.bounds.width - 30
            if model.rollImgs != nil && (model.rollImgs?.count)! == 1{
                imgWidth = NewsTelegraphListCell.getSingleImage(model.rollImgs as! [LJNewsRollListDataListRollImgsModel])
            }
            make.width.equalTo(imgWidth)
            make.top.equalTo(contentLabel.snp.bottom).offset(14)
            make.height.equalTo(imageHeight)
        }
        
        commentNum.snp.updateConstraints {(make) -> Void in
            make.right.equalTo(contentView.snp.right).offset(-15)
            if imageHeight == 0{
                make.top.equalTo(telegraphImagesView.snp.bottom).offset(0)
            }else{
                make.top.equalTo(telegraphImagesView.snp.bottom).offset(14)
            }
            make.height.equalTo(15)
            let width : CGFloat! = commentNum.text!.size(withMaxWidth: 200, font: UIFont.systemFont(ofSize: 12)).width
            make.width.equalTo(width)
        }
        
        commentButton.snp.updateConstraints { (make) -> Void in
            make.right.equalTo(contentView.snp.right)
            make.left.equalTo(commentNum.snp.left).offset(-10)
            make.top.equalTo(commentNum.snp.top).offset(-10)
            make.height.equalTo(35)
        }
        
        shareButton.snp.updateConstraints {(make) -> Void in
            make.right.equalTo(commentNum.snp.left).offset(-18)
            make.top.equalTo(commentButton.snp.top)
            make.height.equalTo(35)
            make.width.equalTo(50)
        }
        
        readNum.snp.updateConstraints {(make) -> Void in
            make.right.equalTo(shareButton.snp.left).offset(-18)
            make.top.equalTo(commentNum.snp.top)
            make.height.equalTo(commentNum.snp.height)
            let width : CGFloat! = readNum.text!.size(withMaxWidth: 200, font: UIFont.systemFont(ofSize: 12)).width
            make.width.equalTo(width)
        }
        
        lineView.snp.updateConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp.left).offset(15)
            make.right.equalTo(contentView.snp.right).offset(-15)
            make.top.equalTo(readNum.snp.bottom).offset(13)
            make.height.equalTo(1)
        }
        
    }
    
    func updateWithModel(_ model : LJNewsRollListDataListModel , hideLine : Bool) {
        
        self.model = model
        let linesNum = model.isShowAll ? 0 : Consts.TextMaxNumLine
        contentLabel.numberOfLines = linesNum
        contentLabel.attributedText = NewsTelegraphListCell.getContentStyle(model)
        readNum.text = "阅 "+(model.readingNum ?? "")
        commentNum.text = "评论 "+(model.commentNum ?? "")
        lineView.isHidden = hideLine
        
        if (model.hasImg != nil) && model.hasImg! == "1" && (model.rollImgs != nil) && (model.rollImgs?.count)! > 0 && linesNum != Consts.TextMaxNumLine{
            telegraphImagesView.isHidden = false
            var width = Consts.MaxImgsWidth
            if model.rollImgs?.count == 1 {
                width = NewsTelegraphListCell.getSingleImage(model.rollImgs as! [LJNewsRollListDataListRollImgsModel])
            }
            
            telegraphImagesView.update(withImages: model.rollImgs as! [LJNewsRollListDataListRollImgsModel]!, width : width)
            imageHeight = LJTelegraphImagesView.height(forModel: model.rollImgs, width:width)

        }else{
            telegraphImagesView.isHidden = true
            imageHeight = 0
        }

        
        initConstraints()
    }

    
    //长按复制
    func longPressAction(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began{
            let board = UIPasteboard.general
            board.string = contentLabel.text!+"(来自蓝鲸财经|垂直行业信息电报)"
            
            let window = UIApplication.shared.keyWindow
            let hud  = MBProgressHUD.showAdded(to: window!, animated:true)
            hud.mode = .text
            hud.label.text = "复制成功"
            hud.hide(animated: true, afterDelay: 0.5)
            
            MobClick.event("Roll_List_Copy")

        }
        
    }
    
    //电报详情
    func toDetail(){
        if toTelegraphDetail != nil {
            toTelegraphDetail!(self)
        }

    }
    
    //分享
    func shareAction(){
        if shareButtonClick != nil {
            shareButtonClick!(model)
        }
    }
    
    //点击查看大图
    func clickImageView(_ index : Int ,section : Int , imageView:UIImageView?){
        
        let controller = ZLPhotoPickerBrowserViewController()
        let count = section * 2 + index
        controller.currentIndexPath = IndexPath.init(row: count, section: 0)
        let version = UIDevice.current.systemVersion
        if version.hasPrefix("8") {
            controller.status = .fade
        }else{
            controller.status = .zoom
        }
        controller.delegate = self
        controller.dataSource = self
        controller.show()
        
        MobClick.event("Roll_List_Show_OrgImg", attributes: ["typeId":typeId])

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
        if model?.rollImgs != nil {
            return model?.rollImgs?.count ?? 0
        }else{
            return 0
        }
    }
    
    /**
     *  每个对应的IndexPath展示什么内容
     */
    func photoBrowser(_ pickerBrowser: ZLPhotoPickerBrowserViewController!, photoAt indexPath: IndexPath!) -> ZLPhotoPickerBrowserPhoto! {
        
        let fromView = self.telegraphImagesView.image(at: indexPath.row)
        
        let imgModel = model?.rollImgs?[indexPath.row] as! LJNewsRollListDataListRollImgsModel
        let photo = ZLPhotoPickerBrowserPhoto()
        photo.photoURL = URL.init(string: imgModel.org?.url ?? "")
        photo.thumbImage = fromView?.image
        photo.toView = fromView
        
        return photo
    }

}
