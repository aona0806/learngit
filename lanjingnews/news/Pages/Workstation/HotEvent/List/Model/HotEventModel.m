//
//  HotEventModel.m
//  news
//
//  Created by 陈龙 on 16/6/3.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "HotEventModel.h"

@implementation  HotEventDataAtricleRecListModel



+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  HotEventModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"errno":@"dErrno" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  HotEventDataExpertRecListModel



+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  HotEventDataModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"atricle_rec_list":@"atricleRecList",@"zan_num":@"zanNum",@"is_zan":@"isZan",@"expert_rec_list":@"expertRecList" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
