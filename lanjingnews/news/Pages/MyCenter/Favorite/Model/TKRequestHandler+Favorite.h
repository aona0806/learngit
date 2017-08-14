//
//  TKRequestHandler+Favorite.h
//  news
//
//  Created by wxc on 16/1/6.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"
#import "LJFavoriteModel.h"
#import "LJBaseJsonModel.h"

@interface TKRequestHandler (Favorite)

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

/**
 *  获取活动收藏列表（5.1.1添加）
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

/**
 *  添加收藏(5.1.0 会议收藏没有使用）
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


/**
 *  取消收藏
 *
 *  @param type     收藏类型(5.1.0 会议收藏没有使用）
 *  @param aid      id（帖子的id）
 *  @param finish   结果处理
 *
 *  @return
 */
-(NSURLSessionDataTask * _Nonnull)cancelFavoriteWithType:(NSString * _Nonnull)type
                                                     aid:(NSString * _Nonnull)aid
                                                  finish:(void (^_Nonnull)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJBaseJsonModel * _Nonnull model , NSError * _Nullable error))finish;

@end
