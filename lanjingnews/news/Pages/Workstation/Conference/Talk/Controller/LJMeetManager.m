//
//  LJMeetManager.m
//  news
//
//  Created by chunhui on 15/10/23.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMeetManager.h"
#import "LJMeetBackTipView.h"
#import "news-Swift.h"
#import "LJMeetTalkViewController.h"
#import "LJNavigationController.h"
#import "ClientPush.pbobjc.h"
#import "LJMeetMsgController.h"
#import "LLDispatcher.h"

@interface LJMeetManager()<LLRequestProtocol>

@property(nonatomic , strong)LJMeetBackTipView *backTipView;
@property(nonatomic , assign) BOOL isShowBackTipView;//是否正在显示回到会议提示

@end

@implementation LJMeetManager

//+(void)load
//{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [[LJMeetManager SharedInstance] showOrHideTipBar:YES];
//        
//    });
//}

+(LJMeetManager *)SharedInstance
{
    static LJMeetManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LJMeetManager alloc]init];
    });
    return manager;
}


-(instancetype)init
{
    self = [super init ];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogoutNotification:) name:@"LJUserLogout" object:nil];
        
        [[LLDispatcher SharedInstance]registListener:self];
        
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[LLDispatcher SharedInstance]unregistListener:self];
}

-(LJMeetBackTipView *)backTipView
{
    if (_backTipView == nil) {
        _backTipView = [[LJMeetBackTipView alloc]initWithFrame:CGRectZero];
        [_backTipView addTarget:self action:@selector(tapBackTipAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backTipView;
}



-(void)showOrHideTipBar:(BOOL)show
{
    self.isShowBackTipView = show;
    

    __weak typeof(self) weakSelf = self;
    ViewController *mainController = [AppDelegate mainController];
    NSArray *controllers = [mainController viewControllers];
    for (LJNavigationController *nav in controllers) {
        if ([nav isKindOfClass:[LJNavigationController class]]) {
            if (show) {
                [nav showTipStatusBarWithContent:@"回到会议" tapBlock:^{
                    [weakSelf enterMeet];
                }];
            }else{
                [nav hideTipStatusBar];
            }
        }
    }
    
}


-(void)showBackMeetTip
{
    [self showOrHideTipBar:YES];
    
}

-(void)hideBackMeetTip
{
    [self showOrHideTipBar:NO];
}

-(void)enterMeet
{
    ViewController *controller = [(AppDelegate *)[[UIApplication sharedApplication]delegate] viewController];
    UIViewController *selController = controller.selectedViewController;
    if ([selController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)selController;
        LJMeetTalkViewController *meetController = [LJMeetTalkViewController ControllerWithMeetInfo:self.meetInfo];
        meetController.hidesBottomBarWhenPushed = YES;
        BOOL animated = YES;
        if ([[[UIDevice currentDevice]systemVersion] floatValue] < 7.9) {
            animated = NO;
        }
        [navController pushViewController:meetController animated:animated];
    }
}

-(void)tapBackTipAction:(id)sender
{
    [self hideBackMeetTip];
    
    [self enterMeet];
}


-(void)userLogoutNotification:(NSNotification *)notfication
{
    [self hideBackMeetTip];
}


-(void)handleResponse:(id)obj
{
    if (self.isShowBackTipView) {
        if ([obj isKindOfClass:[NotifyMessageRequest class]]) {
            NotifyMessageRequest *request = (NotifyMessageRequest *)obj;
            NotifyMessage *msg = request.msg;
            if (msg.channelType == ChannelType_MeetingQuit) {
                QuitMessage *qMessage = (QuitMessage *)[LJMeetMsgController messageWithName:@"QuitMessage" andData:msg.data];
                if (qMessage.meetingId == [self.meetInfo.meetingId integerValue]) {
                    //我的会议被关闭了
                    [self hideBackMeetTip];
                    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
                    hud.detailsLabel.text = @"您参加的会议已经被关闭";
                    hud.mode = MBProgressHUDModeText;
                    [hud hideAnimated:YES afterDelay:1.5];
                }
            }
            
        }
    }
}

@end
