//
//  TKRequestHandler+MessageTalk.h
//  news
//
//  Created by 陈龙 on 15/12/29.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"
#import "LJMessageTalkModel.h"
#import "LJMessageTalkCallBackModel.h"

@interface TKRequestHandler (MessageTalk)

/**
 *  1.6 获取聊天信息
 *
 *  @param type
 *  @param msgUid        聊天对象用户id
 *  @param lastMidString 最后一条聊天记录id
 *  @param finish        <#finish description#>
 *
 *  @return <#return value description#>
 */
- (NSURLSessionDataTask * _Nullable)getMessageTypeType:(TKDataFreshType)type
                                       MsgUid:(NSString *_Nonnull)msgUid
                                      lastmid:(NSString *_Nonnull)lastMidString
                                    complated:(void (^_Nullable)(NSURLSessionDataTask *_Nonnull sessionDataTask, LJMessageTalkModel * _Nullable model , NSError *_Nullable  error))finish;

/**
 *  1.7 发送聊天消息
 *
 *  @param toUid    <#toUid description#>
 *  @param content  <#content description#>
 *  @param isNotify <#isNotify description#>
 *  @param finish   <#finish description#>
 *
 *  @return <#return value description#>
 */
- (NSURLSessionDataTask * _Nullable)postMessageToUid:(NSString *_Nonnull)toUid
                                    content:(NSString *_Nonnull)content
                                   isNotify:(BOOL)isNotify
                                  complated:(void (^_Nullable)(NSURLSessionDataTask *_Nonnull sessionDataTask, LJMessageTalkCallBackModel *_Nullable model , NSError *_Nullable   error))finish;

@end
