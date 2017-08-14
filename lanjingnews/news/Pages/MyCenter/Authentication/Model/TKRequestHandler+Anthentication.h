//
//  TKRequestHandler+Anthentication.h
//  news
//
//  Created by 奥那 on 16/1/8.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"
#import "LJUserInfoModel.h"
#import "LJRecommendModel.h"

@interface TKRequestHandler (Anthentication)

/**
 *  验证邀请码
 *
 *  @param code   邀请码
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
- (NSURLSessionDataTask *)checkInvitationCodeWithCode:(NSString *)code finish:(void (^)(NSURLSessionDataTask *sessionDataTask,id response,NSError *error))finish;

/**
 *  认证后完善个人资料
 *
 *  @param model  用户model
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
- (NSURLSessionDataTask *)postCompleteInfoWithModel:(LJUserInfoModel *)model finish:(void (^)(NSURLSessionDataTask *sessionDataTask,id response,NSError *error))finish;

/**
 *  上传手机联系人
 *
 *  @param mobileListArray 手机联系人
 *  @param finish          完成回调
 *
 *  @return 请求对象
 */
- (NSURLSessionDataTask *)postAddressListFinish:(void (^)(NSURLSessionDataTask *sessionDataTask,id response,NSError *error))finish;

/**
 *  获取推荐关注列表
 *
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
- (NSURLSessionDataTask *)getRecommendListFinish:(void (^)(NSURLSessionDataTask *sessionDataTask,id response,NSError *error))finish;

/**
 *  批量关注
 *
 *  @param followerUid 用户id
 *  @param finish      完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *)focusManyPersonWithFollowerUid:(NSString *)followerUid Finish:(void (^)(NSURLSessionDataTask *sessionDataTask,id response,NSError *error))finish;

@end
