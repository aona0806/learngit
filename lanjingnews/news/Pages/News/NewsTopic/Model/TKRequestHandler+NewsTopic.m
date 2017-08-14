//
//  TKRequestHandler+NewsTopic.m
//  news
//
//  Created by 陈龙 on 16/1/8.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "TKRequestHandler+NewsTopic.h"
#import "news-Swift.h"

@implementation TKRequestHandler (NewsTopic)

- (NSURLSessionDataTask * _Nonnull)getTopicListFeed:(NSInteger)tid
                                          fromSubId:(NSString * _Nullable)fromsubid
                                           lastTime:(NSString * _Nonnull)lastCtime
                                                 rn:(NSInteger)rn
                                        refreshType:(TKDataFreshType)refreshType
                                          complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, NewsTopicDetailModel * _Nullable model , NSError * _Nullable error))finish
{
    NSString *methodString = @"/v1/news/get_topic";
    
    
    NSString *path = [NSString stringWithFormat:@"%@%@",[NetworkManager apiHost],methodString];
    NSString *rnString = [NSString stringWithFormat:@"%ld",(long)rn];
    NSString *tidString = [NSString stringWithFormat:@"%ld",(long)tid];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"tid":tidString, @"last_time":lastCtime, @"rn":rnString}];
    
    NSString *refreshTypeString = @"1";
    if (refreshType == TKDataFreshTypeRefresh || (refreshType == TKDataFreshTypeLoadMore && lastCtime == 0)) {
        refreshTypeString = @"0";
    } else {
        refreshTypeString = @"1";
    }
    [param setObject:refreshTypeString forKey:@"refresh_type"];
    
    if (!fromsubid) {
        fromsubid = @"0";
    }
    [param setObject:fromsubid forKey:@"from_sub_id"];
    
    NSString *jsonName = [NSString stringWithCString:class_getName([NewsTopicDetailModel class])
                                            encoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *sessionDataTask = [[TKRequestHandler sharedInstance] getRequestForPath:path param:param jsonName:jsonName finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask, (NewsTopicDetailModel *)model, error);
        }
    }];
    return sessionDataTask;
}

@end
