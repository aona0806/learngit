//
//  TKRequestHandler+HotNews.h
//  news
//
//  Created by chunhui on 15/11/28.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"
#import "LJAdModel.h"
#import "LJTweetModel.h"
#import "LJBaseJsonModel.h"

typedef NS_ENUM(NSInteger, LJShareContentType){
    LJShareContentTypeConference = 3,
    LJShareContentTypeTimeLine = 2,
    LJShareContentTypeTweet = 1,
};

@interface TKRequestHandler (HotNews)


/**
 *  加载banner信息
 *
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *)getAdInfoFinish:(void (^ )(NSURLSessionDataTask *sessionDataTask, LJAdModel * model , NSError *  error))finish;

/**
 *  推荐加载帖子信息
 *
 *  @param isNew    yes 是刷新 no 加载更多
 *  @param firstTid 当为加载更多时 上一次拉取的最后一条帖子id
 *  @param finish   完成回调
 *
 *  @return 请求的对象
 */
-(NSURLSessionDataTask *)getNewsTweetListIsNew:(BOOL)isNew FirstTid:(NSString *)firstTid finish:(void (^)(NSURLSessionDataTask *sessionDataTask, LJTweetModel *model , NSError *error))finish;

///**
// *  发表帖子
// *
// *  @param type     分享类型："timeaxis" 时间轴 “meeting” 会议 "new" 帖子
// *  @param title    帖子标题
// *  @param content  帖子内容
// *  @param imgs     帖子图片 url string 的数组
// *  @param industry 行业 全部 或者 TMT 默认为全部
// *  @param catalog  类别
// *  @param extends  <#extends description#>
// *  @param finish   <#finish description#>
// *
// *  @return <#return value description#>
// */
//-(NSURLSessionDataTask *)postDiscussionType:(LJShareContentType)type
//                                      title:(NSString *)title
//                                    content:(NSString *)content
//                                        img:(NSArray *)imgs
//                                   industry:(NSString *)industry
//                                    catalog:(NSString *)catalog
//                                    extends:(NSString *)extends
//                                     finish:(void (^)(NSURLSessionDataTask *sessionDataTask, LJBaseJsonModel *model , NSError *error))finish;
@end
