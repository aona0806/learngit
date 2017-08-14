//
//  NewsActivityDetailModel.m
//  news
//
//  Created by 陈龙 on 16/1/9.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "NewsActivityDetailModel.h"

@implementation  NewsActivityDetailDataModel

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"author_info":@"authorInfo",
                                                        @"time_start": @"timeStart",
                                                        @"fav_type": @"favType",
                                                        @"fav_time": @"favTime",
                                                        @"share_url": @"shareUrl",
                                                        @"in_list": @"inList",
                                                        @"template_type": @"templateType",
                                                        @"fav_status": @"favStatus",
                                                        }];
}

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  NewsActivityDetailModel


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

