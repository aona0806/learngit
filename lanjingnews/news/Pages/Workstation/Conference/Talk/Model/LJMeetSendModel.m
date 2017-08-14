//
//  LJMeetSendModel.m
//  news
//
//  Created by chunhui on 15/9/29.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMeetSendModel.h"

@implementation  LJMeetSendModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"errno":@"dErrno" }];
}

@end


@implementation  LJMeetSendDataModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"msg_id":@"msgId" }];
}

@end
