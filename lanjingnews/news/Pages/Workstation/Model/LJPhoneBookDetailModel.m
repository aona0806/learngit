//
//  LJPhoneBookDetailModel.m
//  news
//
//  Created by 陈龙 on 15/12/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJPhoneBookDetailModel.h"

@implementation  LJPhoneBookDetailModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"errno":@"dErrno" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJPhoneBookDetailDataModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"time_create":@"timeCreate",@"eq_uid":@"eqUid" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

