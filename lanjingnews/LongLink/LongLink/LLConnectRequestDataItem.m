//
//  LLConnectRequestDataItem.m
//  LongLink
//
//  Created by chunhui on 15/9/25.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import "LLConnectRequestDataItem.h"

@implementation LLConnectRequestDataItem

-(NSString *)name
{
    return @"connect";
}

-(NSData *)pbData
{
    return [_request data];
}

@end
