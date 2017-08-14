//
//  TKRequestHandler+MesageList.m
//  news
//
//  Created by 陈龙 on 15/12/8.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler+Message.h"
#import "news-Swift.h"

@implementation TKRequestHandler (Message)

- (NSURLSessionDataTask * )getMessageListFinish:(void (^)(NSURLSessionDataTask *sessionDataTask, LJMessageListModel * model , NSError *   error))finish
{
    NSString *path = [NSString stringWithFormat:@"%@%@",[NetworkManager api2Host],@"/message/usermsg"];
    NSDictionary *param = nil;
    NSURLSessionDataTask *sessionDataTask = [[TKRequestHandler sharedInstance] getRequestForPath:path param:param jsonName:@"LJMessageListModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask, (LJMessageListModel *)model,error);
        }
    }];
    return sessionDataTask;
}

- (NSURLSessionDataTask * )getDelMessageFromListWithMesUid:(NSString *)msg_uid
                                                 complated:(void (^)(NSURLSessionDataTask *sessionDataTask, LJBaseJsonModel * model , NSError *   error))finish
{
    NSString *path = [NSString stringWithFormat:@"%@%@",[NetworkManager api2Host],@"/message/delmsg"];
    NSDictionary *param = nil;
    NSURLSessionDataTask *sessionDataTask = [[TKRequestHandler sharedInstance] getRequestForPath:path param:param jsonName:@"LJBaseJsonModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask, (LJBaseJsonModel *)model,error);
        }
    }];
    return sessionDataTask;
}

- (NSURLSessionDataTask * )getFriendListWithPageIndex:(NSInteger )pageIndex
                                           withCount:(NSString *)count
                                  AndIfSearchWithKey:(NSString *)q
                                           complated:(void (^)(NSURLSessionDataTask *sessionDataTask, LJUserFriendModel * model , NSError *   error))finish
{
    NSString *path = [NSString stringWithFormat:@"%@%@",[NetworkManager apiHost],@"/plus/user/user_friends"];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"page":@(pageIndex).description,@"count":count}];
    if (q.length  != 0)
    {
        [param setObject: q forKey:@"q"];
    }
    NSURLSessionDataTask *sessionDataTask = [[TKRequestHandler sharedInstance] getRequestForPath:path param:param jsonName:@"LJUserFriendModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask, (LJUserFriendModel *)model, error);
        }
    }];
    return sessionDataTask;
}

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
                                                 complated:(void (^)(NSURLSessionDataTask *sessionDataTask, LJUserFriendModel * model , NSError *   error))finish
{
    NSString *path = [NSString stringWithFormat:@"%@%@",[NetworkManager apiHost],@"/plus/user/user_relation_new"];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"page":page,@"count":count}];
    if (q.length  != 0)
    {
        [param setObject: q forKey:@"q"];
    }
    NSURLSessionDataTask *sessionDataTask = [[TKRequestHandler sharedInstance] getRequestForPath:path param:param jsonName:@"LJUserFriendModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask, (LJUserFriendModel *)model, error);
        }
    }];
    return sessionDataTask;
}

//- (NSURLSessionDataTask * )getMessageTypeType:(TKDataFreshType)type
//                                       MsgUid:(NSString *)msgUid
//                                      lastmid:(NSString *)lastMidString
//                                    complated:(void (^)(NSURLSessionDataTask *sessionDataTask, LJMessageTalkModel * model , NSError *   error))finish
//{
//    NSString *path = [NSString stringWithFormat:@"%@%@",[NetworkManager api2Host],@"/message/talk"];
//    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"msg_uid":msgUid}];
//    NSInteger lastMid = lastMidString.intValue;
//    switch (type) {
//        case TKDataFreshTypeRefresh:
//            if (lastMid > 0 ) {
//                [param setObject:@"new" forKey:@"type"];
//                [param setObject:lastMidString forKey:@"first_mid"];
//            }
//            break;
//        case TKDataFreshTypeLoadMore:
//            if (lastMid > 0) {
//                [param setObject:@"next" forKey:@"type"];
//                [param setObject:lastMidString forKey:@"last_mid"];
//            }
//            
//        default:
//            break;
//    }
//
//    
//    NSURLSessionDataTask *sessionDataTask = [[TKRequestHandler sharedInstance] getRequestForPath:path param:param jsonName:@"LJMessageTalkModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
//        if (finish) {
//            finish(sessionDataTask, (LJMessageTalkModel *)model, error);
//        }
//    }];
//    return sessionDataTask;
//}
//
//- (NSURLSessionDataTask * )postMessageToUid:(NSString *)toUid
//                                    content:(NSString *)content
//                                   isNotify:(BOOL)isNotify
//                                  complated:(void (^)(NSURLSessionDataTask *sessionDataTask, LJMessageTalkCallBackModel * model , NSError *   error))finish
//{
//    NSString *path = [NSString stringWithFormat:@"%@%@",[NetworkManager api2Host],@"/message/newmsg"];
//    NSString *flag = isNotify ? @"1" : @"0";
//    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
//    [param setObject: toUid forKey:@"to_uid"];
//    [param setObject: content forKey:@"content"];
//    [param setObject: flag forKey:@"flag"];
//    
//    NSURLSessionDataTask *sessionDataTask = [[TKRequestHandler sharedInstance] postRequestForPath:path param:param jsonName:@"LJMessageTalkCallBackModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
//        if (finish) {
//            finish(sessionDataTask, (LJMessageTalkCallBackModel *)model, error);
//        }
//    }];
//    return sessionDataTask;
//}

@end
