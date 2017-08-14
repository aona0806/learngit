//
//  LJMeetOnlineListModel.h
//  news
//
//  Created by chunhui on 15/9/28.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "JSONModel.h"

@protocol LJMeetOnlineListDataDataModel<NSObject>

@end


@interface  LJMeetOnlineListDataDataUserInfoModel  : JSONModel

@property(nonatomic , copy)   NSString * followType;
@property(nonatomic , copy)   NSString * sname;
@property(nonatomic , copy)   NSString * uid;
@property(nonatomic , copy)   NSString * avatar;

@end


@interface  LJMeetOnlineListDataDataModel  : JSONModel

@property(nonatomic , strong) LJMeetOnlineListDataDataUserInfoModel * userInfo ;
@property(nonatomic , copy)   NSString * roleName;
@property(nonatomic , copy)   NSString * role;
@property(nonatomic , copy)   NSString * uid;
@property(nonatomic , copy)   NSString * meetingId;

@end


@interface  LJMeetOnlineListDataModel  : JSONModel

@property(nonatomic , strong) NSNumber * onlineCt;
@property(nonatomic , strong) NSArray<LJMeetOnlineListDataDataModel> * data;

@end


@interface  LJMeetOnlineListModel  : JSONModel

@property(nonatomic , copy)   NSString * msg;
@property(nonatomic , strong) NSNumber * dErrno;
@property(nonatomic , strong) LJMeetOnlineListDataModel * data ;

@end

