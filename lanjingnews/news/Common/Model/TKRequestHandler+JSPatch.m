//
//  TKRequestHandler+JSPatch.m
//  news
//
//  Created by chunhui on 16/5/11.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#if 0

#import "TKRequestHandler+JSPatch.h"

@implementation TKRequestHandler (JSPatch)

-(NSURLSessionDataTask *)getJSPatchConfig:(NSString *)patchVersion completion:(void(^)(NSURLSessionDataTask *task , NSString *version , NSString *url , NSString *sign))completion
{
    NSString *path = @"http://www.chunhui.com:8088/jspatch/config";
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if (patchVersion.length > 0) {
        param[@"version"] = patchVersion;
    }
    
    return [self getRequestForPath:path param:param finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {
        
        NSString *url = nil;
        NSString *version = nil;
        NSString *sign = nil;
        NSDictionary *data = response[@"data"];
        if (data) {
            url = data[@"url"];
            version = data[@"version"];
            sign = data[@"sign"];
            if (completion) {
                completion(sessionDataTask , version,url,sign);
            }
        }
    }];
}

@end

#endif
