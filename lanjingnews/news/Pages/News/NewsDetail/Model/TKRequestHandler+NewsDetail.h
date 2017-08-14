//
//  TKRequestHandler+NewsDetail.h
//  news
//
//  Created by wxc on 16/1/7.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"
#import "LJNewsDetailModel.h"
#import "LJzanNewsDetailModel.h"

@interface TKRequestHandler (NewsDetail)

/**
 *  点赞
 *
 *  @param newsId 新闻id
 *  @param finish 结果处理
 *
 *  @return
 */
-(NSURLSessionDataTask *)zanNewsDetailWithNewsId:(NSString* )newsId
                                          finish:(void (^)(NSURLSessionDataTask *sessionDataTask, LJzanNewsDetailModel *model , NSError *error))finish;

/**
 *  获取文章详情
 *
 *  @param newsId 新闻id
 *  @param finish 结果处理
 *
 *  @return 
 */
/**
 *  获取文章详情
 *
 *  @param newsId    新闻id
 *  @param fromSubId option 来源
 *  @return
 */
-(NSURLSessionDataTask *)getNewsDetailWithNewsId:(NSString *)newsId
                                       fromSubId:(NSString *)fromSubId
                                          finish:(void (^)(NSURLSessionDataTask *sessionDataTask, LJNewsDetailModel *model , NSError *error))finish;

@end
