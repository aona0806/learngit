//
//  NewsTopicDetailModel.m
//  news
//
//  Created by 陈龙 on 16/1/8.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "NewsTopicDetailModel.h"


@implementation  NewsTopicDetailDataModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"refresh_type":@"refreshType",@"news_list":@"newsList",@"topic_info":@"topicInfo"}];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end



@implementation  NewsTopicDetailModel


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  NewsTopicDetailDataTopicInfoModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"focus_img":@"focusImg",@"short_title":@"shortTitle", @"fav_type":@"favType", @"fav_status":@"favStatus" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


