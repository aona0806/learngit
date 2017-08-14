//
//  LJUrlHelper.m
//  news
//
//  Created by 陈龙 on 16/6/14.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "LJUrlHelper.h"
#import "NSString+Encode.h"

@implementation LJUrlHelper

+ (NSURL * _Nullable)tryEncode:(NSString *_Nullable)urlString {
    NSURL *url = nil;
    if (urlString) {
        url = [NSURL URLWithString:urlString];
        if (!url) {
            url = [urlString encodeURL];
        }
    }
    return url;
}

@end
