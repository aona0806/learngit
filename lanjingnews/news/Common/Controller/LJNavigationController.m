//
//  LJNavigationViewController.m
//  Demo
//
//  Created by chunhui on 15/10/28.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import "LJNavigationController.h"
#import "LJNavigationTipStatusBar.h"
@interface LJNavigationController ()

@property(nonatomic , strong) LJNavigationTipStatusBar *tipBar;
@property(nonatomic , copy) void (^tipBarTapBlcok)();

@end

@implementation LJNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self.topViewController) {
        return;
    }
    [super pushViewController:viewController animated:animated];
}

-(LJNavigationTipStatusBar *)tipBar
{
    if (_tipBar == nil) {
        CGRect frame = [[UIScreen mainScreen]bounds];
        frame.origin.y = -20;
        frame.size.height = 40;
        _tipBar = [[LJNavigationTipStatusBar alloc]initWithFrame:frame];
        [_tipBar addTarget:self action:@selector(tipTapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tipBar;
}

-(void)showTipStatusBarWithContent:(NSString *)content tapBlock:(void(^)())tapBlock
{
    if(self.isNavigationBarHidden){
        return;
    }
    [self.tipBar updateTip:content];
    [self.navigationBar addSubview:self.tipBar];
    [self.tipBar startFlash];
    CGRect frame = self.navigationBar.frame;
    if (frame.size.height < 50) {
        frame.size.height = 64;
        self.navigationBar.frame = frame;
        [self needUpdateLayout];
    }
    self.tipBarTapBlcok = tapBlock;
}

-(void)hideTipStatusBar
{
    
    [_tipBar stopFlash];
    [_tipBar removeFromSuperview];
    CGRect frame = self.navigationBar.frame;
    if (frame.size.height > 50) {
        frame.size.height = 44;
        self.navigationBar.frame = frame;
        [self needUpdateLayout];
    }
}

-(void)needUpdateLayout
{
    for (UIViewController *controller in self.viewControllers) {
        [controller.view setNeedsLayout];
        [controller.view setNeedsUpdateConstraints];
    }
    [self.view setNeedsUpdateConstraints];
    
    if ([[UIApplication sharedApplication]isIgnoringInteractionEvents]){
        [[UIApplication sharedApplication]endIgnoringInteractionEvents];
    }
}

-(BOOL)checkAndUpdateNavbar
{
    if (_tipBar && _tipBar.superview) {
        UINavigationBar *bar = self.navigationBar;
        CGRect frame = bar.frame;
        if (frame.size.height < 50) {
            frame.origin.y = 20;
            frame.size.height = 64;
            bar.frame  = frame;
            return YES;
        }
        if ([[UIApplication sharedApplication]isIgnoringInteractionEvents]){
            [[UIApplication sharedApplication]endIgnoringInteractionEvents];
        }else {
            
        }
    }
    
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self checkAndUpdateNavbar];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self checkAndUpdateNavbar]){
        [self needUpdateLayout];
    }
    if (_tipBar && _tipBar.superview) {
        [_tipBar startFlash];        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tipTapAction:(id)sender
{
    [self hideTipStatusBar];
    if (_tipBarTapBlcok) {
        _tipBarTapBlcok();
    }
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
