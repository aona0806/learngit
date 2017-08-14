//
//  LJMeetCommon.h
//  news
//
//  Created by chunhui on 15/10/10.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#ifndef LJMeetCommon_h
#define LJMeetCommon_h

/*
 1-创建者，2-管理员，3-嘉宾，4-普通用户
 */
typedef NS_ENUM(NSInteger , LJMeetUserRole) {
    kUserRoleCreator = 1,
    kUserRoleManager = 2,
    kUserRoleGuest   = 3,
    kUserRoleNormalUser = 4,
};


#endif /* LJMeetCommon_h */
