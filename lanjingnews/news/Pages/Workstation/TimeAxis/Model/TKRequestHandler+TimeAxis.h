//
//  TKRequestHandler+TimeAxis.h
//  news
//
//  Created by 奥那 on 15/12/26.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"
#import "LJTimeAxisDataListModel+ModifyInfo.h"

@interface TKRequestHandler (TimeAxis)
/**
 *  时间轴添加事件
 *
 *  @param model  事件model
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask * _Nonnull)AddTimeAxisEventsWithModel:
(LJTimeAxisDataListModel * _Nonnull)model finish:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, id  _Nullable response , NSError * _Nullable error))finish;
/**
 *  时间轴编辑事件
 *
 *  @param model   事件model
 *  @param eventId 事件id
 *  @param finish  完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask * _Nonnull)editTimeAxisEventsWithModel:
(LJTimeAxisDataListModel * _Nonnull)model eventId:(NSString *_Nonnull)eventId finish:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, id  _Nullable response , NSError * _Nullable error))finish;

/**
 *  时间轴删除事件
 *
 *  @param eventId 事件id
 *  @param finish  完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask * _Nonnull)DeleteEventWithEventId:(NSString * _Nonnull)eventId  finish:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, id  _Nullable response , NSError * _Nullable error))finish;

/**
 *  时间轴接口
 *
 *  @param time   <#time description#>
 *  @param page   <#page description#>
 *  @param count  <#count description#>
 *  @param order  <#order description#>
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask * _Nonnull)GetTimeDataWithTime:(NSString * _Nonnull)time
                                              andPage:(NSString * _Nonnull)page
                                             andCount:(NSString * _Nonnull)count
                                             andOrder:(NSString * _Nonnull)order
                                               finish:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask,LJTimeAxisModel * _Nullable model,NSError * _Nullable error))finish;
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
                                                         finish:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask,id _Nullable response,NSError * _Nullable error))finish;



/**
 *  时间轴事件详情
 *
 *  @param eventId 事件id
 *  @param finish  完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask * _Nonnull)GetEventsDecWithEventId:(NSString *_Nonnull)eventId finish:(void (^ _Nullable )(NSURLSessionDataTask * _Nonnull sessionDataTask,id _Nullable response,NSError * _Nullable error))finish;

@end
