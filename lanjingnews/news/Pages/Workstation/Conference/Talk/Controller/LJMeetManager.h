//
//  LJMeetManager.h
//  news
//
//  Created by chunhui on 15/10/23.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJMeetJoinMeetInfoModel.h"

@interface LJMeetManager : NSObject

@property(nonatomic , strong) LJMeetJoinMeetInfoDataUserModel *meetInfo;


+(LJMeetManager *)SharedInstance;

-(void)showBackMeetTip;
-(void)hideBackMeetTip;

@end
