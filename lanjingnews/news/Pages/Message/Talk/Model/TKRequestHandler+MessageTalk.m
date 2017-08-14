//
//  TKRequestHandler+MessageTalk.m
//  news
//
//  Created by 陈龙 on 15/12/29.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler+MessageTalk.h"
#import "news-Swift.h"

@implementation TKRequestHandler (MessageTalk)

- (NSURLSessionDataTask * )getMessageTypeType:(TKDataFreshType)type
                                       MsgUid:(NSString *)msgUid
                                      lastmid:(NSString *)lastMidString
                                    complated:(void (^)(NSURLSessionDataTask *sessionDataTask, LJMessageTalkModel * model , NSError *   error))finish
{
    NSString *path = [NSString stringWithFormat:@"%@%@",[NetworkManager api2Host],@"/message/talk"];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"msg_uid":msgUid}];
    NSInteger lastMid = lastMidString.intValue;
    switch (type) {
        case TKDataFreshTypeRefresh:
            if (lastMid > 0 ) {
                [param setObject:@"new" forKey:@"type"];
                [param setObject:lastMidString forKey:@"first_mid"];
            }
            break;
        case TKDataFreshTypeLoadMore:
            if (lastMid > 0) {
                [param setObject:@"next" forKey:@"type"];
                [param setObject:lastMidString forKey:@"last_mid"];
            }
            
        default:
            break;
    }
    
    NSURLSessionDataTask *sessionDataTask = [[TKRequestHandler sharedInstance] getRequestForPath:path param:param jsonName:@"LJMessageTalkModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask, (LJMessageTalkModel *)model, error);
        }
    }];
    return sessionDataTask;
}

- (NSURLSessionDataTask * )postMessageToUid:(NSString *)toUid
                                    content:(NSString *)content
                                   isNotify:(BOOL)isNotify
                                  complated:(void (^)(NSURLSessionDataTask *sessionDataTask, LJMessageTalkCallBackModel * model , NSError *   error))finish
{
    NSString *path = [NSString stringWithFormat:@"%@%@",[NetworkManager api2Host],@"/message/newmsg"];
    NSString *flag = isNotify ? @"1" : @"0";
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject: toUid forKey:@"to_uid"];
    [param setObject: content forKey:@"content"];
    [param setObject: flag forKey:@"flag"];
    
    NSURLSessionDataTask *sessionDataTask = [[TKRequestHandler sharedInstance] postRequestForPath:path param:param jsonName:@"LJMessageTalkCallBackModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask, (LJMessageTalkCallBackModel *)model, error);
        }
    }];
    return sessionDataTask;
}

@end
