//
//  TKRequestHandler+MyInfo.h
//  news
//
//  Created by 奥那 on 15/12/9.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"
#import "LJUserInfoModel.h"
#import "LJMyDiscussModel.h"
#import "LJDollarsModel.h"
#import "LJUserInfoModel+ModifyInfo.h"
#import "LJPushInfoModel+ModifyInfo.h"

@interface TKRequestHandler (MyInfo)

/**
 *  上传个人信息
 *
 *  @param model  用户信息
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *_Nullable)postUserInfoWithModel:(LJUserInfoModel* _Nonnull)model finish:(void ( ^_Nullable) (id _Nullable responses, NSError *_Nullable error))finish;

/**
 *  上传用户头像数据
 *
 *  @param fileName 图片文件
 *  @param finish   完成回调
 *
 *  @return 请求参数
 */
- (NSURLSessionDataTask *_Nullable)postUserInfoAvator:(NSData *_Nonnull )avatorData finish:(void (^_Nullable)(NSURLSessionDataTask *_Nullable sessionDataTask ,id _Nullable responses,NSError *_Nullable error))finish;

/**
 *  我的讨论
 *
 *  @param uid         用户id
 *  @param rn          <#rn description#>
 *  @param lastTid     <#lastTid description#>
 *  @param isUprefresh true 上拉刷新
 *                     false 下拉刷新

 *  @param finish      完成回调
 *
 *  @return 请求对象
 */
- (NSURLSessionDataTask *_Nullable)getDiscussionListWithUid:(NSString * _Nonnull)uid
                                                rn:(NSString *_Nullable)rn
                                       lastId:(NSString *_Nullable)lastTid
                                  isUprefresh:(BOOL)isUprefresh
                                 finish:(void (^_Nullable) (NSURLSessionDataTask *_Nonnull sessionDataTask, LJMyDiscussModel *_Nullable model , NSError * _Nullable error))finish;

/**
 *  我的蓝鲸币流水
 *
 *  @param isUprefresh true 上拉刷新
 *                     false 下拉刷新
 *  @param finish      完成回调
 *
 *  @return 请求对象
 */
- (NSURLSessionDataTask *_Nullable)getDollarsIsUpRefresh:(BOOL)isUprefresh
                                         finish:(void (^_Nullable)(NSURLSessionDataTask *_Nonnull sessionDataTask,LJDollarsModel *_Nullable model,NSError *_Nullable error))finish;

/**
 *  获取当前用户的推送设置
 *
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
- (NSURLSessionDataTask *_Nullable) getPushInfoWithFinish:(void (^_Nullable)(NSURLSessionDataTask *_Nullable sessionDataTask,LJPushInfoModel *_Nullable model, NSError *_Nullable error))finish;

/**
 *  推送同步数据
 *
 *  @param configString 推送设置
 *  @param isNormal     判断是否普通用户
 *  @param finish       完成回调
 *
 *  @return 请求对象
 */
- (NSURLSessionDataTask *_Nullable) syncPushInfoConfig:(LJPushInfoDataConfigModel *_Nonnull )model finish:(void (^_Nullable)(NSURLSessionDataTask *_Nullable sessionDataTask,id _Nullable response,NSError *_Nullable error))finish;



/**
 *  普通用户保存个人信息
 *
 *  @param model  用户model
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
- (NSURLSessionDataTask *_Nullable)postNormalUserInfoWithModel:(LJUserInfoModel * _Nonnull)model finish:(void (^_Nullable)(NSURLSessionDataTask *_Nullable sessionDataTask,id _Nullable response,NSError *_Nullable error))finish;



@end
