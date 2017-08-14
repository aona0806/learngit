//
//  TKRequestHandler+Push.m
//  news
//
//  Created by 陈龙 on 15/12/28.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler+Push.h"
#import "news-Swift.h"

@implementation TKRequestHandler (Push)

/**
 *  进行设备绑定或者解绑定
 *
 *  @param pushToken push device token
 *  @param uid       0 或者用户 uid ， 为0时为解绑定
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *)pushBind:(NSString *)registerId deviceToken:(NSString *)token  uid:(NSString *)uid  completion:(void (^)(NSURLSessionDataTask *sessionDataTask, LJBaseJsonModel *model ,NSError *error))finish
{
    
    NSString *path = [NSString stringWithFormat:@"%@%@",[NetworkManager api2Host],@"/push/bind"];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:registerId forKey:@"xg_device_token"];
    [param setObject:@"2" forKey:@"device_type"];
    [param setObject:token?:@"" forKey:@"ios_device_token"];
    [param setObject:@"2" forKey:@"push_src"];
    [param setObject:uid forKey:@"uid"];
    
    
    NSURLSessionDataTask *sessionDataTask = [[TKRequestHandler sharedInstance] postRequestForPath:path param:param jsonName:@"LJBaseJsonModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask, (LJBaseJsonModel *)model, error);
        }
    }];
    return sessionDataTask;
}

-(NSURLSessionDataTask *)pushFeedbackMsgId:(NSString *)msgId timestamp:(NSTimeInterval)timestamp deviceToken:(NSString *)deviceToken completion:(void (^)(NSURLSessionDataTask *task , BOOL success ))completion
{
    if (msgId.length == 0 || deviceToken.length == 0) {
        
        NSLog(@" msg id is nil or device token is: nil");
        return nil;
    }
    
    NSDictionary *param = @{@"device_token":deviceToken,@"msg_id":msgId , @"timestamp":[NSString stringWithFormat:@"%.0f",timestamp]};
    NSMutableDictionary *mparam = [[NSMutableDictionary alloc]init];
    [mparam addEntriesFromDictionary:param];
    
    NSString *path = [NSString stringWithFormat:@"%@/push/statistics",[NetworkManager api2Host]];
    
    return [self postRequestForPath:path param:param finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {
        //        NSLog(@"push feed back response is: %@ \n error is: %@\n\n\n",response,error);
        BOOL success = false;
        if ( error == nil && response[@"data"] && [response[@"data"] integerValue] == 0) {
            success = true;
        }
        completion(sessionDataTask,success);
    }];
    
}

@end
