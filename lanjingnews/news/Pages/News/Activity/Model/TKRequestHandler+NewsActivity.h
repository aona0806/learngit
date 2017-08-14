//
//  TKRequestHandler+NewsActivity.h
//  news
//
//  Created by 陈龙 on 16/1/9.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"
#import "NewsActivityDetailModel.h"

@interface TKRequestHandler (NewsActivity)

/**
 *  1.获取活动详情
 *
 *  @param tid    <#tid description#>
 *  @param finish <#finish description#>
 *
 *  @return <#return value description#>
 */
- (NSURLSessionDataTask * _Nonnull)getNewsActivityDetail:(NSInteger)tid
                                               fromSubId:(NSString * _Nullable)fromSubId
                                               complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, NewsActivityDetailModel * _Nullable model , NSError * _Nullable error))finish;

/**
 *  2.活动报名
 *
 *  @param name   <#name description#>
 *  @param phone  <#phone description#>
 *  @param aid    <#aid description#>
 *  @param finish <#finish description#>
 *
 *  @return <#return value description#>
 */
- (NSURLSessionDataTask * _Nonnull)postActivitySubscribeWithName:(NSString * _Nonnull)name
                                                           phone:(NSString * _Nonnull)phone
                                                             aid:(NSString * _Nonnull)aid
                                                       complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJBaseJsonModel * _Nullable model , NSError * _Nullable error))finish;
@end
