//
//  LJUserAddressBookSearchTableViewController.m
//  news
//
//  Created by 陈龙 on 15/12/22.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJUserAddressBookViewController.h"
#import "UIViewController+Refresh.h"
#import "TKRequestHandler+Workstation.h"
#import "LJUserNoteSearchTableViewCell.h"
#import "LJUserDeltailViewController.h"
#import "news-Swift.h"

@interface LJUserAddressBookViewController ()<UISearchResultsUpdating, UISearchBarDelegate,UISearchControllerDelegate>{
    
}
@property (nonatomic, strong) UITableViewController *searchResultController;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray<LJUserPhoneBookDataListModel *> *searchList;
@property (nonatomic, strong) NSMutableArray<LJUserPhoneBookDataListModel *> *userDataList;

@property (nonatomic, strong) UIView *topbar;
@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger persionalPageNum;
@property (nonatomic, assign) NSInteger searchPage;
@property (nonatomic, assign) BOOL isFirstLoading;
@property (nonatomic, strong) NSString *choosedUid;//在搜索栏活跃时选择的用户uid
@property (nonatomic, weak)   NSURLSessionDataTask *currentTask;

@end

@implementation LJUserAddressBookViewController

#pragma mark - lifCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = true;
    self.automaticallyAdjustsScrollViewInsets = true;
    self.hidesBottomBarWhenPushed = YES;
    self.title = @"用户通讯录";
        
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.userDataList = [NSMutableArray new];
    
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
    
    self.headView = [self createHeadview];
    
    // 添加 searchbar 到 headerview
    self.tableView.tableHeaderView = self.headView;
    
    self.definesPresentationContext = true;

    // 设置TableView的刷新
    __weak __typeof(self) weakSelf = self;
    [self addHeaderRefreshView:self.tableView callBack:^{
        weakSelf.pageNum = 1;
        [weakSelf getTongxunluSearchContent:nil WithPage:@"1" withPerct:@"20"];
    }];
    
    [self addFooterRefreshView:self.tableView callBack:^{
        NSString *pageString = [NSString stringWithFormat:@"%ld", (long)weakSelf.pageNum];
        [weakSelf getTongxunluSearchContent:nil WithPage:pageString withPerct:@"20"];
    }];
    
    self.searchPage = 1;
    [self addFooterRefreshView:_searchResultController.tableView callBack:^{
        NSString *searchString = weakSelf.searchController.searchBar.text;
        [weakSelf searchDataWithPage:weakSelf.searchPage withSearchString:searchString];
    }];

    self.pageNum = 1;
    self.persionalPageNum = 1;
    
    self.isFirstLoading = true;
    [self getTongxunluSearchContent:nil WithPage:@"1" withPerct:@"20"];

    self.navigationController.navigationBar.translucent = false;
    [self updateLayout];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.searchController.presentingViewController) {
        [self.navigationController setNavigationBarHidden:false animated:true];
    }
    self.navigationController.interactivePopGestureRecognizer.enabled = false;
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = false;
}

#pragma mark - private

- (UIView *)createHeadview
{
    UIView *headerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    headerView.backgroundColor = [UIColor clearColor];
        
    self.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"搜索";
    self.searchBar.backgroundColor=[UIColor clearColor];
    
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
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
    [headerView addSubview: self.searchBar];
    
    headerView.clipsToBounds = true;
    
    return headerView;
    
}

-(UIView *)topbar
{
    if (!_topbar) {
        
        _topbar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
        _topbar.backgroundColor = RGB(235, 236, 238);
    }
    return _topbar;
}

-(void)updateLayout
{
    if (self.navigationController != nil) {
        
        CGRect navFrame = self.navigationController.navigationBar.frame;
        CGRect headFrame = _headView.frame;
        headFrame.size.height = CGRectGetHeight(navFrame);
        if (!CGRectEqualToRect(headFrame, _headView.frame)) {
            _headView.frame = headFrame;
            self.tableView.tableHeaderView =_headView;
        }
    }
}

#pragma mark - download

/**
 *  获取全部数据
 *
 *  @param searchString ;
 *  @param page         <#page description#>
 *  @param perct        <#perct description#>
 */
-(void)getTongxunluSearchContent:(NSString *)searchString WithPage:(NSString *)page withPerct:(NSString *)perct
{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hud = nil;
    if (self.isFirstLoading) {
        hud = [self showLoadingGif:self.view];
        self.isFirstLoading = false;
    }
    
    
    [[TKRequestHandler sharedInstance] getUserPhoneBookSearchKeyword:searchString Page:page withCount:perct complated:^(NSURLSessionDataTask * _Nonnull sessionDataTask, LJUserPhoneBookModel * _Nullable model, NSError * _Nullable error) {
        
        [weakSelf stopRefresh:self.tableView];
        if (hud != nil) {
            [hud hideAnimated:YES];
        }
        
        
        if (!error) {
            if (model.dErrno.integerValue == 0) {
                
                NSIndexPath *nearIndexPath = nil;
                if ([page isEqualToString:@"1"]) {
                    self.userDataList = [NSMutableArray arrayWithArray:model.data.list];
                } else {
                    NSInteger row = model.data.list.count > 0 ? 1 : 0;
                    row += self.userDataList.count - 1;
                    nearIndexPath = [NSIndexPath indexPathForRow:row inSection:0];

                    [self.userDataList addObjectsFromArray:model.data.list];
                }
                self.pageNum ++;
                [self.tableView reloadData];
                if (nearIndexPath) {
                    [self.tableView scrollToRowAtIndexPath:nearIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                }
            } else {
                NSString *msg =  model.msg ?: [GlobalConsts NetRequestNoResult];
                [weakSelf showToastHidenDefault:msg];
            }
        } else {
            
            [weakSelf showToastHidenDefault:error.domain];
            
        }
    }];
}


-(void)searchDataWithPage:(NSInteger)page withSearchString:(NSString *)searchString
{
    static NSInteger totlePage = 1;
    
    if (page > totlePage)
    {
        [self stopRefresh:_searchResultController.tableView];
        return;
    }
    
    if (_currentTask && _currentTask.state == NSURLSessionTaskStateRunning) {
        [_currentTask cancel];
    }
    
    NSString *pageString = [NSString stringWithFormat:@"%d",(int)page];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [[TKRequestHandler sharedInstance] getUserPhoneBookSearchKeyword:searchString Page:pageString withCount:@"15" complated:^(NSURLSessionDataTask * _Nonnull sessionDataTask, LJUserPhoneBookModel * _Nullable model, NSError * _Nullable error) {
        
        [weakSelf stopRefresh:weakSelf.searchResultController.tableView];
        
        if (!error) {
            if (model.dErrno.integerValue == 0) {
                NSIndexPath *nearIndexPath = nil;
                if (weakSelf.searchPage == 1) {
                    weakSelf.searchList = [[NSMutableArray alloc] initWithArray:model.data.list];
                }else{
                    NSInteger row = model.data.list.count > 0 ? 1 : 0;
                    row += weakSelf.searchList.count - 1;
                    nearIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
                    [weakSelf.searchList addObjectsFromArray: model.data.list];
                }
                weakSelf.searchPage ++;
                totlePage = model.data.totalNumber.integerValue;
                [_searchResultController.tableView reloadData];
                if (nearIndexPath) {
                    [_searchResultController.tableView scrollToRowAtIndexPath:nearIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                }
            } else {
                if (weakSelf.searchPage == 1) {
                    weakSelf.searchList = nil;
                    [_searchResultController.tableView reloadData];
                }
            }

        }
    }];
    
    self.currentTask = task;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = 1;
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (tableView == self.tableView)
    {
        count = self.userDataList.count;

    }else{
        count = self.searchList.count;
    }
    return count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 60;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifile = @"LJAddNoteTableViewCellIdentifile";
    LJUserNoteSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifile];
    if (cell == nil)
    {
        cell = [[LJUserNoteSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                           reuseIdentifier:CellIdentifile];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    LJUserPhoneBookDataListModel *info = nil;
    if (tableView == self.tableView) {
        info = self.userDataList[indexPath.row];
    } else {
        info = self.searchList[indexPath.row];
    }
    
    [cell updateInfo:info];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated: YES];
    
    self.tabBarController.tabBar.hidden = YES;
    UINavigationController *navController = self.navigationController;
    NSArray<LJUserPhoneBookDataListModel *> *listArray;
    if (tableView == self.tableView) {
        
        listArray = self.userDataList;
    }else{
        listArray = self.searchList;
    }
    
    NSString *noteIdString = listArray[indexPath.row].id;
    if (_searchController.isActive) {
        
        self.choosedUid = noteIdString;
        [self.searchController setActive:false];
        
    }else{
    
        LJUserDeltailViewController *userDetailViewController = [[LJUserDeltailViewController alloc] init];
        userDetailViewController.uid = noteIdString;
        [navController pushViewController: userDetailViewController animated: YES];
        
    }
}

#pragma mark - UISearchDisplayDelegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if (_choosedUid.length == 0) {
        _searchPage = 1;
        [self searchDataWithPage:1 withSearchString:searchController.searchBar.text];
    }  
}

- (void)presentSearchController:(UISearchController *)searchController
{
}

- (void)willPresentSearchController:(UISearchController *)searchController
{
    self.tableView.header.hidden = true;
    self.headView.clipsToBounds = false;
    _choosedUid = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 10.0) {
        [self.searchController.view addSubview:self.topbar];
    }
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
    self.tableView.header.hidden = false;
}
- (void)willDismissSearchController:(UISearchController *)searchController
{
    self.headView.clipsToBounds = true;
    self.tableView.header.hidden = true;
}
- (void)didDismissSearchController:(UISearchController *)searchController
{
    self.tableView.header.hidden = false;
    if (_choosedUid.length > 0) {
        LJUserDeltailViewController *userDetailViewController = [[LJUserDeltailViewController alloc] init];
        userDetailViewController.uid = _choosedUid;
        [self.navigationController pushViewController: userDetailViewController animated: YES];
    }
    self.searchBar.top = 0;
}

@end
