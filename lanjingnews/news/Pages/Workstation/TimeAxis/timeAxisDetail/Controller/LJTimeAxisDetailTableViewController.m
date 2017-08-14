//
//  TimeAxisDetailTableViewController.m
//  news
//
//  Created by 奥那 on 15/12/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJTimeAxisDetailTableViewController.h"
#import "LJTimeAxisDetailCell.h"
#import "LJTimeAxisModel.h"
#import "news-Swift.h"
#import "BlocksKit+UIKit.h"
#import "LJAddEventTableViewController.h"
#import "TKModuleWebViewController.h"

@interface LJTimeAxisDetailTableViewController ()
@property (nonatomic, strong)NSArray *titleList;
@property (nonatomic, copy)NSString *type;
@property (nonatomic, copy)NSString *uid;
@property (nonatomic , strong)NSArray *contentList;

@end

@implementation LJTimeAxisDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详情";
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = RGBACOLOR(245, 245, 245, 1);
    
    [self setupData];
    
    [self customNavigationItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning] ;
    // Dispose of any resources that can be recreated.
}

- (BOOL)isPublicMyself{
    if (![self.uid isEqualToString:_model.uid]) {
        return NO;
    }
    return YES;
}

- (void)customNavigationItem{
    if (![self isPublicMyself]) {
        return;
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"timeAxis_edit"] style:UIBarButtonItemStyleDone target:self action:@selector(editorAction)];
}

- (void)setupData{
    
    self.titleList = @[@"标题:",@"类别:",@"地点:",@"开始时间:", @"结束时间:",@"详情:",@"主办方:"];
    
    self.uid = [AccountManager sharedInstance].uid;
    
    if (self.model == nil) {
        [self loadEventData];
    }
    self.type = _model.type;

    self.contentList = [self.model toMidifyArrayIsSimplify:YES];

}

- (void)editorAction {
    LJAddEventTableViewController *controller = [[LJAddEventTableViewController alloc] init];
    controller.model = self.model;
    controller.isEdit = YES;
    __weak typeof (self)weakSelf = self;
    controller.addEvent = ^(LJTimeAxisDataListModel *model){
        [weakSelf setupData];
        [weakSelf.tableView reloadData];
        [weakSelf.navigationController popToViewController:weakSelf animated:YES];
    };

    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) backAciton{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteEvents:(UIButton *)sender{
    
    __weak typeof (self)weakSelf = self;
    UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:nil];

    [actionSheet bk_addButtonWithTitle:@"确定删除事件" handler:^{
        [weakSelf deleteEvent];
    }];
    [actionSheet bk_setCancelButtonWithTitle:@"取消" handler:^{
        
    }];

    [actionSheet showInView:self.view];
}

- (void)deleteEvent {
    
    __weak typeof(self) weakSelf = self;
    [[TKRequestHandler sharedInstance] DeleteEventWithEventId:_model.id finish:^(NSURLSessionDataTask * _Nonnull sessionDataTask, id  _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            [self showToastHidenDefault:error.domain];

        }else{
            NSString *errnoStr = [NSString stringWithFormat:@"%@",response[@"errno"]];
            if ([errnoStr isEqualToString:@"0"])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:[GlobalConsts Notification_TimeAxisDeleteEvent] object:nil];
                [weakSelf backAciton];
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.detailsLabel.text = @"删除失败";
                [hud hideAnimated:YES afterDelay: 1];
            }
        }
    }];
    
}

- (void)loadEventData{
    __weak typeof(self) weakSelf = self;
    [[TKRequestHandler sharedInstance] GetEventsDecWithEventId:self.eventId finish:^(NSURLSessionDataTask * _Nonnull sessionDataTask, id  _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            [weakSelf showToastHidenDefault:error.domain];
        }else{
            weakSelf.model = [[LJTimeAxisDataListModel alloc] init];
            [weakSelf.model setValuesForKeysWithDictionary:response[@"data"]];
            
            [weakSelf setupData];
            [weakSelf.tableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger count = 6;
    if (_model.type.integerValue == 2) {
        count = 7;
    } else {
        count = 6;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LJTimeAxisDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detail"];
    if (cell == nil) {
        cell = [[LJTimeAxisDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detail"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.clipsToBounds = YES;
    }
    cell.title = [_titleList objectAtIndex:indexPath.row];
    cell.detailString = [self.contentList objectAtIndex:indexPath.row];
    if (indexPath.row == 1) {
        cell.contentLabel.textColor = [self.model getTextColorWithType];
    }
    
    if (indexPath.row == 5) {

        cell.contentLabel.copyingEnabled = YES;
        cell.contentLabel.urlLinkTapHandler = ^(KILabel *label, NSString *string, NSRange range , NSString *contentString){
            
            NSString *urlString = contentString;
            TKModuleWebViewController *webController = [self moduleWebViewWithUrl:urlString];
            [self.navigationController pushViewController:webController animated:YES];
            
        };
    } else {
        cell.contentLabel.copyingEnabled = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *titleString = [_titleList objectAtIndex:indexPath.row];
    NSString *content = [_contentList objectAtIndex:indexPath.row];
    CGFloat height = [LJTimeAxisDetailCell cellHeightForTitle:titleString Content:content];
    if (indexPath.row == 4) {
        NSString *endTimeString = self.contentList[4];
        if (!endTimeString || endTimeString.length == 0) {
            height = 0;
        }
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    aView.backgroundColor = [UIColor clearColor];
    aView.userInteractionEnabled = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 16, SCREEN_WIDTH, 44);
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(deleteEvents:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"timeAxis_delete"] forState:UIControlStateNormal];
    [aView addSubview:button];
    return aView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([self isPublicMyself]) {
        return 60;
    }
    return 0;
}

@end
