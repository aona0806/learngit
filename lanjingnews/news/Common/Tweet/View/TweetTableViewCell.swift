//
//  TweetTableViewCell.swift
//  news
//
//  Created by chunhui on 15/11/26.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

enum TweetTapTap : Int {
    case invalid = 0 
    case author //点击作者
    case image  //点击图片
    case forward //点击转发
    case comment //点击评论
    case praise  //点击赞
    case forwardAuthor //点击转发作者
    case urlLink  //点击网页链接
    case atAuthor //点击at 作者
    case jump //点击时间轴等分享的帖子中对应的提示
}



class TweetTableViewCell: BaseTableViewCell {

    /**
     *  定义常量
     */
    struct Consts{
        static let DateFontName = "Helvetica"
        static let ContentFontName = "Heiti SC"
        private static let CX = 96 / 72 * 0.8
        
        static let TitleWidth = UIScreen.main.bounds.size.width - Consts.ContentLeftAlign - Consts.ContentRightAlign
        static let TitleFont = UIFont.boldSystemFont(ofSize: 14)
        static let titleColor = UIColor.rgb(0x020202)
        static let TitleTopAlign = CGFloat(10)
        
        static let ContentLeftAlign = CGFloat(63)
        static let ContentTopAlign  = CGFloat(18)
        static let ContentRightAlign = CGFloat(12)
        
        static let AvatarWidth = CGFloat(40)
        
        // font size
        static let forwardAuthodSize : CGFloat = CGFloat(13)
        static let authodSize : CGFloat = CGFloat(16)
        static let DateFontSize : CGFloat = CGFloat(12)
        static let CompanyFontSize : CGFloat = 12
        static let ContentFontSize : CGFloat = 15
        static let CommentFontSize : CGFloat = 13
        static let CommentMoreFontSize : CGFloat = 12
        
        // line spacing
        static let ForwardLineSpacing = CGFloat(8.0)
        
        // color
        static let BlackColor = UIColor.rgb(0x161616)
        static let ContentColor = UIColor.rgb(0x252525)
        static let LightGrayColor = UIColor.rgb(0xa0a4a3)
        static let BlueColor = UIColor.rgb(0x316994)
        /// 评论中的蓝色
        static let CommentBlueColor = UIColor.rgb(0x316994)
        static let CommentBlackColor = UIColor.rgb(0x2a2a2a)
        
        static let CommentBackgroundColor = UIColor.rgb(0xf0f0f0)
        static let CommentSeperateLineColor = UIColor.white
        
        static let PraiseImageViewWidth = 15.0
        static let PraiseImageViewHeight = 15.0
        static let PraiseImageMarginRight = 4.0
        static let CommentSuperPaddingH = 11.0
        static let commentSuperPaddingVTop = 8.0
        static let CommentCellSpaceV = 8.0
        
        /// 转发按钮高亮颜色
        static let forwardAuthorHightColor = UIColor.lightGray
        
        static let PraiseWidth = Double(UIScreen.main.bounds.width) - 73.0 - Consts.PraiseImageViewWidth - Consts.PraiseImageMarginRight - Consts.CommentSuperPaddingH - 3
        static let CommentListWidth = Double(UIScreen.main.bounds.width) - 73.0 - Consts.CommentSuperPaddingH
        
    }

    /**
     * ui相关控件
     */
    private var forwardAuthorTitle : UILabel? //转发了
    private var forwardAuthorButton : UIButton?  //转发者的名字
    
    private var avatarImageView : UIImageView
    private var authorLabel : UILabel
    private var identifyImageView : UIImageView
    private var companyLabel : UILabel
    private var dateLabel : UILabel
    
    private var titleLabel: UILabel!
    private var contentLabel : KILabel
    private var jumpButton : UIButton?
    private var photosBgView : PhotoScrollView = PhotoScrollView()
    
    private var forwardView : UIButton?
    private var commentView : UIButton?
    private var praiseView  : UIButton?
    private var commentArrowView : UIImageView?
    private var commentInfoView : TweetSocialInfoView?
    private var praiseListView : TweetPraiseListView?//只显示赞列表
    
    private var bottomlineView : UIView?
    
    private var authorTapGesture : UITapGestureRecognizer? = nil
    
    var tapAction : ((_ cell : TweetTableViewCell , _ info : LJTweetDataContentModel , _ type : TweetTapTap  , _ extra : Any? ) -> ())?
    
    var showCommentList = true//是否显示评论列表
    var hideBottomline  = false {//是否隐藏底部分隔线
        didSet{
            bottomlineView?.isHidden = hideBottomline
        }
    }
        
    var info : LJTweetDataContentModel? {
        didSet {
           self.update()
        }
    }
    
    class func heightForInfo(_ info : LJTweetDataContentModel , showCommentList : Bool = true) -> CGFloat{
        
        let contentWidth = UIScreen.main.bounds.size.width - Consts.ContentLeftAlign - Consts.ContentRightAlign
        
        var height = CGFloat(0)
        if  info.originTopic != nil {
            //包含转发
            height = 85
        }else{
            height = 60
        }
        
        height += 12;
        
        if  let tweetType = LJTweetType(rawValue: info.type?.intValue ?? 0 ) {
            
            if tweetType == .news || tweetType == .activity || tweetType == .hotEventDetail || tweetType == .hotEvent {
                
                var titleString = info.title ?? ""
                titleString = String(format: "%@", titleString)
                let size = titleString.size(withMaxWidth: Consts.TitleWidth, font: Consts.TitleFont, maxLineNum: 2)
                height += size.height + Consts.TitleTopAlign
                height += 10
            }
            
        }
        
        
        let font = UIFont(name: Consts.ContentFontName, size: Consts.ContentFontSize)
        let offset = UIOffset(horizontal: 0, vertical: -5)
        let nsContent = info.body ?? ""
        
        if let mcontent = nsContent.show( with: font ,imageOffSet : offset , lineSpace: Consts.ForwardLineSpacing , imageWidthRatio: CGFloat(1.5)) {
            let links = KILabel.urlMatches(forText: mcontent.string, range: NSMakeRange(0,mcontent.length))
            if  (links?.count ?? 0) > 0 {
                
                let linkText = KILabel.urllinkAttributeString()
                for match in links!.reversed() {
                    mcontent.replaceCharacters(in: match.range, with: linkText)
                }
            }
            
            height += mcontent.size(withMaxWidth: contentWidth, font: font).height + 2
        }
        
        if info.isDel == "0" && ((info.type?.int32Value ?? 0)  >= 2 ) {
            //时间轴转发
            height += 36;//top + height
        }
        
        if (info.img?.count ?? 0) > 0 {

            var hasImg = false
            for url in info.img! {
                if (url as? String) != nil {
                    hasImg = true
                    break
                }
            }
            if hasImg {//防止img里面有null等错误数据
                height += 10 + 81 //top + height
            }
            
        }
        //评论 转发 和分享
        height += 10 + 20
        //评论详情
        if showCommentList {
            if (info.praise?.user?.count ?? 0) > 0 || (info.comment?.list?.count ?? 0) > 0 || (info.forward?.user?.count ?? 0) > 0 {
                height += 10
                height += TweetSocialInfoView.heightForInfo(info, width: contentWidth ,showCommentList: showCommentList)
//                height += 10
            }
        }else if (info.praise?.user?.count ?? 0) > 0{
            //在帖子详情页只显示赞列表
            height += 10
            height += TweetPraiseListView.heightForModel(info)
        }
        
        height += 5
        
        return height
            
    }
    
    func initForwardItems(){
        //初始化转发作者和转发了
        if self.forwardAuthorButton == nil {
            self.forwardAuthorButton = UIButton(type: .custom)
            let font = UIFont(name: Consts.ContentFontName, size: Consts.forwardAuthodSize)
            forwardAuthorButton?.titleLabel?.font = font
            forwardAuthorButton?.setTitleColor(Consts.BlueColor, for: UIControlState())
            forwardAuthorButton?.setTitleColor(Consts.BlueColor, for: .highlighted)

            
            forwardAuthorButton?.addTarget(self, action: #selector(TweetTableViewCell.forwardAuthorTapAction(_:)), for: .touchUpInside)
            
            
            self.forwardAuthorTitle = UILabel()
            forwardAuthorTitle?.font = font
            forwardAuthorTitle?.textColor = Consts.LightGrayColor
            self.forwardAuthorTitle?.text = "转发了"
            forwardAuthorTitle?.sizeToFit()
            
            self.contentView.addSubview(forwardAuthorButton!)
            self.contentView.addSubview(forwardAuthorTitle!)
            
            forwardAuthorButton?.snp.makeConstraints({ (make) -> Void in
                make.left.equalTo(Consts.ContentLeftAlign)
                make.centerY.equalTo(forwardAuthorTitle!.snp.centerY)
            })
            
            forwardAuthorTitle?.snp.makeConstraints({ (make) -> Void in
                make.left.equalTo(forwardAuthorButton!.snp.right)
                make.top.equalTo(Consts.ContentTopAlign)
            })
            
        }
    }
    
    func initJumpItem(){
        
        if jumpButton == nil {
            jumpButton = UIButton(type: .custom)

            jumpButton?.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            let titleColor = UIColor.rgb(0x2a77b1)
            jumpButton?.setTitleColor(titleColor, for: UIControlState())
            jumpButton?.setTitleColor(titleColor, for: .highlighted)
            jumpButton?.addTarget(self, action: #selector(TweetTableViewCell.timelineAction(_:)), for: .touchUpInside)
            jumpButton?.layer.borderColor = UIColor.rgb(0xeaeaea).cgColor
            jumpButton?.layer.borderWidth = 1
            jumpButton?.layer.cornerRadius = 6
            jumpButton?.layer.masksToBounds = true

            self.contentView.addSubview(jumpButton!)
            
            jumpButton?.snp.updateConstraints({ (make) -> Void in
                make.left.equalTo(authorLabel.snp.left)
                make.top.equalTo(contentLabel.snp.bottom).offset(10)
                make.width.equalTo(jumpButton!.width)
                make.height.equalTo(26)
            })
            
        }
        
        var title = ""
        if  let tweetType = LJTweetType(rawValue: self.info!.type?.intValue ?? 0) {
            switch tweetType {
            case .timeAxis:
                title = "查看时间轴"
                break
            case .news:
                title = "查看新闻详情"
                break
            case .activity:
                title = "查看活动详情"
                break
            case .topic:
                title = "查看专题详情"
                break
            case .hotEvent:
                title = "查看热点事件列表"
                break
            case .hotEventDetail:
                title = "查看热点事件详情"
                break
            default:
                title = ""
            }
        }
        
        jumpButton?.setTitle(title, for: UIControlState())
        
        let size = title.size(withMaxWidth: self.width,font:jumpButton?.titleLabel?.font)
                
        jumpButton?.snp.updateConstraints({ (make) -> Void in
            make.width.equalTo(size.width+20)
        })
    }
    
    func initComments(){
        if commentInfoView == nil {
            
            commentInfoView = TweetSocialInfoView(frame: self.bounds)
            commentInfoView?.onAtUserClick = tapAtUser
            commentInfoView?.backgroundColor = UIColor.rgb(0xf0f0f0)
            commentInfoView?.isUserInteractionEnabled = true
            
            let image = UIImage(named: "arrow_gray_up")
            commentArrowView = UIImageView(image: image)
            
            self.contentView.addSubview(commentArrowView!)
            self.contentView.addSubview(commentInfoView!)
        }
    }
    
    func initPraiseList(){
        if praiseListView == nil {
            praiseListView = TweetPraiseListView(frame: self.bounds)
            praiseListView?.isUserInteractionEnabled = true
            praiseListView?.backgroundColor = UIColor.rgb(0xf0f0f0)
            praiseListView?.onAtUserClick = tapAtUser
            self.contentView.addSubview(praiseListView!)
        }
    }
    
    func button(_ selector : Selector , img : UIImage) -> UIButton {
        
        let button = UIButton(type : .custom)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        let color = TweetTableViewCell.Consts.LightGrayColor
        button.setTitleColor(color, for: UIControlState())
        button.setTitleColor(color, for: .highlighted)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.setImage(img, for: UIControlState())
        button.setImage(img, for: .highlighted)
        
        return button
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    
        avatarImageView = UIImageView()
        authorLabel = UILabel()
        identifyImageView = UIImageView()
        companyLabel = UILabel()
        dateLabel  = UILabel()
        contentLabel = KILabel()
        titleLabel = UILabel()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.layoutMargins = UIEdgeInsets.zero
        self.preservesSuperviewLayoutMargins = false
        
        avatarImageView.layer.cornerRadius = Consts.AvatarWidth/2
        avatarImageView.layer.masksToBounds = true
        
        let tapAvatarGesture = UITapGestureRecognizer(target: self, action: #selector(TweetTableViewCell.authorTapAction(_:)))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapAvatarGesture)
        
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView!.backgroundColor = UIColor.rgb(0xf6f6f6)
        authorLabel.font = UIFont(name: Consts.ContentFontName, size: Consts.authodSize)
        authorLabel.textColor = UIColor.rgb(0x161616)
        
        companyLabel.textColor = UIColor.rgb(0xa0a4a3)
        companyLabel.font = UIFont(name: Consts.ContentFontName, size: Consts.CompanyFontSize)
        dateLabel.font = UIFont(name: Consts.DateFontName, size: Consts.DateFontSize)
        dateLabel.textColor = Consts.LightGrayColor
        
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = Consts.TitleFont
        titleLabel.textColor = Consts.titleColor
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.isHidden = true
        titleLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.size.width - Consts.ContentLeftAlign - Consts.ContentRightAlign
        
        contentLabel.font = UIFont(name: Consts.ContentFontName, size: Consts.ContentFontSize)
        contentLabel.linkGroundColor = Consts.BlueColor
        contentLabel.isUserInteractionEnabled = true
        contentLabel.isCopyingEnabled = true
        
        contentLabel.numberOfLines = 0
        contentLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.size.width - Consts.ContentLeftAlign - Consts.ContentRightAlign
        
        bottomlineView = UIView()
        bottomlineView?.backgroundColor = UIColor.rgb(0xdddddd)
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(avatarImageView)
        self.contentView.addSubview(authorLabel)
        self.contentView.addSubview(identifyImageView)
        self.contentView.addSubview(companyLabel)
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(contentLabel)
        
        var img = UIImage(named: "tweet_forward")
        forwardView = self.button(#selector(TweetTableViewCell.forwardAction(_:)), img: img!)
        self.contentView.addSubview(forwardView!)
        
        img = UIImage(named: "tweet_comment")
        commentView = self.button(#selector(TweetTableViewCell.commentAction(_:)), img: img!)
        self.contentView.addSubview(commentView!)
        
        img = UIImage(named: "tweet_praise")
        praiseView = self.button(#selector(TweetTableViewCell.praiseAction(_:)), img: img!)
        img = UIImage(named: "tweet_praised")
        praiseView?.setImage(img, for: .selected)        
        self.contentView.addSubview(praiseView!)

        self.contentView.addSubview(bottomlineView!)
        
        //点击图片
        photosBgView.tapImage = { [weak self] (index : Int) -> Void in
            self?.tapImage(index)
        }
        
        self.initConstrainst()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        avatarImageView = UIImageView()
        authorLabel = UILabel()
        identifyImageView = UIImageView()
        companyLabel = UILabel()
        dateLabel  = UILabel()
        contentLabel = KILabel()
        titleLabel = UILabel()
        
        super.init(coder: aDecoder)
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initConstrainst(){
        
        avatarImageView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(12)
            make.width.equalTo(Consts.AvatarWidth)
            make.height.equalTo(Consts.AvatarWidth)
            make.top.equalTo(20)
        }
        
        identifyImageView.snp.updateConstraints({ (make) -> Void in
            make.left.equalTo(authorLabel.snp.right)
            make.centerY.equalTo(authorLabel.snp.centerY)
            make.width.equalTo(15)
            make.height.equalTo(10)
        })
        
        companyLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(authorLabel.snp.left)
            make.top.equalTo(authorLabel.snp.bottom)
            make.right.lessThanOrEqualTo(companyLabel.superview!.snp.right).offset(-Consts.ContentRightAlign)
            make.height.equalTo(0)
        }
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(authorLabel.snp.left)
            make.top.equalTo(companyLabel.snp.bottom).offset(Consts.TitleTopAlign)
            make.right.equalTo(titleLabel.superview!.snp.right).offset(-Consts.ContentRightAlign)
            make.height.equalTo(0)
        }
        
        contentLabel.snp.makeConstraints({ (make) -> Void in
            make.left.equalTo(authorLabel.snp.left)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.right.equalTo(contentLabel.superview!.snp.right).offset(-Consts.ContentRightAlign)
            make.height.equalTo(0)
        })
        
        commentView?.snp.makeConstraints({ (make) -> Void in
            make.right.equalTo(praiseView!.snp.left).offset(-10)
            make.top.equalTo(praiseView!.snp.top)
            make.width.equalTo(60)
            make.bottom.equalTo(praiseView!.snp.bottom)
        })
        
        forwardView?.snp.makeConstraints({ (make) -> Void in
            make.right.equalTo(commentView!.snp.left).offset(-10)
            make.top.equalTo(praiseView!.snp.top)
            make.bottom.equalTo(praiseView!.snp.bottom)
        })
        
        
        bottomlineView?.snp.makeConstraints({ (make) -> Void in
            make.left.equalTo(bottomlineView!.superview!.snp.left)
            make.right.equalTo(bottomlineView!.superview!.snp.right)
            make.bottom.equalTo(bottomlineView!.superview!.snp.bottom)
            make.height.equalTo(0.5)
        })
        
    }
    
    
    func update(){
        
        if self.info == nil {
            return
        }
        
        if  self.info!.originTopic != nil {
            //包含转发
            self.initForwardItems()
            forwardAuthorButton?.setTitle(info?.originTopic?.sname, for: UIControlState())
            forwardAuthorButton?.setTitle(info?.originTopic?.sname, for: .highlighted)
            forwardAuthorButton?.isHidden = false
            forwardAuthorTitle?.isHidden = false
        }else if self.forwardAuthorButton != nil{
            forwardAuthorTitle?.isHidden = true
            forwardAuthorButton?.isHidden = true
        }
        //头像
        let defaultHeader =  UIImage(named: "user_default_head")

        let url = Urlhelper.tryEncode(info!.avatar)
        avatarImageView.sd_setImage(with: url, placeholderImage: defaultHeader)
        //姓名
        authorLabel.text = info?.sname
        authorLabel.sizeToFit()
        
        //v
        var vImg : UIImage? = nil
        
        if let ukind = info!.ukind {
            switch  ukind {
            case "1":
                vImg = UIImage(named: "tag_v")
            case "2":
                vImg = UIImage(named: "tag_v2")
            default:
                break
            }
        }
        if vImg == nil {
            identifyImageView.isHidden = true
        }else{
            identifyImageView.isHidden = false
            identifyImageView.image = vImg
        }
        
        if info?.originTopic != nil {
            dateLabel.text = info?.originTopic?.ctime
        }else{
            dateLabel.text = info?.ctime
        }
        dateLabel.sizeToFit()
        
        companyLabel.text = "\(info!.company ?? "") \(info!.companyJob ?? "")"
        companyLabel.sizeToFit()
        
        let tweetType = LJTweetType(rawValue: self.info!.type?.intValue ?? 0)
        if tweetType == .news || tweetType == .activity || tweetType == .hotEventDetail || tweetType == .hotEvent {
            
            var titleString = info?.title ?? ""
            titleString = String(format: "%@", titleString)
            
            titleLabel.isHidden = false
            let size = titleString.size(withMaxWidth: Consts.TitleWidth, font: Consts.TitleFont, maxLineNum: 2)
            titleLabel.text = titleString
            titleLabel.size = size
            
        } else {
            titleLabel.isHidden = true
        }

            
        //content
        let content = info!.body
        if content != nil {
            let offset = UIOffset(horizontal: 0, vertical: -5)
            let nsContent = content!
            let mcontent = nsContent.show(with: contentLabel.font ,imageOffSet : offset , lineSpace: Consts.ForwardLineSpacing , imageWidthRatio: CGFloat(1.5))
            
            let option = KILinkTypeOption.custom.rawValue | KILinkTypeOption.URL.rawValue
            let op = KILinkTypeOption(rawValue: option)
            contentLabel.linkDetectionTypes = op
            
            contentLabel.attributedText = mcontent
            contentLabel.customString = content
            
            //需要考虑替换content中的网页链接
            let size = contentLabel.attributedText!.size(withMaxWidth: contentLabel.preferredMaxLayoutWidth, font: contentLabel.font)
            contentLabel.size = CGSize(width: ceil(size.width), height: ceil(size.height)+2)
            
        }else{
            contentLabel.text = nil
            contentLabel.size = CGSize.zero
        }
        
        var atuidArray = Array<String>()
        let atuids = info!.atuids ?? ""
        if (  atuids.isEmpty ) {
            atuidArray = info!.atuids!.components(separatedBy: ",")
        }
        weak var weakSelf = self
        contentLabel.userHandleLinkTapHandler = {(operation: KILabel,
            string: String,range : NSRange,contentString : String) in
            
            if let strongSelf = weakSelf {
                
                let index : Int? = Int(contentString)
                if (index != nil) {
                    
                    if index! < atuidArray.count {
                        let atuid = atuidArray[index!]
                        strongSelf.tapAction?(strongSelf , strongSelf.info! , .atAuthor,atuid)
                    }
                }
            }
        }
        
        contentLabel.urlLinkTapHandler = {(operation: KILabel,
            string: String,range : NSRange,contentString : String) in
            if let strongSelf = weakSelf {
                strongSelf.tapAction?(strongSelf, strongSelf.info! , .urlLink, string)
            }
        }
        
        //没有删除时显示其他信息
        if info?.isDel == "0" && (info?.type?.int32Value ?? 0) >= 2 {
            //时间轴分享
            initJumpItem()
            self.jumpButton?.isHidden = false
        }else if self.jumpButton != nil {
            self.jumpButton?.isHidden = true
        }
        
        //图片
        if (info?.img?.count ?? 0) > 0 {
            
            if photosBgView.superview == nil {
                self.contentView.addSubview(photosBgView)
            }
            var imgs = Array<String>()
            for url in info!.img! {
                if (url as? String) != nil   &&  (url as AnyObject).length() > 0 {
                    imgs.append("\(url)\(GlobalConsts.thumbImageSufix)")
                }
            }
            if imgs.count > 0 {
                
                self.photosBgView.updateWithUrls(imgs)
                photosBgView.isHidden = false
                
            }else{
                photosBgView.isHidden = true
            }
            
        }else{
            self.photosBgView.isHidden = true
        }
        
        //点赞 评论 和转发
        
        let count = " \(info!.praise?.num ?? "0") "
        praiseView?.setTitle(count, for: UIControlState())
        praiseView?.setTitle(count, for: .highlighted)
        praiseView?.isSelected =  info!.praise?.flag ?? false
        
        commentView?.setTitle(info!.comment?.num ?? "0", for: UIControlState())
        commentView?.setTitle(info!.comment?.num ?? "0", for: .highlighted)
        
        forwardView?.setTitle(info!.forward?.num, for: UIControlState())
        forwardView?.setTitle(info!.forward?.num, for: .highlighted)
        
        
        praiseView?.sizeToFit()
        commentView?.sizeToFit()
        forwardView?.sizeToFit()
        
        if self.showCommentList {
            let count = (info!.praise?.user?.count ?? 0 ) + (info!.comment?.list?.count ?? 0) + (info!.forward?.user?.count ?? 0)
            if count > 0 {
                self.initComments()
                commentInfoView?.isHidden = false
                commentArrowView?.isHidden = false
                
                commentInfoView?.info = info
                
                let contentWidth = UIScreen.main.bounds.size.width - Consts.ContentLeftAlign - Consts.ContentRightAlign
                
                commentInfoView?.height = TweetSocialInfoView.heightForInfo(info!, width: contentWidth)
                
            }else{
                commentInfoView?.isHidden = true
                commentArrowView?.isHidden = true
            }
        }else{
            
            if (info!.praise?.user?.count ?? 0 ) > 0 {
                initPraiseList()
                praiseListView?.isHidden = false
                
                praiseListView?.info = info
                
            }else{
                praiseListView?.isHidden = true
            }
        }
        
        self.setNeedsUpdateConstraints()
    }
    
    
    override func updateConstraints() {
        
        if self.info == nil {
            super.updateConstraints()
            return
        }
        var showForwardAuthor = false
        if forwardAuthorButton != nil && forwardAuthorButton?.isHidden == false {
            showForwardAuthor = true
        }
        
        photosBgView.snp.removeConstraints()
        
        avatarImageView.snp.updateConstraints { (make) -> Void in
            if showForwardAuthor {
                make.top.equalTo(45)
            }else{
                make.top.equalTo(20)
            }
        }
        
        authorLabel.snp.remakeConstraints { (make) -> Void in
            make.left.equalTo(Consts.ContentLeftAlign)
            if showForwardAuthor {
                make.top.equalTo(forwardAuthorButton!.snp.bottom)
            }else{
                make.top.equalTo(22)
            }
            make.height.equalTo(authorLabel.height)
        }
        
        dateLabel.snp.remakeConstraints { (make) -> Void in
            make.right.equalTo(dateLabel.superview!.snp.right).offset(-Consts.ContentRightAlign)
            if showForwardAuthor {
              make.top.equalTo(forwardAuthorTitle!.snp.top)
            }else{
                make.top.equalTo(authorLabel.snp.top)
            }
            make.height.equalTo(dateLabel.height)
        }
        
        
        companyLabel.snp.updateConstraints { (make) in
            make.height.equalTo(companyLabel.height)
        }
        
        var contentLabelTopOffset = 0
        if titleLabel.isHidden {
            //没有title时，与title平齐
            
            titleLabel.snp.updateConstraints { (make) -> Void in
                make.height.equalTo(0)
            }
            
            
        }else{
            
            titleLabel.snp.updateConstraints { (make) -> Void in
                make.left.equalTo(authorLabel.snp.left)
                make.top.equalTo(companyLabel.snp.bottom).offset(Consts.TitleTopAlign)
                make.right.equalTo(contentLabel.superview!.snp.right).offset(-Consts.ContentRightAlign)
                make.height.equalTo(titleLabel.height)
            }
            
            contentLabelTopOffset = 10
        }
        
        let contentHeight = contentLabel.height
        contentLabel.snp.updateConstraints({ (make) -> Void in
            make.height.equalTo(contentHeight)
            make.top.equalTo(titleLabel.snp.bottom).offset(contentLabelTopOffset)
        })
        
        var showTimeline = false
        if jumpButton != nil && jumpButton?.isHidden == false {
            showTimeline = true
        }
        
        if photosBgView.isHidden == false {
            
            photosBgView.snp.remakeConstraints({ (make) -> Void in
                make.left.equalTo(authorLabel.snp.left)
                make.right.equalTo(photosBgView.superview!.snp.right).offset(-Consts.ContentRightAlign)
                if showTimeline {
                    make.top.equalTo(jumpButton!.snp.bottom).offset(10)
                }else{
                    make.top.equalTo(contentLabel.snp.bottom).offset(10)
                }
                make.height.equalTo(81).priority(250)
            })
        }
        
        praiseView?.snp.remakeConstraints({ (make) -> Void in
            make.right.equalTo(praiseView!.superview!.snp.right).offset(-Consts.ContentRightAlign)
            if photosBgView.isHidden == false {
                make.top.equalTo(photosBgView.snp.bottom).offset(10)
            }else if showTimeline {
                make.top.equalTo(jumpButton!.snp.bottom).offset(10)
            }else {
                make.top.equalTo(contentLabel.snp.bottom).offset(10)
            }
            make.height.equalTo(20)
        })
        
        if commentInfoView != nil && commentInfoView?.isHidden == false {
            commentArrowView?.snp.updateConstraints({ (make) -> Void in
                make.top.equalTo(commentView!.snp.bottom).offset(5)
                make.centerX.equalTo(commentView!.snp.centerX)
                make.width.equalTo(11)
                make.height.equalTo(5)
            })
            
            commentInfoView?.snp.updateConstraints({ (make) -> Void in
                make.top.equalTo(commentArrowView!.snp.bottom)
                make.left.equalTo(authorLabel.snp.left)
                make.right.equalTo(commentInfoView!.superview!.snp.right).offset(-Consts.ContentRightAlign)
                make.height.equalTo(commentInfoView!.height)
            })
            
            commentInfoView?.setNeedsUpdateConstraints()
        }else if praiseListView != nil && praiseListView?.isHidden == false {
            praiseListView?.snp.updateConstraints({ (make) -> Void in
                make.top.equalTo(commentView!.snp.bottom).offset(5)
                make.left.equalTo(avatarImageView.snp.left)
                make.right.equalTo(praiseListView!.superview!.snp.right).offset(-Consts.ContentRightAlign)
                make.bottom.equalTo(praiseListView!.superview!.snp.bottom).offset(-5)
            })
        }
                
        super.updateConstraints()
    }
    
    func forwardAuthorTapAction(_ sender : UIButton){
        
        tap(.forwardAuthor)
    }
    func authorTapAction(_ gesture: UITapGestureRecognizer){
        tap(.author)
    }
    
    func timelineAction(_ sender : UIButton){
        
        tap(.jump)
        
    }
    
    func forwardAction(_ sender : UIButton){
        
        tap(.forward)
        
    }
    func commentAction(_ sender : UIButton){
        
        tap(.comment)
        
    }
    func praiseAction(_ sender : UIButton){
        
        tap(.praise)
        
    }
    
    func tapImage(_ index : Int){
        
        var images = [UIImage]()
        for imgView in self.photosBgView.imageViews {
            if imgView.image != nil {
                images.append(imgView.image!)
            }
        }
        
        let imgInfo = ["index":index , "imgs":images,"imageView":self.photosBgView.imageViews[index]] as [String : Any]
        
        tap(.image,extra: imgInfo as AnyObject?)
        
    }
    
    func tapAtUser(_ uid : String , content : String) {
     
        tap(.atAuthor, extra: uid as AnyObject?)
        
    }
    
    private func tap(_ type:TweetTapTap , extra: AnyObject? = nil){
        
        if tapAction != nil {
            tapAction!(self,self.info!,type,extra)
        }
        
    }
    
}
