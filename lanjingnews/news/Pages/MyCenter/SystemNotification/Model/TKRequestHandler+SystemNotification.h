//
//  TKRequestHandler+SystemNotification.h
//  news
//
//  Created by chunhui on 16/1/11.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"
#import "LJSystemNofiticationModel.h"


@interface TKRequestHandler (SystemNotification)

/**
 *  拉取系统消息
 *
 *  @param refreshType 刷新类型
 *  @param actionType  系统通知类型 普通 、评论、赞
 *  @param cid         请求上一个的回调
 *  @param finish      完成会滴
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *)getSystemMessageWithRefreshType:(TKDataFreshType)refreshType actionType:(LJSystemNotificationType)actionType cid:(NSString *)cid finish:(void (^)(NSURLSessionDataTask *sessionDataTask, LJSystemNofiticationModel *model , NSError *error))finish;


@end
