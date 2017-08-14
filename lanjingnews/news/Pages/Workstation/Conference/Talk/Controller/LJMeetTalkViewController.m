 //
//  LJMeetTalkViewController.m
//  news
//
//  Created by chunhui on 15/9/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMeetTalkViewController.h"
#import "LJMeetTalkHostViewController.h"
#import "LJMeetTalkConfereeViewController.h"
#import <Masonry.h>
#import "LJLongLinkManager.h"
#import "LJMeetMsgController.h"
#import "LJMeetVoiceManager.h"
#import "LJUserDeltailViewController.h"
#import "LYKeyBoardView.h"
#import "RecorderManager.h"
#import "PlayerManager.h"
#import "LJMeetExpandProtocol.h"
#import "LJMeetTalkViewModel.h"
#import "LJMeetManager.h"
#import "RecordingView.h"
#import "UIView+Utils.h"
#import "MBProgressHUD.h"
#import "UIBarButtonItem+Navigation.h"
#import "ZLPhotoPickerViewController.h"
#import "ZLPhotoAssets.h"
#import "ZLCamera.h"
#import "ImageHelper.h"

#define kMaxImageCount 3

typedef NS_ENUM(NSInteger , MeetShowStatus) {

    kShowHalf = 0, //一半一半
    kShowHostFull = 1,//主持人全屏
    kShowConfereFull = 2,//记者全屏
};

@interface LJMeetTalkViewController ()<LYKeyBoardViewDelegate,RecordingDelegate,LJMeetExpandProtocol,UINavigationControllerDelegate>

@property(nonatomic , strong) LJMeetTalkViewModel *meetViewModel;
@property(nonatomic , strong) UIView *contentView;
@property(nonatomic , strong) LJMeetTalkHostViewController *hostController;
@property(nonatomic , strong) LJMeetTalkConfereeViewController *confereeController;
@property(nonatomic , assign) MeetShowStatus showStatus;
@property(nonatomic , strong) LJMeetMsgController *msgController;
@property(nonatomic , strong) LJMeetVoiceManager *speechManager;
@property(nonatomic , strong) LYKeyBoardView *inputBar;
@property(nonatomic , strong) RecordingView *audioRecordingView;
@property(nonatomic , assign) CGFloat keyboardShowHeight;
@property(nonatomic , strong) UITapGestureRecognizer *tapRecognizer;
@property(nonatomic , strong) LJMeetUserInfo *meetUserInfo;

@property(nonatomic , assign) CGFloat keyboardOffset;
@property(nonatomic , assign) BOOL isQuitMeet;
@property(nonatomic , weak)   id<UINavigationControllerDelegate> navOriginDelegate;

@property(nonatomic , strong) NSMutableDictionary *photosUploadTasks;

@end

@implementation LJMeetTalkViewController

+(LJMeetTalkViewController *)ControllerWithId:(NSString *)meetId background:(NSString *)bgUrl
{
    LJMeetTalkViewController *controller = [[LJMeetTalkViewController alloc] init];
    controller.meetUserInfo.meetId = meetId;
    return controller;
}

+(LJMeetTalkViewController *)ControllerWithMeetInfo:(LJMeetJoinMeetInfoDataUserModel *)meetInfo
{
    LJMeetTalkViewController *controller = [[LJMeetTalkViewController alloc] init];
    controller.meetUserInfo.meetInfo = meetInfo;
    return controller;
}

+(void)tryEnterWithMeetId:(NSString *)meetId nav:(UINavigationController *)nav completion:(void(^)(BOOL ok , NSString *msg, LJMeetTalkViewController *controller))completion
{
    [LJMeetTalkViewModel enterMeetWithMid:meetId completion:^(bool ok,NSString *errMsg ,LJMeetJoinMeetInfoModel *model) {
       
        LJMeetTalkViewController *controller = nil;
        
        if (ok) {
            if (model && model.data.user) {
                controller = [LJMeetTalkViewController ControllerWithMeetInfo:model.data.user];                    
                controller.meetUserInfo.needRefresh = NO;
                [nav pushViewController:controller animated:YES];
            }else{
                if (errMsg.length == 0) {
                    errMsg = @"会议已经结束或者被取消";
                }
                ok = NO;
            }
        }else if(errMsg.length == 0){
            errMsg = @"网络请求错误";
        }
        if (completion) {
            completion(ok,errMsg,controller);
        }        
    }];
}


-(LJMeetTalkViewModel *)meetViewModel
{
    if (_meetViewModel == nil) {
        _meetViewModel = [[LJMeetTalkViewModel alloc]init];
    }
    return _meetViewModel;
}

-(LJMeetUserInfo *)meetUserInfo
{
    if (!_meetUserInfo ) {
        _meetUserInfo = [[LJMeetUserInfo alloc]init];
    }
    return _meetUserInfo;
}

-(LJMeetTalkHostViewController *)hostController
{
    if (_hostController == nil) {
        _hostController = [[LJMeetTalkHostViewController alloc]init];
        _hostController.delegate = self;
        _hostController.meetUserInfo = self.meetUserInfo;
        __weak typeof(self) weakSelf = self;
        _hostController.showOtherUserInfoBlock = ^(NSString *uid){
            [weakSelf showOtherInfo:uid];
        };
        _hostController.view.backgroundColor = [UIColor whiteColor];
        
    }
    return _hostController;
}

-(LJMeetTalkConfereeViewController *)confereeController
{
    if (_confereeController == nil) {
        _confereeController = [[LJMeetTalkConfereeViewController alloc]init];
        _confereeController.delegate = self;
        _confereeController.meetUserInfo = self.meetUserInfo;

        __weak typeof(self) weakSelf = self;
        _confereeController.showOtherUserInfoBlock = ^(NSString *uid){
            [weakSelf showOtherInfo:uid];
        };
        _confereeController.view.backgroundColor = [UIColor whiteColor];
    }
    return _confereeController;
}

-(LYKeyBoardView *)inputBar
{
    if (_inputBar == nil) {
        _inputBar = [[LYKeyBoardView alloc]initDelegate:self superView:self.view type:kLYKeyBoardEmojiOnlyLeft];
        _inputBar.maxInputCount = 1024;
        [self.view addSubview:_inputBar];
    }
    return _inputBar;
}

-(RecordingView *)audioRecordingView
{
    if (_audioRecordingView == nil) {
        _audioRecordingView = [[RecordingView alloc]initWithState:DDShowVolumnState];
    }
    return _audioRecordingView;
}

-(UIView *)contentView
{
    if (_contentView == nil) {
        _contentView = [[UIView alloc]initWithFrame:self.view.bounds];
    }
    return _contentView;
}

-(UITapGestureRecognizer *)tapRecognizer
{
    if (_tapRecognizer == nil) {
        _tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    }
    return _tapRecognizer;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        
        [self addChildViewController:self.hostController];
        [self addChildViewController:self.confereeController];
        
        self.title = @"会议中";

        self.msgController = [[LJMeetMsgController alloc]init];
        __weak typeof(self) weakSelf = self;
        _msgController.receiveMessage = ^(ChannelType type , GPBMessage *message){
            [weakSelf recevieMessage:message type:type];
        };
        [[LJLongLinkManager SharedInstance]registListener:self.msgController];
        
        _speechManager = [[LJMeetVoiceManager alloc]init];
        
        self.keyboardShowHeight = 50;   

        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(appResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
        [center addObserver:self selector:@selector(applicationBecomeActiveNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
        [center addObserver:self selector:@selector(longLinkConnectDoneNotification:) name:kLongLinkConnectedNotification object:nil];
        [center addObserver:self selector:@selector(longLinkConnectingNotification:) name:kLongLinkConnectingNotification object:nil];
        [center addObserver:self selector:@selector(longLinkConnectFailedNotification:) name:kLongLinkConnectFailedNotification object:nil];
        [center addObserver:self selector:@selector(longLinkConnectFailedNotification:) name:kLongLinkCloseNotification object:nil];
        [center addObserver:self selector:@selector(menuwillHideNotification:) name:UIMenuControllerDidHideMenuNotification object:nil];
        [center addObserver:self selector:@selector(showMenuNotification:) name:kLJMeetShowMenuNotification object:nil];
        //屏幕常亮
        [[UIApplication sharedApplication]setIdleTimerDisabled:YES];
        
    }
    return self;
}

-(void)dealloc
{
    if (self.msgController) {
        [[LJLongLinkManager SharedInstance]unregistListener:self.msgController];
    }
    //关闭屏幕常亮
    [[UIApplication sharedApplication]setIdleTimerDisabled:NO];

    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)backAction:(id)sender
{
    self.isQuitMeet = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)quitMeet:(NSString *)reason
{
    if (self.isQuitMeet) {
        return;
    }
    _isQuitMeet = YES;
    __weak typeof(self) weakSelf = self;
    if (reason.length > 0) {
        UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:reason];
        [alert bk_addButtonWithTitle:@"确定" handler:^{
            [weakSelf.meetViewModel quitMeet:^(bool ok) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                if(weakSelf.quitBlock){
                    weakSelf.quitBlock(weakSelf.meetUserInfo.meetId);
                }
            }];
        }];
        [alert show];
    }else{
        [self.meetViewModel quitMeet:^(bool ok) {
//            if (ok) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
//            }else{
//            _isQuitMeet = NO;
//        }
        }];
    }
}
-(void)quitMeetAction:(id)sender
{
    UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:@"确定退出会议?"];
    [alert bk_addButtonWithTitle:@"确定" handler:^{
        [self quitMeet:nil];
    }];
    [alert bk_setCancelButtonWithTitle:@"取消" handler:^{
        
    }];
    [alert show];
    
}

-(void)initNavigationBar
{
    UIImage *image = [UIImage imageNamed:@"meet_quit"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(quitMeetAction:)];
    
    self.navigationItem.rightBarButtonItem = item;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem defaultLeftItemWithTarget:self action:@selector(backAction:)];
}

-(void)loadMeetData
{
    LJMeetJoinMeetInfoDataUserModel *userinfo = self.meetUserInfo.meetInfo;
    [self updateMyRole:[userinfo.role integerValue]];
    [self.view addSubview:self.contentView];
    
    [self.contentView addSubview:self.hostController.view];
    [self.contentView addSubview:self.confereeController.view];
    [self.view addSubview:self.inputBar];
    
    [self.view setNeedsUpdateConstraints];
    
    [self.hostController loadData];
    [self.confereeController loadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _hostController.meetUserInfo = self.meetUserInfo;
    _confereeController.meetUserInfo = self.meetUserInfo;
    self.meetViewModel.meetUserInfo = self.meetUserInfo;
    
    [self initNavigationBar];
    
    
    if (self.meetUserInfo.meetInfo && !self.meetUserInfo.needRefresh) {
        //有会议信息，且信息有效，直接拉取数据
        [self loadMeetData];
        
    }else{
        
        __weak typeof(self) weakSelf = self;
        [self.meetViewModel enterMeet:^(bool ok ,NSString *errMsg ,LJMeetJoinMeetInfoModel *model) {
            NSInteger errNo = [model.dErrno integerValue];
            if (ok && model.data.user && errNo == 0) {
                [weakSelf loadMeetData];
            }else{
                if (!self.meetUserInfo.meetInfo || errNo != 0) {
                    //会议已经结束等信息
                    weakSelf.isQuitMeet = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{                        
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    });
                    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
                    if (errMsg.length > 0) {
                        hud.detailsLabel.text  = errMsg;
                    }else{
                        hud.detailsLabel.text = @"会议已经结束或者取消";
                    }
                    hud.mode = MBProgressHUDModeText;
                    [hud hideAnimated:YES afterDelay:1.5];
                }else{
                    
                    [self loadMeetData];
                    if(errMsg .length > 0){
                        self.title = errMsg;
                    }else{
                        [self longLinkConnectFailedNotification:nil];
                    }
                }
            }
        }];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.delegate = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[PlayerManager sharedManager]stopPlaying];
    });
    [self checkQuit];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[LJMeetManager SharedInstance]hideBackMeetTip];
    [self.navigationController setNavigationBarHidden:false animated:true];
    self.navigationController.delegate = self;
}

-(void)updateViewConstraints
{
    [super updateViewConstraints];
    
    if (self.contentView.superview == nil) {
        return;
    }
    
    CGFloat height = CGRectGetHeight(self.inputBar.frame);
    CGFloat orignY = self.inputBar.top;
    [self.inputBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(@(orignY));
        make.height.equalTo(@(height));
    }];
    
    MeetShowStatus preferStatus = _showStatus;
    if (_keyboardOffset < -1) {
        switch (self.meetUserInfo.role) {
            case kMeetRoleCreator:
            case kMeetRoleGuest:
            case kMeetRoleManager:
                preferStatus = kShowHostFull;
                break;
                
            default:
                preferStatus = kShowConfereFull;
                break;
        }
        if (preferStatus == kShowConfereFull) {
            //显示下部对话
            [self.confereeController scrollToTalk:YES];
        }
    }
    
//    CGFloat bottom = _keyboardOffset;
//    if (bottom  > -1 ) {
//        bottom = -50;
//    }
    
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);//.offset(_keyboardOffset);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.inputBar.mas_top);
    }];
    
    
    UIView *superview = self.hostController.view.superview;
    [self.hostController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.top.equalTo(@(0));
        switch (preferStatus) {
            case kShowHalf:
                make.bottom.equalTo(superview.mas_centerY);
                break;
            case kShowHostFull:
                make.bottom.equalTo(superview.mas_bottom);
                //待输入框
                break;
            case kShowConfereFull:
                make.bottom.equalTo(superview.mas_top);
                break;
            default:
                break;
        }
    }];
    
    superview = self.confereeController.view.superview;
    [self.confereeController.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.top.equalTo(self.hostController.view.mas_bottom);
        make.bottom.equalTo(superview.mas_bottom);
    }];
    
}

-(void)updateMyRole:(LJMeetRoleType)type
{
    if (self.meetUserInfo.role != type) {
        self.meetUserInfo.role = type;
        [[RecorderManager sharedManager] stopRecording];
    }
    
    LYKeyBoardType boardType = kLYKeyBoardAudioAndEmojiLeft;
    if (type == kMeetRoleInvalid || type == kMeetRoleUser) {
        boardType = kLYKeyBoardEmojiOnlyLeft;
    }
    [self.inputBar updateType:boardType];
    NSString *tip = nil;
    switch (type) {
        case kMeetRoleManager:
        case kMeetRoleCreator:
            tip = @"主持人";
            break;
        case kMeetRoleGuest:
            tip = @"嘉宾";
            break;
        case kMeetRoleUser:
            tip = @"参会人";
            break;
        default:
            break;
    }
    if (tip) {
        tip = [NSString stringWithFormat:@"您已被主办方选为%@",tip];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.text = tip;
        [hud hideAnimated:YES afterDelay:1.5];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - long link message
-(void)recevieMessage:(GPBMessage *)message type:(ChannelType)type
{
//    NSLog(@"recevie mssage: %@ \n%@\n\n type: %d\n\n",[message class],message,type);
    if (![self isMyMeetMessage:message type:type]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
                
        switch (type) {
            case ChannelType_MeetingMain:
                //上方消息
            {
                IMMessage *imMsg = (IMMessage *)message;
                [self.hostController receiveTalkMessage:imMsg];
                [self checkMyMsgSetToQuestion:imMsg];
            }
                break;
            case ChannelType_MeetingDiscuss:
            {
                //下方消息
                [self.confereeController receiveTalkMessage:(IMMessage *)message];
            }
                break;
            case ChannelType_MettingTrans:
            {
                //音频转换
                [self.hostController receiveAudioConvertMessage:(PlainTextMessage *)message];
            }
                break;
            case ChannelType_MettingStatus:
            {
                //在线状态变更
                StatusMessage *statusMessage = (StatusMessage *)message;
                [self.confereeController onlineStatusChangeMessage:statusMessage];
//                if (statusMessage.user.uid == [self.meetUserInfo.uid integerValue]) {
//                    //统一账号在多个设备上登录
//                    if (statusMessage.status == 0) {
//                        [self quitMeet];
//                    }
//                }
            }
                break;
            case ChannelType_MettingRole:
            {
                //用户角色变换
                RoleChangeMessage *roleMessage = (RoleChangeMessage *)message;
                if (roleMessage.user.uid == [self.meetUserInfo.uid integerValue]) {
                    //更改我的角色                    
                    [self updateMyRole:roleMessage.user.role];
                }
                [self.hostController userRoleChanagedWithMessage:roleMessage];
                
                [self.confereeController roleChangeMessage:roleMessage];
            }
                break;
            case ChannelType_MeetingQuit:
                //用户退出
            {
                QuitMessage *qMessage = (QuitMessage *)message;
                if (qMessage.user.uid == [self.meetUserInfo.uid integerValue]) {
                    //统一账号在多个设备上登录
                    if(qMessage.type == 3){
                        //会议已经结束
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        hud.mode = MBProgressHUDModeText;
                        NSString *msg = qMessage.reason;
                        if (msg.length == 0) {
                            msg = @"此会议已结束";
                        }
                        hud.detailsLabel.text = msg;
                        [hud hideAnimated:YES afterDelay:1.5];
                        self.isQuitMeet = YES;
                    }else{
                        [self quitMeet:qMessage.reason];
                    }
                }
            }
                break;
            default:
                break;
        }
    });
}

-(BOOL)isMyMeetMessage:(GPBMessage *)message type:(ChannelType)type
{
    int32_t meetid = 0;
#if 1
    SEL meetIdSel = NSSelectorFromString(@"meetingId");
    if([message respondsToSelector:meetIdSel]){
#pragma clang diagnostic push
        
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
        NSMethodSignature *sig = [[message class]instanceMethodSignatureForSelector:meetIdSel];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
        [invocation setTarget:message];
        [invocation setSelector:meetIdSel];
        
        [invocation invoke];
        NSInteger *mId = 0;
        [invocation getReturnValue:&mId];
        meetid = (int32_t)mId;
        
#pragma clang diagnostic pop
        
    }
#else
    
    switch (type) {
        case ChannelTypeMeetingMain:
        case ChannelTypeMeetingDiscuss:
        {
            IMMessage *imMsg = (IMMessage *)message;
            meetid = imMsg.meetingId;
        }
            break;
        case ChannelTypeMettingTrans:
        {
            meetid = [(PlainTextMessage *)message meetingId];
        }
            break;
        case ChannelTypeMettingStatus:
        {
            //在线状态变更
            meetid = [(StatusMessage *)message meetingId];
        }
            break;
        case ChannelTypeMettingRole:
        {
            //用户角色变换
            meetid = [(RoleChangeMessage *)message meetingId];
        }
            break;
        case ChannelTypeMeetingQuit:
        {
            //用户退出
            meetid = [(QuitMessage *)message meetingId];
        }
            break;
        default:
            return NO;
    }

#endif
    return [self.meetUserInfo.meetId integerValue] == meetid;
}

-(void)checkMyMsgSetToQuestion:(IMMessage *)message
{

    NSString *text = nil;
    if (message.fromUser.uid == [self.meetUserInfo.uid integerValue] && self.meetUserInfo.role == kMeetRoleUser) {
        //我是观众，且我的问题被选为问题        

        text = @"您有一条问题被主持人/嘉宾选中解答";

//    }else if ([self.meetUserInfo.meetInfo.role integerValue] == kMeetRoleUser && message.fromUser.role == kMeetRoleUser){
//        //某为观众的发言被选为问题
//        text = [NSString stringWithFormat:@"%@的问题已被选中，加油提问吧！",message.fromUser.sname];
    }
    if (text) {
        UIView *showView = self.view;
        if (self.showStatus == kShowHostFull) {
            showView = self.hostController.view;
        }else if (self.showStatus == kShowConfereFull){
            showView = self.confereeController.view;
        }
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:showView animated:YES];
        hud.offset = CGPointMake(0, -100);
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.text = text;
        [hud hideAnimated:YES afterDelay:1.5];
    }
}

#pragma mark - keyboard delegate
-(void)keyBoardView:(LYKeyBoardView*)keyBoard ChangeDuration:(CGFloat)durtaion
{
    [self.view removeGestureRecognizer:self.tapRecognizer];
    [self.view addGestureRecognizer:self.tapRecognizer];
}

-(void)keyBoardView:(LYKeyBoardView*)keyBoard sendMessage:(NSString*)message
{
    if (message.length == 0) {
        return;
    }
    if (message.length > keyBoard.maxInputCount) {
        message = [message substringToIndex:keyBoard.maxInputCount];
    }
    //check my role
    switch (_meetUserInfo.role) {
        case kMeetRoleCreator:
        case kMeetRoleGuest:
        case kMeetRoleManager:
        {
            [self.hostController sendMessage:message];            
        }
            break;
        case kMeetRoleUser:
        default:
            [self.confereeController sendMessage:message];
            break;
    }
    
}

-(void)keyBoardView:(LYKeyBoardView*)keyBoard audioRuning:(UILongPressGestureRecognizer*)longPress
{
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self.hostController stopPlayAudio];
            [self.confereeController stopPlayAudio];
            
            if (![[self.view subviews] containsObject:self.audioRecordingView])
            {
                [self.view addSubview:_audioRecordingView];
                _audioRecordingView.center = CGPointMake(self.view.width/2, self.view.height/2);
            }
            [_audioRecordingView setHidden:NO];
            [_audioRecordingView setRecordingState:DDShowVolumnState];
            
            [[RecorderManager sharedManager] setDelegate:self];
            [[RecorderManager sharedManager] startRecording];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint location = [longPress locationInView:longPress.view];
            if (location.y < - 20) {
                [_audioRecordingView setRecordingState:DDShowCancelSendState];
            }else{
                [_audioRecordingView setRecordingState:DDShowVolumnState];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (_audioRecordingView.recordingState == DDShowCancelSendState) {
                [[RecorderManager sharedManager]cancelRecording];
            }else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[RecorderManager sharedManager]stopRecording];
                });
            }
            _audioRecordingView.hidden = YES;
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            [[RecorderManager sharedManager]cancelRecording];
            _audioRecordingView.hidden = YES;
        }
            break;
        default:
            break;
    }

}

- (void)keyBoardView:(LYKeyBoardView *)keyBoard changeKeyBoardHeight:(CGFloat)height
{
    self.keyboardOffset = -height;
    
    if (height < 1) {
        [self.view removeGestureRecognizer:self.tapRecognizer];
        self.keyboardOffset = 0;
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
        if (_showStatus != kShowConfereFull) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.hostController scrollToBottom];
            });
        }
    }
    [self.view setNeedsUpdateConstraints];
}

-(void)keyBoardViewClickImgPic:(LYKeyBoardView *)keyBoard{

    __weak typeof(self) wself = self;

    ZLPhotoPickerViewController *pcontroller = [[ZLPhotoPickerViewController alloc]init];

    pcontroller.callBack = ^(NSArray *assets){
        if (assets.count == 0) {
            return ;
        }

    NSMutableArray *images = [[NSMutableArray alloc]init];

        for (id asset in assets) {
            UIImage *image = nil;
            
            if ([asset isKindOfClass:[UIImage class]]) {
                image = asset;
            }else if ([asset isKindOfClass:[ZLPhotoAssets class]]){
                image = [(ZLPhotoAssets *)asset originImage];
            }else if ([asset isKindOfClass:[ZLCamera class]]){
                
                image = [(ZLCamera *)asset fullScreenImage];
            }
            
            image = [ImageHelper normImageOrientation:image];
            image = [ImageHelper resizeImage:image maxWidth:1196];
            
            [images addObject:image];
            NSString *key = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
            NSString *index = [NSString stringWithFormat:@"%ld",(unsigned long)[images indexOfObject:image]];
            NSURLSessionTask *photoTask = [self.hostController sendPic:image index:index finish:^(NSString *result, NSString *error) {
                if (result && result.length > 0) {
                    [wself.photosUploadTasks removeObjectForKey:key];
                }else{
                    for (NSURLSessionTask *task in wself.photosUploadTasks) {
                        [task cancel];
                    }
                }
            }];
            wself.photosUploadTasks[key] = photoTask;
        }

    };
    pcontroller.minCount = kMaxImageCount ;
    pcontroller.status = PickerViewShowStatusCameraRoll;
    pcontroller.topShowPhotoPicker = true;

    [self.confereeController presentViewController:pcontroller animated:YES completion:^{

    }];
}


-(void)tapAction:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.view];
    if (!CGRectContainsPoint(self.inputBar.frame, location)) {
        [self.inputBar tapAction];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog (@"Cancel");
    [picker dismissViewControllerAnimated:YES completion:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

#pragma mark - record delegate
- (void)levelMeterChanged:(float)levelMeter
{
    if (_audioRecordingView &&!_audioRecordingView.hidden) {
        [_audioRecordingView setVolume:levelMeter*2];
    }
}
- (void)recordingFinishedWithFileName:(NSString *)filePath time:(NSTimeInterval)interval
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //record done
        NSTimeInterval length = (long)(interval+0.5);
        
        NSDictionary *attri = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        NSInteger fileSize = [[attri objectForKey:NSFileSize] integerValue];

        if (length < 1.0 || fileSize < 500 ) {
            //时间太短,或者文件小于500Bytes
            
            _audioRecordingView.recordingState = DDShowRecordTimeTooShort;
            _audioRecordingView.hidden = NO;
            
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            
            return;
        }
        
        switch (self.meetUserInfo.role) {
            case kMeetRoleCreator:
            case kMeetRoleManager:
            case kMeetRoleGuest:
            {
                [self.hostController sendAudioMessage:filePath duration:length];
            }
                break;
            default:
            {
                [self.confereeController sendAudioMessage:filePath duration:length];
            }
                break;
        }
        
        if (!_audioRecordingView.hidden) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _audioRecordingView.hidden = NO;
                _audioRecordingView.recordingState = DDShowVolumnState;
                [[RecorderManager sharedManager]startRecording];
            });
        }
        
    });
}
- (void)recordingTimeout
{
    [[RecorderManager sharedManager]stopRecording];
}
- (void)recordingStopped  //录音机停止采集声音
{
    [[RecorderManager sharedManager] stopRecording];
}
- (void)recordingFailed:(NSString *)failureInfoString
{
    _audioRecordingView.hidden = YES;
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = @"本次录音失败";
    [hud hideAnimated:YES afterDelay:.5];
}

#pragma mark - expand
-(void)expand:(UIViewController *)controller
{
    LJMeetShowDegree hostFull = YES;
    LJMeetShowDegree confereeFull = YES;
    switch (self.showStatus) {
        case kShowHalf:
        {
            if (controller == self.hostController) {
                //上半部全屏
                self.showStatus = kShowHostFull;
                hostFull = kMeetShowFull;
                confereeFull = KMeetShowMinimum;
                
            }else if (controller == self.confereeController){
                self.showStatus = kShowConfereFull;
                hostFull = KMeetShowMinimum;
                confereeFull = kMeetShowFull;
            }
        }
            break;
        case kShowHostFull:
        case kShowConfereFull:
        {
            self.showStatus = kShowHalf;
            hostFull = kMeetShowHalf;
            confereeFull = kMeetShowHalf;
        }
            break;
        default:
            return;
    }
    
    [self.view setNeedsUpdateConstraints];
    
    [self.hostController fullScreen:hostFull];
    [self.confereeController fullScreen:confereeFull];

}

#pragma mark - show other info
-(void)showOtherInfo:(NSString *)uid
{
    if(self.isActivityMeet){
        //活动类型的会议
        return;
    }
    
    if (uid.length == 0) {
        return;
    }
    
    LJUserDeltailViewController *controller = [[LJUserDeltailViewController alloc]init];
    controller.uid = uid;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - navigation controllers
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self checkQuit];
}

-(void)checkQuit
{
    if (!_isQuitMeet) {
        NSArray *viewControllers = [self.navigationController viewControllers];
        if (![viewControllers containsObject:self]) {
            
            LJMeetManager *manager = [LJMeetManager SharedInstance];
            self.meetUserInfo.needRefresh = YES;
            manager.meetInfo = self.meetUserInfo.meetInfo;            
            [manager showBackMeetTip];
            
        }
    }
}

#pragma mark - app state
-(void)appResignActiveNotification:(NSNotification *)notification
{
    [[RecorderManager sharedManager]cancelRecording];
    [self.inputBar tapAction];
}

-(void)applicationBecomeActiveNotification:(NSNotification *)notification
{
    [[RecorderManager sharedManager]cancelRecording];
}

#pragma mark - long link status


-(void)longLinkConnectFailedNotification:(NSNotification *)notification
{
    self.title = @"会议中(网络未连接)";
}
-(void)longLinkConnectingNotification:(NSNotification *)notification
{
    self.title = @"会议中(网络连接中)";
}
-(void)longLinkConnectDoneNotification:(NSNotification *)notification
{
    self.title = @"会议中";
}

#pragma mark - menu
-(void)menuwillHideNotification:(NSNotification *)notification
{
    self.inputBar.inputText.customNextResponder = nil;
}

-(void)showMenuNotification:(NSNotification *)notification
{
//    UIView *baseView = (UIView *)notification.userInfo[@"baseView"];
    UITableViewCell *cell = notification.userInfo[@"cell"];
    
    if (self.inputBar.inputText.isFirstResponder) {
        self.inputBar.inputText.customNextResponder = cell;
    }else{
        [cell becomeFirstResponder];
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

NSString *kLJMeetShowMenuNotification = @"_kLJMeetShowMenuNotification";
