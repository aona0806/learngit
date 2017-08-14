//
//  TKRequestHandler+Community.m
//  news
//
//  Created by chunhui on 15/12/21.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler+Community.h"
#import "news-Swift.h"

@implementation TKRequestHandler (Community)

-(NSURLSessionDataTask *)getCommunityTweetListIsNew:(BOOL)isNew lastTid:(NSString *)lastTid finish:(void (^)(NSURLSessionDataTask *sessionDataTask, LJTweetModel *model , NSError *error))finish
{
    return [self getCommunityTweetListIsNew:isNew lastTid:lastTid industry:nil finish:finish];
}

-(NSURLSessionDataTask *)getCommunityTweetListIsNew:(BOOL)isNew lastTid:(NSString *)lastTid industry:(NSString *)industry  finish:(void (^)(NSURLSessionDataTask *sessionDataTask, LJTweetModel *model , NSError *error))finish
{
    
    NSString *path = [NSString stringWithFormat:@"%@/community/home_v2",[NetworkManager api2Host]];
    if (lastTid.length == 0) {
        lastTid = @"0";
    }
    
    NSDictionary *param = @{@"type":isNew?@"new":@"next",@"last_tid":lastTid,@"industry":industry?:@"全部"};
    
    return [[TKRequestHandler sharedInstance] getRequestForPath:path param:param jsonName:@"LJTweetModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask,(LJTweetModel *)model,error);
        }
    }];
    
}


-(NSURLSessionDataTask *)getCommunityRedDotFinish:(void (^)(NSURLSessionDataTask *sessionDataTask, CommunityRedDotModel *model , NSError *error))finish
{

    NSString *path = [NSString stringWithFormat:@"%@/info/unread_num",[NetworkManager api2Host]];
    
    return [[TKRequestHandler sharedInstance] getRequestForPath:path param:nil jsonName:@"CommunityRedDotModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        
        if (finish) {
            finish(sessionDataTask,(CommunityRedDotModel *)model,error);
        }
        
    }];
    
}

@end
