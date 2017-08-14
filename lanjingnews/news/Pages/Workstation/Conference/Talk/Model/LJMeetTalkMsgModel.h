//
//  LJMeetTalkMsgModel.h
//  news
//
//  Created by chunhui on 15/10/8.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "JSONModel.h"

//1-创建者，2-管理员，3-嘉宾，4-普通用户
typedef NS_ENUM(NSInteger , LJMeetRoleType) {
    kMeetRoleInvalid = 0,
    kMeetRoleCreator = 1,
    kMeetRoleManager = 2,
    kMeetRoleGuest   = 3,
    kMeetRoleUser    = 4,
};

@protocol LJMeetTalkMsgDataModel<NSObject>

@end


@interface  LJMeetTalkMsgDataUserInfoModel  : JSONModel

@property(nonatomic , copy)   NSString * company;
@property(nonatomic , copy)   NSString * sname;
@property(nonatomic , copy)   NSString * uid;
@property(nonatomic , copy)   NSString * companyJob;
@property(nonatomic , copy)   NSString * avatar;


@end


@interface  LJMeetTalkMsgDataModel  : JSONModel

@property(nonatomic , copy)   NSString * mtype;
@property(nonatomic , copy)   NSString * audioFormat;
@property(nonatomic , copy)   NSString * uid;
@property(nonatomic , copy)   NSString * questionOper;
@property(nonatomic , copy)   NSString * meetingId;
@property(nonatomic , copy)   NSString * isDel;
@property(nonatomic , copy)   NSString * audioDuration;
@property(nonatomic , copy)   NSString * mid;
@property(nonatomic , copy)   NSString * content;
@property(nonatomic , strong) LJMeetTalkMsgDataUserInfoModel * userInfo ;
@property(nonatomic , copy)   NSString * audioText;
@property(nonatomic , copy)   NSString * updatedt;
@property(nonatomic , copy)   NSString * role;
@property(nonatomic , copy)   NSString * fromChatting;
@property(nonatomic , copy)   NSString * roleName;
@property(nonatomic , copy)   NSString * createdt;
@property(nonatomic , copy)   NSString * uuid;

@property(nonatomic , copy)   NSString * width;
@property(nonatomic , copy)   NSString * height;
@property(nonatomic , strong) UIImage *image;

@end


@interface  LJMeetTalkMsgModel  : JSONModel

@property(nonatomic , copy)   NSString * msg;
@property(nonatomic , strong) NSNumber * dErrno;
@property(nonatomic , copy)   NSString * msgId;
@property(nonatomic , strong) NSArray<LJMeetTalkMsgDataModel> * data;
@property(nonatomic , strong) NSNumber * ct;

@end


@interface LJMeetTalkMsgDataModel (Role)

+(NSString *)RoleNameWithType:(LJMeetRoleType)type;

@end
