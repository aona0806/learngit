//
//  LJMeetJoinMeetInfoModel.h
//  news
//
//  Created by chunhui on 15/10/20.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "JSONModel.h"

@interface  LJMeetEnterMeetDataUserModel  : JSONModel

@property(nonatomic , copy)   NSString * uid;
@property(nonatomic , copy)   NSString * meetingId;
@property(nonatomic , copy)   NSString * type;
@property(nonatomic , copy)   NSString * quitTime;
@property(nonatomic , copy)   NSString * chattingCt;
@property(nonatomic , copy)   NSString * updatedt;
@property(nonatomic , copy)   NSString * role;
@property(nonatomic , copy)   NSString * toMsgCt;
@property(nonatomic , copy)   NSString * createdt;

@end


@interface  LJMeetEnterMeetDataModel  : JSONModel

@property(nonatomic , strong) LJMeetEnterMeetDataUserModel * user ;

@end


@interface  LJMeetJoinMeetInfoModel  : JSONModel

@property(nonatomic , strong) NSNumber * dErrno;
@property(nonatomic , strong) LJMeetEnterMeetDataModel * data ;
@property(nonatomic , strong) NSNumber * time;

@end

