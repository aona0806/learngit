//
//  LJMeetJoinMeetInfoModel.h
//  news
//
//  Created by chunhui on 15/10/20.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "JSONModel.h"

@interface  LJMeetJoinMeetInfoDataUserModel  : JSONModel

@property(nonatomic , copy)   NSString * uid;
@property(nonatomic , copy)   NSString * meetingId;
@property(nonatomic , copy)   NSString * type;
@property(nonatomic , copy)   NSString * quitTime;
@property(nonatomic , copy)   NSString * chattingCt;
@property(nonatomic , copy)   NSString * updatedt;
@property(nonatomic , copy)   NSString * role;
@property(nonatomic , copy)   NSString * toMsgCt;
@property(nonatomic , copy)   NSString * createdt;
@property(nonatomic , copy)   NSString * company;

@end


@interface  LJMeetJoinMeetInfoDataModel  : JSONModel

@property(nonatomic , strong) LJMeetJoinMeetInfoDataUserModel * user ;

@end


@interface  LJMeetJoinMeetInfoModel  : JSONModel

@property(nonatomic , strong) NSNumber * dErrno;
@property(nonatomic , strong) LJMeetJoinMeetInfoDataModel * data ;
@property(nonatomic , strong) NSNumber * time;
@property(nonatomic , copy)   NSString * msg;//错误信息

@end

