//
//  LJMeetTalkViewModel.h
//  news
//
//  Created by chunhui on 15/10/20.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJMeetUserInfo.h"

@interface LJMeetTalkViewModel : NSObject

@property(nonatomic , strong) LJMeetUserInfo *meetUserInfo;

+(void)enterMeetWithMid:(NSString *)meetid completion:(void (^)(bool ok ,NSString *errMsg , LJMeetJoinMeetInfoModel *userinfo))completion;
+(void)quitMeetWithMeetId:(NSString *)meetid completion:(void (^)(bool ok))completion;

-(void)enterMeet:(void (^)(bool ok ,NSString *errMsg , LJMeetJoinMeetInfoModel *userinfo))completion;

-(void)quitMeet:(void (^)(bool ok))completion;

@end
