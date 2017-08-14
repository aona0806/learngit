//
//  TKRequestHandler+Community.h
//  news
//
//  Created by chunhui on 15/12/21.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"
#import "LJTweetModel.h"
#import "CommunityRedDotModel.h"


@interface TKRequestHandler (Community)

/**
 *  拉取圈子列表
 *
 *  @param isNew    yes 下拉刷新 no 加载更多
 *  @param lastTid  上一次最后一个帖子的id ， 加载更多时有效
 *  @param finish   完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *)getCommunityTweetListIsNew:(BOOL)isNew lastTid:(NSString *)lastTid finish:(void (^)(NSURLSessionDataTask *sessionDataTask, LJTweetModel *model , NSError *error))finish;

/**
 *  拉取圈子列表
 *
 *  @param isNew    yes 下拉刷新 no 加载更多
 *  @param lastTid  上一次最后一个帖子的id ， 加载更多时有效
 *  @param industry 行业 默认为全部
 *  @param finish   完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *)getCommunityTweetListIsNew:(BOOL)isNew lastTid:(NSString *)lastTid industry:(NSString *)industry  finish:(void (^)(NSURLSessionDataTask *sessionDataTask, LJTweetModel *model , NSError *error))finish;


/**
 *  拉取圈子上方红点数据
 *
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *)getCommunityRedDotFinish:(void (^)(NSURLSessionDataTask *sessionDataTask, CommunityRedDotModel *model , NSError *error))finish;

@end
