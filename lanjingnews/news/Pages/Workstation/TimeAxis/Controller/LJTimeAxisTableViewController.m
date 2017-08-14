//
//  LJTimeAxisTableViewController.m
//  news
//
//  Created by 奥那 on 15/12/22.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJTimeAxisTableViewController.h"
#import "LJTimeAxisHelpView.h"
#import "news-Swift.h"
#import "LJAddEventTableViewController.h"
#import "LJTimeAxisHeaderView.h"
#import "LJTimeAxisCell.h"
#import "LJTimeAxisModel.h"
#import "LJTimeAxisDetailTableViewController.h"

@interface LJTimeAxisTableViewController ()<JTCalendarDataSource,ShareViewProtocol,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)LJTimeAxisHeaderView *headerView;

@property (nonatomic, assign) BOOL isWeek;
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSArray *modelList;
@property (nonatomic, strong) LJTimeAxisDataModel *timeAxisDataModel;

@property (nonatomic, strong)NSMutableArray *markArray;

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic) NSInteger pageNumber;

@end

@implementation LJTimeAxisTableViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = RGBACOLOR(255, 255, 255, 1);
    
    [self setupDefaultData];
    [self customNavigationItem];
    [self buildCalendar];
    [self initTabeleView];

    [self showHelpView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventDidChanged) name:[GlobalConsts Notification_TimeAxisDeleteEvent] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventDidChanged) name:[GlobalConsts Notification_TimeAxisEditEvent] object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - private

/**
 *  设置初始值
 */
- (void)setupDefaultData{
    self.isWeek = NO;
    if (self.date != nil) {
        self.currentDate = self.date;
        self.selectedDate = self.date;
    }
    
    if (self.currentDate == nil) {
        self.currentDate = [NSDate date];
        self.selectedDate = self.currentDate;
    }
}

- (void)eventDidChanged{
    
    [self performSelector:@selector(refreshData) withObject:self afterDelay:0.5];
}

- (void)refreshData{
    
    NSDate *date = self.selectedDate;
    
    NSString *lastStr = [TKCommonTools getLastMonthFirstTimeInterval:date];
    NSString *nextStr = [TKCommonTools getNextMonthLastTimeInterval:date];
    [self markPointFromTime:lastStr ToTime:nextStr];
    if (self.selectedDate) {
        [self getEveryDayDataWithDate:[NSString stringWithFormat:@"%f",[date timeIntervalSince1970]]refreshType:TKDataFreshTypeRefresh];
    }
}

- (void)customNavigationItem{

    self.title = @"新闻时间轴";
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 65, 40)];
    rightView.backgroundColor = [UIColor clearColor];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 30, 40);
    [addButton setImage:[UIImage imageNamed: @"news_add"] forState:UIControlStateNormal];
    addButton.backgroundColor = [UIColor clearColor];
    addButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [addButton addTarget:self
                  action:@selector(addAciton)
        forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:addButton];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(35, 0, 30, 40);
    [shareButton setImage:[UIImage imageNamed:@"navbar_icon_share"] forState:UIControlStateNormal];
    shareButton.backgroundColor = [UIColor clearColor];
    shareButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:shareButton];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)loadHelpView {
    
    LJTimeAxisHelpView *helpView = [[LJTimeAxisHelpView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:helpView];
 
    __weak typeof(self) weakSelf = self;
    helpView.dismissHelperView = ^(LJTimeAxisHelpView *view){
        [weakSelf dismissHelpView:view];
    };
}

- (void)showHelpView {
    
    BOOL isFirstIn = [[NSUserDefaults standardUserDefaults] boolForKey:[GlobalConsts kFirstLaunched_NoteSearch]];
    if (isFirstIn) {
        
        [self loadHelpView];
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:[GlobalConsts kFirstLaunched_NoteSearch]];
    }
}

- (void)dismissHelpView:(LJTimeAxisHelpView *)view {
    if (view) {
        [view removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:[GlobalConsts kFirstLaunched_NoteSearch]];
    }
}

- (void)initTabeleView{
    CGFloat y = self.headerView.frame.size.height;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT - y)];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
}

- (void)buildCalendar {
    
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, 250);

    self.headerView = [[LJTimeAxisHeaderView alloc] initWithFrame:frame];
    [self.headerView.calendar setDataSource:self];
    
    NSString *dateString = [TKCommonTools dateStringWithFormat:TKDateFormatChineseYM date:_currentDate];
    self.headerView.topDateLabel.text = dateString;
    [self setupDate];
    
    self.headerView.isWeek = NO;
    [self.view addSubview:_headerView];
    
    UISwipeGestureRecognizer *swipeup = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeVerticalAction:)];
    swipeup.direction = UISwipeGestureRecognizerDirectionUp;
    [self.headerView addGestureRecognizer:swipeup];
    
    UISwipeGestureRecognizer *swipedown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeVerticalAction:)];
    swipedown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.headerView addGestureRecognizer:swipedown];
    
    
    if (self.selectedDate) {
        
        [self.headerView.calendar setCurrentDateSelected:self.selectedDate];
        self.headerView.calendarContentView.currentDate = self.selectedDate;
        [self.headerView.calendar reloadData];
    }
    
}

- (void)setTableViewHeaderView:(CGFloat)height isWeek:(BOOL)isWeek {
    
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, height);

    self.headerView.isWeek = isWeek;
    self.headerView.frame = frame;

//    self.tableView.tableHeaderView = self.headerView;
    self.tableView.y = height;
    self.tableView.height = SCREEN_HEIGHT - NAVBAR_HEIGHT - height;
    
    
}

- (void)setupDate{

    NSString *dateStamp = [NSString stringWithFormat:@"%f",[_currentDate timeIntervalSince1970]];
    [self getEveryDayDataWithDate:dateStamp refreshType:TKDataFreshTypeRefresh];
    
    NSString *lastMounthStr = [TKCommonTools getLastMonthFirstTimeInterval:_currentDate];
    NSString *nextMounthStr = [TKCommonTools getNextMonthLastTimeInterval:_currentDate];
    [self markPointFromTime:lastMounthStr ToTime:nextMounthStr];
    
}

- (void)addAciton{
    __weak typeof (self)weakSelf = self;
    LJAddEventTableViewController *controller = [[LJAddEventTableViewController alloc] init];
    controller.addEvent = ^(LJTimeAxisDataListModel *model){
        [weakSelf eventDidAdded:model];
        [weakSelf.navigationController popToViewController:weakSelf animated:YES];
    };
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];

}

- (void)eventDidAdded:(LJTimeAxisDataListModel *)model{
    NSInteger type = model.type.integerValue;
    if (type != 0)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.text = @"已提交审核，通过后转为公开信息";
        [hud hideAnimated:YES afterDelay: 1];
    }
    
    [self eventDidChanged];
}

- (void)shareAction{
    
    if (_modelList == nil || _modelList.count == 0) {
        [self showToastHidenDefault:@"今天没有重要事件，换个日期分享吧"];
        return;
    }
    
    BOOL canShare = NO;
    for (LJTimeAxisDataListModel *model in _modelList) {
        
        if (model.type.integerValue == 1) {
            canShare = YES;
            break;
        }else if (model.type.integerValue == 2) {
            canShare = YES;
            break;
        }
    }

    if (!canShare) {
        [self showToastHidenDefault:@"抱歉！该日期尚无已通过审核的重要事件/发布会，暂不能分享！"];
        return;
    }
    
    BOOL isHideLanjing = ![[[AccountManager sharedInstance] verified] isEqualToString:@"1"];
    ShareView *shareView = [[ShareView alloc] initWithDelegate:self shareObj:self.modelList hideLanjing:isHideLanjing];
    [shareView show:self.view.window animated:YES];
}

#pragma mark - download

- (void)getEveryDayDataWithDate:(NSString *)currentDate refreshType:(TKDataFreshType)refreshType {
    if (refreshType == TKDataFreshTypeRefresh) {
        self.pageNumber = 1;
    } else {
        if (!self.pageNumber) {
            self.pageNumber = 1;
        } else {
            self.pageNumber ++;
        }
    }
    __weak typeof(self) weakSelf = self;
    [[TKRequestHandler sharedInstance] GetTimeDataWithTime:currentDate
                                                   andPage:[NSString stringWithFormat:@"%ld",(long)self.pageNumber]
                                                  andCount:@"30"
                                                  andOrder:@"1"
                                                    finish:^(NSURLSessionDataTask * _Nonnull sessionDataTask, LJTimeAxisModel * _Nonnull model, NSError * _Nonnull error) {
                                                        
                                                        if (error && error.code != 20024) {
                                                            
                                                            [weakSelf showToastHidenDefault:error.domain];
                                                            weakSelf.timeAxisDataModel = nil;
                                                            weakSelf.modelList = nil;
                                                            
                                                        }else{
                                                            if (model.dErrno.integerValue == 0 || model.dErrno.integerValue == 20024) {
                                                                weakSelf.timeAxisDataModel = model.data;
                                                                weakSelf.modelList = model.data.list;
                                                                
                                                            }  else {
                                                                NSString *msg =  model.msg ?: [GlobalConsts NetRequestNoResult];
                                                                [weakSelf showToastHidenDefault:msg];
                                                            }
                                                        }
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            [self.tableView reloadData];
                                                        });
                                                    }];
}

- (void)markPointFromTime:(NSString *)fromTime ToTime:(NSString *)toTime{
    
    __weak typeof(self) weakSelf = self;
    [[TKRequestHandler sharedInstance] MarkPointTimeZhouDataWithFrom:fromTime andTo:toTime finish:^(NSURLSessionDataTask * _Nonnull sessionDataTask, id  _Nonnull response, NSError * _Nonnull error) {
        if (error) {
            [weakSelf showToastHidenDefault:error.domain];
        }else{
            
            weakSelf.markArray = response[@"data"];
            
            if (weakSelf.markArray.count != 0)
            {
                [weakSelf.headerView.calendar reloadData];
            }
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.modelList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LJTimeAxisCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timeAxis"];
    
    if (cell == nil) {
        cell = [[LJTimeAxisCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"timeAxis"];
    }
    
    LJTimeAxisDataListModel *model = [_modelList objectAtIndex:indexPath.row];
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 61;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LJTimeAxisDataListModel *model = [_modelList objectAtIndex:indexPath.row];
    LJTimeAxisDetailTableViewController *controller = [[LJTimeAxisDetailTableViewController alloc] init];
    controller.model = model;

    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat OffsetY = scrollView.contentOffset.y;
    
    if ( OffsetY > 60){
        if (!self.headerView.isWeek) {
            [self setTableViewHeaderView:98 isWeek:YES];
        }
    } else if (OffsetY < - 60){
        if (self.headerView.isWeek) {
            [self setTableViewHeaderView:250 isWeek:NO];
        }
    }
}

#pragma mark - swip action
-(void)swipeVerticalAction:(UISwipeGestureRecognizer *)swipe
{
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp){
        
        if (!self.headerView.isWeek){
             [self setTableViewHeaderView:98 isWeek:YES];
        }
        
    }else if(self.headerView.isWeek){
         [self setTableViewHeaderView:250 isWeek:NO];
    }
    
}

#pragma mark - ShareViewProtocol

- (void)shareAction:(enum ShareType)type shareView:(ShareView *)shareView shareObj:(id)shareObj{
    
    [[ShareAnalyseManager sharedInstance] shareTimeaxis:type info:self.timeAxisDataModel selectedDate: self.selectedDate presentController:self completion:^(BOOL success, NSError * _Nullable error) {
        [self showShareCoinToast:type isSuccess:success type:LJCoinShareTypeTimeaxis error:error];
    }];
    
 }

#pragma mark - JTCalendarDataSource

- (NSString *)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    NSString *timeStr = [[TKCommonTools dateStringWithFormat:TKDateFormatChineseShortYMD date:date] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSString *typeStr = @"0";

    for (NSDictionary *dic in _markArray) {
        NSString *markTimeStr = [NSString stringWithFormat:@"%@",dic[@"date"]];
        
        if ([markTimeStr isEqualToString:timeStr]) {
            typeStr = [NSString stringWithFormat:@"%@",dic[@"sign_show"]];
        }
    }
    return typeStr;
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    self.selectedDate = date;
    self.currentDate = date;
    NSString *dateString = [TKCommonTools dateStringWithFormat:TKDateFormatChineseYM date:_currentDate];
    self.headerView.topDateLabel.text = dateString;
    [self getEveryDayDataWithDate:[NSString stringWithFormat:@"%f",[date timeIntervalSince1970]] refreshType:TKDataFreshTypeRefresh];
    [self eventForName:@"TimeAxis_choosedate" attr:nil];
}

- (void)otherCalendarSeclect:(JTCalendar *)calendar date:(NSDate *)date
{
    [self.headerView.calendar setCurrentDate:date];
}

- (void)calendarScrollToNewPageWithdate:(NSDate *)date withBool:(BOOL)isWeek
{
    NSString *lastStr = [TKCommonTools getLastMonthFirstTimeInterval:date];
    NSString *nextStr = [TKCommonTools getNextMonthLastTimeInterval:date];
    
    [self markPointFromTime:lastStr ToTime:nextStr];
    
    self.currentDate = date;
    NSString *dateString = [TKCommonTools dateStringWithFormat:TKDateFormatChineseYM date:_currentDate];
    self.headerView.topDateLabel.text = dateString;

    self.isWeek = isWeek;
    
}

- (NSMutableArray *)markArray{
    if (_markArray == nil) {
        _markArray = [NSMutableArray array];
    }
    return _markArray;
}

- (NSArray *)modelList{
    if (_modelList == nil) {
        _modelList = [NSArray array];
    }
    return _modelList;
}

@end
