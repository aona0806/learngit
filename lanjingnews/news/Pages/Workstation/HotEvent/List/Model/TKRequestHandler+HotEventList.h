//
//  TKRequestHandler+HotEventList.h
//  news
//
//  Created by 陈龙 on 16/6/3.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"
#import "HotEventModel.h"
#import "HotEventZanModel.h"

@interface TKRequestHandler (HotEventList)

/**
 *  获取热门专家列表
 *
 *  @param lastId      <#lastId description#>
 *  @param rn          <#rn description#>
 *  @param refreshType <#refreshType description#>
 *  @param finish      <#finish description#>
 *
 *  @return <#return value description#>
 */
-(NSURLSessionDataTask * _Nonnull)getHotEventListWithId:(NSString * _Nullable)lastId rn:(NSInteger)rn refreshType:(TKDataFreshType)refreshType finish:(void (^ _Nonnull)(NSURLSessionDataTask * _Nonnull sessionDataTask, HotEventModel * _Nullable model , NSError * _Nullable error))finish;

/**
 *  赞、取消赞
 *
 *  @param idString <#idString description#>
 *  @param finish   <#finish description#>
 *
 *  @return <#return value description#>
 */
-(NSURLSessionDataTask * _Nonnull)getEventZanWithId:(NSString * _Nonnull)idString iszan:(BOOL)iszan finish:(void (^ _Nonnull)(NSURLSessionDataTask * _Nonnull sessionDataTask, HotEventZanModel * _Nullable model , NSError * _Nullable error))finish;
@end
