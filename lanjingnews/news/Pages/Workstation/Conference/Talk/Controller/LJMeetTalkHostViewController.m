//
//  LJMeetTalkHostViewController.m
//  news
//
//  Created by chunhui on 15/9/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMeetTalkHostViewController.h"
#import "Masonry.h"
#import "LJMeetHostViewModel.h"
#import "news-Swift.h"
#import "MJRefreshStateHeader.h"
#import "UIImageView+WebCache.h"

#define kExpandWidth  32

@interface LJMeetTalkHostViewController ()<UITableViewDelegate>

@property(nonatomic , strong) UIImageView *bgImageView;//背景
@property(nonatomic , strong) UITableView *tableView;
@property(nonatomic , strong) UIButton *expandButton;
@property(nonatomic , strong) LJMeetHostViewModel *viewModel;

@end

@implementation LJMeetTalkHostViewController


-(void)addNotifications
{
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setToQuestionNotification:) name:SetToQuestionNotification object:nil];
}


-(instancetype)init
{
    if (self) {
        [self addNotifications];
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self addNotifications];
    }
    return self;
}

-(void)dealloc
{
    
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    self.tableView.delegate = nil;
    
}

-(UIButton *)expandButton
{
    if (_expandButton == nil) {
        _expandButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_expandButton addTarget:self action:@selector(expandAction:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *image = [UIImage imageNamed:@"meet_talk_fullscreen"];
        [_expandButton setBackgroundImage:image forState:UIControlStateNormal];
        [_expandButton setBackgroundImage:image forState:UIControlStateHighlighted];
        _expandButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    }
    return _expandButton;
}

-(LJMeetHostViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [[LJMeetHostViewModel alloc]init];
        _viewModel.showOtherUserInfoBlock = self.showOtherUserInfoBlock;
        _viewModel.isHost = YES;
    }
    return _viewModel;
}

-(UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = NO;
    }
    
    return _tableView;
}

-(UIImageView *)bgImageView
{
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.clipsToBounds = YES;
        _bgImageView.image = [UIImage imageNamed:@"xiaomishu_background.jpg"];
        
    }
    return _bgImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.expandButton];
    
    
    _tableView.delegate = self;
    _tableView.dataSource = self.viewModel;
    __weak typeof(self) weakSelf = self;
    
    MJRefreshStateHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.viewModel loadData];
    }];    
    _tableView.header = header;
    self.viewModel.tableView = _tableView;
    self.viewModel.meetUserInfo = self.meetUserInfo;
    
    self.tableView.backgroundColor = [UIColor clearColor];        
}


-(void)loadData
{
    [self.viewModel loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fullScreen:(LJMeetShowDegree)degree
{
    [self.view setNeedsUpdateConstraints];
    UIImage *image = nil;
    if (degree == kMeetShowFull) {
        image = [UIImage imageNamed:@"meet_talk_shrink"];
    }else{
        image = [UIImage imageNamed:@"meet_talk_fullscreen"];
    }
    [_expandButton setBackgroundImage:image forState:UIControlStateNormal];
    [_expandButton setBackgroundImage:image forState:UIControlStateHighlighted];
    
    if (degree != KMeetShowMinimum) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.viewModel scrollToBottom];
        });
    }
}

-(void)updateViewConstraints
{    
    [self.expandButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(14);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.width.equalTo(@(kExpandWidth));
        make.height.equalTo(@(kExpandWidth));
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self.bgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [super updateViewConstraints];
}

-(void)expandAction:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(expand:)]) {
        [_delegate expand:self];
    }
}

-(void)stopPlayAudio
{
    [self.viewModel stopPlayAudio];
}

-(void)scrollToBottom
{
    [self.viewModel scrollToBottom];
}

/*
 * 设置为问题
 */
-(void)setToQuestion:(LJMeetTalkMsgDataModel *)model state:(BOOL)isOK
{
    [self.viewModel setToQuestion:model state:isOK];
}

#pragma mark - long link
-(void)receiveTalkMessage:(IMMessage *)message
{
    [self.viewModel receiveTalkMessage:message];
}

-(void)receiveAudioConvertMessage:(PlainTextMessage *)message
{
    [self.viewModel receiveAudioConvertMessage:message];
}

-(void)sendMessage:(NSString *)message
{
    [self.viewModel sendMessage:message];
}

-(NSURLSessionTask *)sendPic:(UIImage *)pic index:(NSString *)index finish:(void (^)(NSString *result , NSString *error))finish{
    
    return [self.viewModel sendPic:pic index:index finish:^(NSString *result, NSString *error) {
        if (finish) {
            finish(result , error);
        }
    }];
}

-(void)sendAudioMessage:(NSString *)filePath duration:(NSTimeInterval)duration
{
    [self.viewModel sendAudioMessage:filePath duration:duration];
}

-(void)userRoleChanagedWithMessage:(RoleChangeMessage*)message
{
    [self.viewModel userRoleChanagedWithMessage:message];
}


#pragma mark - tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.viewModel CellHeightFromIndexPath:indexPath];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - set question
#pragma mark - message notification
//-(void)setToQuestionNotification:(NSNotification *)notification
//{
//    NSDictionary *userInfo = notification.userInfo;
//    LJMeetTalkMsgDataModel *item = userInfo[SetTOQuestionItem];
//    BOOL isOk = [userInfo[SetToQuestionState] integerValue] > 0;    
//    [self setToQuestion:item state:isOk];
//}

@end
