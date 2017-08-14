//
//  TKRequestHandler+Conference.m
//  news
//
//  Created by 陈龙 on 15/12/23.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler+Conference.h"
#import "news-Swift.h"

@implementation TKRequestHandler (Conference)

- (NSURLSessionDataTask * _Nonnull)getMeetListWithLastTime:(NSString *)last_time
                                                        rn:(NSInteger)rn
                                              refresh_type:(TKDataFreshType)refresh_type
                                                       complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJMeetListModel * _Nullable model , NSError * _Nullable error))finish
{
    NSString *methodString = @"/v1/meeting/get_list";
    NSString *path = [NSString stringWithFormat:@"%@%@",[NetworkManager apiHost],methodString];
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
    
    NSString *type = (refresh_type == TKDataFreshTypeRefresh) ? @"0" : @"1";
    if (last_time) {
        [mDic setObject: last_time forKey:@"last_time"];
    }
    [mDic setObject: [NSString stringWithFormat:@"%ld",(long)rn] forKey:@"rn"];
    [mDic setObject: type  forKey:@"refresh_type"];
    
    NSString *jsonName = [NSString stringWithCString:class_getName([LJMeetListModel class])
                                            encoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *sessionDataTask = [[TKRequestHandler sharedInstance] getRequestForPath:path param:mDic jsonName:jsonName finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask, (LJMeetListModel *)model, error);
        }
    }];
    return sessionDataTask;
}

- (NSURLSessionDataTask * _Nonnull)postSubscribeMeeting:(NSString * _Nonnull)meetingId
                                            isSubscribe:(BOOL)isSubscribe
                                              complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJBaseJsonModel * _Nullable model , NSError * _Nullable error))finish
{

    
    NSString *methodString = isSubscribe ? @"/v1/meeting_operation/subscribe" : @"/v1/meeting_operation/un_subscribe";
    NSString *path = [NSString stringWithFormat:@"%@%@",[NetworkManager apiHost],methodString];
    NSDictionary *params = @{@"meeting_id":meetingId};
    
    NSString *jsonName = [NSString stringWithCString:class_getName([LJBaseJsonModel class])
                                            encoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *sessionDataTask = [[TKRequestHandler sharedInstance] getRequestForPath:path param:params jsonName:jsonName finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask, (LJBaseJsonModel *)model, error);
        }
    }];
    return sessionDataTask;
}

- (NSURLSessionDataTask * _Nonnull)getHistoryMeetListWithLastTime:(NSString * _Nullable)last_time
                                                        rn:(NSInteger)rn
                                              refresh_type:(TKDataFreshType)refresh_type
                                                 complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJHistoryMeetListModel * _Nullable model , NSError * _Nullable error))finish
{
    NSString *methodString = @"/v1/meeting/get_history";
    NSString *path = [NSString stringWithFormat:@"%@%@",[NetworkManager apiHost],methodString];
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
    
    NSString *type = (refresh_type == TKDataFreshTypeRefresh) ? @"0" : @"1";
    if (last_time) {
        [mDic setObject: last_time forKey:@"last_time"];
    }
    [mDic setObject: [NSString stringWithFormat:@"%ld",(long)rn] forKey:@"rn"];
    [mDic setObject: type  forKey:@"refresh_type"];
    
    NSString *jsonName = [NSString stringWithCString:class_getName([LJHistoryMeetListModel class])
                                            encoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *sessionDataTask = [[TKRequestHandler sharedInstance] getRequestForPath:path param:mDic jsonName:jsonName finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask, (LJHistoryMeetListModel *)model, error);
        }
    }];
    return sessionDataTask;
}

- (NSURLSessionDataTask * _Nonnull)getReservationMeetListWithLastTime:(NSString * _Nullable)last_time
                                                                   rn:(NSInteger)rn
                                                         refresh_type:(TKDataFreshType)refresh_type
                                                            complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJReservationMeetListModel * _Nullable model , NSError * _Nullable error))finish
{
    NSString *methodString = @"/v1/meeting/get_reservation";
    NSString *path = [NSString stringWithFormat:@"%@%@",[NetworkManager apiHost],methodString];
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
    
    NSString *type = (refresh_type == TKDataFreshTypeRefresh) ? @"0" : @"1";
    if (last_time) {
        [mDic setObject: last_time forKey:@"last_time"];
    }
    [mDic setObject: [NSString stringWithFormat:@"%ld",(long)rn] forKey:@"rn"];
    [mDic setObject: type  forKey:@"refresh_type"];
    
    NSString *jsonName = [NSString stringWithCString:class_getName([LJReservationMeetListModel class])
                                            encoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *sessionDataTask = [[TKRequestHandler sharedInstance] getRequestForPath:path param:mDic jsonName:jsonName finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask, (LJReservationMeetListModel *)model, error);
        }
    }];
    return sessionDataTask;
}




@end
