//
//  UIViewController+ModuleWebView.h
//  news
//
//  Created by lanjing on 16/9/26.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKModuleWebViewController.h"

@interface UIViewController (ModuleWebView)

- (TKModuleWebViewController *)moduleWebViewWithUrl:(NSString *)url;

@end
