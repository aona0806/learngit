//
//  LJConfigModel.m
//  news
//
//  Created by chunhui on 16/1/15.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "LJConfigModel.h"

@implementation  LJConfigDataModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"code_sign":@"codeSign",@"has_data":@"hasData",@"refresh_tips_roll":@"refreshTipsRoll",@"switch":@"switchData" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJConfigDataNewsModel



+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJConfigDataTipsModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"relation_follow":@"relationFollow",@"agree_relation":@"agreeRelation" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJConfigModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"errno":@"dErrno" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJConfigDataCurrencyModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"rule_name":@"ruleName",@"rule_id":@"ruleId",@"rule_intro":@"ruleIntro" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

@implementation  LJConfigDataSwitchModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end



