//
//  MeetingDetailModel.m
//  news
//
//  Created by 陈龙 on 15/10/9.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMeetingDetailModel.h"

@implementation  LJMeetingDetailDataModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"company_info":@"companyInfo",@"start_time":@"startTime",@"meeting_info":@"meetingInfo",@"end_time":@"endTime",@"r_status":@"rStatus",@"is_end":@"isEnd",@"meeting_notes":@"meetingNotes",@"dstage":@"dstage",@"meeting_summary":@"meetingSummary" }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end


@implementation  LJMeetingDetailModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"errno":@"dErrno" }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end