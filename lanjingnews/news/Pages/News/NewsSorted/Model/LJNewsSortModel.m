//
//  LJNewsSortModel.m
//  news
//
//  Created by 奥那 on 2017/5/10.
//  Copyright © 2017年 lanjing. All rights reserved.
//

#import "LJNewsSortModel.h"

@implementation  LJNewsSortModel

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

