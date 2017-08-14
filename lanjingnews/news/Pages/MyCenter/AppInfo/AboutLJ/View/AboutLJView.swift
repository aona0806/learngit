//
//  AboutLJCell.swift
//  news
//
//  Created by 奥那 on 16/1/15.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class AboutLJView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        customSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        customSubViews()
    }
    
    func customSubViews(){
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        scrollView.showsVerticalScrollIndicator = false
        self.addSubview(scrollView)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 20, width: 120, height: 64))
        imageView.centerX = width / 2
        imageView.image = UIImage(named: "myInfo_aboutLJ")
        imageView.contentMode = UIViewContentMode.scaleToFill
        scrollView.addSubview(imageView)
        
        let label = UILabel(frame: CGRect(x: 18, y: 112, width: width - 36, height: height))
        let instruction = "蓝鲸财经，财经新闻原创门户+财经记者工作平台。\n蓝鲸财经新闻原创门户：由国内多名资深媒体主编担纲，力推独家快速深度报道。报道行业涉及传媒、TMT、基金、银行、汽车、互联网金融、娱乐资本、教育等资本最为活跃的领域。\n蓝鲸财经记者工作平台：每日推荐选题+针对热点事件推荐专家+多种记者工作工具。\n蓝鲸财经记者工作平台是一个仅针对中国大陆财经记者和编辑开放的财经记者工作平台。平台为财经记者写作所需要的采访通讯录、新闻发布会、新闻线索、热门事件专家推荐等服务。\n蓝鲸财经采访数据库能为记者提供超过40万个采访资源；\n热门采访专家推荐，每天梳理重大财经事件，及时推荐行业内最权威的专家供记者采访咨询；\n蓝鲸财经在线新闻发布会能跨越时空，为企业及时召开在线新闻发布会，并推送给蓝鲸财经平台注册记者；\n蓝鲸财经棱镜系统，能够为用户提供5000万家中国企业的工商、关联关系查询；\n蓝鲸财报查询系统，提供强大的上市公司可视化财报查询，可自动生成动态可视化图表，更可一键保存为图片，进入用户所需要的应用场景；\n信息披露搜索系统，能够为用户提供A股、新三板的公司公告、预披露、监管反馈等披露文件的检索服务。从此公告在手，再也不用为搜集公告信息而发愁；\n此外，蓝鲸财经还为注册财经记者提供免费整理采访录音和蓝鲸财经小秘书24小时人工服务，解决记者在工作中遇到的一切问题。\n目前，已经有近10000名中国大陆一线财经采编人员在蓝鲸财经APP和网站注册。蓝鲸财经实行实名制和严格的审核制。推送新闻线索给记者——记者搜索采访对象——得到企业反馈——专家解读分析——查询企业财报或工商信息等背景资料——采访录音整理……财经记者工作中所需要的一切辅助服务都能在蓝鲸财经找到。蓝鲸财经是一个开放式平台，后续还有更多为记者服务的工具接入。\n在蓝鲸财经，记者、专家能够围绕新闻展开沟通，实现信息的快速生产和回馈，消除传播中的一切信息不对称。走出封闭的环境，蓝鲸财经所生产的内容又能通过各个分发通道传递给亿万普通读者。"
        let paragraphStyle = NSMutableParagraphStyle();
        paragraphStyle.lineSpacing = 8
        paragraphStyle.alignment = .justified
        
        paragraphStyle.firstLineHeadIndent = 35.0
        let attributeString = NSMutableAttributedString(string: instruction)
        attributeString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributeString.length))
        label.attributedText = attributeString
        label.numberOfLines = 0

        let contentRect = attributeString.size(withMaxWidth: label.width, font: label.font)
        label.height = contentRect.height

        label.textColor = UIColor.rgb(0x323232)
        
        scrollView.addSubview(label)
        scrollView.contentSize = CGSize(width: width, height: label.height + imageView.height + 130)
        
    }
}
