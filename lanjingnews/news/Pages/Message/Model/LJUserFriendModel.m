//
//  LJUserFriendModel.m
//  news
//
//  Created by 陈龙 on 15/12/8.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJUserFriendModel.h"

@implementation  LJUserFriendDataListUserRelationModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"follow_type":@"followType",@"friend_type":@"friendType" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJUserFriendDataModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"total_cursor":@"totalCursor",@"previous_cursor":@"previousCursor",@"total_number":@"totalNumber",@"next_cursor":@"nextCursor" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJUserFriendModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"errno":@"dErrno" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJUserFriendDataListModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"ukind_verify":@"ukindVerify",@"company_job":@"companyJob",@"user_relation":@"userRelation" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
