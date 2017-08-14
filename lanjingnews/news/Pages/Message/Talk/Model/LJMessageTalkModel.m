//
//  LJMessageTalkModel.m
//  news
//
//  Created by 陈龙 on 15/12/10.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMessageTalkModel.h"

@implementation  LJMessageTalkDataModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"last_read_mid":@"lastReadMid" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJMessageTalkModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"errno":@"dErrno" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJMessageTalkDataContentModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"to_uid":@"toUid",@"from_uid":@"fromUid" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end