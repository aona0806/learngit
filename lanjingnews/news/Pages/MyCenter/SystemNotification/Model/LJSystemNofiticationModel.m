//
//  LJSystemNofiticaationModel.m
//  news
//
//  Created by chunhui on 16/1/11.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "LJSystemNofiticationModel.h"

@implementation  LJSystemNofiticationDataMsgListModel

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"is_read": @"isRead",
                                                        @"action_content": @"actionContent",
                                                        @"sys_msg_id": @"sysMsgId",
                                                        @"action_type": @"actionType",
                                                        @"from_user": @"fromUser",
                                                        }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJSystemNofiticationDataMsgListFromUserModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJSystemNofiticationModel


@end


@implementation  LJSystemNofiticationDataModel

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"has_more": @"hasMore",
                                                        @"msg_list": @"msgList",
                                                        }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end



