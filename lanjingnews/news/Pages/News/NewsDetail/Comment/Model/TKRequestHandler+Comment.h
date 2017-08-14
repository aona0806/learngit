//
//  TKRequestHandler+Comment.h
//  news
//
//  Created by wxc on 16/1/10.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"
#import "LJCommentModel.h"

@interface TKRequestHandler (Comment)

/**
 *  获取评论列表
 *
 *  @param infoId 信息id 帖子等
 *  @param lastId 最后一条评论id，用于获取下一页数据
 *  @param rn     每页条数限制
 *  @param type   刷新类型，为YES是下拉刷新
 *  @param finish 结果处理
 *
 *  @return
 */
-(NSURLSessionDataTask *)getCommentListlWithInfoId:(NSString*)infoId
                                            lastId:(NSString*)lastId
                                                rn:(NSString*)rn
                                       refreshType:(BOOL)type
                                            finish:(void (^)(NSURLSessionDataTask *sessionDataTask, LJCommentModel *model , NSError *error))finish;

/**
 *  提交评论
 *
 *  @param infoId   信息id
 *  @param replyCid 回复评论id
 *  @param replyUid 回复用户id
 *  @param content  回复内容
 *  @param finish   结果处理
 *
 *  @return
 */
-(NSURLSessionDataTask *)submitCommentWithInfiId:(NSString*)infoId
                                        replyCid:(NSString*)replyCid
                                        replyUid:(NSString*)replyUid
                                         content:(NSString*)content
                                          finish:(void (^)(NSURLSessionDataTask *sessionDataTask, LJSubmitCommentModel *model , NSError *error))finish;


@end
