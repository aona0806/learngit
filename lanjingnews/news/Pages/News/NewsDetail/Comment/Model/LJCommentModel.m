//
//  LJCommentModel.m
//  news
//
//  Created by wxc on 16/1/6.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "LJCommentModel.h"

@implementation  LJCommentDataModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"comment_num":@"commentNum" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJCommentModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"errno":@"dErrno" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJCommentDataListModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"reply_cid":@"replyCid",@"ukind_name":@"ukindName",@"is_del":@"isDel",@"time_create":@"timeCreate",@"reply_uid":@"replyUid",@"time_top":@"timeTop",@"is_top":@"isTop",@"ukind_verify":@"ukindVerify",@"is_hidden":@"isHidden" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}



@end

@implementation  LJSubmitCommentModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"errno":@"dErrno" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
