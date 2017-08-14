//
//  LLHeartbeatDataItem.m
//  LongLink
//
//  Created by chunhui on 15/9/18.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import "LLHeartbeatDataItem.h"

@implementation LLHeartbeatDataItem

-(NSString *)name
{
    return @"hi";
}

-(NSData *)pbData
{
    return [_request data];
}

@end
