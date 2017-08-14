//
//  LJConferenceBaseTableViewController.m
//  news
//
//  Created by 陈龙 on 15/12/22.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJConferenceBaseTableViewController.h"
#import "XBConst.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "UIImage+GIF.h"
#import "BlocksKit.h"
#import "BlocksKit+UIKit.h"
#import "news-Swift.h"
#import <TKShareManager.h>
#import <TkShareData.h>

@protocol ShareViewProtocol;

@interface LJConferenceBaseTableViewController ()

@property (nonatomic,retain,nullable) UIView *errorView;
@property (nonatomic,retain,nullable) UIView *noDataView;

@end

#define DefaultBackgroundColor RGB(245.0, 245.0, 245.0)
//FIXME: 可能需要修改
#define kLodingDurate 1.0

@implementation LJConferenceBaseTableViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildFooterView];
    
    self.dataSource = [NSMutableArray new];
    
    self.tableView = [UITableView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = DefaultBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = nil;
    [self.tableView registerClass:[LJConferenceTableViewCell class]
           forCellReuseIdentifier:[LJConferenceTableViewCell reuseIdentifier]];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    __weak __typeof(self) weakSelf = self;
    
    [self addHeaderRefreshView:self.tableView callBack:^{
        [weakSelf downloadRefresh];
    }];
    
    [self addFooterRefreshView:self.tableView callBack:^{
        [weakSelf downloadLoadMore];
    }];
    self.isFirstLoading = true;
    [self downloadRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setXBParam:(NSString *)XBParam
{
    _XBParam = XBParam;
    XBLog(@"ConferenceBaseTableViewController received param === %@",XBParam);
}

- (void)dealloc
{
    XBLog(@"ConferenceBaseTableViewController delloc");
    
}

#pragma mark - private

- (void)buildFooterView
{
    UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    footerLabel.backgroundColor = [UIColor clearColor];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    footerLabel.textColor = [UIColor rgb:0x7f7b7b];
    footerLabel.font = [UIFont systemFontOfSize:13];
    footerLabel.numberOfLines = 1;
    footerLabel.text = @"没有更多了";
    
    self.tableFooterView = footerLabel;
}

- (void)shareWithShareData:(TkShareData *)shareData andType:(ShareType)type
{
    __weak typeof(self) weakSelf = self;
    
    
    [[ShareAnalyseManager sharedInstance] shareWithData:shareData type:type presentController:self completion:^(BOOL success, NSError * _Nullable error) {
        
        NSString *tipString = @"分享失败";
        if (success) {
            tipString = @"分享成功";
        }
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.superNavController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.text = tipString;
        [hud hideAnimated:YES afterDelay:1];
    }];
}

/**
 *  分享到蓝鲸的内容
 */
- (void) shareToLanjingWithString:(NSString *)theme
{
    TkShareData *shareData = [TkShareData new];
    NSString *shareString = [NSString stringWithFormat:@"我刚刚关注了一个会议【%@】，感兴趣的小伙伴快来围观吧！",theme];

    shareData.title = @"";
    shareData.shareText = shareString;
    __weak typeof(self) weakSelf = self;
    
    [[ShareAnalyseManager sharedInstance] shareToLanjing:shareData type:LJShareFromTypeMeet tid : @"" completion:^(BOOL success, NSError * _Nullable error) {
        
        NSString *tipString = @"分享失败";
        if (success) {
            tipString = @"分享成功";
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.superNavController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.text = tipString;
        [hud hideAnimated:YES afterDelay:1];
    }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.dataSource.count;
    //    count = count > 0 ? 1 : 0;
    return count;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0;
    JSONModel *model = self.dataSource[indexPath.row];
    rowHeight = [LJConferenceTableViewCell heightForCellWithData:model];
    return rowHeight;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = nil;
    if (section == 0) {
        headView = [UIView new];
        headView.backgroundColor = DefaultBackgroundColor;
    }
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = [LJConferenceTableViewCell reuseIdentifier];
    LJConferenceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    LJMeetListDataModel *model = self.dataSource[indexPath.row];
    [cell updateCellWithData:model];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - download

/**
 *  刷新数据
 */
- (void)downloadRefresh
{
    [self stopRefresh:self.tableView];
}

/**
 *  加载更多数据
 */
- (void)downloadLoadMore
{
    [self stopRefresh:self.tableView];
}

- (void)refreshData:(NSNotification  * _Nonnull )notification
{
    [self startHeadRefresh:self.tableView];
}

#pragma mark - LJConferenceTableViewCellDelegate

- (void)share:(JSONModel *)obj
{
    BOOL isHideLanjing = ![[[AccountManager sharedInstance] verified] isEqualToString:@"1"];
    ShareView *shareView = [[ShareView alloc] initWithDelegate:self shareObj:obj hideLanjing:isHideLanjing];
    UINavigationController *viewController = (UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    [shareView show:viewController.topViewController.view animated:YES];
}

#pragma mark - ShareViewProtocol

- (void)shareAction:(ShareType)type shareView:(ShareView * __nonnull)shareView shareObj:(id __nullable)obj
{
    TkShareData *shareData = [TkShareData new];
    
    NSString *theme = nil;
    NSString *aShareUrl = nil;
    NSString *imageString = nil;
    NSString *meetId = nil;
    if ([obj isKindOfClass:[LJMeetListDataModel class]]) {
        LJMeetListDataModel *model = (LJMeetListDataModel *)obj;
        theme = model.theme;
        aShareUrl = model.shareurl;
        imageString = model.img;
        meetId = model.id.description;
    } else if ([obj isKindOfClass:[LJHistoryMeetListDataModel class]]){
        LJHistoryMeetListDataModel *model = (LJHistoryMeetListDataModel *)obj;
        theme = model.theme;
        aShareUrl = model.shareurl;
        imageString = model.img;
        meetId = model.id.description;
    } else if ([obj isKindOfClass:[LJReservationMeetListDataModel class]]){
        LJReservationMeetListDataModel *model = (LJReservationMeetListDataModel *)obj;
        theme = model.theme;
        aShareUrl = model.shareurl;
        imageString = model.img;
        meetId = model.id.description;
    }
    
    if (type == TKSharePlatformWXTimeline) {
        shareData.title = theme;
        shareData.shareImage = [UIImage imageNamed:@"share_icon"];
        shareData.shareText = theme;
        shareData.url = aShareUrl;
    } else if (type == TKSharePlatformSinaWeibo) {
        shareData.title = @"分享来自蓝鲸财经APP的会议";
        shareData.shareText = [NSString stringWithFormat:@"蓝鲸财经提供更高效、更便捷的在线会议解决方案。【%@】会议预告",theme];
        shareData.url = aShareUrl;
        NSURL *imageUrl = [LJUrlHelper tryEncode:imageString];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:imageUrl
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
    }
    
    if (type == ShareTypeLanjing) {
        [self shareToLanjingWithString:shareData.shareText];
    } else if (type == TKSharePlatformSinaWeibo){
        
    } else {
        [self shareWithShareData:shareData andType:type];
    }
    
    [ShareAnalyseManager shareReport:meetId contentType:LJShareFromTypeMeet sharetype:type completion:^(BOOL success, NSError * _Nullable error) {
        
    }];
}

#pragma mark - public

- (MBProgressHUD *)showLoadingHudInView:(UIView *)view
{    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    UIView *superView = [UIView new];
    superView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [UIImageView new];
    //    UIImage *image = [UIImage sd_animatedGIFNamed:@"conference_loading"];
    NSMutableArray *imageArray = [NSMutableArray new];
    for (NSInteger index = 0; index < 9; index ++) {
        NSString *imageString = [NSString stringWithFormat:@"conference_loading_%ld",(long)index];
        UIImage *image = [UIImage imageNamed:imageString];
        [imageArray addObject:image];
    }
    //    imageView.image = image;
    imageView.animationImages = imageArray;
    imageView.animationDuration = kLodingDurate;
    imageView.animationRepeatCount = 0;
    [imageView startAnimating];
    [superView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(superView);
        make.height.mas_equalTo(100);
    }];
    
    UILabel *label = [UILabel new];
    label.text = @"加载中……";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:16];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    [superView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(superView);
        make.top.mas_equalTo(imageView.mas_bottom).offset(10);
    }];
    
    hud.customView = superView;
    [superView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 130));
        make.center.mas_equalTo(hud);
    }];
    
    hud.bezelView.color = [UIColor clearColor];
    return hud;
}

- (void)networkReload
{
    
}

- (void)hidenNoDataView
{
    if (self.noDataView) {
        self.noDataView.hidden = YES;
    }
}

- (void)showNoDataWithTitle:(NSString *)title Error:(void (^)(id sender))handler
{
    if (!self.noDataView) {
        UIView *superView = [UIView new];
        superView.backgroundColor = DefaultBackgroundColor;
        [self.view addSubview:superView];
        [superView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        
        UILabel *tipLabel = [UILabel new];
        tipLabel.font = [UIFont systemFontOfSize:15];
        tipLabel.textColor = [UIColor rgb:0x999999];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.text = title;
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.numberOfLines = 1;
        tipLabel.tag = 1000;
        [superView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(superView);
            make.centerY.mas_equalTo(superView.mas_centerY).offset(-20);
        }];
        self.noDataView = superView;
    } else {
        self.noDataView.hidden = NO;
    }
}

- (void)showNetError:(void (^)(id sender))handler
{
    [self showNetErrorWithTitle:@"网络连接失败，点击重新加载" handler:handler];
}

- (void)hidenNetError
{
    if (self.errorView) {
        self.errorView.hidden = YES;
    }
    
    if (self.noDataView) {
        self.noDataView.hidden = YES;
    }
}

- (void)showNetErrorWithTitle:(NSString * _Nonnull)title handler:(void (^ _Nonnull)(id _Nonnull))handler
{
    if (!self.errorView) {
        UIView *superView = [UIView new];
        superView.backgroundColor = DefaultBackgroundColor;
        [self.view addSubview:superView];
        [superView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        
        UILabel *tipLabel = [UILabel new];
        tipLabel.font = [UIFont systemFontOfSize:15];
        tipLabel.textColor = [UIColor rgb:0x999999];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.text = title;
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.numberOfLines = 1;
        [superView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(superView);
            make.centerY.mas_equalTo(superView.mas_centerY).offset(-20);
        }];
        
        UIButton *button = [UIButton new];
        [button setBackgroundImage:[UIImage imageNamed:@"noresult_refresh"] forState:UIControlStateNormal];
        [button bk_addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
        [superView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(tipLabel.mas_top).offset(-10);
            make.centerX.mas_equalTo(superView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];
        self.errorView = superView;
    } else {
        self.errorView.hidden = NO;
    }
}

@end

