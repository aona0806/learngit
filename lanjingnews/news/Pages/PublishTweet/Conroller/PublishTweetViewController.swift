//
//  PublishTweetViewController.swift
//  news
//
//  Created by chunhui on 15/12/23.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

class PublishTweetViewController : BaseViewController , UITextViewDelegate, UINavigationControllerDelegate, ChatEmojiViewDelegate, ZLPhotoPickerViewControllerDelegate, ZLPhotoPickerBrowserViewControllerDataSource, ZLPhotoPickerBrowserViewControllerDelegate,PasteDelegate{

    struct Const {
        static let horMargin = CGFloat(13)
        
    }
    
    var contentView : SZTextView!
    var photosView : PublishPhotoChooseView!
    var bottombar : PublishBottomBar!
    
    var camerViewController : ZLCameraViewController?
    
    var chatKeyBoard : ChatEmojiView?
    
    var photosUrlDict = [Int : String]()
    var photosUploadTasks = Dictionary<Double, URLSessionDataTask>()
    var shouldPublish = false
    var uploadHud : MBProgressHUD? = nil
    
    
    var publishTweetDone:(()->())? = nil
    
    
    private func initNavbar() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.defaultLeftItem(withTarget: self, action: #selector(PublishTweetViewController.backAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发表", style: .plain, target: self, action:#selector(PublishTweetViewController.publishAction))
        
    }
    
    private func initEmojiKeyboard() {
        
        if chatKeyBoard == nil {
            chatKeyBoard = ChatEmojiView()
            chatKeyBoard?.delegate = self
            self.view.addSubview(chatKeyBoard!)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = true
        self.title = "新讨论"
        
        contentView = SZTextView(frame: CGRect.zero)
        contentView.font = UIFont.systemFont(ofSize: 17)
        contentView.delegate = self
        
        photosView = PublishPhotoChooseView(frame: CGRect(x: 0,y: 0,width: self.view.width,height: 70))
        photosView.tapImage = {[weak self] (type:PublishPhotoTapType , index : Int)->Void in
            self?.tapImage(type, index: index)
        }
        
        bottombar = PublishBottomBar(frame: CGRect(x: 0,y: 0,width: self.view.width,height: 42))
        bottombar.iconTap = { [weak self] (type: PublishIconType , choose: Bool)-> Void in
            self?.bottombarAction(type, choose: choose)
        }
        
        self.initNavbar()
        initEmojiKeyboard()
        self.view.addSubview(contentView)
        self.view.addSubview(photosView)
        self.view.addSubview(bottombar)
        
        self.initConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
                
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardChangeNotification(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        center.addObserver(self, selector: #selector(PublishTweetViewController.keyboardHideNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
     
        NotificationCenter.default.removeObserver(self)

    }
    
    private func initConstraints(){
        
        bottombar.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view.bottom).offset(0)
            make.height.equalTo(42)
        }
        
        photosView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(Const.horMargin)
            make.right.equalTo(self.view).offset(-Const.horMargin)
            make.height.equalTo(70)
            make.bottom.equalTo(bottombar.snp.top).offset(-10)
        }
        
        contentView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(Const.horMargin)
            make.right.equalTo(self.view).offset(-Const.horMargin)
            make.top.equalTo(self.view).offset(5)
            make.bottom.equalTo(photosView.snp.top).offset(-10)
        }
        
        chatKeyBoard?.snp.makeConstraints{ (make) -> Void in
            make.left.right.equalTo(self.view)
            let keyboardHeight : CGFloat = chatKeyBoard!.frame.height
            make.height.equalTo(keyboardHeight)
            make.top.equalTo(self.bottombar.snp.bottom)
        }
        
    }
    
    func publishAction(){
        
        self.contentView.resignFirstResponder()
        self.showEmojiKeyboard(false)
        
        var content  = self.contentView.plainText()
        content = content?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if content?.length() == 0 {
            _ = self.showToastHidenDefault("请填写讨论内容")

            return
        }
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        let images = photosView.selImages()
        if images.count == 0 {
            publishTweet()
        }else{
            
            for i in 0  ..< images.count  {
                self.uploadImage(images[i], index: i)
            }
            
            self.shouldPublish = true
            self.uploadHud = showHud("正在提交...")
        }        
        
    }
    
    
    override func backAction(){
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func uploadImage(_ image : UIImage , index : Int){
        
        weak var weakSelf = self
        let seedKey = Date().timeIntervalSince1970
        
        let task = ImageUploadManager.uploadImage(image, fileName: index.description , completion:  { (task, url, error) -> () in
            
            if  let strongSelf = weakSelf {
                var success = false
                if  url != nil && !url!.isEmpty {
                    strongSelf.photosUrlDict[index] = url!
                    success = true
                }
                
                if success {
                    
                    strongSelf.photosUploadTasks.removeValue(forKey: seedKey)
                    
                    if strongSelf.shouldPublish && (strongSelf.photosUploadTasks.count == 0) {
                        strongSelf.publishTweet()
                    }
                    
                }else{
                    strongSelf.updateImageFailed()
                    
                }
            }
        })
        
        self.photosUploadTasks[seedKey] = task
    }

    
    private func updateImageFailed(){
        
        if self.photosUploadTasks.count == 0 {
            //cancelled task call back
            return
        }
        
        self.uploadHud?.label.text = "上传图片失败"
        self.uploadHud?.hide(animated: true, afterDelay: 1)
        self.shouldPublish = false
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        for task in self.photosUploadTasks.values {
            //cancel正在发送的请求
            task.cancel()
        }
        
        //clear all task
        self.photosUploadTasks.removeAll()
        
    }
    
    func publishTweet(){
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        if self.uploadHud != nil {
            self.uploadHud?.hide(animated: false)
            self.uploadHud = nil
        }
        
        let hud = showHud("正在提交...")
        
        var contentString = self.contentView.plainText()
        contentString = contentString?.replacingOccurrences(of: "\r\n", with: "\n", options: NSString.CompareOptions.literal)
//        contentString = contentString?.replacingOccurrences(of: "\r\n", with: "\n", options: NSString.CompareOptions.literal, range: range)
        contentString = contentString?.replacingOccurrences(of: "\r", with: "\n", options: NSString.CompareOptions.literal)
        
        var imgUrls = [String]()
        if self.photosUrlDict.count > 0 {
            for i in self.photosUrlDict.keys.sorted() {
                imgUrls.append(self.photosUrlDict[i]!)
            }
        }
        
        TKRequestHandler.sharedInstance().publishTweetType("new", title: nil, content: contentString, tid : "", img: imgUrls, extends: nil) { [weak self](task, model , error) -> Void in
            
            guard let strongSelf = self else {
                return
            }
            
            hud.hide(animated: false)
            strongSelf.navigationItem.rightBarButtonItem?.isEnabled = true
            
            if error == nil || error?._code == 20803 {
                
                _ = strongSelf.showToastCoinToast(true, type: .sendTweet, error: error as NSError?, titleSuccess: "发布成功", titleFaile: "发布失败,请重试"){
                    strongSelf.publishTweetDone?()
                    _ = strongSelf.navigationController?.popViewController(animated: true)
                }
            } else{
                _ = strongSelf.showHud("发布失败，请重试", hideDelay: 1)
            }
            
            strongSelf.navigationItem.rightBarButtonItem?.isEnabled = true
            
        }
    }
    
    //MARK: - photo tap 
    func tapImage(_ type:PublishPhotoTapType , index : Int){
        
        contentView.resignFirstResponder()
        
        
        switch type {
        case .image:
            self.showPickBrowerController(index)
        case .addImage:
            
            if self.camerViewController == nil {
                self.camerViewController = ZLCameraViewController()
                
            }
            self.camerViewController!.maxCount = UInt(3 - index)
            self.camerViewController!.startCameraOrPhotoFile(with: self, complate: { [weak self](obj : Any?) in
                
                guard let strongSelf = self else {
                    return
                }
                
                guard let objArray = obj as? NSArray  else {
                    return
                }
                
//                guard let objArray : Array<AnyObject> = object as? Array<AnyObject> else {
//                    return
//                }
                
                var images = [UIImage]()
                var image : UIImage? = nil
                for asset in objArray {
                    if asset is ZLPhotoAssets {
                        let tmp = asset as! ZLPhotoAssets
                        image = tmp.originImage()
                    }else if asset is UIImage {
                        image = asset as? UIImage
                    }else if asset is ZLCamera {
                        let camera = asset as? ZLCamera
                        image = camera?.fullScreenImage
                    }else{
                        image = nil
                    }
                    
                    if image != nil {
                        image = ImageHelper.normImageOrientation(image)
                        image = ImageHelper.resize(image, maxWidth: 1196)
                        
                        images.append(image!)
                    }
                }
                strongSelf.photosView.addImages(images)
                
                
            })
        }
    }
    
    //bottom bar
    func bottombarAction(_ type:PublishIconType , choose: Bool){
        
        if type == .emoji {
            showEmojiKeyboard(choose)
        }
        
    }
    
    /**
     预览需要发送的图片
     
     - parameter currentPage: 当前显示的页面
     */
    func showPickBrowerController(_ currentPage : Int){
        
        let pickerBrowser = ZLPhotoPickerBrowserViewController()
        if currentPage < 3 && currentPage >= 0 {
            pickerBrowser.currentIndexPath = IndexPath(item: currentPage, section: 0)
        } else {
            pickerBrowser.currentIndexPath = IndexPath(item: 0, section: 0)
        }
        pickerBrowser.delegate = self
        pickerBrowser.dataSource = self
        pickerBrowser.isEditing = true
        pickerBrowser.show()
        
    }
    
    
    // MARK: - ZLPhotoPickerBrowserViewControllerDataSource
    
    func numberOfSectionInPhotos(inPickerBrowser pickerBrowser: ZLPhotoPickerBrowserViewController!) -> Int {
        let count = 0
        return count
    }
    
    func photoBrowser(_ photoBrowser: ZLPhotoPickerBrowserViewController!, numberOfItemsInSection section: UInt) -> Int {
        let count = self.photosView.currentImageCount()
        return count
    }
    
    
    func photoBrowser(_ pickerBrowser: ZLPhotoPickerBrowserViewController!, photoAt indexPath: IndexPath!) -> ZLPhotoPickerBrowserPhoto! {
        let imageIndex = indexPath.row
        let image = photosView[imageIndex]
        let photo = ZLPhotoPickerBrowserPhoto(anyImageObjWith: image)
        photo?.toView = photosView.imageViewAt(imageIndex)
        return photo
    }
    
    // MARK: - ZLPhotoPickerBrowserViewControllerDelegate
    
    func photoBrowser(_ photoBrowser: ZLPhotoPickerBrowserViewController!, removePhotoAt indexPath: IndexPath!) {
        let imageIndex = indexPath.row
        self.photosView.removeImageAtIndex(imageIndex)
    }
    
    //keyboard emoji
    
    private func showEmojiKeyboard(_ show: Bool ){
        
        if show || contentView.isFirstResponder {
            contentView.resignFirstResponder()
        }else{
            bottombar.clearChooseState()
        }
        
        var offset = CGFloat(0)
        if show {
            offset = -chatKeyBoard!.frame.height
        }
        
        bottombar.snp.updateConstraints { (make) -> Void in
            make.bottom.equalTo(self.view.snp.bottom).offset(offset)
        }
        
    }
    
    func chatEmojiViewSelectEmojiIcon(_ objIcon: EmojiObj!) {
        
        let font = contentView.font
        let attach = EmoTaxtAttachment(data: nil, ofType: nil)
        attach.top = -3.5
        attach.image = UIImage(named: objIcon.emojiImgName)
        let attributeString = NSMutableAttributedString(attributedString: self.contentView.attributedText)
        let replaceRange = self.contentView.selectedRange
        if attach.image != nil && (attach.image?.size.width)! > CGFloat(1) {
            attach.emoName = objIcon.emojiString
            attributeString.replaceCharacters(in: replaceRange, with: NSAttributedString(attachment: attach))
        }
        self.contentView.attributedText = attributeString
        
        let currentRange = NSMakeRange(replaceRange.location + 1, 0)
        self.contentView.selectedRange = currentRange
        contentView.font = font
        
    }
    
    func chatEmojiViewTouchUpinsideDeleteButton() {
     
        var range = self.contentView.selectedRange
        let location : Int = range.location
        if location == 0 {
            return
        }
        
        range = NSMakeRange(location - 1, 1)
        let attStr : NSMutableAttributedString! = self.contentView.attributedText.mutableCopy() as! NSMutableAttributedString
        attStr.deleteCharacters(in: range)
        self.contentView.attributedText = attStr
        self.contentView.selectedRange = range
        
    }
    
    func chatEmojiViewTouchUpinsideSendButton() {
        
        self.publishAction()
        
    }
    

    
    // MARK: - ZLPickerViewControllerDelegate
    public func pickerViewControllerDoneAsstes(_ assets: [Any]!) {
        
    }
    
    func pickerCollectionViewSelectCamera(_ pickerVc: ZLPhotoPickerViewController!) {
        
    }
    
    //key board
    @objc private func keyboardChangeNotification(_ notification: Notification){
                
//        self.showEmojiKeyboard(false)
        let info = (notification as NSNotification).userInfo!
        let rect: AnyObject = info[UIKeyboardFrameEndUserInfoKey]! as AnyObject
        let rectValue = rect.cgRectValue
        
        
        self.bottombar.snp.updateConstraints { (make) -> Void in
            make.bottom.equalTo(self.view).offset(-rectValue!.height)
        }
        
    }
    
    func keyboardHideNotification(_ notification : Notification){
        
        if bottombar.emojiButton!.isSelected {
            self.bottombar.snp.updateConstraints { (make) -> Void in
                make.bottom.equalTo(self.view)
            }
        }
        
    }
    
    
    // MARK: - past
    func vsPaste(_ string: String!) {
        
        let currentFont = contentView.font
        
        guard let contentAttributeString = contentView!.text.show(with: currentFont , imageOffSet: UIOffsetMake(0, 0), lineSpace: 2) else {
            return
        }
        let attributeString = NSMutableAttributedString(attributedString: self.contentView.attributedText)
        var range = self.contentView.selectedRange
        range = NSMakeRange(range.location - 1, 1)
        attributeString.replaceCharacters(in: range, with: contentAttributeString)
        self.contentView.attributedText = attributeString
        let length = contentAttributeString.length
        let currentRange = NSMakeRange(range.location + length, 0)
        self.contentView.selectedRange = currentRange
        self.contentView.font = currentFont
        
    }
    
    
}
