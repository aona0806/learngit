//
//  HotEventDetailModel.m
//  news
//
//  Created by 陈龙 on 16/6/7.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "HotEventDetailModel.h"

@implementation  HotEventDetailDataModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"atricle_rec_list":@"atricleRecList",@"rec_article":@"recArticle",@"is_zan":@"isZan",@"rec_expert":@"recExpert",@"zan_num":@"zanNum",@"expert_rec_list":@"expertRecList",@"share_url":@"shareUrl" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  HotEventDetailModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"errno":@"dErrno" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
