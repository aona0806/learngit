//
//  TKRequestHandler+ConferenceDetail.h
//  news
//
//  Created by 陈龙 on 15/12/29.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"
#import "LJMeetingDetailModel.h"

@interface TKRequestHandler (ConferenceDetail)

/**
 *  1.5 获取会议详情数据
 *
 *  @param idString <#idString description#>
 *  @param finish   <#finish description#>
 *
 *  @return <#return value description#>
 */
- (NSURLSessionDataTask * _Nonnull)getMeetingDetailWithId:(NSString * _Nonnull)idString
                                                fromsubid:(NSString * _Nullable)fromsubid
                                                complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJMeetingDetailModel * _Nullable model , NSError * _Nullable error))finish;

@end
