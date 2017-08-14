//
//  LJMeetChangeRoleModel.m
//  news
//
//  Created by chunhui on 15/10/8.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMeetChangeRoleModel.h"

@implementation  LJMeetChangeRoleDataModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"change_uid":@"changeUid" }];
}

@end


@implementation  LJMeetChangeRoleModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"errno":@"dErrno" }];
}

@end

