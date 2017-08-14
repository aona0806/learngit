//
//  TKRequestHandler+NewsTelegraphDetail.m
//  news
//
//  Created by wxc on 2017/1/4.
//  Copyright © 2017年 lanjing. All rights reserved.
//

#import "TKRequestHandler+NewsTelegraphDetail.h"

#define TelegraphDetailPath @"/v1/roll/get_detail" //赞

@implementation TKRequestHandler (NewsTelegraphDetail)

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
                                                   finish:(void (^)(NSURLSessionDataTask *sessionDataTask, LJNewsTelegraphDetailModel *model , NSError *error))finish
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObject:newsId forKey:@"nid"];
    
    NSString *push = fromPush?@"1":@"0";
    param[@"from_push"] = push;
    
    return [[TKRequestHandler sharedInstance] getRequestForPath:TelegraphDetailPath param:param jsonName:@"LJNewsTelegraphDetailModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish (sessionDataTask, (LJNewsTelegraphDetailModel*)model, error);
        }
    }];
}

@end
