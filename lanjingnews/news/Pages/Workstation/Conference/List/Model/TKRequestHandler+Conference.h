//
//  TKRequestHandler+Conference.h
//  news
//
//  Created by 陈龙 on 15/12/23.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"
#import "LJMeetListModel.h"
#import "LJBaseJsonModel.h"
#import "LJHistoryMeetListModel.h"
#import "LJReservationMeetListModel.h"

@interface TKRequestHandler (Conference)

/**
 *  1.1 所有预约会议列表
 *
 *  @param last_time    option 最后一条数据的开始时间start_time，默认请求时间
 *  @param rn           option 每页数量，默认20
 *  @param refresh_type option int	0:下拉刷新,1:上拉加载更多-历史
 *  @param complation   complation description
 *
 *  @return <#return value description#>
 */
- (NSURLSessionDataTask * _Nonnull)getMeetListWithLastTime:(NSString * _Nullable)last_time
                                                        rn:(NSInteger)rn
                                              refresh_type:(TKDataFreshType)refresh_type
                                                 complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJMeetListModel * _Nullable model, NSError * _Nullable error))finish;

/**
 *  1.2 预约会议
 *
 *  @param meetingId  <#meetingId description#>
 *  @param isSubscribe YES: 预约会议 NO：取消预约
 *  @param complation <#complation description#>
 *
 *  @return | 数值 | 说明 |
 | -------- | -------- :|
 | 10006 | 用户授权不正确 |
 | 10015 | meeting_id参数不合法 |
 | 21206 | 已经预约该会议 |
 | 20401 | 新增信息失败 |
 | 21205 | 当前阶段会议不允许预约 |
 */
- (NSURLSessionDataTask * _Nonnull)postSubscribeMeeting:(NSString * _Nonnull)meetingId
                                            isSubscribe:(BOOL)isSubscribe
                                              complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJBaseJsonModel * _Nullable model , NSError * _Nullable error))finish;

/**
 *  13.3 历史会议列表
 *
 *  @param last_time    最后一条数据的开始时间start_time，默认请求时间
 *  @param rn           每页数量，默认20
 *  @param refresh_type 0:下拉刷新,1:上拉加载更多-历史
 *  @param complation   <#complation description#>
 *
 *  @return <#return value description#>
 */
- (NSURLSessionDataTask * _Nonnull)getHistoryMeetListWithLastTime:(NSString * _Nullable)last_time
                                                               rn:(NSInteger)rn
                                                     refresh_type:(TKDataFreshType)refresh_type
                                                        complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJHistoryMeetListModel * _Nullable model , NSError * _Nullable error))finish;
/**
 *  1.4 获取我的会议列表
 *
 *  @param last_time    <#last_time description#>
 *  @param rn           <#rn description#>
 *  @param refresh_type <#refresh_type description#>
 *  @param finish       <#finish description#>
 *
 *  @return <#return value description#>
 */
- (NSURLSessionDataTask * _Nonnull)getReservationMeetListWithLastTime:(NSString * _Nullable)last_time
                                                                   rn:(NSInteger)rn
                                                         refresh_type:(TKDataFreshType)refresh_type
                                                            complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJReservationMeetListModel * _Nullable model , NSError * _Nullable error))finish;

@end
