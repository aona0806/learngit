//
//  LJWorkStationTableViewController.m
//  news
//
//  Created by chunhui on 15/11/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJWorkStationTableViewController.h"
#import "news-Swift.h"
#import "LJWorkTableViewCell.h"

@interface LJWorkStationTableViewController ()

@property(nonatomic , strong) UIView *headerView;
@property (nonatomic, strong, nonnull) NSArray<LJWorkStationDataModel *> *workArrayList;
@property(nonatomic , strong) UINavigationBar *navbar;

@end

@implementation LJWorkStationTableViewController


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self addObservers];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if ([[[UIDevice currentDevice] systemVersion]floatValue] < 10.0) {
        [self.navbar removeObserver:self forKeyPath:@"frame"];
    }
}

-(void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forceRefreshNotification:) name:[GlobalConsts kWorkStationRefreshNotification] object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getWorkSpaceData)
                                                 name:[GlobalConsts Notification_WorkStationRefresh] object:nil];
}


#pragma mark - lifCycle

- (void)viewDidLoad {
    self.customUserInfoItem = YES;
    self.customBackItem = NO;
    
    [super viewDidLoad];
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.workArrayList = [NSArray new];
    
    if ([[[UIDevice currentDevice] systemVersion]floatValue] < 10.0) {
        self.navbar = self.navigationController.navigationBar;
        [self.navbar addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        
        
    }    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:false animated:true];
    self.title = @"工作站";
    
    [self getWorkSpaceData];
    
    self.tableView.tableHeaderView = nil;
    
    if (self.navigationController) {
        CGRect navFrame = self.navigationController.navigationBar.frame;
        CGRect headerFrame ;
        headerFrame = navFrame;
        headerFrame.size.height =  navFrame.size.height - 44;
        if (headerFrame.size.height > 1) {
            if (self.headerView == nil) {
                self.headerView = [[UIView alloc] initWithFrame:headerFrame];
            }else{
                headerFrame.origin.y = 0;
                self.headerView.frame = headerFrame;
            }
            self.tableView.tableHeaderView = _headerView;
        }else{
            self.tableView.tableHeaderView = nil;
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

-(void)updateViewConstraints
{
    [super updateViewConstraints];
    [self.tableView reloadData];
}

#pragma mark - download
-(void)getWorkSpaceData
{
    __weak typeof(self) weakSelf = self;
    [[TKRequestHandler sharedInstance] getWorkSpaceWithComplated:^(NSURLSessionDataTask * _Nonnull sessionDataTask, LJWorkStationModel * _Nullable model, NSError * _Nullable error) {
        
        if (error) {
            
            [weakSelf showToastHidenDefault:error.domain];
            
        } else {
            weakSelf.workArrayList = model.data;
            [weakSelf.tableView reloadData];
        }
    }];
}

#pragma mark - action


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = _workArrayList.count;
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  80;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4)
    {
        return 2;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifile = @"cell";
    LJWorkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifile];
    if (cell == nil)
    {
        cell = [[LJWorkTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifile];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    LJWorkStationDataModel *info = self.workArrayList[indexPath.section];
    [cell updateInfo:info];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == 0) {
//     
//        return self.navigationController.navigationBar.bottom - NAVBAR_HEIGHT;
//        
//    }
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    NSInteger section = indexPath.section;
    LJWorkStationDataModel *model = _workArrayList[section];
    
//    NSArray *showRefreshArray = @[@"prism", @"eg365", @"soupilu", @"sulu"];
    
    NSString *scheme = model.scheme;
    
    [[PushManager sharedInstance] handleOpenUrl:scheme];
//    EventListViewController *viewController = [[EventListViewController alloc] init];
//    viewController.hidesBottomBarWhenPushed = true;
//    [self.navigationController pushViewController:viewController animated:YES];
    
    
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    NSDictionary *params = @{@"interview":@"database", @"user":@"contact",
                             @"time_axis":@"timeaxis", @"secretary":@"secretary",
                             @"meeting":@"meet", @"hot_event":@"hotevent"};
    NSArray *keyArray = [params allKeys];
    if ([keyArray containsObject:model.item]) {
        NSString *valueString = [params objectForKey:model.item];
        [self eventForName:[NSString stringWithFormat:@"WorkStation_%@",valueString] attr:nil];
    } else {
        [self eventForName:@"WorkStation_Other" attr:@{@"Tag":model.item}];
    }
}


#pragma mark - refresh

-(void)forceRefreshNotification:(NSNotification *)notification
{
    [self.tableView.header beginRefreshing];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    //ios 9 only
    if ([keyPath isEqualToString:@"frame"]) {
        
        NSValue *value = change[NSKeyValueChangeNewKey];
        CGRect frame = [value CGRectValue];
        CGRect headerFrame = CGRectZero;
        headerFrame.size.height =  frame.size.height - 44;
        if (headerFrame.size.height > 1) {
            if (self.headerView == nil) {
                self.headerView = [[UIView alloc] initWithFrame:headerFrame];
            }else{
                headerFrame.origin.y = 0;
                self.headerView.frame = headerFrame;
            }
            self.tableView.tableHeaderView = _headerView;
        }else{
            self.tableView.tableHeaderView = nil;
        }

        
        
    }
}


@end
