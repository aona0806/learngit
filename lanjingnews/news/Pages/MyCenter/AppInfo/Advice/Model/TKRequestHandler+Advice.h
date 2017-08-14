//
//  TKRequestHandler+Advice.h
//  news
//
//  Created by wxc on 16/1/7.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"

@interface TKRequestHandler (Advice)

/**
 *  意见反馈
 *
 *  @param username 用户名
 *  @param content  反馈内容
 *  @param finish   结果处理
 *
 *  @return
 */
-(NSURLSessionDataTask *)commitAdviceWithUsername:(NSString*)username
                                          content:(NSString*)content
                                           finish:(void (^)(NSURLSessionDataTask *sessionDataTask, id response , NSError *error))finish;

@end
