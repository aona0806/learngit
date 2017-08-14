//
//  LJzanNewsDetailModel.m
//  news
//
//  Created by wxc on 16/1/11.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "LJzanNewsDetailModel.h"

@implementation  LJzanNewsDetailModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"errno":@"dErrno" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJzanNewsDetailDataModel



+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

