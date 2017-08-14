//
//  LJMessageListModel.m
//  news
//
//  Created by 陈龙 on 15/12/8.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMessageListModel.h"

@implementation  LJMessageListModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"errno":@"dErrno" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJMessageListDataModel



+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJMessageListDataContentModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"has_new_msg":@"hasNewMsg",@"to_uid":@"toUid",@"from_uid":@"fromUid" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
