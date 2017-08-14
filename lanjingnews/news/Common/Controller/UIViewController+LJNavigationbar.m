//
//  UIViewController+LJNavigationbar.m
//  news
//
//  Created by chunhui on 16/1/6.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "UIViewController+LJNavigationbar.h"
#import "news-Swift.h"
#import "UIBarButtonItem+Navigation.h"

@implementation UIViewController (LJNavigationbar)

-(void)initNaviUserInfoItem
{
    if ([[AccountManager sharedInstance] isLogin]) {
        
        [self userDidLogin];
    }else{
        UIImage *image = [UIImage imageNamed:@"Logout_defaultAvatar"];
        UIBarButtonItem *userItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(showUserInfo)];
        self.navigationItem.rightBarButtonItem  = userItem;
    }
}

-(void)initBackItem
{
    UIBarButtonItem *backItem = [UIBarButtonItem defaultLeftItemWithTarget:self action:@selector(backAction)];
    
    self.navigationItem.leftBarButtonItem = backItem;
}

-(void)showUserInfo
{
    
    //判断是否登录
    BOOL isLogin = [[AccountManager sharedInstance] isLogin];

    UIViewController *controller = nil;
    if (isLogin) {
        
        //判断用户类型
        NSString *verified = [[AccountManager sharedInstance] verified];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [MobClick event:@"MyCenter"];
        });
        
//        //Todo:打开注释
        if ([verified isEqualToString:@"1"]){
            controller = [[MyInfoTableViewController alloc] initWithStyle:(UITableViewStyleGrouped)];
        }else{
            controller = [[NormalUserTableViewController alloc] init];
        }
    }else{
        
        controller = [[NotLoginUserViewController alloc] init];
//        controller.title = @"蓝鲸财经";
        
    }
    
    if (controller != nil){
        controller.hidesBottomBarWhenPushed = YES;
        AppDelegate *delegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.navController pushViewController:controller animated:YES];
    }
}

- (void)userDidLogin{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    UIButton *avatar = [UIButton buttonWithType:(UIButtonTypeCustom)];
    avatar.frame = CGRectMake(19, 5, 30, 30);
//    avatar.center = view.center;
    avatar.layer.masksToBounds = YES;
    avatar.layer.cornerRadius = 15;
//    avatar.layer.borderColor = [UIColor whiteColor].CGColor;
//    avatar.layer.borderWidth = 1.5;
    [avatar addTarget:self action:@selector(showUserInfo) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:avatar];
    
    LJUserInfoModel *model = [[AccountManager sharedInstance] getUserInfo];
    [avatar sd_setBackgroundImageWithURL:[LJUrlHelper tryEncode:model.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"myInfo_default_headerImage"]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(38, 22, 16, 12)];
        
    [view addSubview:imageView];
    
    if (model.ukind.integerValue == 0){
        imageView.image = nil;
    }else if (model.ukind.integerValue == 1) {
        imageView.image = [UIImage imageNamed:@"tag_v"];
    }else if (model.ukind.integerValue == 2) {
        imageView.image = [UIImage imageNamed:@"tag_v2"];
    }

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];

}


-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
