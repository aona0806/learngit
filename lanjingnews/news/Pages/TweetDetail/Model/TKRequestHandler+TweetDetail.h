//
//  TKRequestHandler+TweetDetail.h
//  news
//
//  Created by chunhui on 15/12/7.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"
#import "LJTweetDetailModel.h"
#import "LJTweetCommentModel.h"

@interface TKRequestHandler (TweetDetail)

/**
 *  获取帖子详情
 *
 *  @param tid    帖子id
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *)getTweetDetailWithTid:(NSString *)tid finish:(void (^)(NSURLSessionDataTask *sessionDataTask, LJTweetDetailModel *model , NSError *error))finish;

/**
 *  拉取评论
 *
 *  @param tid    帖子id
 *  @param isNew  yes 刷新 no 加载更多
 *  @param lastId 上一次拉取的id 当 isNew 为no时有效
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *)getTweetCommentsWithTid:(NSString *)tid isNew:(BOOL)isNew lastCId:(NSString *)lastId finish:(void (^)(NSURLSessionDataTask *sessionDataTask, LJTweetCommentModel *model , NSError *error))finish;

/**
 *  发送评论
 *
 *  @param tid     帖子id
 *  @param content 评论内容
 *  @param rcid    要回复的回复id
 *  @param ruid    要回复的用户id
 *  @param finish  完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *)postCommentWithTid:(NSString *)tid content:(NSString *)content replayCid:(NSString *)rcid replayUid:(NSString *)ruid finish:(void(^)(NSURLSessionDataTask *sessionDataTask, NSString *cid , NSError *error))finish;

/**
 *  删除评论
 *
 *  @param cid    要删除的评论
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
- (NSURLSessionDataTask *) deleteCommentWithCid:(NSString *)cid
                                   withComplete:(void(^)(NSURLSessionDataTask *sessionDataTask, BOOL isOK , NSError *error))finish;


@end
