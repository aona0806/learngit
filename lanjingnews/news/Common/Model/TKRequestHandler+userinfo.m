//
//  TKRequestHandler+userinfo.m
//  news
//
//  Created by chunhui on 15/12/23.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler+userinfo.h"
#import "news-Swift.h"

@implementation TKRequestHandler (userinfo)

-(NSURLSessionDataTask *)getUserInfoWithUid:(NSString *)uid finish:(void (^)(NSURLSessionDataTask *sessionDataTask, LJUserInfoRequestModel *model , NSError *error))finish
{
    NSAssert(uid.length > 0, @"load user info uid must valid");
    
    NSDictionary *param = @{@"uid":uid};

    return [self getRequestForPath:@"/1/user/getinfo" param:param jsonName:@"LJUserInfoRequestModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        
        if (finish) {
            finish(sessionDataTask,(LJUserInfoRequestModel *)model,error);
        }
    }];
    
}

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
- (NSURLSessionDataTask *) postModifyUserRelation:(BOOL)isFollow
                                            myUid:(NSString *)myUid
                                      followerUid:(NSString *)followerUid
                                       completion:(void (^)(NSURLSessionDataTask *sessionDataTask, LJRelationFollowModel * model , NSError *   error))finish
{
    
    NSAssert(followerUid.length > 0, @"modify user relation");
    
    NSString *methodString = isFollow ? @"/relation/follow" : @"/relation/unfollow";
    NSString *path = [NSString stringWithFormat:@"%@%@",[NetworkManager api2Host],methodString];
    if (myUid.length == 0) {
        myUid = [[AccountManager sharedInstance] uid];
    }
    
    NSDictionary *param =  @{@"uid":followerUid,@"follower_uid":myUid?:@""};
    
    NSURLSessionDataTask *sessionDataTask = [[TKRequestHandler sharedInstance] getRequestForPath:path param:param jsonName:@"LJRelationFollowModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask, (LJRelationFollowModel *)model, error);
        }
    }];
    
    return sessionDataTask;
}

@end
