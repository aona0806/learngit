//
//  LJDollarsModel.m
//  news
//
//  Created by 奥那 on 15/12/21.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJDollarsModel.h"

@implementation  LJDollarsModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"errno":@"dErrno" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJDollarsDataModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"min_id":@"minId" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJDollarsDataListModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"time_create":@"timeCreate",@"time_yday":@"timeYday",@"time_year":@"timeYear" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
