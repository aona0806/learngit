//
//  LJTweetModel.m
//  news
//
//  Created by chunhui on 15/11/26.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJTweetModel.h"

@implementation LJTweetDataSocialUserModel


@end

@implementation  LJTweetDataContentPraiseUserModel



+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJTweetDataContentCommentModel



+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJTweetDataModel



+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJTweetDataContentPraiseModel



+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJTweetDataContentOriginTopicModel



+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJTweetDataContentCommentListModel

+(JSONKeyMapper*)keyMapper
{
  return [[JSONKeyMapper alloc] initWithDictionary:@{ @"reply_cid":@"replyCid",@"is_del":@"isDel",@"reply_uid":@"replyUid",@"reply_sname":@"replySname" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJTweetDataContentModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"is_del":@"isDel",@"origin_topic":@"originTopic",@"company_job":@"companyJob",@"ukind_verify":@"ukindVerify",@"zan_num":@"zanNum",@"atuids_org":@"atuidsOrg",@"origin_tid":@"originTid" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJTweetDataContentForwardUserModel



+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJTweetModel


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJTweetDataContentForwardModel



+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
