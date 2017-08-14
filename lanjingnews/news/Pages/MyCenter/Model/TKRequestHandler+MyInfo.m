//
//  TKRequestHandler+MyInfo.m
//  news
//
//  Created by 奥那 on 15/12/9.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler+MyInfo.h"
#import "news-Swift.h"
#import "TKUploader.h"
#import "NSData+ImageContentType.h"
#import "JPUSHService.h"

@implementation TKRequestHandler (MyInfo)


/**
 *  上传个人信息
 *
 *  @param model  用户信息
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *)postUserInfoWithModel:(LJUserInfoModel*)model finish:(void (^) (id responses,NSError *error))finish{
 
    NSString *path = [NSString stringWithFormat:@"%@/plus/user/userinfo_push",[NetworkManager apiHost]];
    
    NSDictionary *param = [model toModifyDictionary];
    
    return [[TKRequestHandler sharedInstance] postRequestForPath:path param:param finish:^(NSURLSessionDataTask *sessionDataTask,id response, NSError *error) {
        if (finish) {
            finish(response,error);
        }
    }];
    
}

/**
 *  上传用户头像数据
 *
 *  @param headerImage 头像图片
 *  @param finish      完成回调
 *
 *  @return 请求对象
 */
- (NSURLSessionDataTask *)postUserInfoAvator:(NSData *)avatorData finish:(void (^)(NSURLSessionDataTask *sessionDataTask ,id responses,NSError *error))finish{
    
    NSString *path = [NSString stringWithFormat:@"%@/upload/user",[NetworkManager api2Host]];

    return [[TKRequestHandler sharedInstance] postRequestForPath:path param:nil formData:^(id<AFMultipartFormData> formData) {
        
        NSString *mimeTypeString = [NSData sd_contentTypeForImageData:avatorData];
        NSString *fileNameString = [NSString stringWithFormat:@"userfile%d.%@",(int)[[NSDate date] timeIntervalSince1970],mimeTypeString];
        
        [formData appendPartWithFileData:avatorData name:@"file" fileName:fileNameString mimeType:mimeTypeString];
        
    } finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {
        if (finish) {
            finish(sessionDataTask,response,error);
        }
    }];
}

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
- (NSURLSessionDataTask *)getDiscussionListWithUid:(NSString *)uid
                                                rn:(NSString *)rn
                                            lastId:(NSString *)lastTid
                                       isUprefresh:(BOOL)isUprefresh
                                            finish:(void (^) (NSURLSessionDataTask *sessionDataTask, LJMyDiscussModel *model , NSError *error))finish{
    NSString *path = [NSString stringWithFormat:@"%@/community/usertopic_v2",[NetworkManager api2Host]];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject: lastTid forKey:@"last_tid"];
    [param setObject: uid forKey:@"uid"];
    [param setObject: rn forKey:@"rn"];
    if (!isUprefresh) {
        [param setObject:@"next" forKey:@"type"];
    }
    
    return [[TKRequestHandler sharedInstance] getRequestForPath:path param:param jsonName:@"LJMyDiscussModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        
        if (finish) {
            finish(sessionDataTask,(LJMyDiscussModel *)model,error);
        }
    }];
}


/**
 *  我的蓝鲸币流水
 *
 *  @param isUprefresh true 上拉刷新
 *                     false 下拉刷新
 *  @param finish      完成回调
 *
 *  @return 请求对象
 */
- (NSURLSessionDataTask *)getDollarsIsUpRefresh:(BOOL)isUprefresh
                                         finish:(void (^)(NSURLSessionDataTask *sessionDataTask,LJDollarsModel *model,NSError *error))finish{
    NSString *path = [NSString stringWithFormat:@"%@/1/currency/detail",[NetworkManager apiHost]];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"50" forKey:@"perct"];
    if (isUprefresh) {
        [param setObject:@"new" forKey:@"type"];
    }
    
    return [[TKRequestHandler sharedInstance] getRequestForPath:path param:param jsonName:@"LJDollarsModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask,(LJDollarsModel *)model,error);
        }
    }];
}

/**
 *  获取当前用户的推送设置
 *
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
- (NSURLSessionDataTask *) getPushInfoWithFinish:(void (^)(NSURLSessionDataTask *sessionDataTask,LJPushInfoModel *model, NSError *error))finish{
    
    NSString *path = [NSString stringWithFormat: @"%@/push/get_config",[NetworkManager api2Host]];

    return [[TKRequestHandler sharedInstance] getRequestForPath:path param:nil jsonName:@"LJPushInfoModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask,(LJPushInfoModel *)model,error);
        }
    }];

    
}

/**
 *  推送同步数据
 *
 *  @param configString 推送设置
 *  @param finish       完成回调
 *
 *  @return 请求对象
 */
- (NSURLSessionDataTask *) syncPushInfoConfig:(LJPushInfoDataConfigModel *)model finish:(void (^)(NSURLSessionDataTask *sessionDataTask,id response,NSError *error))finish{
    NSString *path = [NSString stringWithFormat:@"%@/push/update_config",[NetworkManager api2Host]];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];

    [param setObject:[model toMidifyString] forKey:@"config"];
    NSString *deviceType = [JPUSHService registrationID] ? [JPUSHService registrationID] : @"";
    [param setObject:deviceType forKey:@"xg_device_token"];
    [param setObject:@"2" forKey:@"device_type"];
    
    return [[TKRequestHandler sharedInstance] getRequestForPath:path param:param finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {
        if (finish) {
            finish(sessionDataTask,response,error);
        }
    }];
}


/**
 *  普通用户保存个人信息
 *
 *  @param model  用户model
 *  @param finish 完成回调
 *
 *  @return 请求对象
 */
- (NSURLSessionDataTask *)postNormalUserInfoWithModel:(LJUserInfoModel *)model finish:(void (^)(NSURLSessionDataTask *sessionDataTask,id response,NSError *error))finish{
    
    NSString *path = [NSString stringWithFormat:@"%@/1/user/setinfo",[NetworkManager apiHost]];
    
    NSDictionary *param = [model toNormalUserModifyDictionary];
    
    return [[TKRequestHandler sharedInstance] postRequestForPath:path param:param finish:^(NSURLSessionDataTask *sessionDataTask,id response, NSError *error) {
        if (finish) {
            finish(sessionDataTask,response,error);
        }
    }];
}



@end
