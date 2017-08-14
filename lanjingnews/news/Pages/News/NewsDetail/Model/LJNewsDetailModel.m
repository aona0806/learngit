//
//  LJNewsDetailModel.m
//  news
//
//  Created by wxc on 16/1/6.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "LJNewsDetailModel.h"

@implementation  LJNewsDetailModel

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

@implementation  LJNewsDetailDataArticleRecModel

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"news_id": @"newsId",
                                                        }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

@implementation  LJNewsDetailDataModel

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"author_info": @"authorInfo",
                                                        @"comment_num": @"commentNum",
                                                        @"fav_type": @"favType",
                                                        @"is_zan": @"isZan",
                                                        @"fav_time": @"favTime",
                                                        @"share_url": @"shareUrl",
                                                        @"template_type": @"templateType",
                                                        @"fav_status": @"favStatus",
                                                        @"share_content": @"shareContent",
                                                        @"zan_num": @"zanNum",
                                                        @"top_image": @"topImage",
                                                        @"article_rec": @"articleRec",
                                                        @"app_read_num": @"appReadNum",
                                                        @"is_ad": @"isAd",@"share_img":@"shareImg",
                                                        }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
