//
//  LJNewsTelegraphDetailModel.m
//  news
//
//  Created by wxc on 2017/1/4.
//  Copyright © 2017年 lanjing. All rights reserved.
//

#import "LJNewsTelegraphDetailModel.h"

@implementation  LJNewsTelegraphDetailDataModel

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"comment_num": @"commentNum",
                                                        @"is_zan": @"isZan",
                                                        @"reading_num": @"readingNum",
                                                        @"zan_num": @"zanNum",
                                                        @"share_url": @"shareUrl",
                                                        @"share_img": @"shareImg",
                                                        @"roll_imgs": @"rollImgs",
                                                        }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJNewsTelegraphDetailModel

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

@implementation  LJNewsTelegraphDetailDataImgsModel



+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

@implementation  LJNewsTelegraphDetailDataImgsDetailModel



+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


