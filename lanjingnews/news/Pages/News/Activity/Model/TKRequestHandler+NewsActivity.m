//
//  TKRequestHandler+NewsActivity.m
//  news
//
//  Created by 陈龙 on 16/1/9.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "TKRequestHandler+NewsActivity.h"
#import "news-Swift.h"

@implementation TKRequestHandler (NewsActivity)

- (NSURLSessionDataTask * _Nonnull)getNewsActivityDetail:(NSInteger)tid
                                               fromSubId:(NSString * _Nullable)fromSubId
                                               complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, NewsActivityDetailModel * _Nullable model , NSError * _Nullable error))finish{
    
    
    NSString *methodString = @"/v1/activity/get_detail";
    
    NSString *path = [NSString stringWithFormat:@"%@%@",[NetworkManager apiHost],methodString];
    NSString *tidString = [NSString stringWithFormat:@"%ld",(long)tid];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"id":tidString}];
    if (fromSubId == nil) {
        fromSubId = @"0";
    }
    [param setObject:fromSubId forKey:@"from_sub_id"];
    
    NSString *jsonName = [NSString stringWithCString:class_getName([NewsActivityDetailModel class])
                                            encoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *sessionDataTask = [[TKRequestHandler sharedInstance] getRequestForPath:path param:param jsonName:jsonName finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask, (NewsActivityDetailModel *)model, error);
        }
    }];
    return sessionDataTask;
}

- (NSURLSessionDataTask * _Nonnull)postActivitySubscribeWithName:(NSString * _Nonnull)name
                                                           phone:(NSString * _Nonnull)phone
                                                             aid:(NSString * _Nonnull)aid
                                                       complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJBaseJsonModel * _Nullable model , NSError * _Nullable error))finish
{
    
    
    NSString *methodString = @"/v1/activity/subscribe";
    
    NSString *path = [NSString stringWithFormat:@"%@%@",[NetworkManager apiHost],methodString];
    NSDictionary *param = @{@"name":name, @"phone":phone, @"id":aid};
    
    NSString *jsonName = [NSString stringWithCString:class_getName([LJBaseJsonModel class])
                                            encoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *sessionDataTask = [[TKRequestHandler sharedInstance] postRequestForPath:path param:param jsonName:jsonName finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask, (LJBaseJsonModel *)model, error);
        }
    }];
    return sessionDataTask;
}

@end
