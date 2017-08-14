//
//  LJMeetTalkViewController.h
//  news
//
//  Created by chunhui on 15/9/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJMeetTalkMsgModel.h"
#import "LJMeetUserInfo.h"

extern NSString *kLJMeetShowMenuNotification ;

@interface LJMeetTalkViewController : UIViewController

@property(nonatomic , strong , readonly) LJMeetUserInfo *meetUserInfo;
@property(nonatomic , copy) void (^quitBlock)(NSString *meetid);
@property(nonatomic , assign , getter=isActivityMeet) BOOL activityMeet;//是否是活动类型的会议

+(LJMeetTalkViewController *)ControllerWithId:(NSString *)meetId background:(NSString *)bgUrl;

+(LJMeetTalkViewController *)ControllerWithMeetInfo:(LJMeetJoinMeetInfoDataUserModel *)meetInfo;

+(void)tryEnterWithMeetId:(NSString *)meetId nav:(UINavigationController *)nav completion:(void(^)(BOOL ok , NSString *msg, LJMeetTalkViewController *controller))completion;



@end
