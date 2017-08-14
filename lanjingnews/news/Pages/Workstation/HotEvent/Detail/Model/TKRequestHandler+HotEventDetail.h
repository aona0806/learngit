//
//  TKRequestHandler+HotEventDetail.h
//  news
//
//  Created by 陈龙 on 16/6/3.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"
#import "HotEventDetailModel.h"

@interface TKRequestHandler (HotEventDetail)

/**
 *  获取热点事件详情数据
 *
 *  @param idString 热点事件id
 *  @param finish   <#finish description#>
 *
 *  @return <#return value description#>
 */
-(NSURLSessionDataTask * _Nonnull)getHotEventDetailWithId:(NSString * _Nonnull)idString finish:(void (^ _Nonnull)(NSURLSessionDataTask * _Nonnull sessionDataTask, HotEventDetailModel * _Nullable model , NSError * _Nullable error))finish;

@end
