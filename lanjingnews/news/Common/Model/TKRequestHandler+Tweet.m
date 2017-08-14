//
//  TKRequestHandler+PublishTweet.m
//  news
//
//  Created by chunhui on 15/12/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler+Tweet.h"
#import "news-Swift.h"

@implementation TKRequestHandler (Tweet)

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
-(NSURLSessionTask *)publishTweetType:(NSString *)type title:(NSString *)title content:(NSString *)content tid:(NSString *)tid img:(NSArray<NSString *>*)imgs extends:(NSString *)extends finish:(void(^)(NSURLSessionTask *task , LJBaseJsonModel *model , NSError *error))finish
{
    
    NSString *path = [NSString stringWithFormat:@"%@/community/topic",[NetworkManager api2Host]];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    NSString *img = nil;
    if ([imgs count] > 0) {
        NSMutableString *str = [NSMutableString stringWithFormat:@"[\"%@\"",imgs[0]];
        for (int i = 1; i < [imgs count]; i++) {
            [str appendFormat:@",\"%@\"",imgs[i]];
        }
        [str appendString:@"]"];
        img = str;
    }else{
        img = @"";
    }
    
    param[@"type"] = type.length > 0 ? type:@"new";
    param[@"title"] = title?:@"";
    param[@"content"] = content?:@"";
    param[@"parent_tid"] = tid?:@"";
    param[@"img"] = img;
    if (extends.length > 0) {
        param[@"extends"] = extends;
    }

    return [self postRequestForPath:path param:param jsonName:@"LJBaseJsonModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            LJBaseJsonModel *baseModel = (LJBaseJsonModel *)model;
            if (baseModel) {
                if ([baseModel.dErrno integerValue] != 0 ){
                    error = [NSError errorWithDomain:baseModel.msg code:[baseModel.dErrno integerValue] userInfo:nil];
                }
            }            
            finish(sessionDataTask, (LJBaseJsonModel *)model,error);
        }
    }];
    
}

-(NSURLSessionDataTask *)deleteTweetWithTid:(NSString *)tid finish:(void (^)(NSURLSessionTask *task , BOOL isOK , NSError *error))finish
{

    NSString *path = [NSString stringWithFormat:@"%@/community/topic",[NetworkManager api2Host]];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject: @"delete" forKey:@"type"];
    [param setObject: tid forKey:@"tid"];
    
    return [self postRequestForPath:path param:param jsonName:@"LJBaseJsonModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        
        BOOL isOk = NO;
        LJBaseJsonModel *baseModel = (LJBaseJsonModel *)model;
        if (baseModel) {
            if ([baseModel.dErrno integerValue] == 0) {
                isOk = YES;
            }else if (baseModel.msg.length > 0){
                error = [NSError errorWithDomain:baseModel.msg code:baseModel.dErrno.integerValue userInfo:nil];
            }
        }
        
        if (finish) {
            finish(sessionDataTask,isOk,error);
        }
        
    }];
    
    
}

-(NSURLSessionDataTask *)praise:(BOOL)add WithTid:(NSString *)tid finish:(void(^)(NSURLSessionDataTask *task , BOOL isOk , NSError *error))finish
{
    NSString *path = [NSString stringWithFormat:@"%@/zan/%@",[NetworkManager api2Host],add?@"add":@"cancel"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    param[@"tid"] = tid;
    
    return [self postRequestForPath:path param:param finish:^(NSURLSessionDataTask *sessionDataTask, id response , NSError *error){
        
        BOOL success = NO;
        NSInteger errNum = [response[@"errno"] integerValue];
        if ( errNum == 0) {
            success = YES;
        }else{
            NSString *errMsg = response[@"msg"];
            if (errMsg.length > 0) {
                error = [NSError errorWithDomain:errMsg code:errNum userInfo:nil];
            }
        }
        
        finish(sessionDataTask,success,error);                
    }];
    
}


@end
