//
//  TKRequestHandler+NewsTopic.h
//  news
//
//  Created by 陈龙 on 16/1/8.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"
#import "NewsTopicDetailModel.h"

@interface TKRequestHandler (NewsTopic)

- (NSURLSessionDataTask * _Nonnull)getTopicListFeed:(NSInteger)tid
                                          fromSubId:(NSString * _Nullable)fromsubid
                                           lastTime:(NSString * _Nonnull)lastCtime
                                                 rn:(NSInteger)rn
                                        refreshType:(TKDataFreshType)refreshType
                                          complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, NewsTopicDetailModel * _Nullable model , NSError * _Nullable error))finish;

@end
