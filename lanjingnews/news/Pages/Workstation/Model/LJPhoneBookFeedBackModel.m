//
//  LJPhoneBookFeedBackModel.m
//  news
//
//  Created by 陈龙 on 15/12/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJPhoneBookFeedBackModel.h"

@implementation  LJPhoneBookFeedBackDataModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"next_page":@"nextPage",@"prev_page":@"prevPage",@"total_number":@"totalNumber",@"total_page":@"totalPage" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJPhoneBookFeedBackDataListModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"time_create":@"timeCreate",@"phone_id":@"phoneId",@"time_ago":@"timeAgo",@"contact_status":@"contactStatus" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJPhoneBookFeedBackModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"errno":@"dErrno" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJPhoneBookFeedBackDataListUserinfoModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"update_time":@"updateTime",@"oauth_name":@"oauthName",@"oauth_key":@"oauthKey",@"ukind_name":@"ukindName",@"follower_num":@"followerNum",@"follow_industry_num":@"followIndustryNum",@"friends_num":@"friendsNum",@"company_jion_time":@"companyJionTime",@"lock_num":@"lockNum",@"follow_user_num":@"followUserNum",@"company_job":@"companyJob",@"create_time":@"createTime",@"followee_num":@"followeeNum",@"tweet_num":@"tweetNum",@"ukind_verify":@"ukindVerify",@"is_complete":@"isComplete",@"company_leave_time":@"companyLeaveTime",@"lock_time":@"lockTime",@"user_relation":@"userRelation",@"follow_industry":@"followIndustry" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJPhoneBookFeedBackDataListUserinfoUserRelationModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"follow_type":@"followType",@"friend_type":@"friendType" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

