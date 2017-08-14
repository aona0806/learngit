//
//  HotConferenceTableViewController.m
//  news
//
//  Created by 陈龙 on 15/9/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJHotConferenceTableViewController.h"
#import "MBProgressHUD.h"
#import "UIImage+GIF.h"
#import "LJConferenceDetailViewController.h"
#import "LJMeetTalkViewController.h"


@interface LJHotConferenceTableViewController ()

@end

@implementation LJHotConferenceTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray new];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateJoinConferenceWithMeetId:)
                                                 name:[GlobalConsts KJoinConferenceNotication]
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateCancelConferenceWithMeetId:)
                                                 name:[GlobalConsts KCancelConferenceNotication]
                                               object:nil];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:[GlobalConsts KHotConferenceRefreshNotication] object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name: [GlobalConsts KHotConferenceRefreshNotication] object:nil];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - download

- (void)downloadRefresh
{
    __weak typeof(self) weakSelf = self;
    [self hidenNetError];
    
    MBProgressHUD *hud = nil;
    if (self.isFirstLoading) {
        hud = [self showLoadingGif:self.view];
        self.isFirstLoading = false;
    }
    
    
    TKRequestHandler *requestHandler = [TKRequestHandler sharedInstance];
    [requestHandler getMeetListWithLastTime:nil rn:self.pageNum refresh_type:TKDataFreshTypeRefresh complated:^(NSURLSessionDataTask * _Nonnull sessionDataTask, LJMeetListModel * _Nullable model, NSError * _Nullable error) {
        
        if (hud) {
            [hud hideAnimated:YES];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf stopRefresh:weakSelf.tableView];
        });
        
        if (!error) {
            [weakSelf.dataSource removeAllObjects];
            [weakSelf.dataSource addObjectsFromArray:model.data];
            self.tableView.tableFooterView = nil;
            
            if (self.dataSource.count == 0) {
                [weakSelf showNoDataWithTitle:@"暂无最新会议，可到历史会议中查看往期回顾" Error:^(id sender) {
                    [weakSelf downloadRefresh];
                }];
            }
        } else if (error.code == KENetWorkErrorCode){
            if (weakSelf.dataSource && weakSelf.dataSource.count > 0) {
                [self showToastHidenDefault:error.domain];
            } else {
                [weakSelf showNetError:^(id  _Nonnull sender) {
                    
                    [weakSelf downloadRefresh];
                }];
            }
        } else if (error.code == KENoDataErrorCode) {
            if (self.dataSource.count == 0) {
                [weakSelf showNoDataWithTitle:@"暂无最新会议，可到历史会议中查看往期回顾" Error:^(id sender) {
                    [weakSelf downloadRefresh];
                }];
                
            } else {
                [self showToastHidenDefault:error.domain];
            }
            
        } else {
            if (weakSelf.dataSource && weakSelf.dataSource.count > 0) {
                [self showToastHidenDefault:error.domain];
            } else {
                [weakSelf showNetError:^(id  _Nonnull sender) {
                    
                    [weakSelf downloadRefresh];
                }];
            }
        }
        [weakSelf.tableView reloadData];
    }];
    
}

- (void)downloadLoadMore
{
    if (self.dataSource && self.dataSource.count > 0) {
        LJMeetListDataModel *model = [self.dataSource lastObject];
        NSString *lastTimeString = model.startTime;
        __weak typeof(self) weakSelf = self;
        TKRequestHandler *requestHandler = [TKRequestHandler sharedInstance];
        [requestHandler getMeetListWithLastTime:lastTimeString rn:20 refresh_type:TKDataFreshTypeLoadMore complated:^(NSURLSessionDataTask * _Nonnull sessionDataTask, LJMeetListModel * _Nullable model, NSError * _Nullable error) {
            
            if (!error) {
                [weakSelf.dataSource addObjectsFromArray:model.data];
                [weakSelf stopRefresh:self.tableView];
                if (model.data.count > 0) {
                    weakSelf.tableView.tableFooterView = nil;
                } else {
                    weakSelf.tableView.tableFooterView = weakSelf.tableFooterView;
                }
            } else if (error.code == KENetWorkErrorCode){
                [weakSelf showToastHidenDefault:error.domain];
                
                [weakSelf stopRefresh:weakSelf.tableView];
                
            }
            [weakSelf.tableView reloadData];
        }];
    } else {
        [self downloadRefresh];
    }
}

- (void)updateJoinConferenceWithMeetId:(NSNotification *)notification
{
    NSString *meetIdString = notification.object;
    
    for (NSInteger index = 0; index < self.dataSource.count; index ++ ) {
        LJMeetListDataModel *modelData = self.dataSource[index];
        if ([meetIdString isEqualToString:modelData.id.stringValue]) {
            modelData.rStatus = [NSNumber numberWithInteger:1];
            break;
        }
    }
    [self.tableView reloadData];
}

- (void)updateCancelConferenceWithMeetId:(NSNotification *)notification
{
    NSString *meetIdString = notification.object;
    
    for (NSInteger index = 0; index < self.dataSource.count; index ++ ) {
        LJMeetListDataModel *modelData = self.dataSource[index];
        if ([meetIdString isEqualToString:modelData.id.stringValue]) {
            modelData.rStatus = [NSNumber numberWithInteger:0];
            break;
        }
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JSONModel *model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:[LJMeetListDataModel class]]) {
        LJMeetListDataModel *modelData = (LJMeetListDataModel *)model;
        LJConferenceDetailViewController *viewController = [[LJConferenceDetailViewController alloc] init];
        viewController.idString = [NSString stringWithFormat:@"%@",modelData.id];
        
        self.superNavController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController: viewController animated: YES];
    }
}

#pragma mark - ConferenceTableViewCellDelegate

- (void)joinAppointment:(JSONModel *)amodel
{
    LJMeetListDataModel *modelData = (LJMeetListDataModel *)amodel;
    NSString *meetingId = [modelData.id stringValue];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superNavController.view animated:YES];
    hud.detailsLabel.text = @"预约会议中...";
    __weak typeof(self) weakSelf = self;
    [[TKRequestHandler sharedInstance] postSubscribeMeeting:meetingId isSubscribe:YES complated:^(NSURLSessionDataTask * _Nonnull sessionDataTask, LJBaseJsonModel * _Nullable model, NSError * _Nullable error) {
        
        [hud hideAnimated:YES afterDelay:0.7];
        
        hud.mode = MBProgressHUDModeText;
        if (error) {
            
            if (error.code == /* DISABLES CODE */ (20401) || error.code == 21206) {
                hud.detailsLabel.text = @"已经预约该会议";
                modelData.rStatus = [NSNumber numberWithInteger:1];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            } else if (error.code == 21205) {
                hud.detailsLabel.text = @"当前阶段会议不允许预约";
            }else{
                hud.detailsLabel.text = @"预约失败";
            }
        } else {
            NSInteger errNo = [model.dErrno integerValue];
            if (errNo == 0){
                hud.detailsLabel.text = @"预约成功";
                
                modelData.rStatus = [NSNumber numberWithInteger:1];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                    [[NSNotificationCenter defaultCenter] postNotificationName:[GlobalConsts KJoinConferenceNotication]
                                                                        object:meetingId];
                });
            } else {
                if (model.msg && model.msg.length > 0) {
                    hud.detailsLabel.text = model.msg;
                }
            }
        }
        [hud hideAnimated:YES afterDelay:1.7];
    }];
}

- (void)cancelAppointment:(JSONModel *)amodel
{
    LJMeetListDataModel *modelData = (LJMeetListDataModel *)amodel;
    NSString *meetingId = [modelData.id stringValue];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superNavController.view animated:YES];
    hud.detailsLabel.text = @"预约取消中...";
    __weak typeof(self) weakSelf = self;
    [[TKRequestHandler sharedInstance] postSubscribeMeeting:meetingId isSubscribe:NO complated:^(NSURLSessionDataTask * _Nonnull sessionDataTask, LJBaseJsonModel * _Nullable model, NSError * _Nullable error) {
        [hud hideAnimated:YES afterDelay:0.7];
        
        hud.mode = MBProgressHUDModeText;
        
        if (error) {
            if (!model) {
                hud.detailsLabel.text = @"网络错误";
            } else {
                NSString *msg = model.msg.length > 0 ? model.msg : @"网络错误";
                hud.detailsLabel.text = msg;
            }
        } else {
            NSInteger errNo = [model.dErrno integerValue];
            hud.detailsLabel.text = @"取消预约失败";
            if (errNo == 0){
                hud.detailsLabel.text = @"取消预约成功";
                modelData.rStatus = [NSNumber numberWithInteger:0];
                [[NSNotificationCenter defaultCenter] postNotificationName:[GlobalConsts KCancelConferenceNotication]
                                                                    object:meetingId];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
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

- (void)enterConference:(JSONModel *)model
{
    if ([model isKindOfClass:[LJMeetListDataModel class]]) {
        LJMeetListDataModel *meetModel = (LJMeetListDataModel *)model;
        NSString * meetId = meetModel.id.description;
        if (meetId.length == 0) {
            return;
        }
        
        self.superNavController.hidesBottomBarWhenPushed = YES;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [LJMeetTalkViewController tryEnterWithMeetId:meetId nav:self.navigationController completion:^(BOOL ok ,NSString *errMsg , LJMeetTalkViewController *controller) {
            if (!ok) {
                hud.detailsLabel.text = errMsg;
                hud.mode = MBProgressHUDModeText;
            }
            [hud hideAnimated:YES afterDelay:1.5];
        }];
        
    }
}

@end
