//
//  TKRequestHandler+Util.h
//  news
//
//  Created by chunhui on 15/12/26.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"
#import "LJConfigModel.h"
#import "LJRedDotModel.h"

@interface TKRequestHandler (Util)

/**
 *  发送分享统计请求
 *
 *  @param tid        分享的帖子 会议 时间轴等的id
 *  @param ctype      内容类型：（ctype=1 帖子，ctype=2 时间轴列表，ctype=3 会议, ctype=4, 新闻 ctype=5 新闻活动 ctype=100 注册成功之后分享成功统计（5.1.1新加））
 *  @param stype      分享的平台类型： 0:蓝鲸站内;1:微博;2:qq朋友;3:qq空间(目前没用到);4 微信聊天;5微信朋友圈
 *  @param completion 完成回调
 *
 *  @return 请求的实例
 */
-(NSURLSessionTask *)postShareWithTweetId:(NSString *)tid contentType:(NSInteger)ctype sharetype:(NSInteger)stype  completion:(void (^)(bool success , NSError *error) )completion;

/**
 *  获取app版本号
 *
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
- (NSURLSessionDataTask *)getAppVersionFinish:(void (^) (NSURLSessionDataTask *sessionDataTask,id responses, NSError *error))finish;


/**
 *  拉取应用配置信息
 *
 *  @param codeSign 本地缓存的codesign
 *  @param finish   完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *)getAppConfigWithCodesign:(NSString *)codeSign finish:(void (^)(NSURLSessionDataTask *sessionDataTask,LJConfigModel * model, NSError *error))finish;

/**
 *  拉取红点信息
 *
 *  @param timestamp 上一次拉取推荐的时间戳，没有时传空
 *  @param finish    完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *)getRedDotInfoWithRedTimestamp:(NSString *)timestamp finish:(void (^)(NSURLSessionDataTask *sessionDataTask,LJRedDotModel * model, NSError *error))finish;

@end
