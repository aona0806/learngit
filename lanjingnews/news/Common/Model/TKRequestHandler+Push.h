//
//  TKRequestHandler+Push.h
//  news
//
//  Created by 陈龙 on 15/12/28.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"
#import "LJBaseJsonModel.h"

@interface TKRequestHandler (Push)

/**
 *  进行设备绑定或者解绑定
 *
 *  @param pushToken push device token
 *  @param uid       0 或者用户 uid ， 为0时为解绑定
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *)pushBind:(NSString *)registerId deviceToken:(NSString *)token  uid:(NSString *)uid  completion:(void (^)(NSURLSessionDataTask *sessionDataTask, LJBaseJsonModel *model ,NSError *error))finish;


/**
 *  推送反馈
 *
 *  @param msgId       push id
 *  @param deviceToken 设备token
 *  @param completion
 *
 *  @return
 */
-(NSURLSessionDataTask *)pushFeedbackMsgId:(NSString *)msgId timestamp:(NSTimeInterval)timestamp deviceToken:(NSString *)deviceToken completion:(void (^)(NSURLSessionDataTask *task , BOOL success))completion;

@end
