//
//  HotEventZanModel.m
//  news
//
//  Created by 陈龙 on 16/6/6.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "HotEventZanModel.h"

@implementation  HotEventZanDataModel

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  HotEventZanModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"errno":@"dErrno" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

