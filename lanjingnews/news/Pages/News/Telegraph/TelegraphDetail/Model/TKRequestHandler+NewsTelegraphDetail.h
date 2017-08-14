//
//  TKRequestHandler+NewsTelegraphDetail.h
//  news
//
//  Created by wxc on 2017/1/4.
//  Copyright © 2017年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"
#import "LJNewsTelegraphDetailModel.h"

@interface TKRequestHandler (NewsTelegraphDetail)

/**
 *  获取快讯详情
 *
 *  @param newsId 新闻id
 *  @param finish 结果处理
 *
 *  @return
 */
-(NSURLSessionDataTask *)getNewsTelegraphDetailWithNewsId:(NSString* )newsId
                                                 fromPush:(BOOL)fromPush
                                                   finish:(void (^)(NSURLSessionDataTask *sessionDataTask, LJNewsTelegraphDetailModel *model , NSError *error))finish;

@end
