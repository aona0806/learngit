//
//  MeetListModel.m
//  news
//
//  Created by 陈龙 on 15/10/8.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMeetListModel.h"

//for implementation
@implementation  LJMeetListDataModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"start_time":@"startTime",@"end_time":@"endTime",@"r_status":@"rStatus",@"shareurl":@"shareurl" }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end


@implementation LJMeetListModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"errno":@"dErrno" }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end

