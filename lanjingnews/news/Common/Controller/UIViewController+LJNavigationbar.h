//
//  UIViewController+LJNavigationbar.h
//  news
//
//  Created by chunhui on 16/1/6.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LJNavigationbar)

/*
 * 设置navigationbar 右部显示个人信息item
 */
-(void)initNaviUserInfoItem;

/*
 * 显示个人信息
 */
-(void)showUserInfo;

/**
 *  设置导航栏返回控件
 */

-(void)initBackItem;

/**
 *  导航栏左侧点击返回
 */
-(void)backAction;

@end
