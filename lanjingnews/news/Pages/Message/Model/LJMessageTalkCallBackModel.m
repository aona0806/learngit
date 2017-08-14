//
//  LJMessageTalkCallBackModel.m
//  news
//
//  Created by 陈龙 on 15/12/10.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMessageTalkCallBackModel.h"

@implementation  LJMessageTalkCallBackDataModel

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

@implementation  LJMessageTalkCallBackModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"errno":@"dErrno" }];
}

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
