//
//  UIViewController+ErrorTip.h
//  news
//
//  Created by chunhui on 16/1/9.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ErrorTip)

/**
 *  显示网络错误view
 *
 *  @param errorView 错误view ，为nil时显示默认
 */
-(void)showNetErrorView:(UIView *)errorView;
/**
 *  显示搜索无结果view
 *
 *  @param resultView 无结果view ， 为nil时显示默认
 */
-(void)showNoResultView:(UIView *)resultView;
/**
 *  隐藏网络错误view
 *
 *  @param errorView 错误view
 */
-(void)hideNetErrorView:(UIView *)errorView;
/**
 *  隐藏无结果view
 *
 *  @param resultView 无结果view
 */
-(void)hideNoResultView:(UIView *)resultView;

/**
 *  默认无网络或者无结果点击刷新
 */
-(void)refreshAction;

@end
