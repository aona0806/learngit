//
//  TKRequestHandler+HotEventList.m
//  news
//
//  Created by 陈龙 on 16/6/3.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "TKRequestHandler+HotEventList.h"
#import "news-Swift.h"

@implementation TKRequestHandler (HotEventList)

-(NSURLSessionDataTask * _Nonnull)getHotEventListWithId:(NSString * _Nullable)lastId rn:(NSInteger)rn refreshType:(TKDataFreshType)refreshType finish:(void (^ _Nonnull)(NSURLSessionDataTask * _Nonnull sessionDataTask, HotEventModel * _Nullable model , NSError * _Nullable error))finish
{
    
    NSString *path = [NSString stringWithFormat:@"%@/v2/event/get_list",[NetworkManager apiHost]];
    NSString *rnString = [NSString stringWithFormat:@"%ld",(long)rn];
    NSString *refreshTypeString = refreshType == TKDataFreshTypeRefresh ? @"0" : @"1";
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{ @"rn": rnString, @"refresh_type":refreshTypeString}];
    if (lastId) {
        [param setObject:lastId forKey:@"lastid"];
    }
    
    return [self getRequestForPath:path param:param jsonName:@"HotEventModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish){
            finish(sessionDataTask, (HotEventModel *)model, error);
        }
    }];
}

-(NSURLSessionDataTask * _Nonnull)getEventZanWithId:(NSString * _Nonnull)idString iszan:(BOOL)iszan finish:(void (^ _Nonnull)(NSURLSessionDataTask * _Nonnull sessionDataTask, HotEventZanModel * _Nullable model , NSError * _Nullable error))finish
{
    
    NSString *path = [NSString stringWithFormat:@"%@/v2/event/zan",[NetworkManager apiHost]];
    NSString *iszanString = iszan ? @"1" : @"0";
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{ @"id": idString, @"action": iszanString}];
    
    return [self getRequestForPath:path param:param jsonName:@"HotEventZanModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish){
            finish(sessionDataTask, (HotEventZanModel *)model, error);
        }
    }];
}

@end
