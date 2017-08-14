//
//  LJFriendsNotificationTableViewController.m
//  news
//
//  Created by 陈龙 on 15/12/9.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJFriendsNotificationTableViewController.h"
#import "TKRequestHandler+Message.h"
#import "UIViewController+Refresh.h"
#import "news-Swift.h"
#import "LJFriendsTableViewCell.h"

@interface LJFriendsNotificationTableViewController () <FriendsTableViewCellDelegate>
{
    
}

@property (nonatomic, strong) NSMutableArray<LJUserFriendDataListModel *> *listDataMutableArray;
@property (nonatomic, strong) NSMutableArray<LJUserFriendDataListModel *>*searchArray;
@property (nonatomic, strong) LJUserFriendDataListModel *seclectNoteData;
@property (nonatomic) BOOL isNavigationbarHidden;

@property (nonatomic, strong) LJUserFriendDataListModel *AddNoteData;
@property (nonatomic, strong) LJFriendsTableViewCell *seclectedCell;

@property (nonatomic, strong) UISearchBar *searchBar;
//@property (nonatomic, assign) BOOL isAppear;
@property (nonatomic, strong) UIView *headerView;//用于当导航栏有回到会议时显示头部空白
@property (nonatomic, assign) BOOL isFirstLoading;
@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation LJFriendsNotificationTableViewController


#pragma mark - lifCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"好友通知";
        
    self.navigationItem.backBarButtonItem.title = @"";
    
    self.headerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    _headerView.backgroundColor = [UIColor clearColor];
    
    _pageNum = 1;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 设置TableView的刷新
    self.isFirstLoading = true;
    
    __weak LJFriendsNotificationTableViewController *selfCV = self;
    [self addHeaderRefreshView:self.tableView callBack:^{
        [selfCV downloadData:TKDataFreshTypeRefresh];

    }];
    [self addFooterRefreshView:self.tableView callBack:^{
        
        [selfCV downloadData:TKDataFreshTypeLoadMore];

    }];
    [self downloadData:TKDataFreshTypeRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFriendNotification) name:[GlobalConsts Notification_NewfriendNotification] object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRelationType:) name:[GlobalConsts Notification_UserDetailChangeRelationType] object:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:false animated:true];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refreshFriendNotification{
    [self downloadData:TKDataFreshTypeLoadMore];
}

-(void)updateViewConstraints
{
    [super updateViewConstraints];
    [self updatLayout];
}

-(void)updatLayout
{
    if (self.navigationController != nil) {
        
        CGRect headFrame = _headerView.frame;
        headFrame.size.height = self.navigationController.navigationBar.bottom - NAVBAR_HEIGHT;
        if (!CGRectEqualToRect(headFrame, _headerView.frame)) {
            _headerView.frame = headFrame;
            self.tableView.tableHeaderView =_headerView;
        }
    }
}


//-(void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    CGRect tframe = self.tableView.frame;
//    if (self.isAppear && self.navigationController) {
//        CGRect navFrame = self.navigationController.navigationBar.frame;
//        if (navFrame.size.height > 44) {
//            if (fabs(tframe.origin.y - CGRectGetMaxY(navFrame)) > 1) {
//                tframe.size.height = CGRectGetMaxY(tframe) - CGRectGetMaxY(navFrame);
//                tframe.origin.y = CGRectGetMaxY(navFrame);
//                
//                if (!CGRectEqualToRect(self.tableView.frame, tframe)) {
//                    self.tableView.frame = tframe;
//                }
//            }
//        }
//    }
//}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [RedDotManager sharedInstance].redDotModel.friendMsg = @(0);
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageDismissNOtification" object:nil];
    //FIXME: 消除有好友通知的红点
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

- (void) cellPushToUserTelTableViewController
{
    LJUserDeltailViewController *telViewController = [[LJUserDeltailViewController alloc] init];
//    telViewController.delegate = self;
    telViewController.uid = self.seclectNoteData.id;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController: telViewController animated: YES];
    
}

- (void)changeRelationType:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    NSString *followTypeString = userInfo[@"type"];
    NSString *uidString = userInfo[@"uid"];
    
    for (LJUserFriendDataListModel *noteData in self.listDataMutableArray) {
        if ([noteData.id isEqualToString:uidString]) {
            noteData.userRelation.followType = followTypeString;
            [self.tableView reloadData];
            break;
        }
    }
    
}


#pragma mark - download

- (void) downloadData:(TKDataFreshType)refreshType
{
    if (refreshType == TKDataFreshTypeRefresh) {
        _pageNum = 1;
    }
    
    MBProgressHUD *hud = nil;
    if (self.isFirstLoading) {
        hud = [self showLoadingGif:self.view];
        self.isFirstLoading = false;
    }
    
    NSString *pageStr = [NSString stringWithFormat:@"%ld",(long)_pageNum];
    __weak typeof(self) weakSelf = self;
    
    [[TKRequestHandler sharedInstance] getHaoYouNoticationDataWithPage:pageStr withCount:@"20" AndIfSearchWithKey:@"" complated:^(NSURLSessionDataTask *sessionDataTask, LJUserFriendModel *model, NSError *error) {
        [weakSelf stopRefresh:self.tableView];
        
        if (hud != nil) {
            [hud hideAnimated:YES];
        }
        
        if (error) {
            
            if (error.code != 20024) {
                [weakSelf showToastHidenDefault:error.domain ?:[GlobalConsts NetRequestNoResult]];
            }

            return;
        } else {
            NSArray<LJUserFriendDataListModel *> *userDataArray = model.data.list;
            if (refreshType == TKDataFreshTypeRefresh) {
                weakSelf.listDataMutableArray = [NSMutableArray arrayWithArray:userDataArray];
            } else {
                [weakSelf.listDataMutableArray addObjectsFromArray:userDataArray];
            }
            [weakSelf.tableView reloadData];
            if (model.data.list.count > 0) {
                weakSelf.pageNum += 1;
            }
        }
    }];
}

#pragma mark - UITableViewDataSource 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView)
    {
        return _listDataMutableArray.count;
    }
    else
    {
        return _searchArray.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSString *CellIdentifile = [NSString stringWithFormat:@"CellIdentifile"];
    LJFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifile];
    if (cell == nil)
    {
        cell = [[LJFriendsTableViewCell alloc] initWithMessageStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifile];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.delegate = self;
    }
    
    LJUserFriendDataListModel *noteData;
    
    if (tableView == self.tableView)
    {
        noteData = _listDataMutableArray[row];;
    }
    else
    {
        noteData = _searchArray[row];;
    }
    [cell setValueForCellAllValueWith:noteData];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated: YES];
        
    if (tableView == self.tableView)
    {
        _seclectNoteData = _listDataMutableArray[row];
        [self cellPushToUserTelTableViewController];
    }
}

#pragma mark - FriendsTableViewCellDelegate

- (void)AddFriendsDelegateWithCell:(LJFriendsTableViewCell *)cell
{
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell: cell];
    
    self.seclectedCell = cell;
    
    NSString *tipsStr = [[[[ConfigManager sharedInstance] config] tips] relationFollow];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:tipsStr message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    
    _AddNoteData = _listDataMutableArray[cellIndexPath.row];
}

- (void)AcceptFriendsDelegateWithCell:(LJFriendsTableViewCell *)cell
{
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell: cell];
    
    LJFriendsTableViewCell *tableCell = (LJFriendsTableViewCell *)[self.tableView cellForRowAtIndexPath:cellIndexPath];
    LJUserFriendDataListModel *noteData;
    if (tableCell == cell)
    {
        noteData = _listDataMutableArray[cellIndexPath.row];
    }
    else
    {
        noteData = _searchArray[cellIndexPath.row];
    }
    [cell fourcesSomebodyWith:noteData];
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
        {
            [self.seclectedCell fourcesSomebodyWith:_AddNoteData];
        }
            break;
        default:
            break;
    }
}

@end
