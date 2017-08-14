//
//  LJAddressBookSearchTableViewController.m
//  news
//
//  Created by 陈龙 on 15/12/18.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJInterviewUserListViewController.h"
#import "news-Swift.h"
#import "UIViewController+Refresh.h"
#import "LJAddressBookSearchTableViewCell.h"
#import "LJAddressBookAddTableViewController.h"
#import "LJAddressBookDetailViewController.h"

@interface LJInterviewUserListViewController ()<UISearchBarDelegate, LJAddNoteSegmentTableViewCellDelegate,UISearchResultsUpdating,UISearchControllerDelegate> {
    NSMutableArray<LJPhoneBookDataDataModel *> *allDataArray;
    NSMutableArray<LJPhoneBookDataDataModel *> *persionalListArray;
    NSMutableArray<LJPhoneBookDataDataModel *> *specialistListArray;
}

@property (nonatomic, strong) UITableViewController *searchResultController;
@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) NSMutableArray<LJPhoneBookDataDataModel *> *searchList;
@property (nonatomic, strong) NSMutableArray<LJPhoneBookDataDataModel *> *userDataList;

@property (nonatomic, strong) UIView *topbar;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, assign) NSInteger pageNum; //全部数据的页码
@property (nonatomic, assign) NSInteger persionalPageNum; //我的数据 页码
@property (nonatomic, assign) NSInteger specialPageNum; //热门专家页码
@property (nonatomic, assign) NSInteger searchPage;

@property (nonatomic, assign) LJPhoneBookType phoneBookType;
@property (nonatomic, retain) UIView *helpSuperView;

@property (nonatomic, assign) BOOL isFirstLoadingAll;
@property (nonatomic, assign) BOOL isFirstLoadingPersional;
@property (nonatomic, assign) BOOL isFirstLoadingSpecialist;

@end

@implementation LJInterviewUserListViewController

#define KHeadViewArrow 10000

#pragma mark - lifCycle

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self buildNavBar];
    
    self.navigationController.navigationBar.translucent = true;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.phoneBookType = LJPhoneBookTypeSpecialist;
    
    self.isFirstLoadingAll = true;
    self.isFirstLoadingPersional = true;
    self.isFirstLoadingSpecialist = true;
    
    // 设置TableView的刷新
    __weak __typeof(self) weakSelf = self;
    [self addHeaderRefreshView:self.tableView callBack:^{
        
        switch (weakSelf.phoneBookType) {
            case LJPhoneBookTypeSpecialist:
                weakSelf.specialPageNum = 1;
                break;
            case LJPhoneBookTypePersional:
                weakSelf.persionalPageNum = 1;
                break;
            case LJPhoneBookTypeTotal:
                weakSelf.pageNum = 1;
                break;
            default:
                break;
        }
        
        [weakSelf getTongxunluDataWithType:weakSelf.phoneBookType SearchContent:nil WithPage:@"1" withPerct:@"20"];
    }];

    [self addFooterRefreshView:self.tableView callBack:^{
        
        NSInteger pageNum = 0;
        switch (weakSelf.phoneBookType) {
            case LJPhoneBookTypeSpecialist:
                 pageNum = weakSelf.specialPageNum ;
                break;
            case LJPhoneBookTypePersional:
                pageNum =  weakSelf.persionalPageNum;
                break;
            case LJPhoneBookTypeTotal:
                pageNum = weakSelf.pageNum ;
                break;
            default:
                break;
        }
        
        NSString *pageString = [NSString stringWithFormat:@"%ld", (long)pageNum];
        [weakSelf getTongxunluDataWithType:weakSelf.phoneBookType SearchContent:nil WithPage:pageString withPerct:@"20"];
    }];
    
    _searchResultController = [[UITableViewController alloc]init] ;
    _searchResultController.tableView.delegate = self;
    _searchResultController.tableView.dataSource = self;
    _searchResultController.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _searchResultController.tableView.backgroundColor = [UIColor whiteColor];
    
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
    
    self.navigationController.navigationBar.translucent = false;
    
    weakSelf.searchPage = 1;
    [self addFooterRefreshView:_searchResultController.tableView callBack:^{
        NSString *searchString = weakSelf.searchController.searchBar.text;
        [weakSelf searchDataWithPage:weakSelf.searchPage withSearchString:searchString];
    }];
    
    allDataArray = [[NSMutableArray alloc] init];
    persionalListArray = [[NSMutableArray alloc] init];
    specialistListArray = [[NSMutableArray alloc] init];
    
    self.pageNum = 1;
    self.persionalPageNum = 1;
    self.specialPageNum = 1;
    [self getTongxunluDataWithType:LJPhoneBookTypeSpecialist SearchContent:nil WithPage:@"1" withPerct:@"20"];
    
    BOOL isFirstIn = [[NSUserDefaults standardUserDefaults] boolForKey:[GlobalConsts kFirstLaunched_NoteSearch]];
    if (isFirstIn) {
        [self showHelperView];
        
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:[GlobalConsts kFirstLaunched_NoteSearch]];
    }
    self.definesPresentationContext = true;
    
    [self updateLayout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:false animated:true];
    
    self.title = @"采访数据库";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = false;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled =  true;
}

#pragma mark - private

- (UIView *)createHeadview
{
    UIView *headerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    headerView.backgroundColor = [UIColor clearColor];
    
//    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
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

/**
 *  显示帮助页面
 */
- (void)showHelperView
{
    self.helpSuperView = [[UIView alloc] init];
    self.helpSuperView.backgroundColor = [GlobalConsts CHelpView_background];
    UITapGestureRecognizer *tapGestureGecongnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissHelperView:)];
    [self.helpSuperView addGestureRecognizer:tapGestureGecongnizer];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:self.helpSuperView];
    
    UIImage *tipBackImage = [UIImage imageNamed:@"notesearch_help_tipbackground"];
    tipBackImage = [tipBackImage resizableImageWithCapInsets:UIEdgeInsetsMake(14, 10, 5, 30) resizingMode:UIImageResizingModeTile];
    UIImageView *tipBackImageView = [[UIImageView alloc] initWithImage:tipBackImage];
    [self.helpSuperView addSubview:tipBackImageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"点击此处，添加数\n据库内容，换取蓝\n鲸币"];
    [attributeString addAttribute:NSForegroundColorAttributeName
                            value:[UIColor whiteColor]
                            range:NSMakeRange(0, attributeString.length)];
    [attributeString addAttribute:NSFontAttributeName
                            value:[UIFont boldSystemFontOfSize:12]
                            range:NSMakeRange(0, attributeString.length)];
    
    label.attributedText = attributeString;
    [tipBackImageView addSubview:label];
    
    [self.helpSuperView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(window).offset(0);
        make.center.equalTo(window);
        make.top.equalTo(window).offset(0);
    }];
    
    [label sizeToFit];
    
    [tipBackImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(label.width + 10, label.height + 15));
        make.top.equalTo(self.helpSuperView.mas_top).offset(55);
        make.right.equalTo(self.helpSuperView.mas_right).offset(-9);
    }];
    
    [label mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(tipBackImageView).with.insets(UIEdgeInsetsMake(10,5,5,5));
        
    }];
}

- (void)buildNavBar
{
    self.automaticallyAdjustsScrollViewInsets = true;
    self.hidesBottomBarWhenPushed = YES;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton setImage:[UIImage imageNamed:@"news_add"] forState:UIControlStateNormal];
    rightButton.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0, 0);
    [rightButton addTarget:self
                    action:@selector(addTongxunluButtonClick)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* set_right_btn = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = set_right_btn;
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

#pragma mark - action

- (void)dismissHelperView:(UITapGestureRecognizer *)gesture
{
    if (self.helpSuperView) {
        [self.helpSuperView removeFromSuperview];
        
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:[GlobalConsts kFirstLaunched_noteShare]];
    }
}

-(void)addTongxunluButtonClick
{
    LJAddressBookAddViewController *addTXLViewController = [[LJAddressBookAddViewController alloc] init];
    [self.navigationController pushViewController: addTXLViewController animated: YES];
}

#pragma mark - download

/**
 *  获取全部数据
 *
 *  @param searchString ;
 *  @param page         <#page description#>
 *  @param perct        <#perct description#>
 */
-(void)getTongxunluDataWithType:(LJPhoneBookType)type SearchContent:(NSString *)searchString WithPage:(NSString *)page withPerct:(NSString *)perct
{
    MBProgressHUD *hud = nil;
    if (type == LJPhoneBookTypeTotal && self.isFirstLoadingAll) {
        hud = [self showLoadingGif:self.view];
        self.isFirstLoadingAll = false;
    }
    if (type == LJPhoneBookTypePersional && self.isFirstLoadingPersional) {
        hud = [self showLoadingGif:self.view];
        self.isFirstLoadingPersional = false;
    }
    if (type == LJPhoneBookTypeSpecialist && self.isFirstLoadingSpecialist) {
        hud = [self showLoadingGif:self.view];
        self.isFirstLoadingSpecialist = false;
    }
    
    __weak typeof(self) weakSelf = self;
    [[TKRequestHandler sharedInstance] getPhoneBookSearchWithType:type Keyword:searchString Page:page withPerct:perct complated:^(NSURLSessionDataTask * _Nonnull sessionDataTask, LJPhoneBookModel * _Nullable model, NSError * _Nullable error) {
        
        if (hud != nil) {
            [hud hideAnimated:YES];
        }
        
        [weakSelf stopRefresh:weakSelf.tableView];
        
        NSIndexPath *nearIndexPath = nil;
        if (!error) {
            if (model.dErrno.integerValue == 0) {
                
                if (type == LJPhoneBookTypeTotal) {
                    if ([page isEqualToString:@"1"]) {
                        allDataArray = [NSMutableArray arrayWithArray:model.data.list];
                    } else {
                        NSInteger row = model.data.list.count > 0 ? 1 : 0;
                        row += allDataArray.count - 1;
                        nearIndexPath = [NSIndexPath indexPathForRow:row inSection:1];
                        [allDataArray addObjectsFromArray:model.data.list];
                        
                    }
                    
                    weakSelf.pageNum++;
                    weakSelf.userDataList = allDataArray;

                } else if (type == LJPhoneBookTypePersional) {
                    if ([page isEqualToString:@"1"]) {
                        persionalListArray = [NSMutableArray arrayWithArray:model.data.data];
                    } else {
                        NSInteger row = model.data.list.count > 0 ? 1 : 0;
                        row += persionalListArray.count - 1;
                        nearIndexPath = [NSIndexPath indexPathForRow:row inSection:1];
                        [persionalListArray addObjectsFromArray:model.data.data];
                    }
                    
                    weakSelf.persionalPageNum++;
                    weakSelf.userDataList = persionalListArray;
                } else if (type == LJPhoneBookTypeSpecialist) {
                    if ([page isEqualToString:@"1"]) {
                        specialistListArray = [NSMutableArray arrayWithArray:model.data.list];
                    } else {
                        NSInteger row = model.data.list.count > 0 ? 1 : 0;
                        row += specialistListArray.count - 1;
                        nearIndexPath = [NSIndexPath indexPathForRow:row inSection:1];
                        [specialistListArray addObjectsFromArray:model.data.list];                        
                    }
                    
                    weakSelf.specialPageNum++;
                    weakSelf.userDataList = specialistListArray;
                }
                [weakSelf.tableView reloadData];
                if (nearIndexPath) {
                    [weakSelf.tableView scrollToRowAtIndexPath:nearIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                }
            } else {
                
                if (weakSelf.phoneBookType == type) {
                    //当前tab失败时，才弹toast
                    NSString *msg = model.msg;
                    if ([model.dErrno integerValue] == 20007) {
                        msg = @"暂无数据";
                    }
                    
                    [weakSelf showToastHidenDefault:msg];
                }
            }
        } else {
            if (self.phoneBookType == type) {
                //当前tab失败时，才弹toast
                NSString *msg = error.domain;
                if (error.code == 20007) {
                    msg = @"暂无数据";
                }
                [self showToastHidenDefault:msg];
            }

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
    
    NSString *pageString = [NSString stringWithFormat:@"%d",(int)page];
    __weak typeof(self) weakSelf = self;
    [[TKRequestHandler sharedInstance] getPhoneBookSearchWithType:LJPhoneBookTypeTotal Keyword:searchString Page:pageString withPerct:@"15" complated:^(NSURLSessionDataTask * _Nonnull sessionDataTask, LJPhoneBookModel * _Nullable model, NSError * _Nullable error) {
        
        [weakSelf stopRefresh:_searchResultController.tableView];
        
        NSIndexPath *nearIndexPath = nil;
        if (!error) {
            if (model.dErrno.integerValue == 0) {
                
                if (weakSelf.searchPage == 1) {
                    weakSelf.searchList = [[NSMutableArray alloc] initWithArray:model.data.list];
                }else{
                    NSInteger row = model.data.list.count > 0 ? 1 : 0;
                    row += weakSelf.searchList.count - 1;
                    nearIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
                    [weakSelf.searchList addObjectsFromArray: model.data.list];
                }
                
                weakSelf.searchPage ++;
                totlePage = model.data.totalPage.integerValue;
                [_searchResultController.tableView reloadData];
                if (nearIndexPath) {
                    [_searchResultController.tableView scrollToRowAtIndexPath:nearIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                }
                
            } else {
                if (weakSelf.searchPage == 1) {
                    weakSelf.searchList = nil;
                    [_searchResultController.tableView reloadData];
                    
                    NSString *msg = model.msg;
                    [weakSelf showToastHidenDefault:msg];

                }
            }
        }else {
            
            if (weakSelf.searchPage == 1) {
                weakSelf.searchList = nil;
                [_searchResultController.tableView reloadData];
            }
            
            NSString *msg = error.domain;
            [weakSelf showToastHidenDefault:msg];
        }
    }];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableView)
    {
        return 2;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView)
    {
        NSInteger count = 0;
        switch (section) {
            case 0:
                count = 1;
                break;
            case 1:{
                count = self.userDataList.count;
                break;
            }
            default:
                break;
        }
        return count;
    }else{
        return self.searchList.count;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView)
    {
        CGFloat heigh = 0;
        switch (indexPath.section) {
            case 0:
                heigh = 40;
                break;
            case 1:
                heigh = [LJAddressBookSearchTableViewCell heightForInfo];
                break;
            default:
                break;
        }
        return heigh ;
    } else{
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:{
            if (tableView == self.tableView) {
                NSString *CellIdentifile = @"LJAddNoteSegmentTableViewCellIdentifile";
                LJAddNoteSegmentTableViewCell *addNoteSegment = [tableView dequeueReusableCellWithIdentifier:CellIdentifile];
                if (addNoteSegment == nil)
                {
                    addNoteSegment = [[LJAddNoteSegmentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                                          reuseIdentifier:CellIdentifile];
                    addNoteSegment.delegate = self;
                }
                cell = addNoteSegment;
            } else {
                NSString *CellIdentifile = @"LJAddressBookSearchTableViewCellIdentifile";
                LJAddressBookSearchTableViewCell *addNoteCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifile];
                if (addNoteCell == nil)
                {
                    addNoteCell = [[LJAddressBookSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifile];
                    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                }
                
                [addNoteCell updateInfo:self.searchList[indexPath.row]];
                cell = addNoteCell;
            }
            break;
        }
        case 1:{
            NSString *CellIdentifile = @"LJAddressBookSearchTableViewCellIdentifile";
            LJAddressBookSearchTableViewCell *addNoteCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifile];
            if (addNoteCell == nil)
            {
                addNoteCell = [[LJAddressBookSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifile];
                self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            }
            [addNoteCell updateInfo:self.userDataList[indexPath.row]];
            cell = addNoteCell;
            break;
        }
        default:
            break;
    }

    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated: YES];
    
    self.tabBarController.tabBar.hidden = YES;
    
    UINavigationController *navController = self.navigationController;
    NSArray<LJPhoneBookDataDataModel *> *listArray;
    if (tableView == self.tableView) {
        
        listArray = self.userDataList;
    }else{
        listArray = self.searchList;
        
        navController = self.searchController.presentingViewController.navigationController;
    }
    
    LJPhoneBookDataDataModel *phoneBookDataDataModel = listArray[indexPath.row];
    LJAddressBookDetailViewController *viewController = [[LJAddressBookDetailViewController alloc] init];
    viewController.otherUserId = phoneBookDataDataModel.id;
    viewController.jobStr = phoneBookDataDataModel.job;
    viewController.nameStr = phoneBookDataDataModel.name;
    viewController.companyStr = phoneBookDataDataModel.company;
    [navController pushViewController: viewController animated: YES];
    
}

#pragma mark - LJAddNoteSegmentTableViewCellDelegate

- (void)noteSegmentSelectedWithType:(LJPhoneBookType)type
{
    if (type == LJPhoneBookTypeTotal) {
        self.phoneBookType = LJPhoneBookTypeTotal;
        self.userDataList = allDataArray;
    } else if (type == LJPhoneBookTypeSpecialist) {
        self.phoneBookType = LJPhoneBookTypeSpecialist;
        self.userDataList = specialistListArray;
    } else {
        self.phoneBookType = LJPhoneBookTypePersional;
        self.userDataList = persionalListArray;
    }
    [self.tableView reloadData];
    
    if (self.userDataList.count == 0) {
        [self getTongxunluDataWithType:self.phoneBookType SearchContent:nil WithPage:@"1" withPerct:@"20"];        
    }

}

#pragma mark - UISearchDisplayDelegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    _searchPage = 1;
    [self searchDataWithPage:1 withSearchString:searchController.searchBar.text];
    
}

- (void)presentSearchController:(UISearchController *)searchController
{
    
}

- (void)willPresentSearchController:(UISearchController *)searchController
{
    self.headView.clipsToBounds = false;
    self.tableView.header.hidden = true;
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
    self.tableView.header.hidden = true;
    self.headView.clipsToBounds = true;
}
- (void)didDismissSearchController:(UISearchController *)searchController
{
    self.tableView.header.hidden = false;
    self.searchBar.top = 0;
}

//-(BOOL)_searchResultController:(UI_searchResultController*)controller shouldReloadTableForSearchString:(NSString *)searchString
//{
//    self.searchPage = 1;
//    [self searchDataWithPage:1 withSearchString:searchString];
//    return YES;
//}
//
//- (void) _searchResultControllerDidEndSearch:(UI_searchResultController *)controller
//{
//    if (_searchBar.superview != _headView) {
//        [_headView addSubview:_searchBar];
//    }
//}

@end
