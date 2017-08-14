//
//  LJFriendsNotificationController.h
//  news
//
//  Created by 陈龙 on 15/12/20.
//  Copyright (c) 2015年 lanjing. All rights reserved.
//

#import "LJFriendsListController.h"
#import "news-Swift.h"
#import "UIViewController+Refresh.h"
#import "LJFriendsTableViewCell.h"
#import "TKRequestHandler+Message.h"

@interface LJFriendsListController ()<UISearchResultsUpdating, UISearchBarDelegate,UISearchControllerDelegate,FriendsTableViewCellDelegate>
{
    
}

@property (nonatomic, strong) UITableViewController *searchResultController;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray<LJUserFriendDataListModel *> *listDataMutableArray;
@property (nonatomic, strong) NSMutableArray<LJUserFriendDataListModel *> *searchArray;
@property (nonatomic, strong) LJUserFriendDataListModel *seclectNoteData;
@property (nonatomic) BOOL isNavigationbarHidden;

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *statusView;
@property (nonatomic) NSInteger searchPageNum;
@property (nonatomic, strong) NSString *searchString;
@property (nonatomic, assign) BOOL isFirstLoading;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, weak) MBProgressHUD *loadHUD;

@end

@implementation LJFriendsListController

#pragma mark - download

- (void) downloadData:(BOOL)refreshNew
{
    
    MBProgressHUD *hud = nil;
    if (self.isFirstLoading ) {
        if ( [[UIApplication sharedApplication]applicationState] == UIApplicationStateActive) {
            hud = [self showLoadingGif:self.view];
        }        
        self.isFirstLoading = false;
        self.loadHUD = hud;
    }
    
    if (refreshNew) {
        self.pageNum = 1;
    }
    
    __weak typeof(self) weakSelf = self;
    [[TKRequestHandler sharedInstance] getFriendListWithPageIndex:_pageNum withCount:@"20" AndIfSearchWithKey:@"" complated:^(NSURLSessionDataTask *sessionDataTask, LJUserFriendModel *model, NSError *error) {
        [weakSelf stopRefresh:weakSelf.tableView];
        
        if (hud != nil) {
            BOOL animate = true;
            if ([[UIApplication sharedApplication]applicationState] != UIApplicationStateActive) {
                animate = false;
            }
            [hud hideAnimated:animate];
        }
        
        if (error) {
            if (error.code == 20024) {
                return;
            }
            NSString *msg = error.domain ?: [GlobalConsts NetErrorNetMessage];
            [weakSelf showToastHidenDefault:msg];
            return;
        } else {
            
            NSArray *userDataArray = model.data.list;
            if (refreshNew) {
                _listDataMutableArray = [[NSMutableArray alloc] initWithArray:userDataArray];
                weakSelf.pageNum = 2;
            } else {
                [weakSelf.listDataMutableArray addObjectsFromArray:userDataArray];
                weakSelf.pageNum += 1;
            }
            [weakSelf.tableView reloadData];
                              
        }
        
    }];
}

- (void) updateSearchFriendListWithKeyword:(NSString *)searchString dataRefreshType:(TKDataFreshType)refreshType {
    
    if (refreshType == TKDataFreshTypeRefresh) {
        self.searchPageNum = 1;
    } else {
        if (!self.searchPageNum) {
            self.searchPageNum = 1;
        }
        
        self.searchPageNum ++;
    }
    
    __weak typeof(self) weakSelf = self;
    [[TKRequestHandler sharedInstance] getFriendListWithPageIndex:self.searchPageNum withCount:@"20" AndIfSearchWithKey:searchString complated:^(NSURLSessionDataTask *sessionDataTask, LJUserFriendModel *model, NSError *error) {
        
        [weakSelf stopRefresh:weakSelf.searchResultController.tableView];
        
        if (!error) {
            
            NSArray<LJUserFriendDataListModel *> *userDataArray = model.data.list;
            
            if (refreshType == TKDataFreshTypeRefresh) {
                self.searchArray = [NSMutableArray arrayWithArray:userDataArray];
            } else {
                if (!weakSelf.searchArray) {
                    weakSelf.searchArray = [[NSMutableArray alloc] init];
                }
                [weakSelf.searchArray addObjectsFromArray:userDataArray];
            }
            
            [weakSelf.searchResultController.tableView reloadData];
        } else {
            if (refreshType == TKDataFreshTypeRefresh) {
                weakSelf.searchArray = [[NSMutableArray alloc] init];
                [weakSelf.searchResultController.tableView reloadData];
            }
        }
    }];
}

#pragma mark - lifCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"好友列表";

    _pageNum = 1;
    
    self.navigationController.navigationBar.translucent = true;
    self.automaticallyAdjustsScrollViewInsets = true;
    
    self.definesPresentationContext = true;
    _searchResultController = [[UITableViewController alloc]init] ;
    _searchResultController.tableView.delegate = self;
    _searchResultController.tableView.dataSource = self;
    
    _searchController = [[UISearchController alloc]initWithSearchResultsController:_searchResultController];
    _searchController.searchResultsUpdater = self;
    _searchController.delegate = self;
    
    _searchController.dimsBackgroundDuringPresentation = false;
    [_searchController.searchBar sizeToFit];
    _searchController.searchBar.delegate = self;
    self.searchBar = _searchController.searchBar;
    
    UIView *headerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    headerView.backgroundColor = [UIColor clearColor];
    
    self.searchBar.frame =  CGRectMake(0, 0, SCREEN_WIDTH, 44);
//    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"搜索";
    for (UIView *subview in self.searchBar.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UIView")] && subview.subviews.count > 0) {
            [[subview.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor colorWithRed:235.0/255.0f green:236/255.0f blue:238/255.0f alpha:1];
    imageView.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    [self.searchBar insertSubview:imageView atIndex:0];
    self.searchBar.clipsToBounds = false;
    [headerView addSubview:self.searchBar];
    headerView.clipsToBounds = true;
    
    self.headerView = headerView;
    
    self.tableView.tableHeaderView = headerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 设置TableView的刷新
    __weak LJFriendsListController *selfCV = self;
    [self addHeaderRefreshView:self.tableView callBack:^{
        
        if (selfCV){
            LJFriendsListController *strongSelf = selfCV;
            
            strongSelf.pageNum = 1;
            [strongSelf downloadData:true];
        }
    }];
    
    [self addFooterRefreshView:self.tableView callBack:^{
        [selfCV downloadData:false];
    }];
    
    [self addFooterRefreshView:self.searchResultController.tableView callBack:^{
        selfCV.searchPageNum = 1;
        [selfCV updateSearchFriendListWithKeyword:selfCV.searchString dataRefreshType:TKDataFreshTypeLoadMore];
    }];
    
    self.isFirstLoading = true;
    [self downloadData:true];
    
    self.navigationController.navigationBar.translucent = false;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newfriendNotification:) name:[GlobalConsts Notification_NewFriend] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRelationType:) name:[GlobalConsts Notification_UserDetailChangeRelationType] object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationBecameActivieNotificatin:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] < 10.0) {
        self.statusView = [[UIView alloc]initWithFrame:[[UIApplication sharedApplication] statusBarFrame]];
        self.statusView.backgroundColor =  [UIColor colorWithRed:235.0/255.0f green:236/255.0f blue:238/255.0f alpha:1];
        _statusView.hidden = true;
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:false animated:true];
    if (_statusView) {
        [[[UIApplication sharedApplication]keyWindow] addSubview:_statusView];
    }
    self.navigationController.interactivePopGestureRecognizer.enabled = false;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_statusView removeFromSuperview];
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
}

-(void)updateViewConstraints
{
    [super updateViewConstraints];
    [self updatLayout];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - private

-(void)updatLayout
{
    if (self.navigationController != nil) {
        
        CGRect navFrame = self.navigationController.navigationBar.frame;
        CGRect headFrame = _headerView.frame;
        headFrame.size.height = CGRectGetHeight(navFrame);
        
        if (!CGRectEqualToRect(headFrame, _headerView.frame)) {
            _headerView.frame = headFrame;
            self.tableView.tableHeaderView =_headerView;
        }
        
        self.searchBar.bottom = _headerView.height;
        
    }
}

/**
 *  进入个人详情界面
 */
- (void) cellPushToUserTelTableViewController
{
    LJUserDeltailViewController *telViewController = [[LJUserDeltailViewController alloc] init];
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
    
    for (LJUserFriendDataListModel *noteData in self.searchArray) {
        if ([noteData.id isEqualToString:uidString]) {
            noteData.userRelation.followType = followTypeString;
            [_searchResultController.tableView reloadData];
            break;
        }
    }
    
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated: YES];
    
    if (tableView == self.tableView)
    {
        _seclectNoteData = _listDataMutableArray[row];        
    }else{
        _seclectNoteData = _searchArray[row];;
    }
    
    if (_searchController.isActive) {
        _searchController.active = false;
    }else{
       [self cellPushToUserTelTableViewController];
    }
}



#pragma mark - FriendsTableViewCellDelegate

- (void)AddFriendsDelegateWithCell:(LJFriendsTableViewCell *)cell
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

#pragma mark - UISearchDisplayDelegate


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    self.searchString = searchController.searchBar.text;
    [self updateSearchFriendListWithKeyword:_searchString dataRefreshType:TKDataFreshTypeRefresh];
    
}

- (void)presentSearchController:(UISearchController *)searchController
{
}

- (void)willPresentSearchController:(UISearchController *)searchController
{
    self.tableView.tableHeaderView.clipsToBounds = false;
    self.seclectNoteData = nil;
    
    if (_statusView) {
        self.tableView.header.hidden = true;
    }    
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
    if (_statusView) {
        _statusView.hidden = false;
    }
}
- (void)willDismissSearchController:(UISearchController *)searchController
{
    self.tableView.tableHeaderView.clipsToBounds = true;
    if (_statusView) {
        _statusView.hidden = true;
    }
}
- (void)didDismissSearchController:(UISearchController *)searchController
{
    if (_seclectNoteData) {
        [self cellPushToUserTelTableViewController];
    }
    if (_statusView) {
        self.tableView.header.hidden = false;
    }
    self.searchBar.top = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)applicationBecameActivieNotificatin:(NSNotification *)notification
{
    if (_loadHUD) {
        [_loadHUD hideAnimated:false];
    }
}

-(void)newfriendNotification:(NSNotification *)notification
{
    [self downloadData:true];
}


@end
