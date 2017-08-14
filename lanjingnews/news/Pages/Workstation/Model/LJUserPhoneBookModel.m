//
//  LJUserPhoneBookModel.m
//  news
//
//  Created by 陈龙 on 15/12/22.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJUserPhoneBookModel.h"

@implementation  LJUserPhoneBookModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"errno":@"dErrno" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJUserPhoneBookDataListUserRelationModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"follow_type":@"followType",@"friend_type":@"friendType" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJUserPhoneBookDataListModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"ukind_verify":@"ukindVerify",@"company_job":@"companyJob",@"user_relation":@"userRelation" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJUserPhoneBookDataModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"total_cursor":@"totalCursor",@"previous_cursor":@"previousCursor",@"total_number":@"totalNumber",@"next_cursor":@"nextCursor" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
