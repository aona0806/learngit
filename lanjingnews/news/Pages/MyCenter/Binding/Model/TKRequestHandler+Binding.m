//
//  TKRequestHandler+Binding.m
//  news
//
//  Created by wxc on 16/1/9.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "TKRequestHandler+Binding.h"

@implementation TKRequestHandler (Binding)

/**
 *  绑定老用户
 *
 *  @param mailString     邮箱
 *  @param passwordString 密码
 *  @param finish         结果处理
 *
 *  @return
 */
-(NSURLSessionDataTask *)bindeingOldUserWithMail:(NSString *)mailString
                                    withPassword:(NSString *)passwordString
                                          finish:(void (^)(NSURLSessionDataTask *sessionDataTask, id response , NSError *error))finish
{
    NSDictionary *param = @{@"email":mailString, @"password":passwordString};
    return [[TKRequestHandler sharedInstance] postRequestForPath:@"/plus/user/binding" param:param finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {
        finish (sessionDataTask, response, error);
    }];
}

@end
