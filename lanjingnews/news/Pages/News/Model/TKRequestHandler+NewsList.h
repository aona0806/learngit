//
//  TKRequestHandler+NewsList.h
//  news
//
//  Created by 陈龙 on 16/1/8.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"
#import "LJNewsListModel.h"

@interface TKRequestHandler (NewsList)

- (NSURLSessionDataTask * _Nonnull)getNewsListFeed:(NSInteger)type
                                          lastTime:(NSString * _Nonnull)lastCtime
                                                rn:(NSInteger)rn
                                       refreshType:(TKDataFreshType)refreshType
                                         complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJNewsListModel * _Nullable model , NSError * _Nullable error))finish;

@end
