//
//  TKRequestHandler+Advice.m
//  news
//
//  Created by wxc on 16/1/7.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "TKRequestHandler+Advice.h"

@implementation TKRequestHandler (Advice)

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
                                           finish:(void (^)(NSURLSessionDataTask *sessionDataTask, id response , NSError *error))finish
{
    NSAssert(content.length > 0 , @"意见反馈内容为空");
    NSDictionary *param = @{@"username":username, @"content":content};
    
    return [[TKRequestHandler sharedInstance] postRequestForPath:@"v1/app_feedback/create" param:param finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {
        if (finish) {
            finish(sessionDataTask, response, error);
        }
    }];
}

@end
