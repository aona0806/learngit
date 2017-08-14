//
//  TKRequestHandler+MesageList.h
//  news
//
//  Created by 陈龙 on 15/12/8.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"
#import "LJMessageListModel.h"
#import "LJBaseJsonModel.h"
#import "LJUserFriendModel.h"
#import "LJRelationFollowModel.h"
#import "LJMessageTalkModel.h"
#import "LJMessageTalkCallBackModel.h"

@interface TKRequestHandler (Message)

/**
 *  1.1 获取消息列表
 *
 *  @param finish <#finish description#>
 *
 *  @return <#return value description#>
 */
-(NSURLSessionDataTask * )getMessageListFinish:(void (^)(NSURLSessionDataTask *sessionDataTask, LJMessageListModel * model , NSError *   error))finish;

/**
 *  1.2 删除列表中msgUid的消息
 *
 *  @param msg_uid <#msg_uid description#>
 *  @param finish  <#finish description#>
 *
 *  @return <#return value description#>
 */
- (NSURLSessionDataTask * )getDelMessageFromListWithMesUid:(NSString *)msg_uid
                                                 complated:(void (^)(NSURLSessionDataTask *sessionDataTask, LJBaseJsonModel * model , NSError *   error))finish;
/**
 *  1.3 获取好友列表
 *
 *  @param page   <#page description#>
 *  @param count  <#count description#>
 *  @param q      <#q description#>
 *  @param finish <#finish description#>
 *
 *  @return <#return value description#>
 */
- (NSURLSessionDataTask * )getFriendListWithPageIndex:(NSInteger )pageIndex
                                           withCount:(NSString *)count
                                  AndIfSearchWithKey:(NSString *)q
                                           complated:(void (^)(NSURLSessionDataTask *sessionDataTask, LJUserFriendModel * model , NSError *   error))finish;

/**
 *  1.5 获取好友通知列表
 *
 *  @param page   <#page description#>
 *  @param count  <#count description#>
 *  @param q      <#q description#>
 *  @param finish <#finish description#>
 *
 *  @return <#return value description#>
 */
- (NSURLSessionDataTask * )getHaoYouNoticationDataWithPage:(NSString *)page
                                                 withCount:(NSString *)count
                                        AndIfSearchWithKey:(NSString *)q
                                                 complated:(void (^)(NSURLSessionDataTask *sessionDataTask, LJUserFriendModel * model , NSError *   error))finish;
//
///**
// *  1.6 获取聊天信息
// *
// *  @param type
// *  @param msgUid        聊天对象用户id
// *  @param lastMidString 最后一条聊天记录id
// *  @param finish        <#finish description#>
// *
// *  @return <#return value description#>
// */
//- (NSURLSessionDataTask * )getMessageTypeType:(TKDataFreshType)type
//                                       MsgUid:(NSString *)msgUid
//                                      lastmid:(NSString *)lastMidString
//                                    complated:(void (^)(NSURLSessionDataTask *sessionDataTask, LJMessageTalkModel * model , NSError *   error))finish;
//
///**
// *  1.7 发送聊天消息
// *
// *  @param toUid    <#toUid description#>
// *  @param content  <#content description#>
// *  @param isNotify <#isNotify description#>
// *  @param finish   <#finish description#>
// *
// *  @return <#return value description#>
// */
//- (NSURLSessionDataTask * )postMessageToUid:(NSString *)toUid
//                                    content:(NSString *)content
//                                   isNotify:(BOOL)isNotify
//                                  complated:(void (^)(NSURLSessionDataTask *sessionDataTask, LJMessageTalkCallBackModel * model , NSError *   error))finish;

@end
