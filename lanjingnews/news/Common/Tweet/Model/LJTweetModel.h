//
//  LJTweetModel.h
//  news
//
//  Created by chunhui on 15/11/26.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "JSONModel.h"
#import "LJBaseJsonModel.h"

typedef NS_ENUM(NSInteger , LJTweetType) {
    
    LJTweetTypeNormal = 0, //普通帖子
    LJTweetTypeMeeting = 1, //会议分享
    LJTweetTypeTimeAxis = 2,//时间轴
    LJTweetTypeNews = 3,//新闻
    LJTweetTypeActivity = 4, //线下活动分享
    LJTweetTypeTopic = 5, //专题
    LJTweetTypeHotEvent = 6, //热点事件列表
    LJTweetTypeHotEventDetail = 7 //热点事件详情
    
};


@interface LJTweetDataSocialUserModel : JSONModel

@property(nonatomic , copy , nullable)   NSString * sname;
@property(nonatomic , copy , nullable)   NSString * uid;

@end

@protocol LJTweetDataContentModel<NSObject>

@end


@protocol LJTweetDataContentCommentListModel<NSObject>

@end


@interface  LJTweetDataContentCommentListModel  : JSONModel

@property(nonatomic , copy , nullable)   NSString * replyCid;
@property(nonatomic , copy , nullable)   NSString * sname;
@property(nonatomic , copy , nullable)   NSString * uid;
@property(nonatomic , copy , nullable)   NSString * cid;
@property(nonatomic , copy , nullable)   NSString * isDel;
@property(nonatomic , copy , nullable)   NSString * replySname;
@property(nonatomic , copy , nullable)   NSString * content;
@property(nonatomic , copy , nullable)   NSString * atuids;
@property(nonatomic , copy , nullable)   NSString * replyUid;
@property(nonatomic , copy , nullable)   NSString * avatar;
@property(nonatomic , copy , nullable)   NSString * tid;
@property(nonatomic , copy , nullable)   NSString * ctime;

@end


@interface  LJTweetDataContentCommentModel  : JSONModel

@property(nonatomic , copy , nullable)   NSString * num;
@property(nonatomic , strong , nullable) NSArray<LJTweetDataContentCommentListModel> * list;

@end


@protocol LJTweetDataContentForwardUserModel<NSObject>

@end


@interface  LJTweetDataContentForwardUserModel  : LJTweetDataSocialUserModel


@end


@interface  LJTweetDataContentForwardModel  : JSONModel

@property(nonatomic , copy , nullable)   NSString * url;
@property(nonatomic , copy , nullable)   NSString * num;
@property(nonatomic , strong , nullable) NSArray<LJTweetDataContentForwardUserModel> * user;

@end


@interface  LJTweetDataContentOriginTopicModel  : JSONModel

@property(nonatomic , copy , nullable)   NSString * body;
@property(nonatomic , copy , nullable)   NSString * sname;
@property(nonatomic , copy , nullable)   NSString * uid;
@property(nonatomic , copy , nullable)   NSString * uname;
@property(nonatomic , copy , nullable)   NSString * title;
@property(nonatomic , copy , nullable)   NSString * atuids;
@property(nonatomic , copy , nullable)   NSString * tid;
@property(nonatomic , copy , nullable)   NSString * ctime;

@end


@protocol LJTweetDataContentPraiseUserModel<NSObject>

@end


@interface  LJTweetDataContentPraiseUserModel  : LJTweetDataSocialUserModel


@end


@interface  LJTweetDataContentPraiseModel  : JSONModel

@property(nonatomic , assign) BOOL flag;
@property(nonatomic , copy , nullable)   NSString * num;
@property(nonatomic , strong , nullable) NSArray<LJTweetDataContentPraiseUserModel> * user;

@end


@interface  LJTweetDataContentModel  : JSONModel

@property(nonatomic , strong , nullable) LJTweetDataContentCommentModel * comment ;
@property(nonatomic , copy , nullable)   NSString * uid;
@property(nonatomic , copy , nullable)   NSString * isDel;
@property(nonatomic , copy , nullable)   NSString * companyJob;
@property(nonatomic , copy , nullable)   NSString * atuids;
@property(nonatomic , copy , nullable)   NSString * originTid;
@property(nonatomic , strong , nullable) NSArray * img;
@property(nonatomic , copy , nullable)   NSString * title;
@property(nonatomic , copy , nullable)   NSString * ukind;
@property(nonatomic , copy , nullable)   NSString * extends;
@property(nonatomic , strong , nullable) LJTweetDataContentForwardModel * forward ;
@property(nonatomic , strong , nullable) NSNumber * type;
@property(nonatomic , copy , nullable)   NSString * body;
@property(nonatomic , copy , nullable)   NSString * sname;
@property(nonatomic , copy , nullable)   NSString * timestamp;
@property(nonatomic , copy , nullable)   NSString * company;
@property(nonatomic , copy , nullable)   NSString * tid;
@property(nonatomic , copy , nullable)   NSString * zanNum;
@property(nonatomic , copy , nullable)   NSString * atuidsOrg;
@property(nonatomic , copy , nullable)   NSString * ctime;
@property(nonatomic , copy , nullable)   NSString * industry;
@property(nonatomic , strong , nullable) LJTweetDataContentOriginTopicModel * originTopic ;
@property(nonatomic , copy , nullable)   NSString * avatar;
@property(nonatomic , strong , nullable) LJTweetDataContentPraiseModel * praise ;
@property(nonatomic , copy , nullable)   NSString * ukindVerify;

@end


@interface  LJTweetDataModel  : JSONModel

@property(nonatomic , strong , nullable) NSArray<LJTweetDataContentModel> * content;
@property(nonatomic , copy , nullable)   NSString * type;

@end


@interface  LJTweetModel  : LJBaseJsonModel

@property(nonatomic , strong , nullable) LJTweetDataModel * data ;

@end
