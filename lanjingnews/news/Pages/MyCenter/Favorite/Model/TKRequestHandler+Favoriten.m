//
//  TKRequestHandler+Favorite.m
//  news
//
//  Created by wxc on 16/1/6.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "TKRequestHandler+Favorite.h"

@implementation TKRequestHandler (Favorite)
/**
 *  获取收藏列表
 *
 *  @param refresh  刷新类型
 *  @param lastTime 最后一条数据ctime
 *  @param finish   返回结果处理
 *
 *  @return
 */
-(NSURLSessionDataTask * _Nonnull)getmyFavoriteWithRefreshType:(BOOL)refresh
                                                      lastTime:(NSString * _Nullable)lastTime
                                                        finish:(void (^ _Nonnull)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJFavoriteModel * _Nonnull model, NSError * _Nullable error))finish;
{
    NSString *refreshType;
    if (refresh) {
        refreshType = @"0";
    }else{
        refreshType = @"1";
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObject:refreshType forKey:@"refresh_type"];
    if (lastTime) {
        [param setObject:lastTime forKey:@"last_time"];
    }
    
    return [self getRequestForPath:@"/v1/collection/get" param:param jsonName:@"LJFavoriteModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask,(LJFavoriteModel *)model,error);
        }
    }];
}

/**
 *  获取活动收藏列表
 *
 *  @param refresh  刷新类型
 *  @param lastTime 最后一条数据ctime
 *  @param finish   返回结果处理
 *
 *  @return
 */
-(NSURLSessionDataTask * _Nonnull)getActivityFavoriteWithRefreshType:(BOOL)refresh
                                                            lastTime:(NSString * _Nullable)lastTime
                                                              finish:(void (^ _Nonnull)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJFavoriteModel * _Nonnull model, NSError * _Nullable error))finish;
{
    NSString *refreshType;
    if (refresh) {
        refreshType = @"0";
    }else{
        refreshType = @"1";
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObject:refreshType forKey:@"refresh_type"];
    if (lastTime) {
        [param setObject:lastTime forKey:@"last_time"];
    }
    
    return [self getRequestForPath:@"/v1/activity_meeting/get" param:param jsonName:@"LJFavoriteModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask,(LJFavoriteModel *)model,error);
        }
    }];
}

/**
 *  添加收藏
 *
 *  @param type     收藏类型（会议，专题，活动）
 *  @param aid      id（帖子的id）
 *  @param finish   结果处理
 *
 *  @return
 */
-(NSURLSessionDataTask * _Nonnull)createFavoriteWithType:(NSString * _Nonnull)type
                                                     aid:(NSString * _Nonnull)aid
                                                  finish:(void (^_Nonnull)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJBaseJsonModel * _Nonnull model , NSError * _Nullable error))finish;
{
    NSAssert(aid.length > 0 && type.length > 0, @"load user info uid must valid");
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObject:type forKey:@"type"];
    
    [param setObject:aid forKey:@"aid"];
    
    return [[TKRequestHandler sharedInstance] getRequestForPath:@"/v1/collection/collect" param:param jsonName:@"LJBaseJsonModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask,(LJBaseJsonModel*)model,error);
        }
    }];
}

/**
 *  取消收藏
 *
 *  @param type     收藏类型（会议，专题，活动）
 *  @param aid      id（帖子的id）
 *  @param finish   结果处理
 *
 *  @return
 */
-(NSURLSessionDataTask * _Nonnull)cancelFavoriteWithType:(NSString * _Nonnull)type
                                                     aid:(NSString * _Nonnull)aid
                                                  finish:(void (^_Nonnull)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJBaseJsonModel * _Nonnull model , NSError * _Nullable error))finish;
{
    NSAssert(aid.length > 0 && type.length > 0, @"load user info uid must valid");
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObject:type forKey:@"type"];

    [param setObject:aid forKey:@"aid"];
    
    return [[TKRequestHandler sharedInstance] getRequestForPath:@"/v1/collection/uncollect" param:param jsonName:@"LJBaseJsonModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask,(LJBaseJsonModel*)model,error);
        }
    }];
}

@end
