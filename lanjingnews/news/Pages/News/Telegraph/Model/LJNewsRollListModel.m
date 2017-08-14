//
//  LJNewsRollListModel.m
//  news
//
//  Created by 奥那 on 2017/1/3.
//  Copyright © 2017年 lanjing. All rights reserved.
//

#import "LJNewsRollListModel.h"

@implementation  LJNewsRollListModel

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


@implementation  LJNewsRollListDataListRollImgsOrgModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJNewsRollListDataModel

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"refresh_type": @"refreshType",
                                                        @"cat_type": @"catType",
                                                        @"cat_name": @"catName",
                                                        }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJNewsRollListDataListModel

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"share_img": @"shareImg",
                                                        @"roll_imgs": @"rollImgs",
                                                        @"reading_num": @"readingNum",
                                                        @"template_type": @"templateType",
                                                        @"share_url": @"shareUrl",
                                                        @"comment_num": @"commentNum",
                                                        @"has_img": @"hasImg",
                                                        @"last_time": @"lastTime",
                                                        }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJNewsRollListDataListRollImgsModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
