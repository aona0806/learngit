//
//  TKRequestHandler+LongLink.m
//  news
//
//  Created by chunhui on 15/12/25.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler+LongLink.h"
#import "news-Swift.h"

@implementation TKRequestHandler (LongLink)

/**
 *  获取长连接配置信息
 *
 *  @param cuid       用户的cuid
 *  @param completion 完成回调
 *
 *  @return 请求的实例
 */
-(NSURLSessionTask *)getLongLinkConfigWithCuid:(NSString *)cuid completion:(void (^)(LJConInfoModel *model , NSError *error) )completion
{
    if (cuid.length == 0) {
        return nil;
    }
    
    NSDictionary *param = @{@"cuid":cuid};
    NSString *path = [NSString stringWithFormat:@"%@/v1/conn_info/get",[NetworkManager apiHost]];
    return [self getRequestForPath:path param:param finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {
        
        LJConInfoModel *model = nil;
        if (error == nil && [response isKindOfClass:[NSDictionary class]]) {
            model = [[LJConInfoModel alloc]initWithDictionary:response error:nil];
        }
        if (completion) {
            completion(model,error);
        }
    }];
}

@end
