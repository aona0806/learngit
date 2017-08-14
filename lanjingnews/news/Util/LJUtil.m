//
//  LJUtil.m
//  news
//
//  Created by chunhui on 15/11/3.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJUtil.h"
#import "NSString+MD5.h"

@implementation LJUtil

+ (NSString *)UUID
{
    NSString *  result;
    CFUUIDRef   uuid;
    CFStringRef uuidStr;
    
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    
    result = [NSString stringWithFormat:@"%@",uuidStr];
    
    CFRelease(uuidStr);
    CFRelease(uuid);
    
    return result;
}

+ (NSString *)UUIDShort
{
    NSString *uuid = [LJUtil UUID];
    return [uuid md5String];
}

+ (double)toastInterval:(NSString * _Nonnull)toastString {
    
    if (toastString) {
        double interval = toastString.length * 0.2;
        interval = interval < 1 ? 1 : interval;
        interval = interval > 2 ? 2 : interval;
        return interval;
    } else {
        return 0.7;
    }
}

@end
