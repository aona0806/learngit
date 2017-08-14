//
//  LJRedDotModel.m
//  news
//
//  Created by chunhui on 15/12/29.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJRedDotModel.h"

@implementation  LJRedDotDataModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"friend": @"friendMsg",
                                                        }];
}


@end


@implementation  LJRedDotModel

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


@implementation  LJRedDotDataPmsgModel

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"from_uid": @"fromUid",
                                                        }];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


