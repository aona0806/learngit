//
//  ShareAnalyseManager.swift
//  news
//
//  Created by chunhui on 15/11/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

@objc public enum ShareType : Int{
    case lanjing = 0
    case sinaWeibo = 1
    case qqFriend = 2
    case wxSession = 4
    case wxFriend = 5
}

//@objc public enum ShareFrom : NSInteger {
//
//    case hotNews = 0
//    case community = 1
//    case tweetDetail = 2
//    case meet = 3
//}

/**
 - New:          普通帖子
 - Meet:         会议
 - Timeaxis:     时间轴
 - NewsActivity: 新闻活动
 - NewsDetail:   新闻详情
 - Topic:        新闻专题
 - Web:          关于我们web
 - HotNewsList:  热点事件列表
 - HotNewsDetail:热点事件详情
 */
@objc public enum LJShareFromType : NSInteger {
    
    case new = 0
    case meet = 1
    case timeaxis = 2
    case newsActivity = 3
    case newsDetail = 4
    case topic = 5
    case forward = 6
    case web = 7
    case hotNewsList = 8
    case hotNewsDetail = 9
    case registerRecommend = 100
    
    func description() -> String {
        
        switch self {
        case .new:
            return "new"
        case .meet:
            return "meeting"
        case .timeaxis:
            return "timeaxis"
        case .newsActivity:
            return "activity"
        case .newsDetail:
            return "news"
        case .topic:
            return "topic"
        case .forward:
            return "forward"
        case .registerRecommend:
            return "registerRecommend"
        case .web:
            return "web"
        case .hotNewsList:
            return "hotevent"
        case .hotNewsDetail:
            return "hotevent_detail"
        }
        
    }
}

/// 分享和统计
class ShareAnalyseManager: NSObject {
    
    static let analyseInstance : ShareAnalyseManager = ShareAnalyseManager()
    
//    let shareDefaultImage = UIImage(named: "share_icon")
    let defaultShareImageUrl = "https://static.lanjinger.com/statics/img/share/20170220_00.png"
    
    class func sharedInstance() -> ShareAnalyseManager {
        return analyseInstance
    }
    
    override init(){
        
        super.init()
        
        let manager = TKShareManager.sharedInstance()
        
        manager?.umengKey = "55657cc767e58ec9ef001ac1"
        manager?.wxAppId  = "wxd9ef1ece2b0d029a"
        manager?.wxAppSecret = "ba6a82e1ff6da25b01bf16219781f381"
        manager?.wxAppUrl = "http://www.lanjinger.com/index"
        
        manager?.qqAppId = "1104333206"
        manager?.qqAppKey = "uzCeiBh0EbMOR05q"
        manager?.qqAppUrl = "http://www.lanjinger.com/index"
        
        manager?.weiboAppKey = "541529881"
        manager?.weiboAppSecret = "82c819c6e9b3ceb6f2e9200f0dd7d080"
        manager?.weiboRedirectUrl = "http://sns.whalecloud.com/sina2/callback"
        
        manager?.defaultShareTitle = "蓝鲸财经"
        
        manager?.defaultShareImage =  UIImage(named: "share_icon")
        
        manager?.weiboShowEdit = true
        
        manager?.registerKeys()
        
    }
    
    class func toTkShareType(_ type: ShareType) -> TKSharePlatform {
        switch type{
        case .lanjing:
            return TKSharePlatform.lanjing
        case .sinaWeibo:
            return TKSharePlatform.sinaWeibo
        case .qqFriend:
            return TKSharePlatform.QQ
        case .wxSession:
            return TKSharePlatform.wxSession
        case .wxFriend:
            return TKSharePlatform.wxTimeline
        }
    }
    
    
    private func shareTweetToLanjing(_ tweet: LJTweetDataContentModel , completion:((_ success: Bool , _ error : NSError?) -> ())?){
        
        let content: String?
        if (tweet.sname?.length() ?? 0) > 0 {
            content = tweet.sname! + ":" + (tweet.title ?? "")
        }else {
            content = tweet.title
        }
        
        let shareData = TkShareData()
        shareData.title = ""
        shareData.shareText = content
        
        
        self.shareToLanjing(shareData, type: .forward , tid :tweet.tid!) { (success, error) -> () in
            //            let success = (error == nil )
            if success {
                ShareAnalyseManager.shareReport(tweet.tid!, contentType: .new, sharetype: .lanjing) { (asuccess, aerror) in
                    completion?(success, aerror)
                }
            } else {
                completion?(success, error)
            }
        }
    }
    
    //MARK: - share report
    
    // 分享统计
    class func shareReport(_ theId : String , contentType : LJShareFromType , sharetype : ShareType, completion:((_ success: Bool , _ error : NSError?) -> ())? ){
        //内容类型：（contentType=1 帖子，contentType=2 时间轴列表，contentType=3 会议, ctype = 4 新闻详情 ctype = 5 新闻活动 contentType=100 注册成功之后分享成功统计）
        
        var contentTypeRow: Int! = 0
        switch contentType {
        case .new:
            contentTypeRow = 1
            break
        case .meet:
            contentTypeRow = 3
            
            break
        case .timeaxis:
            contentTypeRow = 2
            
            break
        case .newsActivity:
            contentTypeRow = 5
            
            break
        case .newsDetail:
            contentTypeRow = 4
            
            break
        case .topic:
            contentTypeRow = 0
            
            break
            
        case .hotNewsList:
            contentTypeRow = 6
        case .hotNewsDetail:
            contentTypeRow = 7

        case .registerRecommend:
            contentTypeRow = 100
        default :
            break
        }
        
        TKRequestHandler.sharedInstance().postShare(withTweetId: theId, contentType: contentTypeRow, sharetype: sharetype.rawValue) { (success, error) -> Void in
            
            completion!(success, error as NSError?)
        }
        
    }
    
    // MARK: - public
    
    /**
     分享到app内部
     
     - parameter shareData:  <#shareData description#>
     - parameter type:       <#type description#>
     - parameter completion: <#completion description#>
     */
    func shareToLanjing(_ shareData: TkShareData, type: LJShareFromType, tid :  String, completion:((_ success: Bool , _ error : NSError?) -> ())?){
        
        let typeString = type.description()
        if shareData.extends == nil {
            
            var path = ""
            switch type {
            case .meet:
                path = PushManager.PushPathConst.meetDetail
            case .newsActivity:
                path = PushManager.PushPathConst.activity
            case .topic:
                path = PushManager.PushPathConst.topic
            case .newsDetail:
                path = PushManager.PushPathConst.news
            case .hotNewsList:
                path = PushManager.PushPathConst.hotEvent
            case .hotNewsDetail:
                path = PushManager.PushPathConst.hotEventDeail
            default:
                break
            }
            
            var extends : String? = ""
            
            if path.length() > 0 && type == .hotNewsList {
                let shareUrl = shareData.url
                extends = "{\"jump\":\"lanjing://\(path)?share_url=\(String(describing: shareUrl))\"}"
            } else if path.length() > 0 {
                extends = "{\"jump\":\"lanjing://\(path)?id=\(tid)\",\"id\":\"\(tid)\"}"
            }
            shareData.extends = extends
        }
        
        TKRequestHandler.sharedInstance().publishTweetType(typeString, title: shareData.title, content: shareData.shareText, tid:tid, img: nil, extends: shareData.extends) { (task, model, error) -> Void in
            
            let success = (error == nil )
            completion?(success, error as NSError?)
        }
        
    }
    
    /**
     分享到第三方平台
     
     - parameter data:              <#data description#>
     - parameter type:              <#type description#>
     - parameter from:              <#from description#>
     - parameter presentController: <#presentController description#>
     - parameter completion:        <#completion description#>
     */
    func shareWithData( _ data: TkShareData , type : ShareType , presentController : UIViewController , completion:((_ success : Bool , _ error : NSError?)->())?){
        
        var shareType : TKSharePlatform = .invalid
        
        switch type{
        case .wxSession:
            shareType = .wxSession
        case ShareType.wxFriend:
            shareType = .wxTimeline
        case ShareType.sinaWeibo:
            shareType = .sinaWeibo
            data.shareType = .web
            //分享到微博，改为图片形式分享
//            if data.shareType == .web {
//                data.shareType = .image
//            }
            
        case ShareType.qqFriend:
            shareType = .QQ
        default:
            shareType = .invalid
        }
        
        TKShareManager.postShare(to: shareType, shareData: data, presentedController: presentController) { (success) -> Void in
            completion?(success , nil)
        }
    }
    
    /**
     tweet 分享
     
     - parameter type:              <#type description#>
     - parameter tweet:             <#tweet description#>
     - parameter presentController: <#presentController description#>
     - parameter completion:        <#completion description#>
     */
    func shareTweet(_ type: ShareType , tweet: LJTweetDataContentModel , presentController : UIViewController , completion:((_ success: Bool , _ error : NSError?) -> ())?){
        
        if type == .lanjing {
            self.shareTweetToLanjing(tweet, completion: { (success, error) -> () in
                completion?(success, error)
            })
            return
        }
        
        let shareData = TkShareData()
        let tweetType: LJTweetType! = LJTweetType(rawValue: tweet.type?.intValue ?? 0)
        //        if tweet.title != nil && tweet.title.length() > 0 {
        //            shareData.title = tweet.title
        //        } else {
        //            if type == .WXFriend {
        //                shareData.title = tweet.body
        //            } else {
        //                shareData.title = "分享来自蓝鲸APP" + tweet.sname + "的帖子"
        //            }
        //        }
        
        if tweetType == .news || tweetType == .activity {
            shareData.title = tweet.title
        } else if tweetType == .timeAxis {
            if type == .wxFriend {
                shareData.title = tweet.body
            } else {
                shareData.title = "分享来自蓝鲸财经APP" + tweet.sname! + "的帖子"
            }
        } else {
            if type == .wxFriend {
                shareData.title = tweet.body
            } else {
                shareData.title = "分享来自蓝鲸财经APP" + tweet.sname! + "的帖子"
            }
        }
        shareData.shareText = tweet.body
        let image = UIImage(named: "share_icon")
        shareData.shareImage = image
        
        shareData.url = tweet.forward?.url
        
        
        
        shareWithData(shareData, type: type, presentController: presentController , completion:  { (success, error) -> () in
            
            if success {
                ShareAnalyseManager.shareReport(tweet.tid!, contentType: .new, sharetype: type) { (asuccess, aerror) in
                    completion?(success, aerror)
                    
                }
            } else {
                let aError = NSError(domain: "分享失败", code: 10001, userInfo: nil)
                completion?(success, aError)
            }
        })
        
    }
    
    
    /**
     新闻活动分享
     
     - parameter type:              <#type description#>
     - parameter info:              <#info description#>
     - parameter presentController: <#presentController description#>
     - parameter completion:        <#completion description#>
     */
    func shareNewsActivity(_ type: ShareType , info: NewsActivityDetailDataModel!, presentController : UIViewController , completion:((_ success: Bool , _ error : NSError?) -> ())?){
        
        if type == .lanjing {
            
            var contentString: NSString = info.desc as NSString? ?? ""
            if contentString.length > 50 {
                contentString = contentString.substring(to: 49) as NSString
            }
            let content = contentString as String
            
            let shareData = TkShareData()
            shareData.title = bracketedTitle(info.title)
            shareData.shareText = content
            let tid = String(stringInterpolationSegment: info.id!)
            self.shareToLanjing(shareData, type: .newsActivity,tid : tid, completion: { (success, error) -> () in
                if success {
                    ShareAnalyseManager.shareReport(info.id!, contentType: .newsActivity, sharetype: type) { (asuccess, aerror) in
                        completion?(success, aerror)
                    }
                } else {
                    completion?(success, error)
                }
            })
            return
        } else {
            let shareData = TkShareData()
            shareData.url = info.shareUrl
            shareData.urlResource = defaultShareImageUrl
            switch type {
            case .qqFriend:
                shareData.title = info.title ?? ""
                shareData.shareText = info.desc ?? ""
                break
            case .sinaWeibo:
                let title = info.title ?? ""
                let shareUrl = info.shareUrl ?? ""
                let aString = String(format: "【%@】%@", title, shareUrl)
                var endIndex: Int = 140 - aString.length() - 3
                endIndex = endIndex > 0 ? endIndex : 0
                let contentString: NSString = info.desc as NSString? ?? "" as NSString
                var contentShortString: String = contentString as String 
                if endIndex < contentString.length {
                    contentShortString = contentString.substring(to: endIndex) + "..."
                }
                
                let shareText = String(format: "【%@】%@", title, contentShortString)
                shareData.title = shareText
                
            case .wxFriend:
                shareData.title = info.title ?? ""
                break
            case .wxSession:
                shareData.title = info.title ?? ""
                shareData.shareText = info.desc ?? ""
                break
            default:
                break
            }
            
            // mark: 图片加载有问题
            SDWebImageDownloader.shared().downloadImage(with: Urlhelper.tryEncode(info.thumb), options: .highPriority, progress: { (receivedSize, expectedSize) -> Void in
                
                }, completed: { (image, data, error, finish) -> Void in
                    let defaultImage = UIImage(named: "share_icon")
                    if image != nil {
                        shareData.shareImage = image!.translateToSquare()
                    } else {
                        shareData.shareImage = defaultImage
                    }
                    
                    self.shareWithData(shareData, type: type, presentController: presentController , completion:  { (success, error) -> () in
                        
                        if success {
                            ShareAnalyseManager.shareReport(info.id!, contentType: .newsActivity, sharetype: type) { (asuccess, aerror) in
                                completion?(success, aerror)
                            }
                        } else {
                            let aError = NSError(domain: "分享失败", code: 10001, userInfo: nil)
                            completion?(success, aError)
                        }
                    })
            })
            
        }
    }
    
    /**
     新闻详情分享
     
     - parameter type:              <#type description#>
     - parameter info:              <#info description#>
     - parameter presentController: <#presentController description#>
     - parameter completion:        <#completion description#>
     */
    func shareNewsDetail(_ type: ShareType , info: LJNewsDetailDataModel!, presentController : UIViewController , completion:((_ success: Bool , _ error : NSError?) -> ())?){
        
        if type == .lanjing {
            
            let contentString: NSString? = info.shareContent as NSString?
            // PM 确认后端保证，前端分享全部
            //            if contentString.length > 50 {
            //                contentString = contentString.substringToIndex(49)
            //            }
            let content = contentString as String?
            
            let shareData = TkShareData()
            shareData.title = bracketedTitle(info.title)
            
            shareData.shareText = content
            let tid: String = String(stringInterpolationSegment: info.nid!)
            self.shareToLanjing(shareData, type: .newsDetail,tid: tid, completion: { (success, error) -> () in
                let aSuccess = success
                if aSuccess {
                    ShareAnalyseManager.shareReport((info.nid)!, contentType: .newsDetail, sharetype: type) { (success, error) in
                        completion?(aSuccess, error)
                    }
                } else {
                    completion?(aSuccess, error)
                }
            })
            
            return
        } else {
            let shareData = TkShareData()
            shareData.url = info.shareUrl
            shareData.urlResource = info.shareImg ?? defaultShareImageUrl
            switch type {
            case .qqFriend:
                shareData.title = info.title ?? ""
                shareData.shareText = info.shareContent ?? ""
                break
            case .sinaWeibo:
                let title = info.title ?? ""
                let shareUrl = info.shareUrl ?? ""
                let aString = String(format: "【%@】%@", title, shareUrl)
                var endIndex: Int = 140 - aString.length() - 3
                endIndex = endIndex > 0 ? endIndex : 0
                
                let contentString = info.shareContent ?? ""
                var contentShortString :String = contentString as String
                if endIndex < contentString.length() {
                    let index = contentString.characters.index(contentString.startIndex, offsetBy: endIndex)
                    contentShortString = contentString.substring(to: index) + "..."
                }
                
                
                let shareText = String(format: "【%@】%@", title, contentShortString)
                shareData.title = shareText
                shareData.shareType = .web
                
            case .wxFriend:
                shareData.title = info.title ?? ""
                break
            case .wxSession:
                shareData.title = info.title ?? ""
                shareData.shareText = info.shareContent ?? ""
                break
            default:
                break
            }
            
//            //缩小分享的图片
//            let thumb = info.thumb! + "@200w"
//            SDWebImageDownloader.shared().downloadImage(with: Urlhelper.tryEncode(thumb), options: .ignoreCachedResponse, progress: { (receivedSize, expectedSize) -> Void in
//                
//                }, completed: { (image, data, error, finish) -> Void in
//                    let defaultImage = UIImage(named: "share_icon")
//                    if image != nil {
//                        shareData.shareImage = image!.translateToSquare()
//                    } else {
//                        shareData.shareImage = defaultImage
//                    }
//                    
//                    self.shareWithData(shareData, type: type, presentController: presentController , completion:  { (success, error) -> () in
//                        
//                        let aSuccess = success
//                        if aSuccess {
//                            ShareAnalyseManager.shareReport(info.nid!, contentType: .newsDetail, sharetype: type) { (success, error) in
//                                completion?(aSuccess, error)
//                            }
//                        } else {
//                            let aError = NSError(domain: "分享失败", code: 10001, userInfo: nil)
//                            completion?(success, aError)
//                        }
//                    })
//            })
            self.shareWithData(shareData, type: type, presentController: presentController , completion:  { (success, error) -> () in
                
                let aSuccess = success
                if aSuccess {
                    ShareAnalyseManager.shareReport(info.nid!, contentType: .newsDetail, sharetype: type) { (success, error) in
                        completion?(aSuccess, error)
                    }
                } else {
                    let aError = NSError(domain: "分享失败", code: 10001, userInfo: nil)
                    completion?(success, aError)
                }
            })

        }
    }
    
    private func bracketedTitle(_ title:String?) -> String{
        
        if title == nil {
            return ""
        }
        if !(title!.hasPrefix("【") && title!.hasSuffix("】")) {
            print("【\(title!)】")
            return "【\(title!)】"
        }
        
        return title!
    }
    
    /**
     时间轴分享
     
     - parameter type:              <#type description#>
     - parameter info:              <#info description#>
     - parameter presentController: <#presentController description#>
     - parameter completion:        <#completion description#>
     */
    func shareTimeaxis(_ type: ShareType , info: LJTimeAxisDataModel, selectedDate: Date, presentController : UIViewController , completion:((_ success: Bool , _ error : NSError?) -> ())?){
        
        let list = info.list
        let firstTimeShow = (list?.first as AnyObject).timeShow ?? "0"
        let date = Date.init(timeIntervalSince1970: Double(firstTimeShow!)!)
        let dateString: String! = TKCommonTools.dateString(withFormat: TKDateFormatChineseMD, date: selectedDate)
        let timeString: String = TKCommonTools.dateString(withFormat: TKDateFormatHHMM, date: date)
        
        if info.list.count > 0 {
            let theId = (info.list.first as AnyObject).id ?? "0"
            
            
            if type == .lanjing {
                
                if (list?.count)! > 0 {
                    var shareText = dateString + " 重大会议事件\n"
                    let maxCount = (list?.count)! > 2 ? 2 : list!.count
                    for index in 0..<maxCount {
                        let contentString: String! = (list![index] as AnyObject).title
                        var itemString: String! = ""
                        if index == maxCount - 1 {
                            itemString = String(format: "%@ %@", timeString, contentString)
                        } else {
                            itemString = String(format: "%@ %@\n", timeString, contentString)
                        }
                        shareText = shareText + itemString!
                    }
                    
                    let string = timeString.replacingOccurrences(of: ":", with: "")
                    let dic = NSMutableDictionary(capacity: 2)
                    let timestamp = String.init(format: "%.0f", selectedDate.timeIntervalSince1970)
                    dic.setValue(timestamp, forKey: "time")
                    dic.setValue(string, forKey: "date")
                    let data = try! JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
                    var extentsString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    extentsString = extentsString?.replacingOccurrences(of: "\n", with: "") as NSString?
                    extentsString = extentsString?.replacingOccurrences(of: " ", with: "") as NSString?
                    extentsString = extentsString?.replacingOccurrences(of: "\\", with: "") as NSString?
                    
                    let shareData = TkShareData()
                    shareData.title = ""
                    shareData.shareText = shareText
                    shareData.extends = extentsString! as String
                    
                    self.shareToLanjing(shareData, type: .timeaxis, tid: "",completion: { (success, error) -> () in
                        
                        if success {
                            ShareAnalyseManager.shareReport(theId!, contentType: .timeaxis, sharetype: type) { (asuccess, aerror) in
                                completion?(success, aerror)
                            }
                        } else {
                            completion?(success, error)
                        }
                    })
                }
                
                return
            } else {
                let shareData = TkShareData()
                shareData.url = info.shareUrl;
                shareData.title = dateString + " 蓝鲸财经新闻时间轴"
                shareData.urlResource = defaultShareImageUrl
                shareData.shareText = timeString + ((list?.first as AnyObject).title ?? "")
                if type == .sinaWeibo {
                    shareData.title = String(format: "关注%@重大会议事件，查看蓝鲸财经新闻时间轴", dateString)
                }
                
                self.shareWithData(shareData, type: type, presentController: presentController , completion:  { (success, error) -> () in
                    
                    if success {
                        ShareAnalyseManager.shareReport(theId!, contentType: .timeaxis, sharetype: type) { (asuccess, aerror) in
                            completion?(success, aerror)
                        }
                    } else {
                        let aError = NSError(domain: "分享失败", code: 10001, userInfo: nil)
                        completion?(success, aError)
                    }
                    
                })
            }
        }
    }
    
    /**
    web
     
     - parameter type:              <#type description#>
     - parameter presentController: <#presentController description#>
     - parameter completion:        <#completion description#>
     */
    func shareWeb(_ type: ShareType , presentController : UIViewController , shareUrl: String, shareTitle: String, shareContent: String, completion:((_ success: Bool , _ error : NSError?) -> ())?){
        
        var finalShareUrl = shareUrl
        
        let range = shareUrl.range(of: "?")
        if range != nil  {
            finalShareUrl = shareUrl.substring(to: range!.lowerBound)
        }
        //分享到内部时的id
        let id = ""
        
        //关于我们 web分享 只向外分享
        if type == .lanjing {
            let shareData = TkShareData()
            shareData.title = shareTitle
            
            shareData.shareText = shareContent
            let tid = id
            self.shareToLanjing(shareData, type: .web, tid: tid, completion: { (success, error) -> () in
                let aSuccess = success
                if aSuccess {
                    ShareAnalyseManager.shareReport(tid, contentType: .web, sharetype: type) { (success, error) in
                        completion?(aSuccess, error)
                    }
                } else {
                    completion?(aSuccess, error)
                }
            })
            
            return
        } else {
            let shareData = TkShareData()
            shareData.url = finalShareUrl
            shareData.urlResource = defaultShareImageUrl
            switch type {
            case .qqFriend:
                shareData.title = shareTitle
                shareData.shareText = shareContent
                break
            case .sinaWeibo:
                let title = shareTitle
                let shareUrl = shareUrl
                let aString = String(format: "【%@】%@", title, shareUrl)
                var endIndex: Int = 140 - aString.length() - 3
                endIndex = endIndex > 0 ? endIndex : 0
                
                let contentString = shareContent 
                var contentShortString :String = contentString as String
                if endIndex < contentString.length() {
                    let index = contentString.characters.index(contentString.startIndex, offsetBy: endIndex)
                    contentShortString = contentString.substring(to: index) + "..."
                }
                
                
                let shareText = String(format: "【%@】%@", title, contentShortString)
                shareData.title = shareText
                
            case .wxFriend:
                shareData.title = shareTitle
                break
            case .wxSession:
                shareData.title = shareTitle
                shareData.shareText = shareContent
                break
            default:
                break
            }
            
            self.shareWithData(shareData, type: type, presentController: presentController , completion:  { (success, error) -> () in
                
                let aSuccess = success
                if aSuccess {
                    ShareAnalyseManager.shareReport(id, contentType: .web, sharetype: type) { (success, error) in
                        completion?(aSuccess, error)
                    }
                } else {
                    let aError = NSError(domain: "分享失败", code: 10001, userInfo: nil)
                    completion?(success, aError)
                }
            })
            
        }
    }
    
    /**
     热点事件列表分享
     
     - parameter type:              <#type description#>
     - parameter info:              <#info description#>
     - parameter presentController: <#presentController description#>
     - parameter completion:        <#completion description#>
     */
    func shareHotNewsList(_ type: ShareType , info: [HotEventDataModel], shareUrl: String, presentController : UIViewController , completion:((_ success: Bool , _ error : NSError?) -> ())?){
        
        let title = "热点事件专家推荐"
        
        if type == .lanjing {
            
            // PM 确认后端保证，前端分享全部
            //            if contentString.length > 50 {
            //                contentString = contentString.substringToIndex(49)
            //            }
            
            let shareData = TkShareData()
            
            shareData.title = title
            
            var shareContent = info[0].title
            var secondTitle = ""
            if info.count > 1 {
                secondTitle = info[1].title
                shareContent = shareContent! + "\n\(secondTitle)"
            }
            shareData.shareText = shareContent
            shareData.url = shareUrl
            
            let tid = "0"
            self.shareToLanjing(shareData, type: .hotNewsList,tid: "", completion: { (success, error) -> () in
                let aSuccess = success
                if aSuccess {
                    ShareAnalyseManager.shareReport(tid, contentType: .hotNewsList, sharetype: type) { (success, error) in
                        completion?(aSuccess, error)
                    }
                } else {
                    completion?(aSuccess, error)
                }
            })
            
            return
        } else {
            let shareData = TkShareData()
            shareData.url = shareUrl
            shareData.urlResource = defaultShareImageUrl
            switch type {
            case .qqFriend:
                shareData.title = title
                shareData.shareText = info[0].title ?? ""
                break
            case .sinaWeibo:
                let title = title
                let shareUrl = shareUrl
                let aString = String(format: "【%@】%@", title, shareUrl)
                var endIndex: Int = 140 - aString.length() - 3
                endIndex = endIndex > 0 ? endIndex : 0
                
                let contentString = info[0].title ?? ""
                var contentShortString :String = contentString as String 
                if endIndex < contentString.length() {
                    let index = contentString.characters.index(contentString.startIndex, offsetBy: endIndex)
                    contentShortString = contentString.substring(to: index) + "..."
                }
                
                
                let shareText = String(format: "【%@】%@", title, contentShortString)
                shareData.title = shareText
                
            case .wxFriend:
                shareData.title = info[0].title ?? ""
                break
            case .wxSession:
                shareData.title = title
                shareData.shareText = info[0].title ?? ""
                break
            default:
                break
            }
            
            self.shareWithData(shareData, type: type, presentController: presentController , completion:  { (success, error) -> () in
                
                let aSuccess = success
                if aSuccess {
                    ShareAnalyseManager.shareReport("", contentType: .hotNewsList, sharetype: type) { (success, error) in
                        completion?(aSuccess, error)
                    }
                } else {
                    let aError = NSError(domain: "分享失败", code: 10001, userInfo: nil)
                    completion?(success, aError)
                }
            })
            
        }
    }
    
    /**
     热点事件详情分享
     
     - parameter type:              <#type description#>
     - parameter info:              <#info description#>
     - parameter presentController: <#presentController description#>
     - parameter completion:        <#completion description#>
     */
    func shareHotNewsDetail(_ type: ShareType , info: HotEventDetailDataModel , presentController : UIViewController , completion:((_ success: Bool , _ error : NSError?) -> ())?){
        
        let id = (info.id != nil) ? info.id! : ""
        
        if type == .lanjing {
            
            // PM 确认后端保证，前端分享全部
            //            if contentString.length > 50 {
            //                contentString = contentString.substringToIndex(49)
            //            }
            
            let shareData = TkShareData()
            shareData.title = info.title ?? ""
            
            shareData.shareText = info.brief ?? ""
            let tid = (info.id != nil) ? info.id! : "0"
            
            self.shareToLanjing(shareData, type: .hotNewsDetail, tid: id, completion: { (success, error) -> () in
                let aSuccess = success
                if aSuccess {
                    ShareAnalyseManager.shareReport(tid, contentType: .hotNewsDetail, sharetype: type) { (success, error) in
                        completion?(aSuccess, error)
                    }
                } else {
                    completion?(aSuccess, error)
                }
            })
            
            return
        } else {
            let title = "热点事件专家推荐"
            let shareData = TkShareData()
            shareData.url = info.shareUrl ?? ""
            shareData.urlResource = defaultShareImageUrl
            switch type {
            case .qqFriend:
                shareData.title = title
                shareData.shareText = info.brief ?? ""
                break
            case .sinaWeibo:
                let title = title
                let shareUrl = info.shareUrl ?? ""
                let aString = String(format: "【%@】%@", title, shareUrl)
                var endIndex: Int = 140 - aString.length() - 3
                endIndex = endIndex > 0 ? endIndex : 0
                
                let contentString = info.brief ?? ""
                var contentShortString :String = contentString as String 
                if endIndex < contentString.length() {
                    let index = contentString.characters.index(contentString.startIndex, offsetBy: endIndex)
                    contentShortString = contentString.substring(to: index) + "..."
                }
                
                
                let shareText = String(format: "【%@】%@", title, contentShortString)
                shareData.title = shareText
                
            case .wxFriend:
                shareData.title = info.brief ?? ""
                break
            case .wxSession:
                shareData.title = title
                shareData.shareText = info.brief ?? ""
                break
            default:
                break
            }
            
            self.shareWithData(shareData, type: type, presentController: presentController , completion:  { (success, error) -> () in
                
                let aSuccess = success
                if aSuccess {
                    ShareAnalyseManager.shareReport(id, contentType: .hotNewsDetail, sharetype: type) { (success, error) in
                        completion?(aSuccess, error)
                    }
                } else {
                    let aError = NSError(domain: "分享失败", code: 10001, userInfo: nil)
                    completion?(success, aError)
                }
            })
            
        }
    }
    
    /**
     电报列表分享
     
     - parameter type:              <#type description#>
     - parameter info:              <#info description#>
     - parameter presentController: <#presentController description#>
     - parameter completion:        <#completion description#>
     */
    func shareTelegraphList(_ type: ShareType , info: LJNewsRollListDataListModel, presentController : UIViewController , completion:((_ success: Bool , _ error : NSError?) -> ())?){
        
        let newsId = info.nid ?? ""
        
        var contentString = ""
        if info.title != nil && (info.title?.length())! > 0 {
            contentString += "【"+info.title!+"】"
        }else{
            contentString += ""
        }
        contentString += info.content ?? ""
        
        let vc = presentController as! NewsTelegraphListController
        let title = vc.title ?? "蓝鲸电报"
        let shareData = TkShareData()
        shareData.url = info.shareUrl ?? ""
        shareData.urlResource = info.shareImg ?? defaultShareImageUrl
        
        switch type {
        case .qqFriend:
            shareData.title = title
            shareData.shareText = contentString
            break
        case .sinaWeibo:
            let shareUrl = info.shareUrl ?? ""
            let aString = String(format: "%@%@", title, shareUrl)
            var endIndex: Int = 140 - aString.length() - 3
            endIndex = endIndex > 0 ? endIndex : 0
            
            var contentShortString :String = contentString
            if endIndex < contentString.length() {
                let index = contentString.characters.index(contentString.startIndex, offsetBy: endIndex)
                contentShortString = contentString.substring(to: index) + "..."
            }
            
            let shareText = String(format: "%@%@", title, contentShortString)
            shareData.title = shareText
            
        case .wxFriend:
            shareData.title = contentString
            break
        case .wxSession:
            shareData.title = title
            shareData.shareText = contentString
            break
        default:
            break
        }
        
        self.shareWithData(shareData, type: type, presentController: presentController , completion:  { (success, error) -> () in
            if success {
                ShareAnalyseManager.shareReport(newsId, contentType: .hotNewsDetail, sharetype: type) { (success, error) in
                    completion?(success, error)
                }
            } else {
                let aError = NSError(domain: "分享失败", code: 10001, userInfo: nil)
                completion?(success, aError)
            }
        })

    }
    
    /**
     电报详情详情分享
     
     - parameter type:
     - parameter info:
     - parameter presentController:
     - parameter completion:
     */
    func shareTelegraphNewsDetail(_ type: ShareType , info: LJNewsTelegraphDetailDataModel , presentController : UIViewController , completion:((_ success: Bool , _ error : NSError?) -> ())?){
        
        let newsId = info.nid ?? ""
        
        var contentString = ""
        if info.title != nil && (info.title?.length())! > 0 {
            contentString += "【"+info.title!+"】"
        }else{
            contentString += " "
        }
        contentString += info.content ?? ""
//        if type == .lanjing {
//            // PM 确认后端保证，前端分享全部
//            if contentString.length() > 50 {
//                let index = contentString.characters.index(contentString.startIndex, offsetBy: 50)
//                contentString = contentString.substring(to: index)
//            }
//            
//            let shareData = TkShareData()
//            shareData.title = info.title ?? ""
//            shareData.shareText = contentString
//            
//            self.shareToLanjing(shareData, type: .newsDetail, tid: newsId, completion: { (success, error) -> () in
//                if success {
//                    ShareAnalyseManager.shareReport(newsId, contentType: .hotNewsDetail, sharetype: type) { (success, error) in
//                        completion?(success, error)
//                    }
//                } else {
//                    completion?(success, error)
//                }
//            })
//            
//            return
//        } else {
        
            let vc = presentController as! NewsTelegraphDetailViewController
            let title = vc.title ?? "蓝鲸电报"
            let shareData = TkShareData()
            shareData.url = info.shareUrl ?? ""
            shareData.urlResource = info.shareImg ?? defaultShareImageUrl
            
            switch type {
            case .qqFriend:
                shareData.title = title
                shareData.shareText = contentString
                break
            case .sinaWeibo:
                let shareUrl = info.shareUrl ?? ""
                let aString = String(format: "%@%@", title, shareUrl)
                var endIndex: Int = 140 - aString.length() - 3
                endIndex = endIndex > 0 ? endIndex : 0
                
                var contentShortString :String = contentString
                if endIndex < contentString.length() {
                    let index = contentString.characters.index(contentString.startIndex, offsetBy: endIndex)
                    contentShortString = contentString.substring(to: index) + "..."
                }
                
                let shareText = String(format: "%@%@", title, contentShortString)
                shareData.title = shareText
                
            case .wxFriend:
                shareData.title = contentString
                break
            case .wxSession:
                shareData.title = title
                shareData.shareText = contentString
                break
            default:
                break
            }
            
            self.shareWithData(shareData, type: type, presentController: presentController , completion:  { (success, error) -> () in
                if success {
                    ShareAnalyseManager.shareReport(newsId, contentType: .hotNewsDetail, sharetype: type) { (success, error) in
                        completion?(success, error)
                    }
                } else {
                    let aError = NSError(domain: "分享失败", code: 10001, userInfo: nil)
                    completion?(success, aError)
                }
            })
        
//        }
    }
}
