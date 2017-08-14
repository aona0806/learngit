//
//  LJMeetUserInfo.m
//  news
//
//  Created by chunhui on 15/10/15.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMeetUserInfo.h"

@implementation LJMeetUserInfo

@synthesize role = _role;

-(instancetype)init
{
    self = [super init];
    if (self) {
        _needRefresh = YES;
    }
    return self;
}

-(LJMeetRoleType)role
{
    if (_meetInfo) {
        return (LJMeetRoleType)[_meetInfo.role integerValue];
    }
    return _role;
}

-(void)setRole:(LJMeetRoleType)role
{
    _role = role;
    if (_meetInfo) {
        _meetInfo.role = @(role).description;
    }
}

-(NSString *)meetId
{
    return _meetInfo.meetingId;
}

-(NSString *)uid
{
    if (_meetInfo) {
        return _meetInfo.uid;
    }
    return _uid;
}

@end
