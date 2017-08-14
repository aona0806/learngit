//
//  TKRequestHandler+LoginAndRegist.m
//  news
//
//  Created by 奥那 on 16/1/5.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "TKRequestHandler+LoginAndRegist.h"
#import "news-Swift.h"

@implementation TKRequestHandler (LoginAndRegist)
/**
 *  登录
 *
 *  @param phone    手机号
 *  @param passWord 密码
 *  @param finish   完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *)loginWithPhoneNumber:(NSString *)phone passWord:(NSString *)passWord finish:(void (^) (NSURLSessionDataTask *sessionDataTask,id responses, NSError *error))finish{
    
    NSString *path = [NSString stringWithFormat:@"%@/1/user/login",[NetworkManager apiHost]];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:phone forKey:@"uname"];
    [param setObject:passWord forKey:@"password"];
    
    return [[TKRequestHandler sharedInstance] postRequestForPath:path param:param finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {
        if (finish) {
            finish(sessionDataTask,response,error);
        }
    }];
    
}

/**
 *  注册新用户
 *
 *  @param phone      手机号
 *  @param passWord   密码
 *  @param captcha    验证码
 *  @param nickname   昵称
 *  @param identifier 获取验证码后的返回值
 *  @param finish     完成回调
 *
 *  @return 请求对象
 */
- (NSURLSessionDataTask *)registWithPhoneNmuber:(NSString *)phone passWord:(NSString *)passWord captcha:(NSString *)captcha nickname:(NSString *)nickname identifier:(NSString *)identifier finish:(void (^) (NSURLSessionDataTask *sessionDataTask,id responses, NSError *error))finish{
    
    NSString *path = [NSString stringWithFormat:@"%@/1/user/register",[NetworkManager apiHost]];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:phone forKey:@"uname"];
    [param setObject:passWord forKey:@"password"];
    [param setObject:captcha forKey:@"captcha"];
    [param setObject:nickname forKey:@"nickname"];
    [param setObject:identifier forKey:@"identifier"];
    
    return [[TKRequestHandler sharedInstance] postRequestForPath:path param:param finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {
        if (finish) {
            finish(sessionDataTask,response,error);
        }
    }];
}

/**
 *  注册发送验证码
 *
 *  @param phoneNumber 手机号
 *  @param finish      完成回调
 *
 *  @return 请求对象
 */
- (NSURLSessionDataTask *)registSendCaptchaWithPhoneNumber:(NSString *)phoneNumber ticket:(NSString *)ticket captcha:(NSString *)captcha finish:(void (^) (NSURLSessionDataTask *sessionDataTask,id responses, NSError *error))finish{
    
    NSString *path = [NSString stringWithFormat:@"%@/1/sms/reg",[NetworkManager apiHost]];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:phoneNumber forKey:@"uname"];
    [param setObject:ticket forKey:@"ticket"];
    [param setObject:captcha forKey:@"captcha"];

    return [[TKRequestHandler sharedInstance] postRequestForPath:path param:param finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {
        if (finish) {
            finish(sessionDataTask,response,error);
        }
    }];
}

/**
 *  忘记密码发送验证码
 *
 *  @param phoneNumber 手机号
 *  @param finish      完成回调
 *
 *  @return 请求对象
 */
- (NSURLSessionDataTask *)forgetPassWordSendCaptchaWithPhoneNumber:(NSString *)phoneNumber ticket:(NSString *)ticket captcha:(NSString *)captcha finish:(void (^) (NSURLSessionDataTask *sessionDataTask,id responses, NSError *error))finish{
    
    NSString *path = [NSString stringWithFormat:@"%@/1/sms/change_passwd",[NetworkManager apiHost]];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:phoneNumber forKey:@"uname"];
    [param setObject:ticket forKey:@"ticket"];
    [param setObject:captcha forKey:@"captcha"];
    
    return [[TKRequestHandler sharedInstance] postRequestForPath:path param:param finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {
        if (finish) {
            finish(sessionDataTask,response,error);
        }
    }];
}

/**
 *  忘记密码
 *
 *  @param phoneString 手机号
 *  @param codeId      验证码
 *  @param newPassWord 新密码
 *  @param finish      完成回调
 *
 *  @return 请求对象
 */
-(NSURLSessionDataTask *)findUserPssswordWithPhone:(NSString *)phone
                                       withCaptcha:(NSString *)captcha
                                    withIdentifier:(NSString *)identifier
                                      withPassword:(NSString *)password
                                            finish:(void (^) (NSURLSessionDataTask *sessionDataTask,id responses, NSError *error))finish{
    NSString *path = [NSString stringWithFormat:@"%@/1/user/change_passwd",[NetworkManager apiHost]];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:phone forKey:@"uname"];
    [param setObject:captcha forKey:@"captcha"];
    [param setObject:identifier forKey:@"identifier"];
    [param setObject:password forKey:@"password"];
    
    return [[TKRequestHandler sharedInstance] postRequestForPath:path param:param finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {
        if (finish) {
            finish(sessionDataTask,response,error);
        }
    }];
}


/**
 *  退出登录
 */
- (NSURLSessionDataTask * _Nonnull)logout
{
    NSString *path = [NSString stringWithFormat:@"%@/plus/user/logout",[NetworkManager apiHost]];
    return [[TKRequestHandler sharedInstance] getRequestForPath:path param:nil finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {

    }];
}
@end
