//
//  NewsAcitivityDetailCell.swift
//  news
//
//  Created by 陈龙 on 16/1/9.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class NewsAcitivityDetailView: UIView, UIWebViewDelegate {

    class Consts: NSObject {
        
        static let HorizontalSpace: CGFloat = 15.0
        
        static let TitleTopSpace: CGFloat = 20.0
        static let TitleWidth: CGFloat = GlobalConsts.screenWidth - Consts.HorizontalSpace * 2
        
        static let AuthoreInfoTopSpace: CGFloat = 10.0
//        static let AuthoreInfoHeight: CGFloat = 15.0
        
        static let SponsorTitleWidth: CGFloat = 45.0

        static let TimeTopSpace: CGFloat = 5.0
        
        static let ImageTopSpace: CGFloat = 22.5
        static let PostImageHeight: CGFloat = (GlobalConsts.screenWidth - Consts.HorizontalSpace * 2) * 420 / 690
        
        static let lineHeight: CGFloat = 0.5
        
        static let ContentTitleTopSpace: CGFloat = 20.0
        static let ContentTitleHeight: CGFloat = 20.0
        
        static let ContentTopSpace: CGFloat = 22.5
        static let ContentBottomSpace: CGFloat = 20
        
        static let RuleTitleTopSpace: CGFloat = 20.0
        
        static let RuleTopSpace: CGFloat = 15.0
        
        static let SubmitTopSpace: CGFloat = 40
        static let SubmitBottomSpace: CGFloat = 40.0
        static let SubmitSize: CGSize = CGSize(width: 250, height: 40)
    }
    
    private let titleLabel = UILabel()
    private let sponsorTitleLabel = UILabel()
    private let sponsorLabel = UILabel()
    private let timeLabel = UILabel()
    private let postImageView = UIImageView()
    private let contentTitleLabel = UILabel()
    private var contentWebView: UIWebView = UIWebView()
    private let lineView = UIView()
    private let ruleTitleLabel = UILabel()
    private let ruleLabel = UILabel()
    
    private var contentHeight: CGFloat! = 0
    
    var updateHeight : ((_ view : NewsAcitivityDetailView , _ height : CGFloat) -> ())?
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.buildView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - private
    
    func buildView() {
        
        self.backgroundColor = UIColor.white
        
        titleLabel.textColor = NewsConfig.DetailTitleColor
        titleLabel.font = NewsConfig.DetailTitleFont
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 0
        self.addSubview(titleLabel)
        
        sponsorTitleLabel.textColor = NewsConfig.authorInfoColor
        sponsorTitleLabel.font = NewsConfig.authorInfoFont
        sponsorTitleLabel.numberOfLines = 1
        sponsorTitleLabel.lineBreakMode = .byTruncatingTail
        self.addSubview(sponsorTitleLabel)
        
        sponsorLabel.textColor = NewsConfig.authorInfoColor
        sponsorLabel.font = NewsConfig.authorInfoFont
        sponsorLabel.numberOfLines = 0
        self.addSubview(sponsorLabel)
        
        timeLabel.textColor = NewsConfig.TimeColor
        timeLabel.font = NewsConfig.TimeFont
        timeLabel.numberOfLines = 1
        self.addSubview(timeLabel)
        self.addSubview(postImageView)
        
        contentTitleLabel.textColor = NewsConfig.DetailTitleColor
        contentTitleLabel.font = NewsConfig.DetailTitleFont
        contentTitleLabel.numberOfLines = 1
        contentTitleLabel.text = "活动内容"
        self.addSubview(contentTitleLabel)
        
        contentWebView.scrollView.isScrollEnabled = false
        contentWebView.isUserInteractionEnabled = true
        contentWebView.delegate = self
        self.addSubview(contentWebView)

        lineView.backgroundColor = NewsConfig.SeperateLineColor
        self.addSubview(lineView)
        
        ruleTitleLabel.textColor = NewsConfig.DetailTitleColor
        ruleTitleLabel.font = NewsConfig.DetailTitleFont
        ruleTitleLabel.numberOfLines = 1
        ruleTitleLabel.text = "活动说明"
        self.addSubview(ruleTitleLabel)
        
        ruleLabel.textColor = NewsConfig.DetailContentColor
        ruleLabel.font = NewsConfig.DetailContentFont
        ruleLabel.numberOfLines = 0
        self.addSubview(ruleLabel)
    }
    
    // MARK: - UIWebViewDelegate
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        //用户选择
        let jsSelect = "document.documentElement.style.webkitUserSelect='none';"
        webView.stringByEvaluatingJavaScript(from: jsSelect)
        //用户长按
        let jsTouch = "document.documentElement.style.webkitTouchCallout='none';"
        webView.stringByEvaluatingJavaScript(from: jsTouch)
        
        var height = Float(0.0)
        if let docHeight = webView.stringByEvaluatingJavaScript(from: "document.body.scrollHeight") {
            height = NSString(string: docHeight).floatValue + 10
            
        }else{
            
            for subv in webView.subviews {
                for dsubv in subv.subviews {
                    if dsubv.isKind(of: NSClassFromString("UIWebBrowserView")!){
                        height = Float(dsubv.height) + 10
                        break
                    }
                }
            }
        }
        contentWebView.snp.updateConstraints { (make) -> Void in
            make.height.equalTo(height)
        }
        
        contentHeight = CGFloat(height)
        if (self.info != nil) {
            let viewHeight = heightForCell(self.info!)
            self.updateHeight?(self, viewHeight)
        }
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        if self.info != nil {
            let titleString = self.info!.title ?? ""
            let sponsorTitleString = "主办方: "
            let sponsorString = self.info!.sponsor ?? ""
            let ruleString = self.info!.desc ?? ""
            
            titleLabel.snp.updateConstraints { (make) -> Void in
                make.left.equalTo(self.snp.left).offset(Consts.HorizontalSpace)
                make.right.equalTo(self.snp.right).offset(-Consts.HorizontalSpace)
                make.top.equalTo(self.snp.top).offset(Consts.TitleTopSpace)
                let titleHeight = titleString.size(withMaxWidth: Consts.TitleWidth, font: NewsConfig.DetailTitleFont).height
                make.height.equalTo(titleHeight)
            }
            
            let sponsorTitleSize = sponsorTitleString.size(withMaxWidth: Consts.SponsorTitleWidth, font: NewsConfig.authorInfoFont)
            sponsorTitleLabel.snp.updateConstraints { (make) -> Void in
                make.left.equalTo(titleLabel.snp.left)
                make.top.equalTo(titleLabel.snp.bottom).offset(Consts.AuthoreInfoTopSpace)
                make.width.equalTo(sponsorTitleSize.width)
                make.height.equalTo(sponsorTitleSize.height)
            }
            
            sponsorLabel.snp.updateConstraints { (make) -> Void in
                make.left.equalTo(sponsorTitleLabel.snp.right)
                make.right.equalTo(titleLabel.snp.right)
                make.top.equalTo(sponsorTitleLabel.snp.top)
                let sponsorWidth = Consts.TitleWidth - sponsorTitleSize.width
                let height = sponsorString.size(withMaxWidth: sponsorWidth, font: NewsConfig.authorInfoFont).height
                make.height.equalTo(height)
            }
            
            timeLabel.snp.updateConstraints { (make) -> Void in
                make.left.equalTo(sponsorTitleLabel.snp.left)
                make.right.equalTo(sponsorLabel.snp.right)
                make.top.equalTo(sponsorLabel.snp.bottom).offset(Consts.TimeTopSpace)
                make.height.equalTo(sponsorTitleLabel.snp.height)
            }
            
            postImageView.snp.updateConstraints { (make) -> Void in
                make.left.equalTo(titleLabel.snp.left)
                make.right.equalTo(titleLabel.snp.right)
                make.top.equalTo(timeLabel.snp.bottom).offset(Consts.ImageTopSpace)
                make.height.equalTo(Consts.PostImageHeight)
            }
            
            contentTitleLabel.snp.updateConstraints { (make) -> Void in
                make.left.equalTo(titleLabel.snp.left)
                make.right.equalTo(titleLabel.snp.right)
                make.height.equalTo(Consts.ContentTitleHeight)
                make.top.equalTo(postImageView.snp.bottom).offset(Consts.ContentTitleTopSpace)
            }
            
            contentWebView.snp.updateConstraints { (make) -> Void in
                make.top.equalTo(contentTitleLabel.snp.bottom).offset(Consts.ContentTopSpace)
                make.left.equalTo(titleLabel.snp.left)
                make.right.equalTo(titleLabel.snp.right)
                make.height.equalTo(20) // 定义初始值，需要纠偏
            }
            
            lineView.snp.updateConstraints { (make) -> Void in
                make.left.equalTo(titleLabel.snp.left)
                make.right.equalTo(titleLabel.snp.right)
                make.height.equalTo(Consts.lineHeight)
                make.top.equalTo(contentWebView.snp.bottom).offset(Consts.ContentBottomSpace)
            }
            
            ruleTitleLabel.snp.updateConstraints { (make) -> Void in
                make.left.equalTo(titleLabel.snp.left)
                make.right.equalTo(titleLabel.snp.right)
                make.height.equalTo(Consts.ContentTitleHeight)
                make.top.equalTo(lineView.snp.bottom).offset(Consts.RuleTitleTopSpace)
            }
            
            ruleLabel.snp.updateConstraints { (make) -> Void in
                make.top.equalTo(ruleTitleLabel.snp.bottom).offset(Consts.RuleTopSpace)
                make.left.equalTo(titleLabel.snp.left)
                make.right.equalTo(titleLabel.snp.right)
                let ruleHeight = ruleString.size(withMaxWidth: Consts.TitleWidth, font: NewsConfig.DetailContentFont).height
                make.height.equalTo(ruleHeight)
            }
        }
    }
    
    // MARK: - public
    
    internal func heightForCell(_ info: NewsActivityDetailDataModel) -> CGFloat {
        let titleString = info.title ?? ""
        let ruleString = info.desc ?? ""
        let sponsorString = info.sponsor ?? ""
        let sponsorTitleString = "主办方: "
        
        let titleHeight = titleString.size(withMaxWidth: Consts.TitleWidth, font: NewsConfig.DetailTitleFont).height
        let sponsorWidth = Consts.TitleWidth - Consts.SponsorTitleWidth
        let sponsorTitleSize = sponsorTitleString.size(withMaxWidth: Consts.SponsorTitleWidth, font: NewsConfig.authorInfoFont)
        let sponsorHeight = sponsorString.size(withMaxWidth: sponsorWidth, font: NewsConfig.authorInfoFont).height
        let timeHeight = sponsorTitleSize.height
        
        let ruleHeight = ruleString.size(withMaxWidth: Consts.TitleWidth, font: NewsConfig.DetailContentFont).height

        let ruleTitleHeight = Consts.ContentTitleHeight
        
        let height: CGFloat = Consts.TitleTopSpace + titleHeight + Consts.AuthoreInfoTopSpace + sponsorHeight + Consts.TimeTopSpace + timeHeight + Consts.ImageTopSpace + Consts.PostImageHeight + Consts.ContentTitleTopSpace
            + Consts.ContentTitleHeight + Consts.ContentTopSpace + contentHeight + Consts.ContentBottomSpace + Consts.lineHeight + Consts.RuleTitleTopSpace + ruleTitleHeight + Consts.RuleTopSpace + ruleHeight +  Consts.SubmitBottomSpace
        
        return height
    }
    
    var submitAction: ((_ info: NewsActivityDetailDataModel?) -> ())?
    
    var info: NewsActivityDetailDataModel? {
        didSet {
            let titleString = info?.title ?? ""
            let sponsorString =  info?.sponsor ?? ""
            let timeStartString = info?.timeStart ?? ""
            let timeStartDouble : Double? = Double(timeStartString)
            var timeString = ""
            if info?.timeStart != nil {
                let timeDate = Date(timeIntervalSince1970: timeStartDouble!)
                timeString = TKCommonTools.dateString(withFormat: "MM月dd日 HH:mm", date: timeDate)
            }
            
            let imageUrl = Urlhelper.tryEncode(info?.thumb)
            let contentString = info?.content ?? ""
            let ruleString = info?.desc ?? ""
            
            titleLabel.text = titleString
            
            let sponsorTitleString = "主办方: "
            sponsorTitleLabel.text = sponsorTitleString
            sponsorLabel.text = sponsorString
            
            let timeAttributes = [NSForegroundColorAttributeName:NewsConfig.TimeColor, NSFontAttributeName: NewsConfig.TimeFont]
            let timeStrings = "时时间: " + timeString
            let timeStringAttribute = NSMutableAttributedString(string: timeStrings, attributes: timeAttributes)
            timeStringAttribute.addAttribute(NSForegroundColorAttributeName, value: UIColor.clear, range: NSMakeRange(1, 1))
            timeLabel.attributedText = timeStringAttribute

            let placeHoldImage = UIImage(named: "default_news_activity")
            postImageView.sd_setImage(with: imageUrl, placeholderImage: placeHoldImage)
            
            contentWebView.loadHTMLString(contentString, baseURL: nil)
            ruleLabel.text = ruleString
            
            self.setNeedsUpdateConstraints()
        }
    }
}
