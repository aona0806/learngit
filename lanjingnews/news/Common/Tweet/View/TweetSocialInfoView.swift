//
//  TweetSocialInfoView.swift
//  news
//
//  Created by chunhui on 15/11/28.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

/// 帖子评论 分享 转发等信息
class TweetSocialInfoView: UIView {
    
    static let Horipadding = 10
    static let Verticalpadding = 10
    static let IconWidth = CGFloat(15.0) //点赞转发等image
    static let IconHeight = CGFloat(15.0)
    static let IconMarginRight = 4.0//点赞转发等image的距离右边label的边距
    static let maxCommentCount : Int = 3 //最多显示的评论数目
    
    var praiseImageView : UIImageView?
    var praiseLabel : KILabel?
    var forwardImageView : UIImageView?
    var forwardLabel : KILabel?
    var commentLabels = Array<KILabel>()
    var checkAllLabel : UILabel?
    var topSplitLine : UIView?
    var bottomSplitLine : UIView?
    var info : LJTweetDataContentModel?{
        didSet{
           update()
        }
    }
    var onAtUserClick: (( _ userId : String, _ content : String) -> ())? = nil
    var showCommentList = true//是否显示评论列表
    
    class func heightForInfo(_ info : LJTweetDataContentModel , width : CGFloat , showCommentList : Bool = true) -> CGFloat{
    
        let font = UIFont(name: TweetTableViewCell.Consts.ContentFontName, size: TweetTableViewCell.Consts.CommentFontSize)
        
        var height = CGFloat(0.0)
        let cellWidth = UIScreen.main.bounds.size.width
        let contentWidth  = cellWidth - TweetTableViewCell.Consts.ContentLeftAlign - TweetTableViewCell.Consts.ContentRightAlign

        var showPraiseOrForward = false
        
        let praiseAndForwardWidth = contentWidth -  CGFloat(TweetSocialInfoView.IconWidth) -  CGFloat(TweetSocialInfoView.IconMarginRight) - CGFloat(2*TweetSocialInfoView.Horipadding)
        
        if let praise = info.praise {
            if (praise.user?.count ?? 0 ) > 0 {
                height += CGFloat(TweetSocialInfoView.Verticalpadding)
                let (_ , praiseList ) = TweetSocialInfoView.listFor(praise.user as! [LJTweetDataSocialUserModel])
                let users = praiseList.joined(separator: ", ")
                var praiseHeight = users.size(withMaxWidth: praiseAndForwardWidth , font: font ).height
                if praiseHeight < TweetSocialInfoView.IconWidth {
                    praiseHeight = TweetSocialInfoView.IconWidth
                }
                height += praiseHeight
                
                showPraiseOrForward = true
            }
        }
        
        if let forward = info.forward {
            
            if (forward.user?.count ?? 0) > 0 {
                height += CGFloat(TweetSocialInfoView.Verticalpadding)
                let (_ , praiseList ) = TweetSocialInfoView.listFor(forward.user as! [LJTweetDataSocialUserModel])
                let users = praiseList.joined(separator: ", ")
                var praiseHeight = users.size(withMaxWidth: praiseAndForwardWidth , font: font ).height
                if praiseHeight < TweetSocialInfoView.IconWidth {
                    praiseHeight = TweetSocialInfoView.IconWidth
                }
                height += praiseHeight
                showPraiseOrForward = true
            }
            
        }
        if showCommentList {
            //显示评论列表
            if info.comment != nil && (info.comment?.list?.count ?? 0) > 0 {
                
                let comment = info.comment!
                
                height += CGFloat(TweetSocialInfoView.Verticalpadding)
                
                let commentWidth = contentWidth - 2*CGFloat(TweetSocialInfoView.Horipadding)
                
                for i in 0  ..< min((comment.list?.count ?? 0), TweetSocialInfoView.maxCommentCount)  {
                    let model = info.comment!.list?[i] as! LJTweetDataContentCommentListModel
                    var commentString : String = ""
                    var hasReplyName = false
                    var name : String = ""
                    
                    if model.replySname != nil && model.replySname!.length() > 0 {
                        name = model.sname!
                        hasReplyName = true
                    }else{
                        name = "\(model.sname!):"
                    }
                    commentString += name
                    
                    if hasReplyName {
                        commentString += "回复"
                        name = model.replySname! + ":"
                        commentString += name
                    }
                    commentString +=  " " + model.content!
                    if let contentAttributeString = commentString.show(with: font ,imageOffSet : UIOffsetMake(0, -5) , lineSpace: -2 , imageWidthRatio: CGFloat(1.5) ) {
                    
                        let commentHeight = contentAttributeString.size(withMaxWidth: commentWidth , font: font).height
                        
                        height += commentHeight
                        height += 2
                    }
                }
                let cmtNum = Int(comment.num ?? "0") ?? 0
                if cmtNum > TweetSocialInfoView.maxCommentCount {
                    //点击查看全部
                    height += 21;
                }else{
                    height += CGFloat(TweetSocialInfoView.Verticalpadding/2)
                }
            }else if showPraiseOrForward {
                height += CGFloat(TweetSocialInfoView.Verticalpadding)
            }
        }
        
        return  height
    }
    
    class func listFor(_ userList : Array<LJTweetDataSocialUserModel>) -> (Array<KiCustomItem>,Array<String>){
        
        var users : Array<String> = Array<String>()
        var kiCustomArray : Array<KiCustomItem> = Array<KiCustomItem>()
        var loc : Int = 0
        for user in userList {
            if user.sname == nil {                
                continue
            }
            
            users.append(user.sname!)
            let item : KiCustomItem! = KiCustomItem()
            item?.content = user.sname
            if user.uid!.length() > 0 {
                item?.number = NSNumber(value: Int(user.uid!) ?? 0)
            }else{
                item?.number = NSNumber(value: 0)
            }
            item.location = loc
            item.length = user.sname!.length()
            loc += user.sname!.length() + 2
            kiCustomArray.append(item)
        }
        return (kiCustomArray,users)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    func initPraiseItems(){
        if self.praiseImageView == nil {
            let img = UIImage(named: "tweet_praised")
            self.praiseImageView = UIImageView(image: img)
            
            praiseLabel = KILabel()
            praiseLabel?.isUserInteractionEnabled = true
            praiseLabel?.font = UIFont(name: TweetTableViewCell.Consts.ContentFontName, size: TweetTableViewCell.Consts.CommentFontSize)
            praiseLabel?.linkGroundColor = TweetTableViewCell.Consts.CommentBlueColor
            praiseLabel?.customLinkTapHandler = {[weak self](operation: KILabel,
                string: String,range : NSRange,contentString : String) in
                self!.onAtUserClick?( contentString, string)
            }
            
            self.addSubview(praiseImageView!)
            self.addSubview(praiseLabel!)
        }
    }
    func initForwardItems(){
        if self.forwardImageView == nil {
            let img = UIImage(named: "tweet_forward_list")
            forwardImageView = UIImageView(image:img)
            
            forwardLabel = KILabel()
            forwardLabel?.isUserInteractionEnabled = true
            forwardLabel?.isMultipleTouchEnabled = true
            forwardLabel?.font = UIFont(name: TweetTableViewCell.Consts.ContentFontName, size: TweetTableViewCell.Consts.CommentFontSize)
            forwardLabel?.linkGroundColor = TweetTableViewCell.Consts.CommentBlueColor
            forwardLabel?.customLinkTapHandler = {[weak self](operation: KILabel,
                string: String,range : NSRange,contentString : String) in
                self?.onAtUserClick?( contentString, string)
            }
            
            self.addSubview(forwardImageView!)
            self.addSubview(forwardLabel!)
        }
    }
    
    func initCheckAllItems(){
        if checkAllLabel == nil {
            checkAllLabel = UILabel()
            checkAllLabel?.textAlignment = .center
            checkAllLabel?.backgroundColor = UIColor.clear
            checkAllLabel?.textColor = TweetTableViewCell.Consts.CommentBlueColor
            checkAllLabel?.font = UIFont(name: TweetTableViewCell.Consts.ContentFontName, size: TweetTableViewCell.Consts.CommentMoreFontSize)!
            self.addSubview(checkAllLabel!)
        }
    }
    
    func initTopSplitline(){
        if topSplitLine == nil {
            topSplitLine = UIView()
            topSplitLine?.backgroundColor = UIColor.white
            self.addSubview(topSplitLine!)
        }
    }
    func initBottomSplitline(){
        if bottomSplitLine == nil {
            bottomSplitLine = UIView()
            bottomSplitLine?.backgroundColor = UIColor.white
            self.addSubview(bottomSplitLine!)
        }
    }
    
    
    func commentLabel(_ model : LJTweetDataContentCommentListModel) -> KILabel {
        let commentLabel : KILabel! = KILabel()
        commentLabel.preferredMaxLayoutWidth = self.width - CGFloat(TweetSocialInfoView.Horipadding)
        
        commentLabel.linkGroundColor = TweetTableViewCell.Consts.CommentBlueColor
        commentLabel.textColor = TweetTableViewCell.Consts.CommentBlackColor
        commentLabel?.isUserInteractionEnabled = true
        commentLabel?.isMultipleTouchEnabled = true
        
        let commentFont = UIFont(name: TweetTableViewCell.Consts.ContentFontName, size: TweetTableViewCell.Consts.CommentFontSize)!
        commentLabel?.font = commentFont
        
        
        var loc : Int = 0
        var kiCustomArray : Array<KiCustomItem> = Array<KiCustomItem>()
        var commentString : String = ""
        
        let uItem : KiCustomItem! = KiCustomItem()
        var name : String = ""
        var hasReplyName = false
        
        if model.replySname != nil && model.replySname!.length() > 0 {
            
            name = model.sname!
            hasReplyName = true
            
        }else{
            name = "\(model.sname!):"
        }
        uItem.content = name
        uItem.number =  NSNumber(value: Int(model.uid!) ?? 0)
        uItem.location = loc
        uItem.length = name.length()
        kiCustomArray.append(uItem)
        loc += name.length()
        
        commentString += name
        
        if hasReplyName {
            commentString += "回复"
            loc += 2
            
            let replyItem : KiCustomItem! = KiCustomItem()
            name = model.replySname! + ":"
            replyItem.content = name
            replyItem.number = NSNumber(value: Int(model.replyUid!) ?? 0)
            replyItem.location = loc
            replyItem.length = name.length()
            kiCustomArray.append(replyItem)
            loc += name.length()
            
            commentString += name
        }
        weak var weakSelf = self
        commentLabel?.customLinkTapHandler = {(operation: KILabel,
            string: String,range : NSRange,contentString : String) in

            weakSelf?.onAtUserClick?(contentString, string)
        }
        
        commentString += " " + model.content!
        commentLabel.kiCustomItemArray = kiCustomArray

        let contentAttributeString = commentString.show(with: commentFont ,imageOffSet : UIOffsetMake(0, -5) , lineSpace: -2 , imageWidthRatio: CGFloat(1.5) )
        commentLabel!.attributedText = contentAttributeString
//        let size = commentLabel.sizeThatFits(CGSizeMake(commentLabel.preferredMaxLayoutWidth, CGFloat.max))
        
        let cellWidth = UIScreen.main.bounds.size.width
        let contentWidth  = cellWidth - TweetTableViewCell.Consts.ContentLeftAlign - TweetTableViewCell.Consts.ContentRightAlign
        let commentWidth = contentWidth - 2*CGFloat(TweetSocialInfoView.Horipadding)
        
        if let size = contentAttributeString?.size(withMaxWidth: commentWidth, font: commentLabel.font) {            
            commentLabel.size = CGSize(width: size.width, height: size.height)
        }

        return commentLabel
    }
    
    func update(){
        if info == nil {
            return
        }
        var hasPraiseOrForward = false
        if info!.praise != nil && ((info!.praise!.user?.count ?? 0) > 0) {
            self.initPraiseItems()
            praiseImageView?.isHidden = false
            praiseLabel?.isHidden = false
            let (kiCustomArray , praiseList ) = TweetSocialInfoView.listFor(info!.praise?.user as! [LJTweetDataSocialUserModel])
            praiseLabel?.kiCustomItemArray = kiCustomArray
            praiseLabel?.text = praiseList.joined(separator: ", ")
            if praiseLabel?.text?.length() == 0 {
                //容错，后端返回的数据name为空时
                praiseLabel?.text = " "
            }
            hasPraiseOrForward = true
            
        }else if self.praiseImageView != nil {
            praiseImageView?.isHidden = true
            praiseLabel?.isHidden = true
        }
        
        if info!.forward != nil && ((info!.forward!.user?.count ?? 0) > 0) {
            self.initForwardItems()
            forwardImageView?.isHidden = false
            forwardLabel?.isHidden = false
            let (kiCustomArray , forwardList) = TweetSocialInfoView.listFor(info!.forward!.user as! [LJTweetDataSocialUserModel])
            forwardLabel?.kiCustomItemArray = kiCustomArray
            if forwardList.count > 1 {
                forwardLabel?.text = forwardList.joined(separator: ", ")
            }else{
                forwardLabel?.text =  forwardList.first
            }
            
            if forwardLabel?.text?.length() == 0 {
                forwardLabel?.text = " "
            }
            
            hasPraiseOrForward = true
            
        }else{
            forwardImageView?.isHidden = true
            forwardLabel?.isHidden = true
        }
        
        if hasPraiseOrForward && ((info!.comment?.list?.count ?? 0) > 0 ) {
            self.initTopSplitline()
            topSplitLine?.isHidden = false
        }else if topSplitLine != nil {
            topSplitLine?.isHidden = true
        }
        
        if self.showCommentList {
            
            for commentLabel in commentLabels {
                commentLabel.removeFromSuperview()
            }
            commentLabels.removeAll()
            
            if info!.comment != nil && (( info!.comment?.list?.count ?? 0) > 0 ) {
                
                for i in 0  ..< min((info!.comment?.list?.count ?? 0), TweetSocialInfoView.maxCommentCount)  {
                    let model = info!.comment?.list?[i] as! LJTweetDataContentCommentListModel
                    let commentLabel = self.commentLabel(model )
                    self.addSubview(commentLabel)
                    commentLabels.append(commentLabel)
                }
            }
            
            let cmtNum = Int(info!.comment?.num ?? "") ?? 0
            if cmtNum > TweetSocialInfoView.maxCommentCount {
                self.initCheckAllItems()
                initBottomSplitline()
                checkAllLabel?.isHidden = false
                bottomSplitLine?.isHidden = false
                
                checkAllLabel?.text = "查看全部\(cmtNum)条评论"
                checkAllLabel?.sizeToFit()
                
            }else if (self.checkAllLabel != nil ){
                checkAllLabel?.isHidden = true
                bottomSplitLine?.isHidden = true
            }
        }
        
        self.needsUpdateConstraints()
    }
    
    override func updateConstraints() {
        
        if self.width < 1 {
            super.updateConstraints()
            return
        }
        
        var showPraise = false
        var showForward = false
        
        
        if self.praiseImageView != nil && self.praiseImageView?.isHidden == false {
            
            praiseImageView?.snp.remakeConstraints({ [weak self](make) -> Void in
            
                make.left.equalTo(self!.snp.left).offset( TweetSocialInfoView.Horipadding)
                make.top.equalTo(self!.snp.top).offset(TweetSocialInfoView.Verticalpadding)
                make.width.equalTo(TweetSocialInfoView.IconWidth)
                make.height.equalTo(TweetSocialInfoView.IconHeight)
            })
            
            praiseLabel?.snp.remakeConstraints({ [weak self](make) -> Void in
                make.left.equalTo(self!.praiseImageView!.snp.right).offset(TweetSocialInfoView.IconMarginRight)
                make.top.equalTo(self!.praiseImageView!.snp.top)
                make.right.equalTo(self!.snp.right).offset(-TweetSocialInfoView.Horipadding)
            })
            
            showPraise = true
        }
        
        if self.forwardImageView != nil && self.forwardLabel?.isHidden == false {
            
            showForward = true
            
            forwardImageView?.snp.remakeConstraints({ (make) -> Void in
                make.left.equalTo(self.snp.left).offset( TweetSocialInfoView.Horipadding)
                if showPraise {
                    make.top.equalTo(praiseLabel!.snp.bottom).offset(10)
                }else {
                    make.top.equalTo(self.snp.top).offset(TweetSocialInfoView.Verticalpadding)
                }
                make.width.equalTo(TweetSocialInfoView.IconWidth)
                make.height.equalTo(TweetSocialInfoView.IconHeight)
            })
            
            forwardLabel!.snp.remakeConstraints({[weak self](make) -> Void in
                make.left.equalTo(self!.forwardImageView!.snp.right).offset(TweetSocialInfoView.IconMarginRight)
                make.right.equalTo(self!.snp.right).offset(-TweetSocialInfoView.Horipadding)
                make.top.equalTo(self!.forwardImageView!.snp.top)
            })
        }
        
        if commentLabels.count > 0 {
            
            if showPraise || showForward {
                //设置分隔线
                topSplitLine?.snp.remakeConstraints({ [weak self](make) -> Void in
                    make.left.equalTo(self!.snp.left)
                    make.right.equalTo(self!.snp.right)
                    make.height.equalTo(0.5)
                    if showForward {
                        make.top.equalTo(self!.forwardLabel!.snp.bottom).offset(4)
                    }else{
                        make.top.equalTo(self!.praiseLabel!.snp.bottom).offset(4)
                    }
                })
            }
            
            var lastLabel : KILabel? = nil
            for comment in commentLabels {
                comment.snp.remakeConstraints({ (make) -> Void in
                    
                    make.left.equalTo(self.snp.left).offset(TweetSocialInfoView.Horipadding)
                    make.right.lessThanOrEqualTo(self.snp.right).offset(-TweetSocialInfoView.Horipadding)
                    if lastLabel != nil {
                        make.top.equalTo(lastLabel!.snp.bottom).offset(2)
                    }else {
                        if showPraise || showForward {
                            make.top.equalTo(topSplitLine!.snp.bottom).offset(4)
                        }else{
                           _ =  make.top.equalTo(10)
                        }
                    }
                    make.height.equalTo(comment.height)
                })
                
                lastLabel = comment
            }
            
            if checkAllLabel != nil && checkAllLabel?.isHidden == false {
                bottomSplitLine?.snp.remakeConstraints({ (make) -> Void in
                    make.left.equalTo(self.snp.left)
                    make.right.equalTo(self.snp.right)
                    make.top.equalTo(lastLabel!.snp.bottom).offset(1)
                    make.height.equalTo(0.5)
                })
                checkAllLabel?.snp.updateConstraints({ (make) -> Void in
                    make.left.equalTo(self.snp.left)
                    make.right.equalTo(self.snp.right)
                    make.top.equalTo(bottomSplitLine!.snp.bottom).offset(1)
                    make.height.equalTo(20)
                })
            }
        }
        super.updateConstraints()
    }
        
}
