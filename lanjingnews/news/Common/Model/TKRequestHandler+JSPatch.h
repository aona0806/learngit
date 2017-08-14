//
//  TKRequestHandler+JSPatch.h
//  news
//
//  Created by chunhui on 16/5/11.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"

#if 0
@interface TKRequestHandler (JSPatch)

-(NSURLSessionDataTask *)getJSPatchConfig:(NSString *)patchVersion completion:(void(^)(NSURLSessionDataTask *task , NSString *version , NSString *url , NSString *sign))completion;

@end

#endif