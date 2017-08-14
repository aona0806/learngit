//
//  NSMutableDictionary+Util.m
//  news
//
//  Created by 陈龙 on 15/12/21.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "NSMutableDictionary+Util.h"

@implementation NSMutableDictionary (Util)

- (void)lj_setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (anObject) {
        [self setObject:anObject forKey:aKey];
    }
}

@end
