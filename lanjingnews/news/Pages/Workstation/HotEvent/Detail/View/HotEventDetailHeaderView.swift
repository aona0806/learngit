//
//  HotEventDetailHeaderView.swift
//  news
//
//  Created by 陈龙 on 16/6/7.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

protocol HotEventDetailHeaderViewDelegate {
    func contentWebViewDidLoad(_ view: HotEventDetailHeaderView) -> Void
}

class HotEventDetailHeaderView: UIView, UIWebViewDelegate {

    struct Consts {
        
        static let ContentHorizontalSpace = CGFloat(15)
        
        static var TagImageViewSize: CGSize {
            get {
                let height = Consts.TitleFont.lineHeight
                let size = CGSize(width: 4, height: height)
                return size
            }
        }
        
        static let TitleFont = UIFont.systemFont(ofSize: 20)
        static let TitleColor = UIColor.black
        static let TitleTopSpace = CGFloat(21)
        
        static let ContentTopSpace = CGFloat(20)
        
        static let RecArticleTopSpace = CGFloat(17)
        static let RecArticleBackColor = UIColor.rgb(0xeeeeee)
        static let RecArticleBackHeight = CGFloat(36)
        static let RecArticleHorizonbleSpace = CGFloat(13)
        
        static let RecArticleTitleColor = UIColor.rgb(0x1a93d1)
        static let RecArticleTitleString = "[相关]"
        
        static let RecArticleColor = UIColor.rgb(0x1b1b1b)
        static let RecArticleFont = UIFont.systemFont(ofSize: 14)
        static let RecArticleLeftSpace = CGFloat(12)
        
        static let ExpertTitleColor = UIColor.rgb(0x1a93d1)
        static let ExpertTitleFont = UIFont.systemFont(ofSize: 15)
        static let ExpertTitleTopSpace = CGFloat(18)
        static let ExpertTitleString = "推荐专家:"
        
        static let ExpertLineTopSpace = CGFloat(17)

    }
    
    internal var delegate: HotEventDetailHeaderViewDelegate?
    
    private let tagImageView = UIImageView()
    private let titleLabel = UILabel()
    private let contentWebView = UIWebView()
    private let expertTitleLabel = UILabel()
    private let expertLineView = UIView()
    private var contentWebHeight = CGFloat(0)
    
    // 关联事件
    private let recArticleView = UIView()
    private let recArticleTitleLabel = UILabel()
    private let recArticleLabel = UILabel()
    
    override func updateConstraints() {
        super.updateConstraints()
        
        guard let model = info else {
            return
        }
        
        let titleStirng: NSString = model.title as NSString? ?? ""
        titleLabel.snp.updateConstraints { (make) in
            let width = GlobalConsts.screenWidth - Consts.ContentHorizontalSpace * 2
            let height = titleStirng.size(withMaxWidth: width, font: Consts.TitleFont, maxLineNum: 2).height
            make.height.equalTo(height)
        }

        contentWebView.snp.updateConstraints { (make) in
            make.height.equalTo(contentWebHeight)
        }
        
        let articleRecList = info?.atricleRecList as? [HotEventDataAtricleRecListModel] ?? []
        let articleRec = articleRecList.first
        if articleRec != nil {
            self.recArticleView.snp.updateConstraints { (make) in
                make.top.equalTo(contentWebView.snp.bottom).offset(Consts.RecArticleTopSpace)
                make.height.equalTo(Consts.RecArticleBackHeight)
            }
        } else {
            self.recArticleView.snp.updateConstraints { (make) in
                make.top.equalTo(contentWebView.snp.bottom).offset(0)
                make.height.equalTo(0)
            }
        }
    }
    
    // MARK: - lifecycle
    init (delegate: HotEventDetailHeaderViewDelegate) {
        super.init(frame: CGRect.zero)
        
        self.delegate = delegate
        
        initView()
        initViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private
    
    private func initView() -> Void {
        
        self.backgroundColor = UIColor.clear
        
        tagImageView.image = UIImage(named: "hotevent_list_tag")
        self.addSubview(tagImageView)
        
        titleLabel.textColor = Consts.TitleColor
        titleLabel.font = Consts.TitleFont
        titleLabel.numberOfLines = 0
        titleLabel.backgroundColor = UIColor.clear
        self.addSubview(titleLabel)
        
        autoreleasepool { () -> () in
            contentWebView.scrollView.isScrollEnabled = false
            contentWebView.isUserInteractionEnabled = true
            contentWebView.delegate = self
            self.addSubview(contentWebView)
        }
        
        recArticleView.backgroundColor = Consts.RecArticleBackColor
        recArticleView.isUserInteractionEnabled = true
        let articleGesture = UITapGestureRecognizer(target: self, action: #selector(articleAction(_:)))
        recArticleView.addGestureRecognizer(articleGesture)
        self.addSubview(recArticleView)
        
        recArticleTitleLabel.numberOfLines = 1
        recArticleTitleLabel.textColor = Consts.RecArticleTitleColor
        recArticleTitleLabel.text = Consts.RecArticleTitleString
        recArticleTitleLabel.font = Consts.RecArticleFont
        recArticleTitleLabel.backgroundColor = UIColor.clear
        recArticleView.addSubview(recArticleTitleLabel)
        
        recArticleLabel.numberOfLines = 1
        recArticleLabel.textColor = Consts.RecArticleColor
        recArticleLabel.font = Consts.RecArticleFont
        recArticleLabel.textAlignment = .left
        recArticleLabel.lineBreakMode = .byTruncatingTail
        recArticleLabel.backgroundColor = UIColor.clear
        recArticleView.addSubview(recArticleLabel)
        
        expertTitleLabel.textColor = Consts.ExpertTitleColor
        expertTitleLabel.font = Consts.ExpertTitleFont
        expertTitleLabel.numberOfLines = 1
        expertTitleLabel.text = Consts.ExpertTitleString
        expertTitleLabel.backgroundColor = UIColor.clear
        self.addSubview(expertTitleLabel)
        
        expertLineView.backgroundColor = HotEventConfig.SeperateLineColor
        self.addSubview(expertLineView)
        
    }
    
    private func initViewConstraints() -> Void {
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(Consts.ContentHorizontalSpace)
            make.right.equalTo(self.snp.right).offset(-Consts.ContentHorizontalSpace)
            make.top.equalTo(self.snp.top).offset(Consts.TitleTopSpace)
            make.height.equalTo(0)
        }
        
        tagImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.top.equalTo(titleLabel.snp.top)
            make.size.equalTo(Consts.TagImageViewSize)
        }
        
        contentWebView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(Consts.ContentHorizontalSpace)
            make.right.equalTo(self.snp.right).offset(-Consts.ContentHorizontalSpace)
            make.top.equalTo(titleLabel.snp.bottom).offset(Consts.ContentTopSpace)
            make.height.equalTo(0)
        }
        
        recArticleView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(titleLabel.snp.right)
            make.top.equalTo(contentWebView.snp.bottom).offset(0)
            make.height.equalTo(0)
        }
        
        recArticleTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(recArticleView.snp.left).offset(Consts.RecArticleHorizonbleSpace)
            make.centerY.equalTo(recArticleView.snp.centerY)
            make.height.equalTo(Consts.RecArticleFont.lineHeight)
            let title: NSString = Consts.RecArticleTitleString as NSString
            let width = title.size(withMaxHeight: Consts.RecArticleFont.lineHeight, font: Consts.RecArticleFont).width
            make.width.equalTo(width)
        }
        
        recArticleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(recArticleTitleLabel.snp.right).offset(Consts.RecArticleLeftSpace)
            make.centerY.equalTo(recArticleView.snp.centerY)
            make.right.equalTo(recArticleView.snp.right).offset(-Consts.RecArticleHorizonbleSpace)
            make.height.equalTo(Consts.RecArticleFont.lineHeight)
        }
        
        expertTitleLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(recArticleView.snp.left)
            make.top.equalTo(recArticleView.snp.bottom).offset(Consts.ExpertTitleTopSpace)
            make.height.equalTo(Consts.ExpertTitleFont.lineHeight)
            make.right.equalTo(recArticleView.snp.right)
        }
        
        expertLineView.snp.remakeConstraints { (make) in
            make.left.equalTo(recArticleView.snp.left)
            make.right.equalTo(recArticleView.snp.right)
            make.height.equalTo(HotEventConfig.SeperateLineHeight)
            make.top.equalTo(expertTitleLabel.snp.bottom).offset(Consts.ExpertLineTopSpace)
        }
    }
    
    // MARK: - action
    
    @objc func articleAction(_ sender: UIGestureRecognizer) -> Void {
        
        let articleRecList = info?.atricleRecList as? [HotEventDataAtricleRecListModel] ?? []
        let articleRec = articleRecList.first
        if articleRec != nil {
            let schemaString = articleRec?.schema ?? ""
            PushManager.sharedInstance.handleOpenUrl(schemaString)
        }

    }
    
    // MARK: - public
    
    var info: HotEventDetailDataModel? {
        
        didSet {
            guard let model = info else {
                return
            }
            
            let titleString = model.title ?? ""
            titleLabel.text = titleString
            
            let contentString = model.content ?? ""
            contentWebView.loadHTMLString(contentString, baseURL: nil)
            
            let articleRecList = model.atricleRecList as? [HotEventDataAtricleRecListModel] ?? []
            let articleRec = articleRecList.first
            if articleRec != nil {
                recArticleLabel.text = articleRec?.title
                recArticleView.isHidden = false
            } else {
                recArticleView.isHidden = true
            }
            self.setNeedsUpdateConstraints()
        }
    }
    
    private func heightForCell(_ info: HotEventDetailDataModel?) -> CGFloat {
        
        var height = CGFloat(0)

        if let model = info {
            let titleStirng: NSString = model.title as NSString? ?? ""
            let titleWidth = GlobalConsts.screenWidth - Consts.ContentHorizontalSpace * 2
            let titleHeight = titleStirng.size(withMaxWidth: titleWidth, font: Consts.TitleFont, maxLineNum: 2).height
            
            var articleRecHeight = CGFloat(0)
            let articleRecList = model.atricleRecList as? [HotEventDataAtricleRecListModel] ?? []
            let articleRec = articleRecList.first
            if articleRec != nil {
                articleRecHeight = Consts.RecArticleBackHeight + Consts.RecArticleTopSpace
            }
            
            let expertTitleHeight = Consts.ExpertTitleTopSpace + Consts.ExpertTitleFont.lineHeight + Consts.ExpertLineTopSpace + HotEventConfig.SeperateLineHeight
            
            height = Consts.TitleTopSpace + titleHeight + Consts.ContentTopSpace + contentWebHeight + articleRecHeight + expertTitleHeight
        }
        return ceil(height)
    }
    
    //MARK: - webView相关
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        //用户选择
        let jsSelect = "document.documentElement.style.webkitUserSelect='none';"
        webView.stringByEvaluatingJavaScript(from: jsSelect)
        //用户长按
        let jsTouch = "document.documentElement.style.webkitTouchCallout='none';"
        webView.stringByEvaluatingJavaScript(from: jsTouch)
        
        webView.width = GlobalConsts.screenWidth - Consts.ContentHorizontalSpace * 2
        webView.height = 0
        var height = Float(0.0)
        if let docHeight = webView.stringByEvaluatingJavaScript(from: "document.body.scrollHeight") {
            height = NSString(string: docHeight).floatValue
            
        } else{
            
            for subv in webView.subviews {
                for dsubv in subv.subviews {
                    if dsubv.isKind(of: NSClassFromString("UIWebBrowserView")!){
                        height = Float(dsubv.height)
                        break
                    }
                }
            }
            
        }
        contentWebHeight = CGFloat(height)
        let cellHeight = self.heightForCell(info)
        self.frame = CGRect(x: 0, y: 0, width: GlobalConsts.screenWidth, height: cellHeight)
        delegate?.contentWebViewDidLoad(self)

    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if navigationType == .linkClicked {
            
            let urlString: String! = request.url?.absoluteString ?? ""
            PushManager.sharedInstance.handleOpenUrl(urlString)
            return false
        }
        return true
    }
}
