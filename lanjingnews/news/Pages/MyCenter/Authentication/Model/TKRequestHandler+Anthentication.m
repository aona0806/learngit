//
//  TKRequestHandler+Anthentication.m
//  news
//
//  Created by 奥那 on 16/1/8.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "TKRequestHandler+Anthentication.h"
#import "news-Swift.h"
#import "UserAddressBook.h"

@implementation TKRequestHandler (Anthentication)

/**
 *  验证邀请码
 *
 *  @param code   邀请码
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
- (NSURLSessionDataTask *)checkInvitationCodeWithCode:(NSString *)code finish:(void (^)(NSURLSessionDataTask *sessionDataTask,id response,NSError *error))finish{
    
    NSString *path = [NSString stringWithFormat:@"%@/plus/invite/verify_invite",[NetworkManager apiHost]];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:code forKey:@"invite_code"];
    
    return [[TKRequestHandler sharedInstance] getRequestForPath:path param:param finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {
        if (finish) {
            finish(sessionDataTask,response,error);
        }
    }];
}

/**
 *  认证后完善个人资料
 *
 *  @param model  用户model
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
- (NSURLSessionDataTask *)postCompleteInfoWithModel:(LJUserInfoModel *)model finish:(void (^)(NSURLSessionDataTask *sessionDataTask,id response,NSError *error))finish{
    
    NSString *path = [NSString stringWithFormat:@"%@/1/user/verify",[NetworkManager apiHost]];
    
    NSDictionary *param = [model toCompleteInfoDictionary];
    
    return [[TKRequestHandler sharedInstance] postRequestForPath:path param:param finish:^(NSURLSessionDataTask *sessionDataTask,id response, NSError *error) {
        if (finish) {
            finish(sessionDataTask,response,error);
        }
    }];
    
}

/**
 *  上传手机联系人
 *
 *  @param mobileListArray 手机联系人
 *  @param finish          完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *)postAddressListFinish:(void (^)(NSURLSessionDataTask *sessionDataTask,id response,NSError *error))finish{
    
    NSString *path = [NSString stringWithFormat:@"%@/1/phonebook/user_phone_book",[NetworkManager apiHost]];
    
    NSString *uid = [AccountManager sharedInstance].uid;
    //获取手机通讯录
    NSArray *mobileListArray = [UserAddressBook getAddressBooks];
    
    NSDictionary *noteDic = [NSDictionary dictionaryWithObjectsAndKeys:uid ,@"uid",@"12345",@"imei",mobileListArray,@"data",nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:noteDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:string forKey:@"phone_list"];
    
    return [[TKRequestHandler sharedInstance] postRequestForPath:path param:param finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {
        if (finish) {
            finish(sessionDataTask,response,error);
        }
    }];
}

/**
 *  获取推荐关注列表
 *
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
- (NSURLSessionDataTask *)getRecommendListFinish:(void (^)(NSURLSessionDataTask *sessionDataTask,id response,NSError *error))finish{
    NSString *path = [NSString stringWithFormat:@"%@/recommend/new_user_recommend",[NetworkManager api2Host]];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"0" forKey:@"pn"];
    [param setObject:@"10" forKey:@"rn"];
    
    return [[TKRequestHandler sharedInstance] getRequestForPath:path param:param jsonName:@"LJRecommendModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask,model,error);
        }
    }];
}

/**
 *  批量关注
 *
 *  @param followerUid 用户id
 *  @param finish      完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *)focusManyPersonWithFollowerUid:(NSString *)followerUid Finish:(void (^)(NSURLSessionDataTask *sessionDataTask,id response,NSError *error))finish{
    
    NSString *path = [NSString stringWithFormat:@"%@/relation/follow",[NetworkManager api2Host]];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:followerUid forKey:@"follower_uid"];
    
    return [[TKRequestHandler sharedInstance] postRequestForPath:path param:param finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {
        if (finish) {
            finish(sessionDataTask,response,error);
        }
    }];

}
@end
