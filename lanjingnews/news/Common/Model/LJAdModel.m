//
//  LJAdModel.m
//  news
//
//  Created by chunhui on 15/11/28.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJAdModel.h"

@implementation  LJAdModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"errno":@"dErrno" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJAdDataModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"rel_id":@"relId",@"go_url":@"goUrl",@"img_url":@"imgUrl",@"id":@"adId"}];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
