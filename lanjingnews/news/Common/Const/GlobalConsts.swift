//
//  GlobalConsts.swift
//  news
//
//  Created by 陈龙 on 15/5/25.
//  Copyright (c) 2015年 lanjing. All rights reserved.
//

import UIKit

class GlobalConsts: NSObject {
    
    static let NetErrorNetMessage = "请查看网络连接"
    static let NetRequestNoResult = "请求失败"
    static let ToastFont = UIFont.systemFont(ofSize: 16)
    
    static let NormalNavbarHeight = CGFloat(64.0)
    
    // MARK: - Consts data
    
    static let ShowEmptyHud : Bool = false
    
    static let KToastDismissDuration : Bool = false
    
    //引导页
    static let KUserDefaultsUpdateGuidancePage : String = "KUserDefaultsUpdateGuidancePage"
    
    //帮助页
    static let KUserDefaultsFirstOpenTheApp : String = "UserDefaultsFirstOpenTheApp"
    static let KUserDefaultsTelegraphListGuideView : String = "UserDefaultsTelegraphListGuideView"
    static let KUserDefaultsNewsListGuideView : String = "UserDefaultsNewsListGuideView"
    
    /// 帮助页透明灰色背景
    static let CHelpView_background = UIColor.rgba(102, green: 102, blue: 102, alpha: 0.5)
    
    static let Industry = ["全行业机动","上市公司","TMT","宏观","证券","银行","保险","基金","私募","理财","黄金","外汇","中概股","港股","汽车","新能源","房产","期货","信托","国际财经","传媒","有色","酒行业","医药","农业","煤炭","电力","家电","VC/PE","环保","交通运输","军工","快消","机械","化工"]

    /// 从oss上获取的图片 缩略图模式的后缀
    static let thumbImageSufix = "@!thumb0"
    

    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    
    static let Is320WidthScreen = screenWidth == 320.0
    static let Is375WidthScreen = screenWidth == 375.0
    static let Is414WidthScreen = screenWidth == 414.0
    
    enum ScreenWidthType: Int {
        case screenWidth320
        case screenWidth375
        case screenWidth414
    }
    
    static var ScreenType: ScreenWidthType {
        get {
            var value: ScreenWidthType! = .screenWidth320
            if GlobalConsts.Is320WidthScreen {
                value = .screenWidth320
            } else if GlobalConsts.Is375WidthScreen {
                value = .screenWidth375
            } else if GlobalConsts.Is414WidthScreen {
                value = .screenWidth414
            }
            return value
        }
    }
    
    // MARK: - NSUserDefaults key
    
 /// 存储用户蓝鲸币key
    static let KeyUserDollar = "userDollar"
    
    static let KeyEaseUserName = "ease_username"
    static let KeyEaseavtar = "ease_avtar"
    
 /// 用户首次登陆相关数据存储
    static let KEverLaunched = "everLaunched"
    static let kFirstLaunched = "firstLaunched"
 /// 采访数据库帮助页
    static let kFirstLaunched_NoteSearch = "firstlauched_notesearch"
 /// 时间轴帮助页
    static let kFirstLaunched_noteShare = "firstlauched_noteshare"
    
    
 /// 点击WorkStation item 通知
    static let Notification_WorkStationRefresh = "WorkStationRefreshNotification"
    
 /// tabbar消息红点(当红点取消时，会调用该通知，出现时会调用messageNew通知)
    static let Notification_MainTabbarMessage = "messageShowNotification"
 /// 新的好友消息
    static let Notification_MessageNew = "messageShowNewNotification"
 //好友列表
    static let Notification_NewFriend = "friendShowNewNotification"
    //刷新用户详情
    static let Notification_UserDetailNeedRefresh = "UserDetailNeedRefreshNotification"
    //新的 系统 赞 评论 消息
    static let Notification_NewSystermNotification = "showNewSystermNotification"
    //新的好友通知
    static let Notification_NewfriendNotification = "showNewFriendNotification"
    
 /// 时间轴删除事件通知
    static let Notification_TimeAxisDeleteEvent = "timeAxisDeleteEventNotification"
 /// 时间轴编辑事件通知
    static let Notification_TimeAxisEditEvent = "timeAxisEditEventNotification"
    
     /// 热点时间 赞
    static let Notification_HotEventZan = "hotEventZanNotification"

    //推荐页面上一次刷新时间
    static let kHotRecommendRefreshTime = "HotRecommendRefreshTime"
    
 /// 个人中心选择行业
    static let Notification_MyCenterIndustryDidChanged = "myCenterIndustryDidChanged"
        
    // 会议相关
    static let KJoinConferenceNotication = "KJoinConferenceNotication"
    static let KCancelConferenceNotication = "KCancelConferenceNotication"
    static let KHotConferenceRefreshNotication = "KHotConferenceRefreshNotication"
    static let KMyConferenceRefreshNotication = "KMyConferenceRefreshNotication"
    static let KHistoryConferenceRefreshNotication = "KHistoryConferenceRefreshNotication"
    
 /// 新闻收藏
    static let kNewsCollectNotification = "kNewsCollectNotification"
    static let kNewsCollectInfo: String! = "kNewsCollectInfo"
    static let kNewsCollectId = "kNewsCollectId"
    
    //登录
    static let kLoginSuccessNotication = "loginSuccessNotication"
    static let kAuthenticationNotication = "authenticationNotication"
    static let kLogoutNotification = "logoutNotification"
    
    //注册
    static let kRegisterShowAppRecommend = "registerShowAppRecommend"
    //用户第一次登录id（提示用户注册认证）
    static let kUserFirstLoginUid = "userFirstLoginUid"

    
    //用户头像、身份 修改
    static let kUserAvatarDidChanged = "userAvatarDidChanged"
 
    //推荐或者圈子中帖子更改
    static let kTweetInfoChangeNotification = "tweetInfoChnageNotification"
    static let kTweetDeleteNotification = "tweetDeleteNotification"
    
    //底部刷新
    static let kNewsRefreshNotification = "newsRefreshNotification"
    static let kHotNewsRefreshNotification = "hotNewsRefreshNotification"
    static let kCommunityRefreshNotification = "communityRefreshNotification"
    static let kWorkStationRefreshNotification = "workStationRefreshNotification"
    
    //顶部刷新
    static let kNewsSortedNotification = "newsSortedNotification"
    
    // 修改用户关系状态
    static let Notification_UserDetailChangeRelationType = "userDetailChangeRelationTypeNotification"
    
    //用户配置信息中新闻信息有更新
    static let kAppNewsConfigUpdateNotification = "appNewsConfigUpdateNotification"
    
    //电报评论成功
    static let kRollCommentSuccess = "rollCommentSuccess"
    
    static let kNewsNotLoginFirstShowKey = "NewsNotLoginFirstShowKey"

    
}
