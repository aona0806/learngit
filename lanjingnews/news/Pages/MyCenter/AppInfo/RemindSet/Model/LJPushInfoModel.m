//
//  LJPushInfoModel.m
//  news
//
//  Created by 奥那 on 15/12/28.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJPushInfoModel.h"

@implementation  LJPushInfoDataConfigModel

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"meet_notify": @"meetNotify",
                                                        @"comment_notify": @"commentNotify",
                                                        @"friend_notify": @"friendNotify",
                                                        @"sys_notify": @"sysNotify",
                                                        @"news_notify": @"newsNotify",
                                                        @"pmsg_notify": @"pmsgNotify",
                                                        @"zan_notify": @"zanNotify",
                                                        }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJPushInfoDataModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJPushInfoModel

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"errno": @"dErrno",
                                                        }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJPushInfoDataConfigTelegraphModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
