//
//  TKRequestHandler+LJVerify.h
//  news
//
//  Created by 奥那 on 2017/6/19.
//  Copyright © 2017年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"
#import "LJVerifyModel.h"

typedef NS_ENUM(NSInteger, LJVerifyType){
    LJVerifyRegister = 1,     //注册
    LJVerifyForgetPassword = 2,           //忘记密码
    
};

@interface TKRequestHandler (LJVerify)
-(NSURLSessionDataTask *)verifyWithCaptcha:(NSString *)captcha uniqid:(NSString *)uniqid type:(LJVerifyType )type finish:(void (^)(NSURLSessionDataTask *sessionDataTask,LJVerifyModel *model,NSError *error))finish;
@end
