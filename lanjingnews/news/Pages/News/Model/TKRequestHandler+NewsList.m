//
//  TKRequestHandler+NewsList.m
//  news
//
//  Created by 陈龙 on 16/1/8.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "TKRequestHandler+NewsList.h"
#import "news-Swift.h"

@implementation TKRequestHandler (NewsList)

- (NSURLSessionDataTask * _Nonnull)getNewsListFeed:(NSInteger)type
                                          lastTime:(NSString *_Nonnull)lastCtime
                                                rn:(NSInteger)rn
                                       refreshType:(TKDataFreshType)refreshType
                                         complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJNewsListModel * _Nullable model , NSError * _Nullable error))finish
{
    
    NSString *path = [NSString stringWithFormat:@"%@/v1/feed/get_list",[NetworkManager apiHost]];
    NSString *rnString = [NSString stringWithFormat:@"%d",(int)rn];
    NSString *typeString = [NSString stringWithFormat:@"%d",(int)type];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"type":typeString, @"last_time":lastCtime, @"rn":rnString}];
    NSString *refreshTypeString = (refreshType == TKDataFreshTypeRefresh ? @"0" : @"1");
    [param setObject:refreshTypeString forKey:@"refresh_type"];
    
    NSString *jsonName = [NSString stringWithCString:class_getName([LJNewsListModel class])
                                            encoding:NSUTF8StringEncoding];

    NSURLSessionDataTask *sessionDataTask = [[TKRequestHandler sharedInstance] getRequestForPath:path param:param jsonName:jsonName finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            
            finish(sessionDataTask, (LJNewsListModel *)model, error);
        }
    }];
    return sessionDataTask;
}
@end
