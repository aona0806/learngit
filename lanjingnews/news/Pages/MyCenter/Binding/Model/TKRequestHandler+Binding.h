//
//  TKRequestHandler+Binding.h
//  news
//
//  Created by wxc on 16/1/9.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"

@interface TKRequestHandler (Binding)

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
                                          finish:(void (^)(NSURLSessionDataTask *sessionDataTask, id response , NSError *error))finish;
@end
