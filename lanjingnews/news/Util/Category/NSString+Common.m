//
//  NSString+Common.m
//  CaiLianShe
//
//  Created by 陈龙 on 16/3/8.
//  Copyright © 2016年 chenlong. All rights reserved.
//

#import "NSString+Common.h"

@implementation NSString (Common)

- (NSString *)exchangeReadNum
{
    long long readNum = [self longLongValue];
    if (readNum < 0 ) {
        return @"0";
    }
    NSString *readStr = [NSString stringWithFormat:@"%lld",readNum];
    if (readNum >= 10000)
    {
        readStr = [NSString stringWithFormat:@"%lldw+",readNum/10000];
    }
    return readStr;
}

@end
