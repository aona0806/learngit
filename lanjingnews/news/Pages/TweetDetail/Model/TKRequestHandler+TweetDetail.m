//
//  TKRequestHandler+TweetDetail.m
//  news
//
//  Created by chunhui on 15/12/7.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler+TweetDetail.h"
#import "news-Swift.h"

@implementation TKRequestHandler (TweetDetail)

/**
 *  获取帖子详情
 *
 *  @param tid    帖子id
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *)getTweetDetailWithTid:(NSString *)tid finish:(void (^)(NSURLSessionDataTask *sessionDataTask, LJTweetDetailModel *model , NSError *error))finish
{
    NSAssert(tid.length > 0, @"get tweet detail tweet id must valid");
    
    NSString *path = [NSString stringWithFormat:@"%@/community/detail_v2",[NetworkManager api2Host]];
    NSDictionary *param = @{@"tid":tid};
    return [self getRequestForPath:path param:param jsonName:@"LJTweetDetailModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish){
            finish(sessionDataTask, (LJTweetDetailModel *)model,error);
        }
        
    }];
}

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
-(NSURLSessionDataTask *)getTweetCommentsWithTid:(NSString *)tid isNew:(BOOL)isNew lastCId:(NSString *)lastId finish:(void (^)(NSURLSessionDataTask *sessionDataTask, LJTweetCommentModel *model , NSError *error))finish
{
    NSAssert(tid.length > 0 , @"get tweet comment tid must valid");
    NSString *path =  [NSString stringWithFormat:@"%@/comment/topicmt",[NetworkManager api2Host]];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param addEntriesFromDictionary:@{@"tid":tid , @"type":isNew?@"new":@"next"}];
    if (!isNew ) {
        [param setObject:lastId?:@"0" forKey:@"last_cid"];
    }

    return [self getRequestForPath:path param:param jsonName:@"LJTweetCommentModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask, (LJTweetCommentModel*)model, error);
        }
    }];
}


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
-(NSURLSessionDataTask *)postCommentWithTid:(NSString *)tid content:(NSString *)content replayCid:(NSString *)rcid replayUid:(NSString *)ruid finish:(void(^)(NSURLSessionDataTask *sessionDataTask, NSString *cid , NSError *error))finish
{
    
    NSAssert(tid.length > 0 && content.length > 0, @"post comment tid and content must valid");
    
    NSString *path = [NSString stringWithFormat:@"%@/comment/newcmt",[NetworkManager api2Host]];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:tid forKey:@"tid"];
    [param setObject: content forKey:@"content"];
    if ( rcid.length > 0 && ruid.length > 0 ) {
        [param setObject: rcid  forKey:@"reply_cid"];
        [param setObject: ruid forKey:@"reply_uid"];
    }
    
    return [self postRequestForPath:path param:param finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {
        if ([response isKindOfClass:[NSData class]]) {
            
            @try {
                response = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
            }
            @catch (NSException *exception) {
                
            }
        }
        if (finish) {
                        
            NSString *cid = @"";
            if (error == nil) {
                NSDictionary *data =response[@"data"];
                if (data[@"cid"]) {
                    cid = [NSString stringWithFormat:@"%@",data[@"cid"]];
                }
                
                if (cid.length == 0 ) {
                    error = [NSError errorWithDomain:response[@"msg"] ?: GlobalConsts.NetRequestNoResult  code:1000 userInfo:nil];
                }
            }
            
            finish(sessionDataTask, cid, error);
        }
    }];
    
}

/**
 *  删除评论
 *
 *  @param cid    要删除的评论
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
- (NSURLSessionDataTask *) deleteCommentWithCid:(NSString *)cid
                        withComplete:(void(^)(NSURLSessionDataTask *sessionDataTask, BOOL isOK , NSError *error))finish
{
    
    NSAssert(cid.length > 0 , @"delete comment must set comment id");
    
    NSString *path = [NSString stringWithFormat:@"%@/comment/comment_delete",[NetworkManager api2Host]];

    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject: cid forKey:@"cid"];

    return [self getRequestForPath:path param:param finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {
    
        if (finish) {
            
            NSDictionary *data = (NSDictionary *)response;
            
            BOOL isOK = NO;
            if ([data[@"errno"] integerValue] == 0) {
                isOK = YES;
            }
            
            finish(sessionDataTask,isOK,error);
        }
        
    }];
    
}



@end
