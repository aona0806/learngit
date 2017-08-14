//
//  LJVeriftCodeManager.h
//  news
//
//  Created by 奥那 on 2017/6/16.
//  Copyright © 2017年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKRequestHandler+LJVerify.h"

@interface LJVeriftCodeManager : NSObject
+ (instancetype)shareInstance;

@property (nonatomic , copy) void (^verifySuccess)(NSString *ticket, NSString *validate);
@property (nonatomic , copy) NSString *phoneNum;
@property (nonatomic , assign) LJVerifyType verifyType;

- (BOOL)isShowVerifyView;
- (void)showVerifyCodeView:(UIView *)topView;
- (void)showVerifyCodeView;

@end
