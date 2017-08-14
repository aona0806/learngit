//
//  LJConferenceDetailViewController.m
//  news
//
//  Created by 陈龙 on 15/12/25.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJConferenceDetailViewController.h"
#import "InsetsLabel.h"
#import "LJConferenceDetailInfoView.h"
#import "LJConferenceDetailTitleView.h"
#import "UIColor+Extension.h"
#import <NSString+TKSize.h>
#import "news-Swift.h"
#import "NSDate+Category.h"
#import <TkShareData.h>
#import <TKShareManager.h>
#import "LJMeetTalkViewController.h"
#import "UIBarButtonItem+Navigation.h"
#import "news-Swift.h"

#define DefaultBackgroundColor [UIColor RGBColorR:245.0 G:245.0 B:245.0]
#define KThemeFont [UIFont systemFontOfSize:15]
#define KTableSeperateLineHeight 0.5
#define KAppointmentColor [UIColor RGBColorR:54 G:145 B:225]
#define KAppointmentSelectedColor [UIColor RGBColorR:215 G:74 B:56]

@interface LJConferenceDetailViewController ()<ShareViewProtocol>

{
    NSString *meetingIdString;
}
@property (nullable, nonatomic, retain) LJMeetingDetailDataModel *meetingDetailModel;

@property (nonatomic, retain, nonnull) UIScrollView *scrollView;

@property (nonatomic, retain, nonnull) UIImageView *posterImageView;
@property (nonatomic, retain, nonnull) InsetsLabel *themeLabel;

@property (nonatomic, retain, nonnull) UIView *tableContainerView;
@property (nonatomic, retain, nonnull) UIView *seperateLineView1;
@property (nonatomic, retain, nonnull) UIView *seperateLineView2;

@property (nonatomic, retain, nonnull) LJConferenceDetailTitleView *sponsorView;
@property (nonatomic, retain, nonnull) LJConferenceDetailTitleView *timeView;
@property (nonatomic, retain, nonnull) LJConferenceDetailTitleView *speakerView;

@property (nonatomic, retain, nonnull) LJConferenceDetailInfoView *meetingInfoView;
@property (nonatomic, retain, nonnull) LJConferenceDetailInfoView *companyInfoView;
@property (nonatomic, retain, nonnull) LJConferenceDetailInfoView *managementView;
@property (nonatomic, retain, nonnull) LJConferenceDetailInfoView *releasesView;
@property (nonatomic, retain, nonnull) UIButton *appointmentButton;

@property (nonnull, nonatomic, retain) UIView *containerView;


@end

@implementation LJConferenceDetailViewController

#pragma mark - lifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"会议详情";
    [self buildNavigationbar];
    [self buildView];
    [self updateDataWithId:self.idString];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)updateViewConstraints
{
    [super updateViewConstraints];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

- (void)buildNavigationbar
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 49, 18);
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton setImage:[UIImage imageNamed:@"navbar_icon_share"] forState:UIControlStateNormal];
    rightButton.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0, 0);
    [rightButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* set_right_btn = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = set_right_btn;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem defaultLeftItemWithTarget:self action:@selector(backAction:)];
}

- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buildView
{
    self.view.backgroundColor = DefaultBackgroundColor;
    
    _appointmentButton = [[UIButton alloc] init];
    _appointmentButton.backgroundColor = [UIColor whiteColor];
    [_appointmentButton setTitleColor:KAppointmentColor forState:UIControlStateNormal];
    [_appointmentButton setTitleColor:KAppointmentSelectedColor forState:UIControlStateSelected];
    _appointmentButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    _appointmentButton.layer.borderWidth = 0.2;
    _appointmentButton.layer.borderColor = [UIColor blackColor].CGColor;
    [_appointmentButton addTarget:self action:@selector(underButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_appointmentButton];
    
    self.scrollView = [UIScrollView new];
    [self.view addSubview:self.scrollView];
    
    self.containerView = [UIView new];
    self.containerView.backgroundColor = DefaultBackgroundColor;
    [self.scrollView addSubview:self.containerView];
    
    self.posterImageView = [UIImageView new];
    self.posterImageView.image = [UIImage imageNamed:@"default_conference"];
    [self.containerView addSubview:self.posterImageView];
    
    
    self.themeLabel = [InsetsLabel new];
    self.themeLabel.textColor = [UIColor whiteColor];
    self.themeLabel.backgroundColor = [UIColor RGBAColorR:50 G:50 B:50 A:0.5];
    
    self.themeLabel.font = KThemeFont;
    self.themeLabel.numberOfLines = 2;
    self.themeLabel.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    self.themeLabel.textAlignment = NSTextAlignmentLeft;
    [self.containerView addSubview:self.themeLabel];
    
    self.tableContainerView = [UIView new];
    self.tableContainerView.backgroundColor = [UIColor whiteColor];
    [self.containerView addSubview:self.tableContainerView];
    
    
    self.sponsorView = [[LJConferenceDetailTitleView alloc] init];
    [self.sponsorView updateTitle:@"主办方" andContent:@"--"];
    [self.tableContainerView addSubview:self.sponsorView];
    
    self.seperateLineView1 = [UIView new];
    self.seperateLineView1.backgroundColor = [UIColor lightGrayColor];
    [self.tableContainerView addSubview:self.seperateLineView1];
   
    
    self.timeView = [[LJConferenceDetailTitleView alloc] init];
    [self.timeView updateTitle:@"时   间" andContent:@"--"];
    [self.tableContainerView addSubview:self.timeView];
    
    
    self.seperateLineView2 = [UIView new];
    self.seperateLineView2.backgroundColor = [UIColor lightGrayColor];
    [self.tableContainerView addSubview:self.seperateLineView2];
    
    
    self.speakerView = [[LJConferenceDetailTitleView alloc] init];
    [self.speakerView updateTitle:@"主讲人" andContent:@"--"];
    [self.tableContainerView addSubview:self.speakerView];
    
    self.meetingInfoView = [[LJConferenceDetailInfoView alloc] init];
    [self.meetingInfoView updateTitle:@"会议介绍" andContent:@"--"];
    [self.containerView addSubview:self.meetingInfoView];
    
    self.companyInfoView = [[LJConferenceDetailInfoView alloc] init];
    [self.companyInfoView updateTitle:@"公司介绍" andContent:@"--"];
    [self.containerView addSubview:self.companyInfoView];
    
    
    self.managementView = [[LJConferenceDetailInfoView alloc] init];
    [self.managementView updateTitle:@"管理层介绍" andContent:@"--"];
    [self.containerView addSubview:self.managementView];
    
    
    self.releasesView = [[LJConferenceDetailInfoView alloc] init];
    [self.releasesView updateTitle:@"会议通稿" andContent:@"--"];
    [self.containerView addSubview:self.releasesView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.appointmentButton.mas_top);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.width.mas_equalTo(self.scrollView);
//        make.bottom.mas_equalTo(self.releasesView.mas_bottom).offset(10);
    }];
    
    [self.posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.containerView.mas_top).offset(0);
        make.left.mas_equalTo(self.containerView.mas_left);
        make.right.mas_equalTo(self.containerView.mas_right);
        CGFloat height = [GlobalConsts screenWidth] * 400 / 750;
        make.height.mas_equalTo(height);
    }];
    
    [self.themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.posterImageView);
        make.right.mas_equalTo(self.posterImageView);
        make.bottom.mas_equalTo(self.posterImageView.mas_bottom);
        make.height.mas_equalTo(0);
    }];
    
    [self.tableContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.containerView).offset(0);
        make.top.mas_equalTo(self.posterImageView.mas_bottom);
        make.bottom.mas_equalTo(self.speakerView.mas_bottom);
    }];
    
    [self.sponsorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableContainerView.mas_top);
        make.left.right.mas_equalTo(self.tableContainerView);
    }];
    
    [self.seperateLineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sponsorView.mas_bottom);
        make.left.mas_equalTo(self.sponsorView.titleLabel.mas_left);
        make.right.mas_equalTo(self.tableContainerView.mas_right);
        make.height.mas_equalTo(KTableSeperateLineHeight);
    }];
    
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.seperateLineView1.mas_bottom);
        make.left.right.mas_equalTo(self.tableContainerView);
    }];
    
    [self.seperateLineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeView.mas_bottom);
        make.left.mas_equalTo(self.timeView.titleLabel.mas_left);
        make.right.mas_equalTo(self.tableContainerView.mas_right);
        make.height.mas_equalTo(KTableSeperateLineHeight);
    }];
    
    [self.speakerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.seperateLineView2.mas_bottom);
        make.left.right.mas_equalTo(self.tableContainerView);
    }];
    
    [self.meetingInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableContainerView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(self.tableContainerView);
        make.height.mas_greaterThanOrEqualTo(@0);
    }];
    
    [self.companyInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.meetingInfoView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(self.tableContainerView);
        make.height.mas_greaterThanOrEqualTo(@0);
    }];
    
    [self.managementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.companyInfoView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(self.tableContainerView);
        make.height.mas_greaterThanOrEqualTo(@0);
    }];
    
    [self.releasesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.managementView.mas_bottom).offset(10);
        make.left.right.mas_equalTo(self.tableContainerView);
        make.height.mas_greaterThanOrEqualTo(@0);
    }];
    
    [_appointmentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(@48);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
    }];
    
}

- (void)updateViewWithModel:(LJMeetingDetailDataModel * _Nonnull)model
{
    NSURL *postUrl = [LJUrlHelper tryEncode:model.img];
    UIImage *image = [UIImage imageNamed:@"default_conference"];
    [self.posterImageView sd_setImageWithURL:postUrl placeholderImage:image];
    
    self.themeLabel.text = model.theme;
    [self.themeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat height = [model.theme sizeWithMaxWidth:SCREEN_WIDTH - 20 font:KThemeFont maxLineNum:2].height + 20;
        make.height.mas_equalTo(height);
    }];
    
    [self.sponsorView updateContent:model.sponsor];
    
    long long startTime = [model.startTime longLongValue];
    long long endTime = [model.endTime longLongValue];
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startTime];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endTime];
    NSDateFormatter *startDateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *endDateFormatter = [[NSDateFormatter alloc] init];
    [startDateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
    [endDateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
    if (endDate.day == startDate.day) {
        [endDateFormatter setDateFormat: @"HH:mm"];
    }
    NSString *startDateString = [startDateFormatter stringFromDate:startDate];
    NSString *endDateString = [endDateFormatter stringFromDate:endDate];
    NSString *timeString = [NSString stringWithFormat:@"%@ -- %@",startDateString,endDateString];
    [self.timeView updateContent:timeString];
    
    [self.speakerView updateContent:model.speaker];
    
    [self.meetingInfoView updateContent:model.meetingInfo];
    [self.companyInfoView updateContent:model.companyInfo];
    [self.managementView updateContent:model.management];
    [self.releasesView updateContent:model.meetingNotes];
    
    NSInteger dstage = [model.dstage integerValue];
    if (dstage != 3)  {
        self.releasesView.hidden = YES;
    } else {
        
        self.releasesView.hidden = NO;
    }

    switch (dstage) {
        case 0:{
            NSInteger userId = [[AccountManager sharedInstance] uid].integerValue;
            if (model.uid.integerValue != userId) {
                _appointmentButton.hidden = NO;
                [_appointmentButton setImage:[UIImage imageNamed:@"conference_list_icon_appointment"]
                                    forState:UIControlStateNormal];
                [_appointmentButton setImage:[UIImage imageNamed:@"conference_list_icon_cancelappointment"]
                                    forState:UIControlStateSelected];
                [_appointmentButton setTitle:@"加入预约" forState:UIControlStateNormal];
                [_appointmentButton setTitle:@"取消预约" forState:UIControlStateSelected];
                
                [self.appointmentButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
                }];
                [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(self.managementView.mas_bottom).offset(10);
                }];
                self.appointmentButton.selected = ([model.rStatus integerValue] == 1);
            } else {
                self.appointmentButton.hidden = YES;
                [self.appointmentButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(self.view.mas_bottom).offset(48);
                }];
                
                [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(self.managementView.mas_bottom).offset(10);
                }];
            }
            break;
        }
        case 1:
        case 2:{
            self.appointmentButton.hidden = NO;
            [_appointmentButton setImage:[UIImage imageNamed:@"conference_list_icon_join"]
                                forState:UIControlStateNormal];
            [_appointmentButton setImage:[UIImage imageNamed:@"conference_list_icon_join"]
                                forState:UIControlStateSelected];
            [_appointmentButton setTitle:@"进入会议" forState:UIControlStateNormal];
            [_appointmentButton setTitle:@"进入会议" forState:UIControlStateSelected];
            [self.appointmentButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
            }];
            [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.managementView.mas_bottom).offset(10);
            }];
            break;
        }
        case 3:{
            self.appointmentButton.hidden = NO;
            [_appointmentButton setImage:[UIImage imageNamed:@"conference_icon_detail_summary"]
                                forState:UIControlStateNormal];
            [_appointmentButton setImage:[UIImage imageNamed:@"conference_icon_detail_summary"]
                                forState:UIControlStateSelected];
            [_appointmentButton setTitle:@"会议纪要" forState:UIControlStateNormal];
            [_appointmentButton setTitle:@"会议纪要" forState:UIControlStateSelected];
            [self.appointmentButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
            }];
            [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.releasesView.mas_bottom).offset(10);
            }];
            break;
        }
            
        default:
            break;
    }
}

- (void)share:(id)sender
{
    BOOL isHideLanjing = ![[[AccountManager sharedInstance] verified] isEqualToString:@"1"];
    ShareView *shareView = [[ShareView alloc] initWithDelegate:self
                                                      shareObj:self.meetingDetailModel
                                                   hideLanjing:isHideLanjing];
    UINavigationController *viewController = (UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    [shareView show:viewController.topViewController.view animated:YES];
    
}

#pragma mark - ShareViewProtocol

- (void)shareAction:(enum ShareType)type shareView:(ShareView * __nonnull)shareView shareObj:(id __nullable)shareObj
{
    if (type == ShareTypeLanjing) {
        [self shareToLanjing];
    } else {
        NSString *theme = nil;
        NSString *aShareUrl = nil;
        NSString *imageString = nil;
        if ([shareObj isKindOfClass:[LJMeetingDetailDataModel class]]) {
            LJMeetingDetailDataModel *model = (LJMeetingDetailDataModel *)shareObj;
            theme = model.theme;
            aShareUrl = model.shareurl;
            imageString = model.img;
        }
        TkShareData *shareData = [TkShareData new];
        if (type == TKSharePlatformWXSession) {
            shareData.title = @"分享来自蓝鲸财经APP的会议";
            shareData.shareImage = [UIImage imageNamed:@"share_icon"];
            shareData.shareText = theme;
            shareData.url = aShareUrl;
            [self shareWithShareData:shareData andType:type];
        } else if (type == TKSharePlatformSinaWeibo) {
            shareData.title = @"分享来自蓝鲸财经APP的会议";
            shareData.shareText = [NSString stringWithFormat:@"蓝鲸财经提供更高效、更便捷的在线会议解决方案。【%@】会议预告",theme];
            shareData.url = aShareUrl;
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[LJUrlHelper tryEncode:imageString]
                                                                  options:SDWebImageDownloaderIgnoreCachedResponse
                                                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                                     
                                                                 }
                                                                completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                                    shareData.shareImage = image;
                                                                    [self shareWithShareData:shareData andType:type];
                                                                }];

        } else {
            shareData.title = @"分享来自蓝鲸财经APP的会议";
            shareData.shareImage = [UIImage imageNamed:@"share_icon"];
            shareData.shareText = theme;
            shareData.url = aShareUrl;
            
            [self shareWithShareData:shareData andType:type];
        }
    }
    
    [ShareAnalyseManager shareReport:self.meetingDetailModel.id.stringValue contentType:LJShareFromTypeMeet sharetype:type completion:^(BOOL success, NSError * _Nullable error) {
        
    }];

}

- (void)shareWithShareData:(TkShareData *)shareData andType:(ShareType)type
{
    __weak typeof(self) weakSelf = self;
    [[ShareAnalyseManager sharedInstance] shareWithData:shareData type:type presentController:self completion:^(BOOL success, NSError * _Nullable error) {
        
        NSString *tipString = @"分享失败";
        if (success) {
            tipString = @"分享成功";
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.text = tipString;
        [hud hideAnimated:YES afterDelay:1];
    }];
}

/**
 *  分享到蓝鲸财经的内容
 */
- (void) shareToLanjing
{
    TkShareData *shareData = [TkShareData new];
    NSString *shareString = [NSString stringWithFormat:@"我刚刚关注了一个会议【%@】，感兴趣的小伙伴快来围观吧！",self.meetingDetailModel.theme];
    shareData.title = @"";
    shareData.shareText = shareString;
    __weak typeof(self) weakSelf = self;
    [[ShareAnalyseManager sharedInstance] shareToLanjing:shareData type:LJShareFromTypeMeet tid:@"" completion:^(BOOL success, NSError * _Nullable error) {
        NSString *tipString = @"分享失败";
        if (success) {
            tipString = @"分享成功";
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.text = tipString;
        [hud hideAnimated:YES afterDelay:1];
    }];
}

#pragma mark - private

- (void)underButtonAction:(UIButton *)sender
{
    if (self.meetingDetailModel) {
        NSInteger dstage = [self.meetingDetailModel.dstage integerValue];
        if (dstage == 0)  {
            [self appointmentConference:sender];
        } else if (dstage == 1 || dstage == 2 ){
            NSString *meetIdString = self.meetingDetailModel.id.description;
            if (meetIdString.length == 0) {
                return;
            }
            [self enterConferenceId:meetIdString img:self.meetingDetailModel.img];
        } else if (dstage == 3) {
            
            TKModuleWebViewController *webController = [self moduleWebViewWithUrl:self.meetingDetailModel.meetingSummary];
            [self.navigationController pushViewController:webController animated:YES];
        }
    }
}

- (void)appointmentConference:(UIButton *)sender
{
    if (![[AccountManager sharedInstance] isLogin]) {
        LoginRegistViewController *viewController = [[LoginRegistViewController alloc] init];
        [self navigateTo:viewController hideNavigationBar:YES];
        return;
    }
    
    if (self.meetingDetailModel) {
        if (!sender.isSelected) {
            [self joinAppointment:self.meetingDetailModel];
        } else {
            [self cancelAppointment:self.meetingDetailModel];
        }
    }
}

- (void)enterConferenceId:(NSString *)idString img:(NSString *)img
{
//    self.hidesBottomBarWhenPushed = YES;
    if (![[AccountManager sharedInstance] isLogin]) {
        LoginRegistViewController *viewController = [[LoginRegistViewController alloc] init];
        [self navigateTo:viewController hideNavigationBar:YES];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [LJMeetTalkViewController tryEnterWithMeetId:idString nav:self.navigationController completion:^(BOOL ok ,NSString *errMsg , LJMeetTalkViewController *controller) {
            if (!ok || !controller) {
                hud.detailsLabel.text = errMsg;
                hud.mode = MBProgressHUDModeText;
            }else{
                
                controller.activityMeet = ([self.meetingDetailModel.type integerValue] == 1);
                controller.quitBlock = ^(NSString *meetId){
                    
                };
            }
            [hud hideAnimated:YES afterDelay:0.7];
        }];
    }
}



- (void)joinAppointment:(LJMeetingDetailDataModel *)meetingDetailDataModel
{
    NSString *meetingId = [meetingDetailDataModel.id stringValue];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"预约会议中...";
    __weak typeof(self) weakSelf = self;
    
    [[TKRequestHandler sharedInstance] postSubscribeMeeting:meetingId isSubscribe:YES complated:^(NSURLSessionDataTask * _Nonnull sessionDataTask, LJBaseJsonModel * _Nullable model, NSError * _Nullable error) {
        hud.mode = MBProgressHUDModeText;
        
        if (error) {
            if (model) {
                hud.label.text = @"预约失败";
                if (error.code == 20401 || error.code == 21206) {
                    hud.label.text = @"已经预约该会议";
                    dispatch_async(dispatch_get_main_queue(), ^{
                        meetingDetailDataModel.rStatus = [NSNumber numberWithInt:1];
                        weakSelf.appointmentButton.selected = YES;
                    });
                } else if (error.code == 21205) {
                    hud.label.text = @"当前阶段会议不允许预约";
                }
            } else {
                hud.label.text = @"网络错误";
            }
        } else {
            NSInteger errNo = [model.dErrno integerValue];
            if (errNo == 0){
                hud.label.text = @"预约成功";
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    meetingDetailDataModel.rStatus = [NSNumber numberWithInt:1];
                    weakSelf.appointmentButton.selected = YES;
                    [[NSNotificationCenter defaultCenter] postNotificationName:[GlobalConsts KJoinConferenceNotication]
                                                                        object:meetingId];
                });
            } else {
                
                if (model.msg && model.msg.length > 0) {
                    hud.detailsLabel.text = model.msg;
                } else {
                    hud.label.text = @"预约失败";
                    if (errNo == 20401 || errNo == 21206) {
                        hud.label.text = @"已经预约该会议";
                        dispatch_async(dispatch_get_main_queue(), ^{
                            meetingDetailDataModel.rStatus = [NSNumber numberWithInt:1];
                            weakSelf.appointmentButton.selected = YES;
                        });
                    } else if (errNo == 21205) {
                        hud.label.text = @"当前阶段会议不允许预约";
                    }
                }
            }
        }

        [hud hideAnimated:YES afterDelay:0.7];
    }];
}

- (void)cancelAppointment:(LJMeetingDetailDataModel *)meetingDetailDataModel
{
    NSString *meetingId = [meetingDetailDataModel.id stringValue];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"预约取消中...";
    hud.mode = MBProgressHUDModeText;

    __weak typeof(self) weakSelf = self;
    [[TKRequestHandler sharedInstance] postSubscribeMeeting:meetingId isSubscribe:NO complated:^(NSURLSessionDataTask * _Nonnull sessionDataTask, LJBaseJsonModel * _Nullable model, NSError * _Nullable error) {
        hud.mode = MBProgressHUDModeText;
        
        if (error) {
            hud.label.text = error.domain?:@"网络错误";
        } else {
            NSInteger errNo = [model.dErrno integerValue];
            hud.label.text = @"取消预约失败";
            if (errNo == 0){
                hud.label.text = @"取消预约成功";
                [[NSNotificationCenter defaultCenter] postNotificationName:[GlobalConsts KCancelConferenceNotication]
                                                                    object:meetingId];
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.meetingDetailModel.rStatus = [NSNumber numberWithInteger:0];
                    weakSelf.appointmentButton.selected = NO;
                });
            } else {
                if (model.msg && model.msg.length > 0) {
                    hud.detailsLabel.text = model.msg;
                }
            }
        }
        [hud hideAnimated:YES afterDelay:0.7];
    }];
}

#pragma mark - download

- (void)updateDataWithId:(NSString *)idString
{
    __weak typeof(self) weakSelf = self;
    
    [[TKRequestHandler sharedInstance] getMeetingDetailWithId:idString fromsubid:self.fromsubid complated:^(NSURLSessionDataTask * _Nonnull sessionDataTask, LJMeetingDetailModel * _Nullable model, NSError * _Nullable error) {
        
        if (!error) {
            if (model.data == nil) {
                return;
            }
            [weakSelf updateViewWithModel:model.data];
            weakSelf.meetingDetailModel = model.data;
        } else {
            
            [self showToastHidenDefault:error.domain];
            
        }
    }];
}


@end
