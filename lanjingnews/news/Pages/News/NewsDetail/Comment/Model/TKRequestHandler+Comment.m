//
//  TKRequestHandler+Comment.m
//  news
//
//  Created by wxc on 16/1/10.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "TKRequestHandler+Comment.h"

@implementation TKRequestHandler (Comment)

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
                                            finish:(void (^)(NSURLSessionDataTask *sessionDataTask, LJCommentModel *model , NSError *error))finish
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:infoId forKey:@"infoid"];
    if (lastId) {
        [param setObject:lastId forKey:@"lastid"];
    }
    
    if (rn) {
        [param setObject:rn forKey:@"rn"];
    }else{
        [param setObject:@"10" forKey:@"rn"];
    }
    
    if (type) {
        [param setObject:@"0" forKey:@"refresh_type"];
    }else{
        [param setObject:@"1" forKey:@"refresh_type"];
    }
    
    return [[TKRequestHandler sharedInstance]getRequestForPath:@"/v1/comment/get_list" param:param jsonName:@"LJCommentModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask, (LJCommentModel*)model, error);
        }
    }];
}

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
                                          finish:(void (^)(NSURLSessionDataTask *sessionDataTask, LJSubmitCommentModel *model , NSError *error))finish
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:infoId forKey:@"infoid"];
    if (replyCid) {
        [param setObject:replyCid forKey:@"reply_cid"];
    }
    
    if (replyUid) {
        [param setObject:replyUid forKey:@"reply_uid"];
    }
    
    [param setObject:content forKey:@"content"];

    return [[TKRequestHandler sharedInstance] postRequestForPath:@"v1/comment/create" param:param jsonName:@"LJSubmitCommentModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask, (LJSubmitCommentModel*)model, error);
        }
    }];
}

@end
