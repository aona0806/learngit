//
//  LJMeetUserInfo.h
//  news
//
//  Created by chunhui on 15/10/15.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJMeetTalkMsgModel.h"
#import "LJMeetJoinMeetInfoModel.h"

@interface LJMeetUserInfo : NSObject

@property(nonatomic , strong) NSString *meetId;
@property(nonatomic , assign) LJMeetRoleType role;
@property(nonatomic , assign) NSString *uid;
@property(nonatomic , strong) LJMeetJoinMeetInfoDataUserModel *meetInfo;
@property(nonatomic , assign) BOOL needRefresh;//是否需要重新拉取会议信息

@end
