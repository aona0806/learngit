//
//  NSString+Version.m
//  news
//
//  Created by chunhui on 15/12/7.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "NSString+Version.h"

@implementation NSString (Version)

-(NSInteger)compareVersion:(NSString *)anotherVersion
{
    if (anotherVersion == nil) {
        return 1;
    }
    if (![anotherVersion isKindOfClass:[NSString class]]) {
        anotherVersion = [NSString stringWithFormat:@"%@",anotherVersion];
    }
    if (anotherVersion.length == 0) {
        return 1;
    }
    if (self.length == 0) {
        return -1;
    }
    if ([self isEqualToString:anotherVersion]) {
        return 0;
    }
    
    NSArray *myVersions = [self componentsSeparatedByString:@"."];
    NSArray *anotherVersions = [anotherVersion componentsSeparatedByString:@"."];
    
    for (int i = 0 ; i < MIN(myVersions.count, anotherVersions.count) ; i++){
        NSInteger my = [myVersions[i] integerValue];
        NSInteger another = [anotherVersions[i] integerValue];
        if (my > another) {
            return 1;
        }else if (my < another){
            return  -1;
        }
    }
    
    if (myVersions.count < anotherVersions.count) {
        return -1;
    }else if (myVersions.count > anotherVersions.count){
        return 1;
    }
    
    return 0;
}

@end
