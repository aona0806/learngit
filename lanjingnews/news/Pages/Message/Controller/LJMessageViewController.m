//
//  LJMessageViewController.m
//  news
//
//  Created by chunhui on 15/11/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMessageViewController.h"
#import "TKRequestHandler+Message.h"
#import "MessageData.h"
#import "LJMessageTableViewCell.h"
#import "LJFriendsNotificationTableViewController.h"
#import "news-Swift.h"

#define ThisCCHeight        SCREEN_HEIGHT - 64 - 49
#define listHeight_Y        54 * 2

@interface LJMessageViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *listTabelView;
@property (nonatomic, strong) UIView *topContentView;
@property (nonatomic, strong) NSMutableArray<MessageData *> *dataArray;
@property (nonatomic, strong) UIView *topHongDianView;

@end

@implementation LJMessageViewController

#pragma mark - lifcycle

- (void)viewDidLoad {
    
    self.customUserInfoItem = YES;
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;    
    
    UIButton *topButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, listHeight_Y/2.0)];
    [topButton setImage:[UIImage imageNamed:@"topSecBackColor"] forState:UIControlStateNormal];
    [topButton setImage:[UIImage imageNamed:@"topBackColorHighLighe"] forState:UIControlStateHighlighted];
    [topButton addTarget:self action:@selector(pushNewHaoYouList) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(18, (topButton.frame.size.height - 22)/2.0, 22, 22)];
    logoView.image = [UIImage imageNamed:@"add_friend_button"];
    [topButton addSubview:logoView];
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 0, SCREEN_WIDTH - 200, topButton.frame.size.height)];
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.text = @"好友通知";
    topLabel.textColor = RGBA(102, 102, 102, 1);
    topLabel.font = [UIFont systemFontOfSize:16];
    [topButton addSubview:topLabel];
    
    self.topHongDianView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, (topButton.frame.size.height - 10)/2.0, 10, 10)];
    self.topHongDianView.backgroundColor = RGBA(250, 98, 93, 1);
    self.topHongDianView.layer.cornerRadius = 5;
    self.topHongDianView.layer.masksToBounds = YES;
    self.topHongDianView.hidden = YES;
    [topButton addSubview:self.topHongDianView];
    
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 16.5, (topButton.frame.size.height - 11)/2.0, 6, 11)];
    rightView.image = [UIImage imageNamed:@"friend_arrow"];
    [topButton addSubview:rightView];
    
    //    [self.view addSubview:topButton];
    
    UIButton *topSecButton = [[UIButton alloc] initWithFrame:CGRectMake(0, listHeight_Y/2.0, SCREEN_WIDTH, listHeight_Y/2.0)];
    [topSecButton setImage:[UIImage imageNamed:@"topBackColor"] forState:UIControlStateNormal];
    [topSecButton setImage:[UIImage imageNamed:@"topBackColorHighLighe"] forState:UIControlStateHighlighted];
    [topSecButton addTarget:self action:@selector(pushHaoYouList) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *logoSecView = [[UIImageView alloc] initWithFrame:CGRectMake(18, (topButton.frame.size.height - 22)/2.0, 22, 22)];
    logoSecView.image = [UIImage imageNamed:@"icon_friend_list"];
    [topSecButton addSubview:logoSecView];
    
    UILabel *topSecLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 0, SCREEN_WIDTH - 200, topButton.frame.size.height)];
    topSecLabel.backgroundColor = [UIColor clearColor];
    topSecLabel.text = @"好友列表";
    topSecLabel.textColor = RGBA(102, 102, 102, 1);
    topSecLabel.font = [UIFont systemFontOfSize:16];
    [topSecButton addSubview:topSecLabel];
    
    UIImageView *rightSecView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 16.5, (topButton.frame.size.height - 11)/2.0, 6, 11)];
    rightSecView.image = [UIImage imageNamed:@"friend_arrow"];
    [topSecButton addSubview:rightSecView];
    
    self.topContentView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(topButton.frame), CGRectGetWidth(topButton.frame), CGRectGetMaxY(topSecButton.frame))];
    
    [_topContentView addSubview:topButton];
    [_topContentView addSubview:topSecButton];
    
    [self.view addSubview:_topContentView];
    
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    [self loadArchiver];
    
    UIView *kuangLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    kuangLineView.backgroundColor = RGBA(240, 239, 245, 1);
    
    self.listTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, listHeight_Y, SCREEN_WIDTH, ThisCCHeight - listHeight_Y) style:UITableViewStylePlain];
    self.listTabelView.delegate = self;
    self.listTabelView.backgroundColor = RGBA(240, 239, 245, 1);
    self.listTabelView.dataSource = self;
    self.listTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.listTabelView];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self downloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(downloadData)
                                                 name:[GlobalConsts Notification_MainTabbarMessage]
                                               object:nil];
    
    [[RedDotManager sharedInstance] refreshRedDotDisplay];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateViewConstraints
{
    [super updateViewConstraints];
    [self updatelayout];
}

#pragma mark - private

-(void)updatelayout
{
    if(self.navigationController != nil){
        
        CGRect frame = self.navigationController.navigationBar.frame;
        CGRect contentFrame = self.topContentView.frame;
        contentFrame.origin.y = CGRectGetHeight(frame) - 44;
        if (!CGRectEqualToRect(contentFrame, self.topContentView.frame)) {
            self.topContentView.frame = contentFrame;
            CGRect tableFrame = self.view.frame;
            tableFrame.size.height -= CGRectGetMaxY(contentFrame);
            tableFrame.origin.y = CGRectGetMaxY(contentFrame);
            self.listTabelView.frame = tableFrame;
        }
    }
}

-(void) loadArchiver
{
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* filename = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"messageList.dat"];
    self.dataArray= [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    
    for (NSInteger index = 0; index < self.dataArray.count; index ++) {
        
        MessageData *noteData = self.dataArray[index];
        
        NSArray *redDotArray = [RedDotManager sharedInstance].redDotModel.pmsg.fromUid;
        
        
        NSString *userIdString = [NSString stringWithFormat:@"%@",noteData.to_uid];
        
        NSString *uid = [AccountManager.sharedInstance uid];
        if ([userIdString isEqualToString:uid])
        {
            userIdString = [NSString stringWithFormat:@"%@",noteData.from_uid];
        }
        
        if ([redDotArray containsObject:userIdString]) {
            noteData.has_new_msg = @"1";
        } else {
            noteData.has_new_msg = @"0";
        }
    }
}

-(void) saveArchiverWithArray:(NSMutableArray *)history
{
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* filename = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"messageList.dat"];
    
    if (history && [history count]>0) {
        [NSKeyedArchiver archiveRootObject:history toFile:filename];
    }else {
        NSFileManager *defaultManager = [NSFileManager defaultManager];
        if ([defaultManager isDeletableFileAtPath:filename]) {
            [defaultManager removeItemAtPath:filename error:nil];
        }
    }
}

#pragma mark - action

/**
 *  点击好友列表
 */
- (void) pushHaoYouList
{
    LJFriendsListController *controller = [[LJFriendsListController alloc] initWithNibName:nil bundle:nil];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController: controller animated: YES];
    self.hidesBottomBarWhenPushed = NO;
    
    [self eventForName:@"Message_list" attr:nil];
}

/**
 *  好友通知
 */
- (void) pushNewHaoYouList
{
    
    self.topHongDianView.hidden = YES;
    LJFriendsNotificationTableViewController *controller = [[LJFriendsNotificationTableViewController alloc] initWithNibName:nil bundle:nil];
    self.topHongDianView.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController: controller animated: YES];
    self.hidesBottomBarWhenPushed = NO;
    
    [self eventForName:@"Message_friendnoti" attr:nil];
}

#pragma mark - download

- (void) downloadData
{
    BOOL infomsgnum_isred = ([[[[RedDotManager sharedInstance] redDotModel] friendMsg] integerValue] > 0);
    self.topHongDianView.hidden = !infomsgnum_isred;
    
    [[TKRequestHandler sharedInstance] getMessageListFinish:^(NSURLSessionDataTask *sessionDataTask, LJMessageListModel *model, NSError *error) {
        
        if (model && model.dErrno.integerValue == 0) {
            
            NSMutableArray *talksRedDot = [NSMutableArray new];
            NSArray<LJMessageListDataContentModel *> *allValuesArray = model.data.content;
            NSMutableArray *userDataArray = [[NSMutableArray alloc] init];

            for (LJMessageListDataContentModel *contentModel in allValuesArray) {

                if (contentModel.fromUid.length > 0 && contentModel.toUid.length > 0) {
                    //容错 没有from uid 或者 to uid 就丢弃
                    MessageData *listData = [[MessageData alloc] initWithModel:contentModel];
                    [userDataArray addObject: listData];
                    
                    if (contentModel.hasNewMsg.integerValue != 0) {
                        [talksRedDot addObject:contentModel.fromUid];
                    }
                }

            }
            [RedDotManager sharedInstance].redDotModel.pmsg.fromUid = talksRedDot;
            self.dataArray = [[NSMutableArray alloc] initWithArray:userDataArray];
            [self.listTabelView reloadData];
            
            [self saveArchiverWithArray:self.dataArray];
            
            //FIXME: here need to refresh message bottom bar red dot
            
            
        }
    }];
    
}

- (void) deletedMesFromListWithMesUid:(NSString *)mesUid
{
    
    [[TKRequestHandler sharedInstance] getDelMessageFromListWithMesUid:mesUid complated:^(NSURLSessionDataTask *sessionDataTask, LJBaseJsonModel *model, NSError *error) {
        if (model && model.dErrno.integerValue == 0) {
            
            [[RedDotManager sharedInstance] deleteTalkRedDotWithUid:mesUid];
            for (MessageData *item in self.dataArray) {
                if (mesUid && [mesUid isEqualToString:item.from_uid]) {
                    [self.dataArray removeObject:item];
                    break;
                }
            }
            [self saveArchiverWithArray:self.dataArray];
        }
    }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSString *CellIdentifile = [NSString stringWithFormat:@"CellIdentifile"];
    LJMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifile];
    if (cell == nil)
    {
        cell = [[LJMessageTableViewCell alloc] initWithMessageStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifile];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    MessageData *noteData = self.dataArray[row];
    [cell updateInfo:noteData];
    
    return cell;
}



#pragma mark - UiTableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        MessageData *noteData = self.dataArray[row];
        NSString *userIdString = [NSString stringWithFormat:@"%@",noteData.to_uid];
        
        NSString *uid = [NSString stringWithFormat:@"%ld",(long)[AccountManager.sharedInstance uid]];
        if ([userIdString isEqualToString:uid])
        {
            
            userIdString = [NSString stringWithFormat:@"%@",noteData.from_uid];
        }
        
        [self deletedMesFromListWithMesUid:userIdString];
        
        [self.dataArray removeObjectAtIndex:row];
        // Delete the row from the data source.
        [self.listTabelView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    [tableView deselectRowAtIndexPath:indexPath animated: YES];
    
    MessageData *noteData = self.dataArray[row];
    
    noteData.has_new_msg = @"0";
    [self.listTabelView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
    
    LJTalkTableViewController *talkViewController = [LJTalkTableViewController new];
    NSString *userIdString = [NSString stringWithFormat:@"%@",noteData.to_uid];
    NSString *uid = [AccountManager.sharedInstance uid];
    if ([userIdString isEqualToString:uid]) {
        userIdString = noteData.from_uid;
    }

    talkViewController.talkUserName = noteData.nameStr;
    talkViewController.talkingUserId = userIdString.integerValue;
    [self.navigationController pushViewController:talkViewController animated:YES];
    
    [self eventForName:@"Message_talk" attr:nil];
    
}

@end
