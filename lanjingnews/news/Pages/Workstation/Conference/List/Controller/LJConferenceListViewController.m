//
//  LJConferenceListViewController.m
//  news
//
//  Created by 陈龙 on 15/12/22.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJConferenceListViewController.h"
#import "UIView+XBExtension.h"
#import "news-Swift.h"
#import "LJHotConferenceTableViewController.h"
#import "LJMyConferenceViewController.h"
#import "LJHistoricConferenceViewController.h"
#import "LJConferenceCreateViewController.h"
#import "UIBarButtonItem+Navigation.h"

@interface LJConferenceListViewController ()

@property (nonatomic,retain) NSMutableArray *dataArray;

@end

@implementation LJConferenceListViewController

#define kShowTipKey @"_kShowMeetTip"

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"会议";
    
    [self createNargationBar];
    
    [self createScrollPageController];
    
    self.view.clipsToBounds = YES;
    
    BOOL shownTip =  [[NSUserDefaults standardUserDefaults]boolForKey:kShowTipKey];
    
    if (!shownTip) {
        //没有显示过会议提醒
        UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:@"会议系统使用说明"];
        [alert bk_addButtonWithTitle:@"查看" handler:^{
            

            //FIXME: 打开网页界面
            NSString *urlString = [NSString stringWithFormat:@"%@%@",[NetworkManager appHost],@"/share/meeting_manual"];
         
            TKModuleWebViewController *webController = [self moduleWebViewWithUrl:urlString];
            
            [self.navigationController pushViewController:webController animated:YES];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kShowTipKey];
        }];
        
        [alert bk_addButtonWithTitle:@"下次提醒" handler:^{
            
        }];
        [alert bk_addButtonWithTitle:@"永不提醒" handler:^{
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kShowTipKey];
            
        }];
        [alert show];
    }
    
}

-(void)viewDidLayoutSubviews
{
    self.titleVerticalOffset = self.navigationController.navigationBar.height - 44;
    [super viewDidLayoutSubviews];
}

- (instancetype) init
{
    if (self = [super initWithTagViewHeight:49]) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSelectedAtIndex:(NSInteger)index
{
    
    NSString *notificationNameString = nil;
    switch (index) {
        case 0:
            notificationNameString = [GlobalConsts KHotConferenceRefreshNotication];
            break;
        case 1:
            notificationNameString = [GlobalConsts KMyConferenceRefreshNotication];
            break;
        case 2:
            notificationNameString = [GlobalConsts KHistoryConferenceRefreshNotication];
            break;
            
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationNameString
                                                        object:nil];
}

#pragma mark - getters and setters

#pragma mark - create view

/**
 *  创建navgationbar
 */
- (void)createNargationBar
{
    self.tagItemSize = CGSizeMake(SCREEN_WIDTH / 3, 49);
    self.normalTitleColor = [UIColor blackColor];
    self.normalTitleFont = [UIFont systemFontOfSize:16];
    
    UIColor *LJBlueColor = RGB(49, 105, 148);
    self.selectedTitleColor = LJBlueColor;
    self.selectedTitleFont = [UIFont systemFontOfSize:16];
    
    self.selectedIndicatorColor = LJBlueColor;
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton setImage:[UIImage imageNamed:@"news_add"] forState:UIControlStateNormal];
    rightButton.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0, 0);
    [rightButton addTarget:self action:@selector(addConference:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* set_right_btn = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = set_right_btn;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem defaultLeftItemWithTarget:self action:@selector(backAction:)];
}

- (void)createScrollPageController
{
    NSArray *titleArray = @[@"热门会议",@"我的预约",@"历史会议"];
    
    
    LJHotConferenceTableViewController *v1 = [LJHotConferenceTableViewController new];
    LJMyConferenceViewController *v2 = [LJMyConferenceViewController new];
    LJHistoricConferenceViewController *v3 = [LJHistoricConferenceViewController new];
    v1.superNavController = self;
    v2.superNavController = self;
    v3.superNavController = self;
    
    NSArray<UIViewController *> *viewControllers = @[v1,v2,v3];
    
    NSArray *params = @[@"XBParamImage",
                        @"TableView",
                        @"CollectionView",];
    
    [self reloadDataWith:titleArray andSubViewdisplayClasses:viewControllers withParams:params];
}

#pragma mark - private

/**
 *  添加会议系统方法
 *
 *  @param sender ;
 */
- (void)addConference:(id)sender
{
    self.hidesBottomBarWhenPushed = YES;
    
    LJConferenceCreateViewController *viewController = [[LJConferenceCreateViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end


