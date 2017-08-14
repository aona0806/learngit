//
//  TKRequestHandler+LoginAndRegist.h
//  news
//
//  Created by 奥那 on 16/1/5.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"

@interface TKRequestHandler (LoginAndRegist)
/**
 *  登录
 *
 *  @param phone    手机号
 *  @param passWord 密码
 *  @param finish   完成回调
 *
 *  @return 请求对象
 */
- (NSURLSessionDataTask *)loginWithPhoneNumber:(NSString *)phone passWord:(NSString *)passWord finish:(void (^) (NSURLSessionDataTask *sessionDataTask,id responses, NSError *error))finish;

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
- (NSURLSessionDataTask *)registWithPhoneNmuber:(NSString *)phone passWord:(NSString *)passWord captcha:(NSString *)captcha nickname:(NSString *)nickname identifier:(NSString *)identifier finish:(void (^) (NSURLSessionDataTask *sessionDataTask,id responses, NSError *error))finish;

/**
 *  注册发送验证码
 *
 *  @param phoneNumber 手机号
 *  @param ticket 图形验证码产生的唯一标识
 *  @param captcha 图形验证码

 *  @param finish      完成回调
 *
 *  @return 请求对象
 */
- (NSURLSessionDataTask *)registSendCaptchaWithPhoneNumber:(NSString *)phoneNumber ticket:(NSString *)ticket captcha:(NSString *)captcha finish:(void (^) (NSURLSessionDataTask *sessionDataTask,id responses, NSError *error))finish;

/**
 *  忘记密码发送验证码
 *
 *  @param phoneNumber 手机号
 *  @param ticket 图形验证码产生的唯一标识
 *  @param captcha 图形验证码
 *  @param finish      完成回调
 *
 *  @return 请求对象
 */
- (NSURLSessionDataTask *)forgetPassWordSendCaptchaWithPhoneNumber:(NSString *)phoneNumber ticket:(NSString *)ticket captcha:(NSString *)captcha finish:(void (^) (NSURLSessionDataTask *sessionDataTask,id responses, NSError *error))finish;

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
finish:(void (^) (NSURLSessionDataTask *sessionDataTask,id responses, NSError *error))finish;

/**
 *  退出登录
 */
- (NSURLSessionDataTask *)logout;




@end
