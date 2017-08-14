//
//  LJNewsListModel.m
//  news
//
//  Created by 陈龙 on 16/1/5.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "LJNewsListModel.h"

@implementation  LJNewsListDataListTipModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJNewsListModel

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"errno": @"dErrno",
                                                        }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJNewsListDataModel

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"refresh_type": @"refreshType",
                                                        @"cat_type": @"catType",
                                                        @"cat_name": @"catName"
                                                        }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJNewsListDataListModel

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"banner_content": @"bannerContent",
                                                        @"author_info": @"authorInfo",
                                                        @"fav_type": @"favType",
                                                        @"fav_time": @"favTime",
                                                        @"template_type": @"templateType",
                                                        @"fav_status": @"favStatus",
                                                        @"app_read_num": @"appReadNum",
                                                        @"last_time": @"lastTime",
                                                        @"time_start":@"timeStart",
                                                        @"roll_list":@"rollList",
                                                        @"is_del":@"isDel"
                                                        }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJNewsListDataListBannerModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

@implementation  LJNewsListDataListRollListModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
