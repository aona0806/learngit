//
//  LJMeetOnlineListModel.m
//  news
//
//  Created by chunhui on 15/9/28.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMeetOnlineListModel.h"

@implementation  LJMeetOnlineListDataModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"online_ct":@"onlineCt" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJMeetOnlineListModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"errno":@"dErrno" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJMeetOnlineListDataDataModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"user_info":@"userInfo",@"role_name":@"roleName",@"meeting_id":@"meetingId" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJMeetOnlineListDataDataUserInfoModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"follow_type":@"followType" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

