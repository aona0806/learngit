//
//  HistoryMeetListModel.m
//  news
//
//  Created by 陈龙 on 15/10/9.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJHistoryMeetListModel.h"

@implementation  LJHistoryMeetListModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"refresh_type":@"refreshType",@"errno":@"dErrno" }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end


@implementation LJHistoryMeetListDataModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"start_time":@"startTime",@"end_time":@"endTime" }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end