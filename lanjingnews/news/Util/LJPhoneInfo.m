//
//  LJPhoneInfo.m
//  news
//
//  Created by chunhui on 15/12/21.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJPhoneInfo.h"
#import "TKAppInfo.h"

@implementation LJPhoneInfo

+(NSDictionary<NSString * , NSString *> *)phoneInfo
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    NSString *modelString = [[UIDevice currentDevice] model];
    [dic setObject:modelString forKey:@"mb"];
    NSString *ovString = [[UIDevice currentDevice] systemVersion];
    [dic setObject:@"iOS" forKey:@"os"];
    [dic setObject:ovString forKey:@"ov"];
    [dic setObject:[TKAppInfo appVersion] forKey:@"sv"];
    NSInteger reachabilityFlagsTag = [[Reachability reachabilityForInternetConnection] currentReachabilityStatusTag];
    NSString *reachabilityFlagsString = [NSString stringWithFormat:@"%ld",(long)reachabilityFlagsTag];
    [dic setObject:reachabilityFlagsString forKey:@"net"];
    
    [dic setObject:@"lanjing" forKey:@"app"];
    NSString *uuidString = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    [dic setObject:uuidString forKey:@"cuid"];
    [dic setObject:@"iPhone" forKey:@"platform"];
    
//    [dic setObject:@"100010" forKey:@"app_key"];
//    [dic setObject:@"e853b9b68d83a36cbd706b343f7f25a6" forKey:@"app_secret"];
    
    return dic;
}

@end
