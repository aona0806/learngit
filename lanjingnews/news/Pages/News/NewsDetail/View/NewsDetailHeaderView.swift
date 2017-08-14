//
//  NewsDetailHeaderView.swift
//  news
//
//  Created by wxc on 16/1/5.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

@objc protocol NewsDetailHeaderViewDelegate : NSObjectProtocol{
    
@objc optional func newsDetailHeaderViewPraiseButtonClick(headerView:NewsDetailHeaderView, button:UIButton)
}

class NewsDetailHeaderView: UIView , UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    struct Consts {
        static let TitleFont = UIFont.boldSystemFont(ofSize: 23)
        static let TopTitleLabelColor = UIColor.white
        static let ContentWidth = GlobalConsts.screenWidth
        static let RelatedReadLabelFont = UIFont.systemFont(ofSize: 15)
        static let RelatedReadLableColor = UIColor.rgb(0x8fc31f)
        
        static let MarginValue: CGFloat = 15  //留边宽度
        static let IntervalToTopImageBottom: CGFloat = 15
        static let IntervalValue: CGFloat = 10
        static let IntervalToTop: CGFloat = 23
        static let IntervalToTitle: CGFloat = 23
        static let IntervalToTagLabel: CGFloat = 10
        static let IntervalToFirstSplitView: CGFloat = 20
        static let IntervalToRelatedLabel: CGFloat = 7
        
        
        static let SplitViewHeight: CGFloat = 7
        static let TopViewHeight: CGFloat = GlobalConsts.screenWidth * 2 / 3
        static let BottomViewHeight: CGFloat = 40
        static let BottomBtnHeight: CGFloat = 15
        static let BottomBtnWidth: CGFloat = 40
    }

    var headerWebView:UIWebView!        //webView
    var bottomView:UIView!              //底部的view，标签点赞等
    var webViewheight: CGFloat = GlobalConsts.screenHeight       //webView的高度
    
    
    //bottomView展示控件
    var titleLabel:UILabel!             //标题
    var taglabel:UILabel!               //标签，公司，姓名，时间
    var praiseButton:UIButton!          //点赞按钮
    var commentButton:UIButton!         //评论按钮
    var commentImageView: UIImageView!   //评论
    var commentLabel: UILabel!          //最新评论
    
    // 顶部视图及子视图
    var topView: UIView?
    var topTitleLabel: UILabel?
    var topImageView:UIImageView?
    var topTitleShadowView: UIImageView?
    
    var relatedReadImageView: UIImageView?   //评论
    var relatedReadLabel: UILabel? //相关阅读lable
    var relatedReadTableView:UITableView?  // 相关阅读tableview
    var splitViewBelowWebView: UIView? //webview下的间隔view
    var splitViewBelowRelatedRead: UIView? //相关阅读下的间隔view
    
    var isHasTopImage: Bool = false
    var isHasRelatedReading: Bool = false
    
    var topImageViewHeight: CGFloat = 0
    var relatedReadLabelHeight: CGFloat = 0
    var relatedReadTableViewHeight: CGFloat = 0
    
    private var newsDetailModel:LJNewsDetailModel? = nil   //当前新闻详情数据
    
//    var lineView:UIView!                //灰色分割线
    weak var delegate:NewsDetailHeaderViewDelegate? = nil //代理
    
    //高度设置
    var titleHeight: CGFloat! = 0
    var tagHeight: CGFloat! = 0
    
    init() {
        super.init(frame: CGRect.zero)
        
        initView()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initView()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        //整体布局
        if isHasTopImage {
            topView?.snp.updateConstraints({ (make) in
                make.left.equalTo(self.snp.left)
                make.right.equalTo(self.snp.right)
                make.top.equalTo(self.snp.top)
                make.height.equalTo(topImageViewHeight)
            })
            
            topImageView?.snp.updateConstraints{ (make) in
                make.edges.equalTo(topView!)
            }
            
            
            topTitleLabel?.snp.remakeConstraints({ (make) in
                make.left.equalTo(topView!.snp.left).offset(Consts.MarginValue)
                make.right.equalTo(topView!.snp.right).offset(-Consts.MarginValue)
                make.bottom.equalTo(topView!.snp.bottom).offset(-Consts.IntervalToTopImageBottom)
                make.height.equalTo(titleHeight)
            })
            
            topTitleShadowView?.snp.updateConstraints({ (make) in
                make.left.equalTo(topView!.snp.left)
                make.right.equalTo(topView!.snp.right)
                make.top.equalTo(topTitleLabel!.snp.top)
                make.bottom.equalTo(topView!.snp.bottom)
            })
            
            if self.newsDetailModel?.data?.isAd != nil && self.newsDetailModel?.data?.isAd == "1" {
                headerWebView.snp.remakeConstraints({ (make) -> Void in
                    make.left.equalTo(self.snp.left).offset(Consts.MarginValue)
                    make.right.equalTo(self.snp.right).offset(-Consts.MarginValue)
                    make.top.equalTo(topView!.snp.bottom).offset(Consts.IntervalToTagLabel)
                    make.height.equalTo(webViewheight)
                })
            } else {
                taglabel.snp.remakeConstraints { (make) -> Void in
                    make.left.equalTo(self.snp.left).offset(Consts.MarginValue)
                    make.right.equalTo(self.snp.right).offset(-Consts.MarginValue)
                    make.top.equalTo(topView!.snp.bottom).offset(Consts.IntervalToTitle)
                    make.height.equalTo(tagHeight)
                }
                
                headerWebView.snp.remakeConstraints({ (make) -> Void in
                    make.left.equalTo(self.snp.left).offset(Consts.MarginValue)
                    make.right.equalTo(self.snp.right).offset(-Consts.MarginValue)
                    make.top.equalTo(taglabel.snp.bottom).offset(Consts.IntervalToTagLabel)
                    make.height.equalTo(webViewheight)
                })
            }
            
        } else {
            titleLabel.snp.remakeConstraints { (make) -> Void in
                make.left.equalTo(self.snp.left).offset(Consts.MarginValue)
                make.right.equalTo(self.snp.right).offset(-Consts.MarginValue)
                make.top.equalTo(self.topImageView!.snp.bottom).offset(Consts.IntervalToTop)
                make.height.equalTo(titleHeight!)
            }
            
            if self.newsDetailModel?.data?.isAd != nil && self.newsDetailModel?.data?.isAd == "1" {
                headerWebView.snp.remakeConstraints({ (make) -> Void in
                    make.left.equalTo(self.snp.left).offset(Consts.MarginValue)
                    make.right.equalTo(self.snp.right).offset(-Consts.MarginValue)
                    make.top.equalTo(titleLabel.snp.bottom).offset(Consts.IntervalToTagLabel)
                    make.height.equalTo(webViewheight)
                })
            } else {
                taglabel.snp.remakeConstraints { (make) -> Void in
                    make.left.equalTo(self.snp.left).offset(Consts.MarginValue)
                    make.right.equalTo(self.snp.right).offset(-Consts.MarginValue)
                    make.top.equalTo(titleLabel.snp.bottom).offset(Consts.IntervalToTitle)
                    make.height.equalTo(tagHeight)
                }
                
                headerWebView.snp.remakeConstraints({ (make) -> Void in
                    make.left.equalTo(self.snp.left).offset(Consts.MarginValue)
                    make.right.equalTo(self.snp.right).offset(-Consts.MarginValue)
                    make.top.equalTo(taglabel.snp.bottom).offset(Consts.IntervalToTagLabel)
                    make.height.equalTo(webViewheight)
                })
            }
            
        }
        
        if self.newsDetailModel?.data?.isAd == nil || self.newsDetailModel?.data?.isAd == "0" {
            splitViewBelowWebView?.snp.remakeConstraints({ (make) in
                make.left.equalTo(self.snp.left)
                make.right.equalTo(self.snp.right)
                make.top.equalTo(headerWebView.snp.bottom)
                make.height.equalTo(Consts.SplitViewHeight)
            })
        }
        
        if isHasRelatedReading {
            relatedReadImageView?.snp.updateConstraints({ (make) in
                make.left.equalTo(self.snp.left)
                make.top.equalTo(splitViewBelowWebView!.snp.bottom).offset(Consts.IntervalToFirstSplitView)
            })
            
            relatedReadLabel?.snp.updateConstraints { (make) in
                make.left.equalTo(relatedReadImageView!.snp.left).offset(Consts.IntervalValue)
                make.right.equalTo(self.snp.right).offset(-Consts.MarginValue)
                make.top.equalTo(splitViewBelowWebView!.snp.bottom).offset(Consts.IntervalToFirstSplitView)
                make.height.equalTo(relatedReadLabelHeight)
            }
            
            relatedReadTableView?.snp.updateConstraints{ (make) in
                make.left.equalTo(self.snp.left)
                make.right.equalTo(self.snp.right)
                make.top.equalTo(relatedReadLabel!.snp.bottom).offset(Consts.IntervalToRelatedLabel)
                make.height.equalTo(relatedReadTableViewHeight)
            }
            
            splitViewBelowRelatedRead?.snp.updateConstraints({ (make) in
                make.left.equalTo(self.snp.left)
                make.right.equalTo(self.snp.right)
                make.top.equalTo(relatedReadTableView!.snp.bottom)
                make.height.equalTo(Consts.SplitViewHeight)
            })
        }
        
        if self.newsDetailModel?.data?.isAd == nil || self.newsDetailModel?.data?.isAd == "0" {
            bottomView.snp.remakeConstraints({ (make) in
                make.left.equalTo(self.snp.left)
                make.right.equalTo(self.snp.right)
                if isHasRelatedReading {
                    make.top.equalTo(splitViewBelowRelatedRead!.snp.bottom)
                } else {
                    make.top.equalTo(splitViewBelowWebView!.snp.bottom)
                }
                
                make.height.equalTo(Consts.BottomViewHeight)
            })
            
            //bottomView布局
            commentImageView.snp.updateConstraints { (make) in
                make.left.equalTo(bottomView.snp.left)
                make.centerY.equalTo(bottomView.snp.centerY)
            }
            
            commentLabel.snp.updateConstraints { (make) in
                make.left.equalTo(commentImageView.snp.right).offset(Consts.IntervalValue)
                make.centerY.equalTo(bottomView.snp.centerY)
            }
            
            commentButton.snp.updateConstraints { (make) -> Void in
                make.right.equalTo(bottomView.snp.right).offset(-Consts.MarginValue)
                make.centerY.equalTo(bottomView.snp.centerY)
                make.height.equalTo(Consts.BottomBtnHeight)
                make.width.equalTo(Consts.BottomBtnWidth)
            }
            
            praiseButton.snp.updateConstraints { (make) -> Void in
                make.right.equalTo(commentButton.snp.left).offset(-37)
                make.centerY.equalTo(commentButton.snp.centerY)
                make.height.equalTo(Consts.BottomBtnHeight)
                make.width.equalTo(Consts.BottomBtnWidth)
            }
        }

    }

    // MARK: - private
    
    private func initView() -> Void {
        
        self.clipsToBounds = true
        self.backgroundColor = UIColor.white

        topView = UIView(frame: CGRect(x: 0, y: 0, width: GlobalConsts.screenWidth - 2 * Consts.MarginValue, height: Consts.TopViewHeight))
        topView!.backgroundColor = UIColor.clear
        self.addSubview(topView!)
        
        topImageView = UIImageView()
        topImageView?.contentMode = .scaleAspectFill
        topImageView?.clipsToBounds = true
        topView!.addSubview(topImageView!)
        
        topTitleShadowView = UIImageView()
        topTitleShadowView?.contentMode = .scaleToFill
        topTitleShadowView?.clipsToBounds = true
        topTitleShadowView?.image = UIImage(named: "newsdetail_shadow")
        topView!.addSubview(topTitleShadowView!)
   
        topTitleLabel = UILabel()
        topTitleLabel!.font = Consts.TitleFont
        topTitleLabel!.numberOfLines = 0
        topTitleLabel!.textColor = Consts.TopTitleLabelColor
        topView!.addSubview(topTitleLabel!)
        
        
    
        autoreleasepool { () -> () in
            headerWebView = UIWebView()
            headerWebView.scrollView.isScrollEnabled = false
            headerWebView.isUserInteractionEnabled = true
            self.addSubview(headerWebView)
        }
        
        bottomView = UIView()
        bottomView.isUserInteractionEnabled = true
        self.addSubview(bottomView)
        
        titleLabel = UILabel()
        titleLabel.font = Consts.TitleFont
        titleLabel.numberOfLines = 0
        titleLabel.textColor = NewsConfig.TitleColor
        self.addSubview(titleLabel)
        
        taglabel = UILabel()
        taglabel.numberOfLines = 0
        taglabel.textColor = NewsConfig.TimeColor
        taglabel.font = NewsConfig.TimeFont
        self.addSubview(taglabel)
        
        splitViewBelowWebView = UIView()
        splitViewBelowWebView?.backgroundColor = UIColor.rgb(0xeeeeee)
        self.addSubview(splitViewBelowWebView!)
        
        splitViewBelowRelatedRead = UIView()
        splitViewBelowRelatedRead?.backgroundColor = UIColor.rgb(0xeeeeee)
        self.addSubview(splitViewBelowRelatedRead!)
        
        praiseButton = UIButton()
        praiseButton.addTarget(self, action: #selector(NewsDetailHeaderView.praiseButtonClick(_:)), for: .touchUpInside)
        praiseButton.setImage(UIImage.init(named: "newsdetail_unpraise"), for: UIControlState.normal)
        praiseButton.setImage(UIImage.init(named: "newsdetail_praise"), for: UIControlState.selected)
        praiseButton.setTitle(" 0", for: UIControlState.normal)
        praiseButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        praiseButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
        bottomView.addSubview(praiseButton)
        
        commentButton  = UIButton()
        commentButton.setImage(UIImage.init(named: "newsdetail_comment"), for: UIControlState.normal)
        commentButton.setTitle(" 0", for: UIControlState.normal)
        commentButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
        commentButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        bottomView.addSubview(commentButton)
        
        commentLabel = UILabel()
        commentLabel.frame = CGRect(x: 15, y: 0, width: UIScreen.main.bounds.width - 15, height: 20)
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
        
        
        relatedReadImageView = UIImageView(frame:CGRect(x: 0, y: 0, width: 5, height: 15))
        relatedReadImageView?.contentMode = .scaleAspectFill
        relatedReadImageView?.clipsToBounds = true
        relatedReadImageView?.image = UIImage(named: "newsdetail_relatedread")
        relatedReadImageView?.isHidden = true
        self.addSubview(relatedReadImageView!)
        
        relatedReadLabel = UILabel()
        relatedReadLabel!.font = Consts.RelatedReadLabelFont
        relatedReadLabel!.textColor = Consts.RelatedReadLableColor
        relatedReadLabel!.text = "相关阅读"
        relatedReadLabel!.width = (relatedReadLabel?.text!.size(withMaxWidth: 200, font: Consts.RelatedReadLabelFont).width)!
        relatedReadLabel!.height = (relatedReadLabel?.text!.size(withMaxWidth: 200, font: Consts.RelatedReadLabelFont).height)!
        relatedReadLabel!.isHidden = true
        self.addSubview(relatedReadLabel!)
        
        relatedReadTableView = UITableView(frame: CGRect(x: 0, y: 0, width: GlobalConsts.screenWidth - 2 * Consts.MarginValue, height: 0))
        relatedReadTableView?.separatorStyle = .none
        relatedReadTableView?.delegate = self
        relatedReadTableView?.dataSource = self
        relatedReadTableView?.scrollsToTop = false
        self.addSubview(relatedReadTableView!)
        
        
    }
    
    private func heightForString(_ string:NSAttributedString, size:CGSize) -> CGFloat{
        return string.boundingRect(with: size, options: NSStringDrawingOptions.usesDeviceMetrics, context: nil).size.height
    }
    
    //MARK: - public
    
    func heightForCell(_ webHeight: CGFloat = GlobalConsts.screenHeight, model: LJNewsDetailModel?) -> CGFloat {
        
        let topHeight: CGFloat = isHasTopImage ? Consts.TopViewHeight : self.titleHeight + Consts.IntervalToTop
        
        var height: CGFloat = topHeight
        
        if self.newsDetailModel?.data?.isAd == nil || self.newsDetailModel?.data?.isAd == "0" {
            height = height  + Consts.IntervalToTitle + tagHeight
        }
        
        height = height + Consts.IntervalToTagLabel + webHeight
        
        if self.newsDetailModel?.data?.isAd == nil || self.newsDetailModel?.data?.isAd == "0" {
            height = height + Consts.BottomViewHeight + Consts.SplitViewHeight
        }
        
        if isHasRelatedReading {
            height = height + Consts.IntervalToFirstSplitView + self.relatedReadLabelHeight
            height = height + Consts.IntervalToRelatedLabel + self.relatedReadTableViewHeight + Consts.SplitViewHeight
        }
        
        return height
    }
    
    func praiseButtonClick(_ sender:UIButton){
        
        delegate?.newsDetailHeaderViewPraiseButtonClick?(headerView: self, button: sender)
    }
    
    /**
    *  赋值
    */
    func setValueWithModel(_ model:LJNewsDetailModel?) {
        
        self.newsDetailModel = model
        if model?.data?.topImage == nil || model?.data?.topImage!.length() == 0 {
            isHasTopImage = false
        } else {
            isHasTopImage = true
        }
        
        if model?.data?.articleRec == nil || model?.data?.articleRec!.count == 0 {
            relatedReadImageView!.isHidden = true
            relatedReadLabel!.isHidden = true
            isHasRelatedReading = false
        } else {
            relatedReadImageView!.isHidden = false
            relatedReadLabel!.isHidden = false
            isHasRelatedReading = true
        }
        
        if isHasTopImage {
            let imageUrl:String? = model?.data?.topImage
            let url = Urlhelper.tryEncode(imageUrl!)
            topImageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "default_news_detail"))
            
            let titleStr:NSString = model?.data?.title as NSString? ?? ""
            let title:NSAttributedString = titleStr.show(with: titleLabel.font, imageOffSet: UIOffset.init(horizontal: 0, vertical: -4), lineSpace: 0, imageWidthRatio: 1.2)
            topTitleLabel!.attributedText = title
            titleHeight = title.size(withMaxWidth: self.size.width - 2*Consts.MarginValue, font: titleLabel.font).height
        } else {
            let titleStr:NSString = model?.data?.title as NSString? ?? ""
            let title:NSAttributedString = titleStr.show(with: titleLabel.font, imageOffSet: UIOffset.init(horizontal: 0, vertical: -4), lineSpace: 0, imageWidthRatio: 1.2)
            titleLabel.attributedText = title
            titleHeight = title.size(withMaxWidth: self.size.width - 2*Consts.MarginValue, font: titleLabel.font).height
        }
        
        if self.newsDetailModel?.data?.isAd != nil && self.newsDetailModel?.data?.isAd == "1" {
            self.taglabel.isHidden = true
            self.splitViewBelowWebView?.isHidden = true
            self.bottomView.isHidden = true
        } else {
            let time = model?.data?.ctime ?? ""
            let authorInfo = model?.data?.authorInfo ?? ""
            var tagStr = authorInfo.length() > 0 ? authorInfo + "  I  最后更新于" : "最后更新于"
            tagStr = tagStr + DateFormatter.dayTimeZhunHuan(time, withFormat: " MM-dd HH:mm")
            
            let tag = tagStr.show(with: taglabel.font, imageOffSet: UIOffset.init(horizontal: 0, vertical: -4), lineSpace: 0, imageWidthRatio: 1.2)
            taglabel.attributedText = tag
            tagHeight = tag?.size(withMaxWidth: self.size.width - 2*Consts.MarginValue, font: taglabel.font).height
            
            let isZan = model?.data?.isZan ?? "0"
            let isZanNumber = Int(isZan)
            if isZanNumber != nil && isZanNumber == 1 {
                praiseButton.isSelected = true
            }else{
                praiseButton.isSelected = false
            }
            
            var zanNum = " 0"
            var commentNum = " 0"
            
            let zanNum1 = model?.data?.zanNum ?? "0"
            let zanNumber = Int(zanNum1)
            if zanNumber != nil && zanNumber! > 0 {
                zanNum = " \(zanNum1)"
            }
            
            let commentNum1 = model?.data?.commentNum ?? "0"
            let commentNumber = Int(commentNum1)
            if commentNumber != nil && commentNumber! > 0 {
                commentNum = " \(commentNum1)"
            }
            
            praiseButton.setTitle(zanNum, for: .normal)
            praiseButton.setTitle(zanNum, for: .selected)
            commentButton.setTitle(commentNum, for: .normal)
            
        }
            
        headerWebView.loadHTMLString((model?.data?.content)!, baseURL: nil)
        
        if isHasTopImage {
            topImageViewHeight = Consts.TopViewHeight
        } else {
            topImageViewHeight = 0
        }
        
        if isHasRelatedReading {
            self.relatedReadTableView?.reloadData()
            
            relatedReadLabelHeight = relatedReadLabel!.height
            relatedReadTableViewHeight = relatedReadTableView!.contentSize.height
        } else {
            relatedReadLabelHeight = 0
            relatedReadTableViewHeight = 0
        }
        
        self.setNeedsUpdateConstraints()
    }
    
    func addCommentNum(){
        let num:NSString = commentButton.title(for: .normal)! as NSString
        let numInt = num.integerValue + 1
        let numComment = NSNumber.init(value: numInt)
        commentButton.setTitle(" \(numComment.stringValue)", for: .normal)
        commentButton.setTitle(" \(numComment.stringValue)", for: .selected)
    }
    
    //MARK: UITableViewDelegate, DateSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.newsDetailModel == nil {
            return 0
        }
        return (self.newsDetailModel?.data?.articleRec?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let articleModel: LJNewsDetailDataArticleRecModel? = self.newsDetailModel?.data?.articleRec![(indexPath as NSIndexPath).row] as? LJNewsDetailDataArticleRecModel
        let cellId = "cellid"
        var cell: NewsRelatedReadingTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId) as? NewsRelatedReadingTableViewCell
        if cell == nil {
            cell = NewsRelatedReadingTableViewCell(style: .default, reuseIdentifier: cellId)
        }
        cell!.setValueWithArticleRecModel(articleModel)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let articleModel: LJNewsDetailDataArticleRecModel? = self.newsDetailModel?.data?.articleRec![(indexPath as NSIndexPath).row] as? LJNewsDetailDataArticleRecModel
        return NewsRelatedReadingTableViewCell.cellHeightWithArticleRecModel(articleModel)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleModel: LJNewsDetailDataArticleRecModel? = self.newsDetailModel?.data?.articleRec![(indexPath as NSIndexPath).row] as? LJNewsDetailDataArticleRecModel
        
        let urlString: String! = articleModel?.jump ?? ""
        PushManager.sharedInstance.handleOpenUrl(urlString)
    }
    
}
