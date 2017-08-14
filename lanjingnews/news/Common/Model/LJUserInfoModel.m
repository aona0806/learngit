//
//  LJUserInfoModel.m
//  news
//
//  Created by chunhui on 15/12/23.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJUserInfoModel.h"


@implementation  LJUserInfoModel

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"is_complete": @"isComplete",
                                                        @"ukind_name": @"ukindName",
                                                        @"company_jion_time": @"companyJionTime",
                                                        @"friends_num": @"friendsNum",
                                                        @"follow_user_num": @"followUserNum",
                                                        @"company_job": @"companyJob",
                                                        @"tweet_num": @"tweetNum",
                                                        @"user_follow_num": @"userFollowNum",
                                                        @"company_leave_time": @"companyLeaveTime",
                                                        @"ukind_verify": @"ukindVerify",
                                                        @"user_relation": @"userRelation",
                                                        @"follow_industry": @"followIndustry",
                                                        }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJUserInfoRelationModel

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"follow_type": @"followType",
                                                        @"friend_type": @"friendType",
                                                        }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJUserInfoIndustryModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
