//
//  TKRequestHandler+SystemNotification.m
//  news
//
//  Created by chunhui on 16/1/11.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "TKRequestHandler+SystemNotification.h"
#import "news-Swift.h"


@implementation TKRequestHandler (SystemNotification)

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
-(NSURLSessionDataTask *)getSystemMessageWithRefreshType:(TKDataFreshType)refreshType actionType:(LJSystemNotificationType)actionType cid:(NSString *)cid finish:(void (^)(NSURLSessionDataTask *sessionDataTask, LJSystemNofiticationModel *model , NSError *error))finish
{
    NSString *path =  [NSString stringWithFormat:@"%@/system_message/get",[NetworkManager api2Host]];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    NSString *typeName = nil;
    NSString *cidName =nil ;
    switch (refreshType) {
        case TKDataFreshTypeRefresh:
            typeName = @"new";
            cidName = @"first_id";
            break;
        case TKDataFreshTypeLoadMore:
            typeName = @"next";
            cidName = @"last_id";
        default:
            break;
    }
    
    if (typeName.length > 0) {
        [param setObject: (refreshType==TKDataFreshTypeRefresh ? @"new":@"next") forKey:@"type"];
    }
    if (cid.length > 0 && cidName.length > 0) {
        [param setObject:cid forKey:cidName];
    }
    
    NSString *actionTypeName = nil;
    switch (actionType) {
        case LJSystemNotificationTypeComment:
            actionTypeName = @"comment";
            break;
        case LJSystemNotificationTypePraise:
            actionTypeName = @"zan";
            break;
        default:
            break;
    }
    if (actionTypeName.length > 0) {
        [param setObject:actionTypeName forKey:@"action_type"];
    }
    
    return [self getRequestForPath:path param:param jsonName:@"LJSystemNofiticationModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        
        if (finish) {
            finish(sessionDataTask,(LJSystemNofiticationModel *)model,error);
        }
        
    }];
    
    
}


@end
