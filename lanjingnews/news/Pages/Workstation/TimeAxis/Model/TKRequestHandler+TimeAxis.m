//
//  TKRequestHandler+TimeAxis.m
//  news
//
//  Created by 奥那 on 15/12/26.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler+TimeAxis.h"
#import "news-Swift.h"

@implementation TKRequestHandler (TimeAxis)
/**
 *  时间轴接口
 *
 *  @param fromTime 开始时间
 *  @param toTime   结束时间
 *  @param finish   完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask * _Nonnull)MarkPointTimeZhouDataWithFrom:(NSString * _Nonnull)fromTime
                                                          andTo:(NSString * _Nonnull)toTime
                                                         finish:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask,id _Nonnull response,NSError * _Nonnull error))finish{
    NSString *path = [NSString stringWithFormat:@"%@/plus/time_axis/search_simple",[NetworkManager apiHost]];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"d" forKey:@"type"];
    [param setObject:fromTime forKey:@"strtime"];
    [param setObject:toTime forKey:@"endtime"];
    
    return [[TKRequestHandler sharedInstance] getRequestForPath:path param:param finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {
        if (finish){
            finish(sessionDataTask,response,error);
        }
    }];
}


/**
 *  时间轴删除事件
 *
 *  @param eventId 事件id
 *  @param finish  完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask * _Nonnull)DeleteEventWithEventId:(NSString * _Nonnull)eventId  finish:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, id  _Nullable response , NSError * _Nullable error))finish{
    NSString *methodString = @"/plus/time_axis/remove";
    NSString *path = [NSString stringWithFormat:@"%@%@",[NetworkManager apiHost],methodString];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:eventId forKey:@"id"];
    
    return [[TKRequestHandler sharedInstance] postRequestForPath:path param:param finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {
        if (finish) {
            finish(sessionDataTask,response,error);
        }
    }];
}

/**
 *  时间轴添加事件
 *
 *  @param model  事件model
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask * _Nonnull)AddTimeAxisEventsWithModel:(LJTimeAxisDataListModel * _Nonnull)model
                                                      finish:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, id  _Nullable response , NSError * _Nullable error))finish{
    
    NSString *methodString = @"/plus/time_axis/new_info";

    NSString *path = [NSString stringWithFormat:@"%@%@",[NetworkManager apiHost],methodString];
    
    NSDictionary *param = [model toModifyDictionary];

    return [[TKRequestHandler sharedInstance] postRequestForPath:path param:param finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {
        if (finish) {
            finish(sessionDataTask,response,error);
        }
    }];
}

/**
 *  时间轴编辑事件
 *
 *  @param model   事件model
 *  @param eventId 事件id
 *  @param finish  完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask * _Nonnull)editTimeAxisEventsWithModel:(LJTimeAxisDataListModel * _Nonnull)model
                                                      eventId:(NSString *)eventId
                                                       finish:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, id  _Nullable response , NSError * _Nullable error))finish{
    
    NSString *methodString = @"/plus/time_axis/update_info";

    NSString *path = [NSString stringWithFormat:@"%@%@",[NetworkManager apiHost],methodString];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:[model toModifyDictionary]];
    [param setObject:eventId forKey:@"id"];
    
    return [[TKRequestHandler sharedInstance] postRequestForPath:path param:param finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {
        if (finish) {
            finish(sessionDataTask,response,error);
        }
    }];
}

/**
 *  时间轴接口
 *
 *  @param time   请求日期
 *  @param page   页数
 *  @param count  每页个数
 *  @param order
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask * _Nonnull)GetTimeDataWithTime:(NSString * _Nonnull)time
                                              andPage:(NSString * _Nonnull)page
                                             andCount:(NSString * _Nonnull)count
                                             andOrder:(NSString * _Nonnull)order
                                               finish:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask,LJTimeAxisModel * _Nonnull model,NSError * _Nonnull error))finish{
    
    NSString *path = [NSString stringWithFormat:@"%@/plus/time_axis/get_data_by_day",[NetworkManager apiHost]];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:time forKey:@"time"];
    [param setObject:page forKey:@"page"];
    [param setObject:count forKey:@"count"];
    [param setObject:order forKey:@"order"];
    
    return [[TKRequestHandler sharedInstance] getRequestForPath:path param:param jsonName:@"LJTimeAxisModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask,(LJTimeAxisModel *)model,error);
        }
    }];
}

/**
 *  时间轴事件详情
 *
 *  @param eventId 事件id
 *  @param finish  完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask * _Nonnull)GetEventsDecWithEventId:(NSString *_Nonnull)eventId finish:(void (^ _Nullable )(NSURLSessionDataTask * _Nonnull sessionDataTask,id _Nullable response,NSError * _Nullable error))finish{
    
    NSString *path = [NSString stringWithFormat:@"%@/plus/time_axis/get_one_by_id",[NetworkManager apiHost]];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:eventId forKey:@"id"];
    
    return [[TKRequestHandler sharedInstance] getRequestForPath:path param:param finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {
        if (finish) {
            finish(sessionDataTask,response,error);
        }
    }];
}

@end
