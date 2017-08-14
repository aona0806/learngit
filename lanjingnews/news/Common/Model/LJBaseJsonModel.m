//
//  LJBaseJsonModel.m
//  news
//
//  Created by 陈龙 on 15/12/8.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJBaseJsonModel.h"

@implementation LJBaseJsonModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"errno":@"dErrno",@"time":@"dtime"}];
}

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
