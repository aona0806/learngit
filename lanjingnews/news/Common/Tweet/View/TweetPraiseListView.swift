//
//  TweetPraiseListView.swift
//  news
//
//  Created by chunhui on 15/12/8.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

class TweetPraiseListView: UIView {

    
    var praiseImageView : UIImageView?
    var praiseLabel : KILabel?
    var onAtUserClick: (( _ userId : String, _ content : String) -> ())? = nil
    
    var info : LJTweetDataContentModel? {
        didSet {
            self.update()
        }
    }
    
    
    class func heightForModel(_ info : LJTweetDataContentModel) -> CGFloat{
        
        let font = UIFont(name: TweetTableViewCell.Consts.ContentFontName, size: TweetTableViewCell.Consts.CommentFontSize)
        
        var height = CGFloat(0.0)
        let cellWidth = UIScreen.main.bounds.size.width
        let contentWidth  = cellWidth - TweetTableViewCell.Consts.ContentRightAlign - CGFloat(TweetSocialInfoView.Horipadding) - CGFloat(2*TweetSocialInfoView.Horipadding)
        // - TweetTableViewCell.Consts.ContentLeftAlign
        
        if info.praise != nil && (( info.praise!.user?.count ?? 0) > 0) {
            height += CGFloat(TweetSocialInfoView.Verticalpadding)
            let (_ , praiseList ) = TweetSocialInfoView.listFor(info.praise?.user as! [LJTweetDataSocialUserModel])
            let users = praiseList.joined(separator: ", ")
            height += users.size(withMaxWidth: contentWidth - CGFloat(TweetSocialInfoView.IconWidth) - CGFloat(TweetSocialInfoView.IconMarginRight) , font: font ).height
        }
        
        return height
        
    }
    
    func initPraiseItems(){
        if self.praiseImageView == nil {
            let img = UIImage(named: "tweet_praised")
            self.praiseImageView = UIImageView(image: img)
            
            praiseLabel = KILabel()
            praiseLabel?.isUserInteractionEnabled = true
            praiseLabel?.font = UIFont(name: TweetTableViewCell.Consts.ContentFontName, size: TweetTableViewCell.Consts.CommentFontSize)
            praiseLabel?.linkGroundColor = TweetTableViewCell.Consts.CommentBlueColor
            weak var weakSelf = self
            praiseLabel?.customLinkTapHandler = {(operation: KILabel,
                string: String,range : NSRange,contentString : String) in
                weakSelf?.onAtUserClick?( contentString, string)
            }
            
            self.addSubview(praiseImageView!)
            self.addSubview(praiseLabel!)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initPraiseItems()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initPraiseItems()
    }
    
    
    func update(){
        if info == nil {
            return
        }
        
        if info!.praise != nil && ((info!.praise?.user?.count ?? 0) > 0 ){
            
            self.initPraiseItems()
            praiseImageView?.isHidden = false
            praiseLabel?.isHidden = false
            let (kiCustomArray , praiseList ) = TweetSocialInfoView.listFor(info!.praise?.user as! [LJTweetDataSocialUserModel])
            praiseLabel?.kiCustomItemArray = kiCustomArray
            praiseLabel?.text = praiseList.joined(separator: ", ")
            
        }else if self.praiseImageView != nil {
            
            praiseImageView?.isHidden = true
            praiseLabel?.isHidden = true
        }
        
        self.setNeedsUpdateConstraints()
        
    }
    
    
    override func updateConstraints() {
        
        if self.width < 1 {
            super.updateConstraints()
            return
        }
        
        if self.praiseImageView != nil && self.praiseImageView?.isHidden == false {
            
            praiseImageView?.snp.remakeConstraints({ (make) -> Void in
                make.left.equalTo(self.snp.left).offset(TweetSocialInfoView.Horipadding)
                make.top.equalTo(self.snp.top).offset(TweetSocialInfoView.Verticalpadding)
                make.width.equalTo(TweetSocialInfoView.IconWidth)
                make.height.equalTo(TweetSocialInfoView.IconHeight)
            })
            
            praiseLabel?.snp.remakeConstraints({ (make) -> Void in
                make.left.equalTo(praiseImageView!.snp.right).offset(TweetSocialInfoView.IconMarginRight)
                make.top.equalTo(praiseImageView!.snp.top)
                make.right.equalTo(self.snp.right).offset(-TweetSocialInfoView.Horipadding)
            })
        }
        
        super.updateConstraints()
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
