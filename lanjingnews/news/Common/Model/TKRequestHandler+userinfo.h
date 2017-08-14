//
//  TKRequestHandler+userinfo.h
//  news
//
//  Created by chunhui on 15/12/23.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"
#import "LJUserInfoRequestModel.h"
#import "LJRelationFollowModel.h"


@interface TKRequestHandler (userinfo)

/**
 *  拉取用户信息
 *
 *  @param uid    用户uid
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
-( NSURLSessionDataTask  *_Nullable)getUserInfoWithUid:( NSString * _Nonnull )uid finish:(void (^_Nullable)( NSURLSessionDataTask *_Nonnull sessionDataTask,  LJUserInfoRequestModel *_Nullable model , NSError *_Nullable error))finish;

/**
 *  用户关系变更 当前用户对其他人的关系
 *
 *  @param isFollow    yes 关注  no 取消关注
 *  @param myUid       我的uid
 *  @param followerUid 被关注的用户的uid
 *  @param finish      完成回调
 *
 *  @return 请求对象
 */
- ( NSURLSessionDataTask *_Nullable) postModifyUserRelation:(BOOL)isFollow
                                            myUid:(NSString *_Nullable)myUid
                                      followerUid:(NSString *_Nonnull)followerUid
                                        completion:(void (^_Nullable)(NSURLSessionDataTask *_Nonnull sessionDataTask, LJRelationFollowModel *_Nullable model , NSError * _Nullable  error))finish;

@end
