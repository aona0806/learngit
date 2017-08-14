//
//  LJUserInfoRequestModel.m
//  news
//
//  Created by chunhui on 15/12/23.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJUserInfoRequestModel.h"


@implementation  LJUserInfoRequestModel

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
