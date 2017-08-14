//
//  LJVeriftCodeManager.m
//  news
//
//  Created by 奥那 on 2017/6/16.
//  Copyright © 2017年 lanjing. All rights reserved.
//

#import "LJVeriftCodeManager.h"
#import <VerifyCode/NTESVerifyCodeManager.h>
#import "news-Swift.h"

#define kVerifyCodeCaptchaId @"c97ed571c9cc45f6b04ca1b71d8c38a5"

@interface LJVeriftCodeManager ()<NTESVerifyCodeManagerDelegate>
@property (nonatomic , strong) NTESVerifyCodeManager *codeManager;
@property (nonatomic , strong) UIView *backView;
@property (nonatomic , strong) UIView *verifyView;
@end

@implementation LJVeriftCodeManager
+ (instancetype)shareInstance{
    static LJVeriftCodeManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LJVeriftCodeManager alloc] init];
    });
    return manager;
}

- (BOOL)isShowVerifyView{
    
    NSString *isOpen = [[[[ConfigManager sharedInstance] config] switchData] dun163];
    if (isOpen.integerValue == 0) {
        return NO;
    }
    
    return YES;

}

-(NTESVerifyCodeManager *)codeManager{
    if (!_codeManager) {
        _codeManager = [NTESVerifyCodeManager sharedInstance];
//        _codeManager.frame = CGRectNull;
        _codeManager.delegate = self;
        [_codeManager configureVerifyCode:kVerifyCodeCaptchaId timeout:10.0];
        _codeManager.alpha = 0.7;
    }
    return _codeManager;
}

- (void)showVerifyCodeView:(UIView *)topView{
    
    [self.codeManager openVerifyCodeView:topView];
    
}

- (void)showVerifyCodeView{
    
    CGRect frame = CGRectMake(18 , 64+110, SCREEN_WIDTH - 37, 300);
    if (_verifyType == LJVerifyForgetPassword){
        frame = CGRectMake(18, 30+64, SCREEN_WIDTH - 36, 300);
    }
    self.codeManager.frame = frame;

    [self.codeManager openVerifyCodeView];
    
}

#pragma mark - NTESVerifyCodeManagerDelegate
/**
 * 验证码组件初始化完成
 */
- (void)verifyCodeInitFinish{
}

/**
 * 验证码组件初始化出错
 *
 * @param message 错误信息
 */
- (void)verifyCodeInitFailed:(NSString *)message{
}

/**
 * 完成验证之后的回调
 *
 * @param result 验证结果 BOOL:YES/NO
 * @param validate 二次校验数据，如果验证结果为false，validate返回空
 * @param message 结果描述信息
 *
 */
- (void)verifyCodeValidateFinish:(BOOL)result
                        validate:(NSString *)validate
                         message:(NSString *)message{

    if (result) {
        [self verifyAgain:validate];
    }
    
}

/**
 * 关闭验证码窗口后的回调
 */
- (void)verifyCodeCloseWindow{

}

/**
 * 网络错误
 *
 * @param error 网络错误信息
 */
- (void)verifyCodeNetError:(NSError *)error{
}


- (void)verifyAgain:(NSString *)validate{
    [[TKRequestHandler sharedInstance] verifyWithCaptcha:validate uniqid:_phoneNum type:_verifyType finish:^(NSURLSessionDataTask *sessionDataTask, LJVerifyModel *model, NSError *error) {
        if (error) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabel.text = error.domain;
            [hud hideAnimated:YES afterDelay:1.0];
            
            return ;
        }
        if (model.dErrno.integerValue == 0 && model.data.ticket.length > 0) {
            
            if (self.verifySuccess) {
                self.verifySuccess(model.data.ticket,validate);
            }
        }
    }];
}

@end
