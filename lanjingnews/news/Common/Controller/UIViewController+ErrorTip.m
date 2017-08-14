//
//  UIViewController+ErrorTip.m
//  news
//
//  Created by chunhui on 16/1/9.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "UIViewController+ErrorTip.h"
#import <objc/runtime.h>
#import "news-Swift.h"


static const char *kNoNetTipChar;
static const char *kNoResultTipChar;

@implementation UIViewController (ErrorTip)

-(UIView *)netErrorView
{
    NoResultTipView *netErrorView = objc_getAssociatedObject(self,&kNoNetTipChar);
    if (netErrorView == nil) {
        netErrorView = [NoResultTipView netErrorView];
        netErrorView.backgroundColor = [UIColor clearColor];
        
        __weak typeof(self) weakSelf = self;
        
        netErrorView.refreshClosure = ^(NoResultTipView *view){
            [view removeFromSuperview];
            [weakSelf refreshAction];
        };
        
        objc_setAssociatedObject(self, &kNoNetTipChar, netErrorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return netErrorView;
}

-(UIView *)noResultView
{
    NoResultTipView *noResultView = objc_getAssociatedObject(self, &kNoResultTipChar);
    if (noResultView == nil) {
        noResultView = [NoResultTipView noresultView];
        noResultView.backgroundColor = [UIColor clearColor];
        __weak typeof(self) weakSelf = self;
        
        noResultView.refreshClosure = ^(NoResultTipView *view){
            [view removeFromSuperview];
            [weakSelf refreshAction];
        };
        
        objc_setAssociatedObject(self, &kNoResultTipChar, noResultView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return noResultView;
}


-(void)showNetErrorView:(UIView *)errorView
{
    if (errorView == nil) {
        errorView = self.netErrorView;
    }
    [self showInfoView:errorView];
}

-(void)showNoResultView:(UIView *)resultView
{
    if (resultView == nil) {
        resultView = self.noResultView;
    }
    [self showInfoView:resultView];
}


-(void)hideNetErrorView:(UIView *)errorView
{
    if (errorView == nil) {
        errorView = self.netErrorView;
    }
    [self hideInfoView:errorView];
}

-(void)hideNoResultView:(UIView *)resultView
{
    if (resultView == nil) {
        resultView = self.noResultView;
    }
    [self hideInfoView:resultView];
}

-(void)showInfoView:(UIView *)infoView
{
    [self.view addSubview:infoView];
}

-(void)hideInfoView:(UIView *)infoView
{
    [infoView removeFromSuperview];
}


-(void)refreshAction{
    
}

@end
