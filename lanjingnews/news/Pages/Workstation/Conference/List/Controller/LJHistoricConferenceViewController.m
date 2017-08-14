//
//  HistoricConferenceViewController.m
//  news
//
//  Created by 陈龙 on 15/9/26.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJHistoricConferenceViewController.h"
#import "LJConferenceDetailViewController.h"

@interface LJHistoricConferenceViewController ()

@end

@implementation LJHistoricConferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataSource = [NSMutableArray new];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:[GlobalConsts KHistoryConferenceRefreshNotication] object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[GlobalConsts KHistoryConferenceRefreshNotication] object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LJHistoryMeetListDataModel *modelData = self.dataSource[indexPath.row];
    if (modelData.status.integerValue != 4) {
        LJConferenceDetailViewController *viewController = [[LJConferenceDetailViewController alloc] init];
        viewController.idString = [NSString stringWithFormat:@"%@",modelData.id];
        
        self.superNavController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController: viewController animated: YES];
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
    
    [[TKRequestHandler sharedInstance] getHistoryMeetListWithLastTime:nil rn:self.pageNum refresh_type:TKDataFreshTypeRefresh complated:^(NSURLSessionDataTask * _Nonnull sessionDataTask, LJHistoryMeetListModel * _Nullable model, NSError * _Nullable error) {
        
        if (hud) {
            [hud hideAnimated:YES];
        }
        
        [self stopRefresh:self.tableView];
        
        if (!error) {
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:model.data];
            self.tableView.tableFooterView = nil;
            if (self.dataSource.count == 0) {
                [weakSelf showNoDataWithTitle:@"暂无历史会议，请等待会议结束再来查看吧" Error:^(id sender) {
                    [weakSelf downloadRefresh];
                }];
                
            }
        } else if (error.code == KENetWorkErrorCode) {
            if (weakSelf.dataSource && weakSelf.dataSource.count > 0) {
                [self showToastHidenDefault:error.domain];
            } else {
                [weakSelf showNetError:^(id  _Nonnull sender) {
                    [weakSelf downloadRefresh];
                }];
            }
        } else {
            [self showToastHidenDefault:error.domain];
        }
        [self.tableView reloadData];
    }];
}

- (void)downloadLoadMore
{
    if (self.dataSource && self.dataSource.count > 0) {
        LJHistoryMeetListDataModel *model = [self.dataSource lastObject];
        NSString *lastTimeString = model.startTime.stringValue;
        __weak typeof(self) weakSelf = self;
        [[TKRequestHandler sharedInstance] getHistoryMeetListWithLastTime:lastTimeString rn:20 refresh_type:TKDataFreshTypeLoadMore complated:^(NSURLSessionDataTask * _Nonnull sessionDataTask, LJHistoryMeetListModel * _Nullable model, NSError * _Nullable error) {
            
            [weakSelf stopRefresh:self.tableView];
            if (model.data.count > 0) {
                weakSelf.tableView.tableFooterView = nil;
            } else {
                weakSelf.tableView.tableFooterView = weakSelf.tableFooterView;
            }
            if (!error) {
                [weakSelf.dataSource addObjectsFromArray:model.data];
            } else if (error.code == KENetWorkErrorCode) {
                [weakSelf showToastHidenDefault:error.domain];
            }
            [weakSelf.tableView reloadData];
        }];
    } else {
        [self downloadRefresh];
    }
}

@end
