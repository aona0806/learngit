//
//  LJNavigationViewController.h
//  Demo
//
//  Created by chunhui on 15/10/28.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJNavigationController : UINavigationController

-(void)showTipStatusBarWithContent:(NSString *)content tapBlock:(void(^)())tapBlock;
-(void)hideTipStatusBar;

@end
