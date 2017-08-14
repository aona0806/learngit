//
//  TKRequestHandler+ConferenceDetail.m
//  news
//
//  Created by 陈龙 on 15/12/29.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler+ConferenceDetail.h"
#import "news-Swift.h"

@implementation TKRequestHandler (ConferenceDetail)

- (NSURLSessionDataTask * _Nonnull)getMeetingDetailWithId:(NSString * _Nonnull)idString
                                                fromsubid:(NSString * _Nullable)fromsubid
                                                complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJMeetingDetailModel * _Nullable model , NSError * _Nullable error))finish
{
    NSString *methodString = @"/v1/meeting/get_detail";
    NSString *path = [NSString stringWithFormat:@"%@%@",[NetworkManager apiHost],methodString];
    NSLog(@"idString:%@",idString);
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary: @{@"id":idString}];
    if (!fromsubid) {
        fromsubid = @"0";
    }
    [params setObject:fromsubid forKey:@"from_sub_id"];
    
    NSString *jsonName = [NSString stringWithCString:class_getName([LJMeetingDetailModel class])
                                            encoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *sessionDataTask = [[TKRequestHandler sharedInstance] getRequestForPath:path param:params jsonName:jsonName finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask, (LJMeetingDetailModel *)model, error);
        }
    }];
    return sessionDataTask;
}

@end
