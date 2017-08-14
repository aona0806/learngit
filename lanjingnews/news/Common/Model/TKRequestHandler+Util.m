//
//  TKRequestHandler+Util.m
//  news
//
//  Created by chunhui on 15/12/26.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler+Util.h"
#import "news-Swift.h"


@implementation TKRequestHandler (Util)


/**
 *  发送分享统计请求
 *
 *  @param tid        分享的帖子 会议 时间轴等的id
 *  @param ctype      内容类型：（ctype=1 帖子，ctype=2 时间轴列表，ctype=3 会议 ）
 *  @param stype      分享的平台类型： 0:蓝鲸站内;1:微博;2:qq朋友;3:qq空间(目前没用到);4 微信聊天;5微信朋友圈
 *  @param completion 完成回调
 *
 *  @return 请求的实例
 */
-(NSURLSessionTask *)postShareWithTweetId:(NSString *)tid contentType:(NSInteger)ctype sharetype:(NSInteger)stype  completion:(void (^)(bool success , NSError *error) )completion
{
    if (tid.length == 0) {
        return nil;
    }
    NSString *path = [NSString stringWithFormat:@"%@/v1/currency/share_to_add",[NetworkManager apiHost]];

    NSDictionary *param = @{@"pk":tid,@"ctype":@(ctype).description,@"stype":@(stype).description};

    return [self postRequestForPath:path param:param finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {
        
        bool success = NO;
        if (response) {
            
            NSDictionary *responseDict = response;
            success = ([responseDict[@"errno"] integerValue] == 0);
            if (!success) {
                NSString *msg = responseDict[@"msg"];
                if (msg.length == 0) {
                    msg = @"";
                }
                error = [NSError errorWithDomain:msg code:[responseDict[@"errno"] integerValue] userInfo:nil];
            }
        }
        if (completion) {
            completion(success,error);
        }
    }];
}

/**
 *  获取app版本号
 *
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
- (NSURLSessionDataTask *)getAppVersionFinish:(void (^) (NSURLSessionDataTask *sessionDataTask,id responses, NSError *error))finish{
    NSString *path = [NSString stringWithFormat:@"%@/v1/version",[NetworkManager apiHost]];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject: @"1" forKey: @"ios"];
    
    return [[TKRequestHandler sharedInstance] getRequestForPath:path param:param finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {
        if (finish) {
            finish(sessionDataTask,response,error);
        }
    }];
}


/**
 *  拉取应用配置信息
 *
 *  @param codeSign 本地缓存的codesign
 *  @param finish   完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *)getAppConfigWithCodesign:(NSString *)codeSign finish:(void (^)(NSURLSessionDataTask *sessionDataTask,LJConfigModel * model, NSError *error))finish
{
    
    NSString *path = [NSString stringWithFormat:@"%@/v1/config",[NetworkManager apiHost]];
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    if (codeSign.length > 0) {
        param[@"code_sign"] = codeSign;
    }
    
    return [[TKRequestHandler sharedInstance] getRequestForPath:path param:param jsonName:@"LJConfigModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
                
        if (finish) {
            
            finish(sessionDataTask,(LJConfigModel*)model,error);
        }
        
    }];
    
}

/**
 *  拉取红点信息
 *
 *  @param timestamp 上一次拉取推荐的时间戳，没有时传空
 *  @param finish    完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *)getRedDotInfoWithRedTimestamp:(NSString *)timestamp finish:(void (^)(NSURLSessionDataTask *sessionDataTask,LJRedDotModel * model, NSError *error))finish
{
    
    NSString *path = [NSString stringWithFormat:@"%@/v1/reddot/sync",[NetworkManager apiHost]];
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    if (timestamp.length > 0) {
        param[@"timestamp"] = timestamp;
    }
    
    return [[TKRequestHandler sharedInstance] getRequestForPath:path param:param jsonName:@"LJRedDotModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        
        if (finish) {
            finish(sessionDataTask,(LJRedDotModel*)model,error);
        }
        
    }];
    
}



@end
