//
//  TKRequestHandler+LJVerify.m
//  news
//
//  Created by 奥那 on 2017/6/19.
//  Copyright © 2017年 lanjing. All rights reserved.
//

#import "TKRequestHandler+LJVerify.h"
#import "news-Swift.h"

@implementation TKRequestHandler (LJVerify)

-(NSURLSessionDataTask *)verifyWithCaptcha:(NSString *)captcha uniqid:(NSString *)uniqid type:(LJVerifyType )type finish:(void (^)(NSURLSessionDataTask *sessionDataTask,LJVerifyModel *model,NSError *error))finish{
    
    NSString *path = [NSString stringWithFormat:@"%@/v1/ydcaptcha/verify",[NetworkManager apiHost]];
    NSDictionary *param = @{@"captcha":captcha,@"uniqid":uniqid,@"rtype":[NSString stringWithFormat:@"%ld",type]};
    
    return [[TKRequestHandler sharedInstance] postRequestForPath:path param:param jsonName:@"LJVerifyModel" finish:^(NSURLSessionDataTask * _Nullable sessionDataTask, JSONModel * _Nullable model, NSError * _Nullable error) {
        if (finish) {
            finish(sessionDataTask,(LJVerifyModel *)model,error);
        }
    }];
    
}

@end
