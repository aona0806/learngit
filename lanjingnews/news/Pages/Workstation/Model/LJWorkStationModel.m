//
//  LJWorkStationModel.m
//  news
//
//  Created by 陈龙 on 15/12/18.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJWorkStationModel.h"

@implementation  LJWorkStationModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"errno":@"dErrno" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJWorkStationDataModel



+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end