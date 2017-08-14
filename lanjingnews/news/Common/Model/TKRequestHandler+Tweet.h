//
//  TKRequestHandler+PublishTweet.h
//  news
//
//  Created by chunhui on 15/12/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"
#import "LJBaseJsonModel.h"

@interface TKRequestHandler (Tweet)

/**
 *  发表帖子
 *
 *  @param type    帖子类型  new 普通帖子   meeting : 会议  timeaxis:时间轴 activity:新闻活动 topic:新闻专题 news:新闻详情  forward : 转发时使用 
 *  @param title   帖子的标题
 *  @param content 帖子内容
 *  @param imgs    图片的url数组
 *  @param extends 附加参数
 *  @param finish  完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionTask *)publishTweetType:(NSString *)type title:(NSString *)title content:(NSString *)content tid:(NSString *)tid img:(NSArray<NSString *>*)imgs extends:(NSString *)extends finish:(void(^)(NSURLSessionTask *task , LJBaseJsonModel *model , NSError *error))finish;

/**
 *  赞或者取消赞帖子
 *
 *  @param add    yes 赞 no 取消赞
 *  @param tid    帖子id
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *)praise:(BOOL)add WithTid:(NSString *)tid finish:(void(^)(NSURLSessionDataTask *task , BOOL isOk , NSError *error))finish;

/**
 *  删除帖子
 *
 *  @param tid    帖子id
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *)deleteTweetWithTid:(NSString *)tid finish:(void (^)(NSURLSessionTask *task , BOOL isOK , NSError *error))finish;


@end
