//
//  LJMyDiscussModel.m
//  news
//
//  Created by 奥那 on 15/12/12.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMyDiscussModel.h"


@implementation  LJMyDiscussDataContentTopicForwardModel

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJMyDiscussModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"errno":@"dErrno" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJMyDiscussDataContentModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"user_info":@"userInfo" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJMyDiscussDataModel



+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJMyDiscussDataContentTopicCommentModel



+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJMyDiscussDataContentTopicForwardUserModel



+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJMyDiscussDataContentUserInfoModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"company_job":@"companyJob" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJMyDiscussDataContentTopicOriginTopicModel



+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJMyDiscussDataContentTopicPraiseUserModel



+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJMyDiscussDataContentTopicCommentListModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"reply_cid":@"replyCid",@"is_del":@"isDel",@"reply_uid":@"replyUid",@"reply_sname":@"replySname" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

