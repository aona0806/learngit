//
//  TKRequestHandler+HotNews.m
//  news
//
//  Created by chunhui on 15/11/28.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler+HotNews.h"
#import "news-Swift.h"

@implementation TKRequestHandler (HotNews)

-(NSURLSessionDataTask *)getAdInfoFinish:(void (^)(NSURLSessionDataTask *sessionDataTask, LJAdModel *_Nullable model , NSError * _Nullable  error))finish
{
    NSString *path = [NSString stringWithFormat:@"%@/1/ad/get",[NetworkManager apiHost]];
    NSDictionary *param = @{@"perct":@"3",@"pos":@"1"};
    return [[TKRequestHandler sharedInstance] getRequestForPath:path param:param jsonName:@"LJAdModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask, (LJAdModel *)model,error);
        }
    }];
}

/**
 *  推荐加载帖子信息
 *
 *  @param isNew    yes 是刷新 no 加载更多
 *  @param firstTid 当为加载更多时 上一次拉取的最后一条帖子id
 *  @param finish   完成回调
 *
 *  @return 请求的对象
 */
-(NSURLSessionDataTask *)getNewsTweetListIsNew:(BOOL)isNew FirstTid:(NSString *)firstTid finish:(void (^)(NSURLSessionDataTask *sessionDataTask, LJTweetModel *model , NSError *error))finish
{
    NSString *path = [NSString stringWithFormat:@"%@/hotnews/home",[NetworkManager api2Host]];
//    NSAssert(isNew && firstTid.length == 0, @"load next must set firstTid");
    if (firstTid.length == 0) {
        firstTid = @"0";
    }
    NSDictionary *param = @{@"type":isNew?@"new":@"next",@"last_tid":firstTid};
    return [[TKRequestHandler sharedInstance] getRequestForPath:path param:param jsonName:@"LJTweetModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask, (LJTweetModel *)model,error);
        }
    }];
}

@end
