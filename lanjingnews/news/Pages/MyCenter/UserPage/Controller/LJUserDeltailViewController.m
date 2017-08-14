//
//  LJUserDeltailViewController.m
//  news
//
//  Created by 陈龙 on 15/12/11.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJUserDeltailViewController.h"
#import "TKRequestHandler+Message.h"
#import <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import "FSPhotoBrowserHelper.h"
#import <UMMobClick/MobClick.h>
#import "news-Swift.h"
#import "LJUserDetailHeaderTableViewCell.h"
#import "LJUserDetailTitleArrowTableViewCell.h"
#import "LJUserDetailTitleTableViewCell.h"
#import "LJUserDetailTitleMoreTableViewCell.h"
#import "LJUserDetailSendTableViewCell.h"
#import "TKRequestHandler+userinfo.h"

@interface LJUserDeltailViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIAlertViewDelegate,LJUserDetailHeaderTableViewCellDelegate, UIGestureRecognizerDelegate, LJUserDetailSendTableViewCellDelegate>
{
    UIView *iHeadView;
}

@property (nonatomic, strong) LJUserInfoModel * _Nullable detailData;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *sendMessButton;

@property (nonatomic) BOOL isExpandPersonNote;

/**
 *  单位职务行业等信息数组
 */
@property (nonatomic, strong) NSArray *infoArray;

@end

#define PersonNoteMax_length 28

@implementation LJUserDeltailViewController

#pragma mark - lifCycle

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self getInfoDataWithUid:self.uid];
    
    self.tableView = [UITableView new];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top);
    }];
    
    iHeadView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    iHeadView.backgroundColor = RGBACOLOR(1, 2, 1, 1);
    [self.view insertSubview:iHeadView belowSubview: self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserDetail:) name:[GlobalConsts Notification_UserDetailNeedRefresh] object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRelationType:) name:[GlobalConsts Notification_UserDetailChangeRelationType] object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:true animated:true];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshUserDetail:(NSNotification *)sender{
    NSString *uidString = [sender valueForKey:@"userInfo"][@"uid"];
    [self getInfoDataWithUid:uidString];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}


#pragma mark - download

-(void)getInfoDataWithUid:(NSString *)uid
{
    if (!uid) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [[TKRequestHandler sharedInstance] getUserInfoWithUid:uid finish:^(NSURLSessionDataTask *sessionDataTask, LJUserInfoRequestModel *model, NSError *error) {
        
        if (error) {
            
            [weakSelf showToastHidenDefault:error.domain];
            
        }else{
            if (model.dErrno.integerValue == 0) {
                weakSelf.detailData = model.data;
                [weakSelf updateInfoArray];
            }else{
                [weakSelf showToastHidenDefault:model.msg];
            }
            [weakSelf.tableView reloadData];
        }
    }];
}

/**
 *  关注/取消关注好友
 */
-(void)postFocusSomeOne
{
    
    NSNumber *myFocusString  = self.detailData.userRelation.followType;
    
    BOOL isFollow = myFocusString.integerValue == 1 || myFocusString.integerValue == 2;
    NSString *myUid = [[AccountManager sharedInstance] uid];
    
    __weak typeof(self) weakSelf = self;
    [[TKRequestHandler sharedInstance] postModifyUserRelation:!isFollow myUid:myUid  followerUid:self.detailData.uid completion:^(NSURLSessionDataTask *sessionDataTask, LJRelationFollowModel *model, NSError *error) {
        
        if (!error) {
            if (model.dErrno.integerValue == 0) {
                NSNumber *followType = [[NSNumber alloc] init];
                LJRelationFollowDataModel  *followArray = model.data[0];
                if (followArray) {
                    followType = followArray.type;
                } else {
                    if (myFocusString.integerValue == 1) {
                        followType = [NSNumber numberWithInt:0];
                    } else if (myFocusString.integerValue == 2) {
                        followType = [NSNumber numberWithInt:3];
                    } else if (myFocusString.integerValue == 0) {
                        followType = [NSNumber numberWithInt:1];
                    } else if (myFocusString.integerValue == 3) {
                        followType = [NSNumber numberWithInt:2];
                    }
                }
                
                if (followType.integerValue == 2) {
                    //互相关注（成为好友） 后就弹框
                    NSString *tipsStr = [[[[ConfigManager sharedInstance] config] tips] agreeRelation];
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:tipsStr
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil, nil];
                    [alertView show];
                }
                
                NSDictionary *userInfo = @{@"uid":self.detailData.uid, @"type": followType.stringValue};
                [[NSNotificationCenter defaultCenter] postNotificationName:[GlobalConsts Notification_UserDetailChangeRelationType] object:nil userInfo:userInfo];
            } else {
                
                NSString *msg = model.msg ?: error.domain;
                [weakSelf showToast:msg?:@"请求失败" hideDelay:1];
                
            }
        } else {
            
            NSString *msg = error.domain;
            [weakSelf showToast:msg?:@"请求失败" hideDelay:1];
        }
    }];
}

- (void)changeRelationType:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    NSString *uid = self.detailData.uid;

    if ([userInfo[@"uid"] isEqualToString:uid]) {
        NSString *followTypeString = userInfo[@"type"];
        NSNumber *followType = [NSNumber numberWithInt:followTypeString.intValue];
        self.detailData.userRelation.followType =  followType;
        [self.tableView reloadData];
    }
}

#pragma mark - private

/**
 *  设置渐变背景颜色
 */
- (void)setViewBackGroundColor
{
    //???: 这里颜色需要斟酌
    
    CAGradientLayer *newShadow = [[CAGradientLayer alloc] init];
    newShadow.frame = self.view.frame;
    newShadow.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:0.5], [NSNumber numberWithFloat:0.51], [NSNumber numberWithFloat:1.0], nil];
    //添加渐变的颜色组合
    newShadow.colors = [NSArray arrayWithObjects:(id)[UIColor blackColor].CGColor, (id)[UIColor blackColor].CGColor,
                        (id)[UIColor blackColor].CGColor,(id)[UIColor blackColor].CGColor,nil];
    
    [self.view.layer addSublayer:newShadow];
}

-(void)updateInfoArray
{
    
    NSString *cityString = self.detailData.city;
    
    //行业重组
    NSMutableString *finishIndustryString = [[NSMutableString alloc] init];
    
    NSArray<LJUserInfoIndustryModel *> *followIndustryDic = self.detailData.followIndustry;
    for (NSInteger index = 0; index < followIndustryDic.count; index ++) {
        LJUserInfoIndustryModel *industryModel = followIndustryDic[index];
        if(industryModel.title.length == 0){
            continue;
        }
        
        if (index == 0) {
            [finishIndustryString appendString:industryModel.title];
        } else {
            [finishIndustryString appendFormat:@" | %@",industryModel.title];
        }
    }
    
    
    self.infoArray = @[self.detailData.company,self.detailData.companyJob,finishIndustryString,cityString];
}

#pragma mark - action

-(void)sendButtonClick
{
    LJTalkTableViewController *talkViewController = [LJTalkTableViewController new];
    talkViewController.talkingUserId = self.detailData.uid.integerValue;
    talkViewController.talkUserName = self.detailData.sname;
    [self.navigationController pushViewController: talkViewController animated: YES];
}

-(void)focusMeButtonAlertClick
{
    NSString *messageString = [[ConfigManager sharedInstance] config].tips.relationFollow;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: messageString
                                                        message: nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    [alertView show];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float height = scrollView.contentOffset.y;
//    NSLog(@"%lf",(float)height);
    
    if (height < 0)
    {
        iHeadView.frame = CGRectMake(0, 0, SCREEN_WIDTH, -height + 100);
    }else if (height > 0)
    {
        iHeadView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return  1;
    }else if(section == 1){
        return  4;
    }else if (section == 2){
        return 1;
    }else if (section == 3){
        return 1;
    }else if (section == 4){
        if (self.detailData.userRelation) {
            return 1;
        }else{
            return 0;
        }
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    //    NSInteger row = indexPath.row;
    if (section == 0) {
        return  125 + 3 + 64;
    }else if (section == 1)
    {
        NSString *content = self.infoArray[indexPath.row];
        CGFloat textHeight = [LJUserDetailTitleMoreTableViewCell cellHeightForTitleInfo:content];
        return textHeight;
    }else if (section == 2)
    {
        return 50;
    }else if (section == 3){
        NSString *introString = self.detailData.intro;
        CGFloat textHeight = [LJUserDetailTitleMoreTableViewCell cellHeightForTitleInfo:introString];
        return textHeight + 15;
    }else{
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0;
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4)
    {
        return 5;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:{
            NSString *reuseIdentifier = [NSString stringWithCString:class_getName([LJUserDetailHeaderTableViewCell class])
                                                           encoding:NSUTF8StringEncoding];
            LJUserDetailHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if (!cell) {
                cell = [[LJUserDetailHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                              reuseIdentifier:reuseIdentifier];
                cell.ljDelegate = self;
            }
            
            [cell updateInfo:self.detailData];
            return cell;
        }
        case 1:{
            NSArray *listArray = @[@"所在单位",@"职务",@"报道条线",@"所在地区"];
            NSString *reuseIdentifier = [NSString stringWithCString:class_getName([LJUserDetailTitleMoreTableViewCell class]) encoding:NSUTF8StringEncoding];
            LJUserDetailTitleMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if (!cell) {
                cell = [[LJUserDetailTitleMoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                 reuseIdentifier:reuseIdentifier];
            }
            NSString *contentString = self.infoArray[indexPath.row];
            [cell updatePersonNoteCell:contentString title:listArray[indexPath.row]];
            return cell;        }
        case 2:{
            NSString *reuseIdentifier = [NSString stringWithCString:class_getName([LJUserDetailTitleArrowTableViewCell class]) encoding:NSUTF8StringEncoding];
            LJUserDetailTitleArrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if (!cell) {
                cell = [[LJUserDetailTitleArrowTableViewCell alloc] initWithTitle:@"Ta的讨论" reuseIdentifier:reuseIdentifier];
            }
            
            NSString *discussNum = self.detailData.tweetNum.description;
            if (discussNum) {
                discussNum = [discussNum validStringWithDefault:@"0"];
            }else{
                discussNum = @"0";
            }

            NSString *contentString = [NSString stringWithFormat:@"%@条讨论",discussNum];
            [cell updateContent:contentString];
            return cell;
        }
        case 3:{
            NSString *reuseIdentifier = [NSString stringWithCString:class_getName([LJUserDetailTitleMoreTableViewCell class]) encoding:NSUTF8StringEncoding];
            LJUserDetailTitleMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if (!cell) {
                cell = [[LJUserDetailTitleMoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                 reuseIdentifier:reuseIdentifier];
            }
            NSString *introString = self.detailData.intro;
            [cell updatePersonNoteCell:introString title:@"自我介绍"];
            return cell;
        }
        case 4:{
            NSString *reuseIdentifier = [NSString stringWithCString:class_getName([LJUserDetailSendTableViewCell class]) encoding:NSUTF8StringEncoding];
            LJUserDetailSendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if (!cell) {
                cell = [[LJUserDetailSendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                            reuseIdentifier:reuseIdentifier];
                
            }
            
            [cell updateWithType:self.detailData.userRelation.followType.stringValue uid:self.uid];
            cell.delegate = self;
            return cell;
        }
            
        default:{
            UITableViewCell *cell = [UITableViewCell new];
            return cell;
        }
    }
    UITableViewCell *cell = nil;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    long section = indexPath.section;
    
    if (section == 2)
    {
        MyDiscussTableViewController *controller = [MyDiscussTableViewController new];
        NSString *userIdString = _detailData.uid;
        if (userIdString)
        {
            controller.userId = userIdString;
            
            
            [self.navigationController pushViewController: controller animated: YES];
        }
    }
}


#pragma mark - LJUserDetailHeaderTableViewCellDelegate

- (void)avatarCheckWithUserDetailHeaderTableViewCell:(LJUserDetailHeaderTableViewCell * _Nonnull)cell
{
    if (self.detailData) {
        FSPhotoBrowserHelper *heaper = [[FSPhotoBrowserHelper alloc] init];
        UIImage *bigImage = cell.headImageView.image;
        heaper.placeHolderImages = [[NSArray alloc] initWithObjects:bigImage, nil];
        heaper.currentIndex = 0;
        heaper.liftImageView = cell.headImageView;
        
        NSString *avatarString = self.detailData.avatar;
        heaper.images = [NSArray arrayWithObject:avatarString];
        
        [heaper show];
    }
}

- (void)changeTheFocunRelationWithType:(NSNumber * _Nonnull)type
         userDetailHeaderTableViewCell:(LJUserDetailHeaderTableViewCell * _Nonnull)cell
{
    
}

- (void)changeRelationTypeWithuserDetailHeaderTableViewCell:(LJUserDetailHeaderTableViewCell * _Nonnull)cell
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"温馨提示"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:@"解除好友关系"
                                                    otherButtonTitles:nil, nil];
    [actionSheet showInView: self.view];
}

- (void)userDetailHeaderTableViewCellBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //删除好友
        [self postFocusSomeOne];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10001) {
        if (buttonIndex == 1) {
            [self postFocusSomeOne];
        }
    }else {
        switch (buttonIndex)
        {
            case 0:
                
                break;
            case 1:
                [self postFocusSomeOne];
                [self eventForName:@"UserPage_add" attr:nil];
                break;
            default:
                break;
        }
    }
}

#pragma mark - LJUserDetailSendTableViewCellDelegate

- (void)LJUserDetailSendTableViewCellSendMessage
{
    LJTalkTableViewController *talkViewController = [LJTalkTableViewController new];
    talkViewController.talkingUserId = self.detailData.uid.integerValue;
    talkViewController.talkUserName = self.detailData.sname;
    [self.navigationController pushViewController: talkViewController animated: YES];
}

- (void)LJUserDetailSendTableViewCellSendFocusMe
{
    [self postFocusSomeOne];
}
@end
