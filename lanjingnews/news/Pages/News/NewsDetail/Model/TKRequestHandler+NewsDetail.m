//
//  TKRequestHandler+NewsDetail.m
//  news
//
//  Created by wxc on 16/1/7.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "TKRequestHandler+NewsDetail.h"

#define zanPath @"/v1/zan/addzan" //赞
#define detailPath @"/v1/news/get_detail" //详情

@implementation TKRequestHandler (NewsDetail)

/**
 *  点赞
 *
 *  @param newsId 新闻id
 *  @param finish 结果处理
 *
 *  @return
 */
-(NSURLSessionDataTask *)zanNewsDetailWithNewsId:(NSString*)newsId
                                          finish:(void (^)(NSURLSessionDataTask *sessionDataTask, LJzanNewsDetailModel *model , NSError *error))finish
{
    NSString *path = zanPath;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObject:newsId forKey:@"aid"];
    return [[TKRequestHandler sharedInstance] getRequestForPath:path param:param jsonName:@"LJzanNewsDetailModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish (sessionDataTask, (LJzanNewsDetailModel*)model, error);
        }
    }];
}

/**
 *  获取文章详情
 *
 *  @param newsId 新闻id
 *  @param finish 结果处理
 *
 *  @return
 */
-(NSURLSessionDataTask *)getNewsDetailWithNewsId:(NSString *)newsId
                                       fromSubId:(NSString *)fromSubId
                                          finish:(void (^)(NSURLSessionDataTask *sessionDataTask, LJNewsDetailModel *model , NSError *error))finish
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObject:newsId forKey:@"nid"];
    if (fromSubId == nil) {
        fromSubId = @"0";
    }
    [param setObject:fromSubId forKey:@"from_sub_id"];
    NSString *path = detailPath;
    
    return [[TKRequestHandler sharedInstance] getRequestForPath:path param:param jsonName:@"LJNewsDetailModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
//            NSData *jsonData = [NSData dataWithContentsOfFile:@"/Users/liuzhao/Desktop/relatedread.json"];
//            LJNewsDetailModel *dmodel = [[LJNewsDetailModel alloc] initWithData:jsonData error:nil];
//            finish(sessionDataTask, (LJNewsDetailModel *)dmodel, error);
            finish(sessionDataTask, (LJNewsDetailModel*)model, error);
        }
    }];
}

@end
