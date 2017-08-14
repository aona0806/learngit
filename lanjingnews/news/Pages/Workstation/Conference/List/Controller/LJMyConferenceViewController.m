//
//  MyConferenceViewController.m
//  news
//
//  Created by 陈龙 on 15/9/26.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMyConferenceViewController.h"
#import "LJConferenceDetailViewController.h"
#import "LJMeetTalkViewController.h"

@interface LJMyConferenceViewController ()

@end

@implementation LJMyConferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(downloadRefresh)
                                                 name:[GlobalConsts KJoinConferenceNotication]
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cancelConferenceWithMeetingid:)
                                                 name:[GlobalConsts KCancelConferenceNotication]
                                               object:nil];
    self.dataSource = [NSMutableArray new];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:[GlobalConsts KMyConferenceRefreshNotication] object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[GlobalConsts KMyConferenceRefreshNotication] object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelConferenceWithMeetingid:(NSNotification *)notification
{
    NSString *meetidString = [notification object];
    for (LJReservationMeetListDataModel *model in self.dataSource) {
        if ([[model.id stringValue] isEqualToString:meetidString]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.dataSource removeObject:model];
                [self.tableView reloadData];
            });
        }
    }
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
    
    [[TKRequestHandler sharedInstance] getReservationMeetListWithLastTime:nil rn:self.pageNum refresh_type:TKDataFreshTypeRefresh complated:^(NSURLSessionDataTask * _Nonnull sessionDataTask, LJReservationMeetListModel * _Nullable model, NSError * _Nullable error) {
        
        if (hud) {
            [hud hideAnimated:YES];
        }
        
        [weakSelf stopRefresh:weakSelf.tableView];
        
        if (!error) {
            [weakSelf.dataSource removeAllObjects];
            [weakSelf.dataSource addObjectsFromArray:model.data];
            weakSelf.tableView.tableFooterView = nil;
            
            if (weakSelf.dataSource.count == 0) {
                [weakSelf showNoDataWithTitle:@"您还没有预约任何会议" Error:^(id sender) {
                    [weakSelf downloadRefresh];
                }];
                
            }
        } else if (error.code == KENetWorkErrorCode){
            if (weakSelf.dataSource && weakSelf.dataSource.count > 0) {
                [weakSelf showToastHidenDefault:error.domain];
            } else {
                
                [weakSelf showNetError:^(id  _Nonnull sender) {
                    
                    [weakSelf downloadRefresh];
                }];
            }
            
        } else if (error.code == KENoDataErrorCode) {
            if (weakSelf.dataSource.count == 0) {
                [weakSelf showNoDataWithTitle:@"您还没有预约任何会议" Error:^(id sender) {
                    [weakSelf downloadRefresh];
                }];
                
            } else {
                [weakSelf showToastHidenDefault:error.domain];
            }
            
        } else {
            [weakSelf showToastHidenDefault:error.domain];
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
        [[TKRequestHandler sharedInstance] getReservationMeetListWithLastTime:lastTimeString rn:20 refresh_type:TKDataFreshTypeLoadMore complated:^(NSURLSessionDataTask * _Nonnull sessionDataTask, LJReservationMeetListModel * _Nullable model, NSError * _Nullable error) {
            
            [weakSelf stopRefresh:self.tableView];
            
            if (model.data.count > 0) {
                weakSelf.tableView.tableFooterView = nil;
            } else {
                weakSelf.tableView.tableFooterView = weakSelf.tableFooterView;
            }
            
            if (!error) {
                [weakSelf.dataSource addObjectsFromArray:model.data];
            } else if (error.code == KENetWorkErrorCode){
                [weakSelf showToastHidenDefault:error.domain];
            }
            [weakSelf.tableView reloadData];

        }];
    } else {
        [self downloadRefresh];
    }

}

#pragma mark - LJConferenceTableViewCellDelegate

- (void)joinAppointment:(JSONModel *)amodel
{
    LJReservationMeetListDataModel *modelData = (LJReservationMeetListDataModel *)amodel;
    NSString *meetingId = [modelData.id stringValue];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superNavController.view animated:YES];
    hud.label.text = @"预约会议中...";
    __weak typeof(self) weakSelf = self;
    [[TKRequestHandler sharedInstance] postSubscribeMeeting:meetingId isSubscribe:YES complated:^(NSURLSessionDataTask * _Nonnull sessionDataTask, LJBaseJsonModel * _Nullable model, NSError * _Nullable error) {
        
        [hud hideAnimated:YES];
        
        hud.mode = MBProgressHUDModeText;
        if (error) {
            if (error.code == 20401 || error.code == 21206) {
                hud.label.text = @"已经预约该会议";
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            } else if (error.code == 21205) {
                hud.label.text = @"当前阶段会议不允许预约";
            }else{
                hud.label.text = @"网络错误";
            }
        } else {
            NSInteger errNo = [model.dErrno integerValue];
            if (errNo == 0){
                hud.label.text = @"预约成功";
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
        [hud hideAnimated:YES afterDelay:0.7];

    }];
}

- (void)cancelAppointment:(JSONModel *)amodel
{
    LJReservationMeetListDataModel *modelData = (LJReservationMeetListDataModel *)amodel;
    NSString *meetingId = [modelData.id stringValue];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superNavController.view animated:YES];
    hud.label.text = @"预约取消中...";
    __weak typeof(self) weakSelf = self;
    [[TKRequestHandler sharedInstance] postSubscribeMeeting:meetingId isSubscribe:NO complated:^(NSURLSessionDataTask * _Nonnull sessionDataTask, LJBaseJsonModel * _Nullable model, NSError * _Nullable error) {
        
        hud.mode = MBProgressHUDModeText;
        
        if (error) {
            hud.label.text = @"取消预约失败";
        } else {
            NSInteger errNo = [model.dErrno integerValue];
            if (errNo == 0){
                hud.label.text = @"取消预约成功";
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
    if ([model isKindOfClass:[LJReservationMeetListDataModel class]]) {
        LJReservationMeetListDataModel *meetModel = (LJReservationMeetListDataModel *)model;
        NSString * meetId = meetModel.id.description;
        if (meetId.length == 0) {
            return;
        }
        self.superNavController.hidesBottomBarWhenPushed = YES;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [LJMeetTalkViewController tryEnterWithMeetId:meetId nav:self.navigationController completion:^(BOOL ok,NSString *errMsg , LJMeetTalkViewController *controller) {
            if (!ok) {
                hud.detailsLabel.text = errMsg;
                hud.mode = MBProgressHUDModeText;
            }
            [hud hideAnimated:YES afterDelay:1.5];
        }];
    }
}

-(void)showMeetDetail:(NSString *)meetId
{
    LJConferenceDetailViewController *viewController = [[LJConferenceDetailViewController alloc] init];
    viewController.idString = meetId;
    self.superNavController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController: viewController animated: YES];
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LJReservationMeetListDataModel *modelData = self.dataSource[indexPath.row];
    if (modelData.stage.integerValue != 4) {
        [self showMeetDetail:[NSString stringWithFormat:@"%@",modelData.id]];
    }
}

@end
