//
//  LJVerifyModel.m
//  news
//
//  Created by 奥那 on 2017/6/19.
//  Copyright © 2017年 lanjing. All rights reserved.
//

#import "LJVerifyModel.h"

@implementation  LJVerifyModel

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


@implementation  LJVerifyDataModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
