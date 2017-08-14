//
//  LJMeetJoinMeetInfoModel.m
//  news
//
//  Created by chunhui on 15/10/20.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMeetJoinMeetInfoModel.h"

@implementation  LJMeetJoinMeetInfoDataUserModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"quit_time":@"quitTime",@"chatting_ct":@"chattingCt",@"to_msg_ct":@"toMsgCt",@"meeting_id":@"meetingId" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJMeetJoinMeetInfoModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"errno":@"dErrno" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJMeetJoinMeetInfoDataModel



+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

