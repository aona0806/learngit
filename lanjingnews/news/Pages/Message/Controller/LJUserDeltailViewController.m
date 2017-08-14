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
#import "FSPhotoBrowserHelper.h"
#import "MobClick.h"
#import "news-swift.h"
#import "LJUserNoteDataModel.h"
#import "LJUserDetailHeaderTableViewCell.h"
#import "LJUserDetailTitleArrowTableViewCell.h"
#import "LJUserDetailTitleTableViewCell.h"
#import "LJUserDetailTitleMoreTableViewCell.h"
#import "LJUserDetailSendTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface LJUserDeltailViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIAlertViewDelegate,LJUserDetailHeaderTableViewCellDelegate, UIGestureRecognizerDelegate, LJUserDetailSendTableViewCellDelegate>
{
}

@property (nonatomic, strong) LJUserNoteDataDataModel * _Nullable detailData;

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
    
    [self setViewBackGroundColor];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self getInfoDataWithUid:self.noteId];
    
    self.tableView = [UITableView new];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).width.insets(UIEdgeInsetsMake(-20, 0, 0, 0));
    }];
    
//    iHeadView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, 20)];
//    iHeadView.backgroundColor = RGBACOLOR(1, 2, 1, 1);
//    [self.view insertSubview:iHeadView belowSubview: self.tableView];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)getInfoDataWithUid:(NSString *)noteId
{
    if (!noteId) {
        return;
    }
    [[TKRequestHandler sharedInstance] postUserDetailWithUid:noteId complated:^(NSURLSessionDataTask *sessionDataTask, LJUserNoteDataModel *model, NSError *error) {
        if (error) {
            
        } else {
            if (model.dErrno.integerValue == 0) {
                self.detailData = model.data;
                [self updateInfoArray];
            }
            [self.tableView reloadData];
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
    
    [[TKRequestHandler sharedInstance] postFocusSomeOneWithFollower:!isFollow FollowerUid:self.detailData.uid complated:^(NSURLSessionDataTask *sessionDataTask, LJRelationFollowModel *model, NSError *error) {
        if (!error) {
            if (model.dErrno.integerValue == 0) {
                
                NSArray<LJRelationFollowDataModel *> *followArray = model.data[0];
                self.detailData.userRelation.followType = followArray[0].type;
                
                if (self.detailData.userRelation.followType.integerValue == 2) {
                    //互相关注（成为好友） 后就弹框
                    NSString *messageString = [[NSUserDefaults standardUserDefaults] objectForKey: @"agree_relation"];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: messageString
                                                                        message: nil
                                                                       delegate: nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil, nil];
                    [alertView show];
                }
                [self.tableView reloadData];

            } else {
                
            }
        }
    }];
}

#pragma mark - private

/**
 *  设置背景颜色
 */
- (void)setViewBackGroundColor
{
    //???: 这里颜色需要斟酌
    
    CAGradientLayer *newShadow = [[CAGradientLayer alloc] init];
    newShadow.frame = self.view.frame;
    newShadow.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:0.5], [NSNumber numberWithFloat:0.51], [NSNumber numberWithFloat:1.0], nil];
    //添加渐变的颜色组合
    newShadow.colors = [NSArray arrayWithObjects:(id)[UIColor blackColor], (id)[UIColor blackColor],
                        (id)[UIColor whiteColor].CGColor,(id)[UIColor whiteColor].CGColor,nil];
    
    [self.view.layer addSublayer:newShadow];
    
}

-(void)updateInfoArray
{
    
    NSString *cityString = self.detailData.city;
    
    //行业重组
    NSString *finishIndustryString;
    
    NSDictionary *followIndustryDic = self.detailData.followIndustry;
    if (followIndustryDic && [followIndustryDic isKindOfClass: [NSDictionary class]])
    {
        NSArray *followArray = followIndustryDic.allValues;
        NSMutableString *industryString;
        for (int index = 0; index < followArray.count; index ++)
        {
            if (index == 0) {
                industryString = [NSMutableString stringWithFormat:@"%@",followArray[index]];
            }else{
                [industryString appendFormat: @"| %@",followArray[index]];
            }
        }
        finishIndustryString = industryString ? industryString : @"" ;
    }else{
        finishIndustryString = @"";
    }
    
    self.infoArray = @[self.detailData.company,self.detailData.companyJob,finishIndustryString,cityString];
}

#pragma mark - action

-(void)sendButtonClick
{
    LJTalkTableViewController *talkViewController = [LJTalkTableViewController new];
    talkViewController.talkingUserId = self.detailData.id.integerValue;
    talkViewController.talkUserName = self.detailData.sname;
    [self.navigationController pushViewController: talkViewController animated: YES];
}

-(void)focusMeButtonAlertClick
{
    NSString *messageString = [[NSUserDefaults standardUserDefaults] objectForKey: [GlobalConsts KeyRelationFollow]];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: messageString
                                                        message: nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    [alertView show];
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
        return 1;
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
        
        return [LJUserDetailTitleTableViewCell cellHeightForTitleInfo:content];
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
            NSArray *listArray = @[@"所在单位",@"职务",@"所属行业",@"所在地区"];
            NSString *reuseIdentifier = [NSString stringWithCString:class_getName([LJUserDetailTitleTableViewCell class]) encoding:NSUTF8StringEncoding];
            LJUserDetailTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if (!cell) {
                cell = [[LJUserDetailTitleTableViewCell alloc] initWithTitle:listArray[indexPath.row]
                                                             reuseIdentifier:reuseIdentifier];
            }
            NSString *contentString = self.infoArray[indexPath.row];
            [cell updateContent:contentString];
            return cell;        }
        case 2:{
            NSString *reuseIdentifier = [NSString stringWithCString:class_getName([LJUserDetailTitleArrowTableViewCell class]) encoding:NSUTF8StringEncoding];
            LJUserDetailTitleArrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if (!cell) {
                cell = [[LJUserDetailTitleArrowTableViewCell alloc] initWithTitle:@"Ta的讨论" reuseIdentifier:reuseIdentifier];
            }
            
            NSString *discussNum = self.detailData.tweetNum;
            discussNum = [discussNum validStringWithDefault:@"0"];
            NSString *contentString = [NSString stringWithFormat:@"%@条讨论11",discussNum];
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
            [cell updatePersonNoteCell:introString];
            return cell;
        }
        case 4:{
            NSString *reuseIdentifier = [NSString stringWithCString:class_getName([LJUserDetailSendTableViewCell class]) encoding:NSUTF8StringEncoding];
            LJUserDetailSendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if (!cell) {
                cell = [[LJUserDetailSendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                            reuseIdentifier:reuseIdentifier];
            }
            
            [cell updateWithType:self.detailData.userRelation.followType.stringValue uid:self.noteId];
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
//        MyDiscussTableViewController *controller = [MyDiscussTableViewController new];
//        NSString *userIdString = _detailData[@"uid"];
//        if (userIdString)
//        {
//            controller.userId = userIdString.integerValue;
//            
//            
//            [self.navigationController pushViewController: controller animated: YES];
//        }
        
        //FIXME: 进入个人讨论界面
    }
}


#pragma mark - LJUserDetailHeaderTableViewCellDelegate

- (void)avatarCheckWithUserDetailHeaderTableViewCell:(LJUserDetailHeaderTableViewCell * _Nonnull)cell
{
    FSPhotoBrowserHelper *heaper = [[FSPhotoBrowserHelper alloc] init];
    UIImage *bigImage = cell.headImageView.image;
    heaper.placeHolderImages = [[NSArray alloc] initWithObjects:bigImage, nil];
    heaper.currentIndex = 0;
    heaper.liftImageView = cell.headImageView;
    
    NSString *avatarString = self.detailData.avatar;
    
    heaper.images = [NSArray arrayWithObject:avatarString];
    
    [heaper show];
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
    switch (buttonIndex)
    {
        case 0:
            
            break;
        case 1:
            [self postFocusSomeOne];
            [MobClick event:@"UserPage_add"];
            break;
        default:
            break;
    }
}

#pragma mark - LJUserDetailSendTableViewCellDelegate

- (void)LJUserDetailSendTableViewCellSendMessage
{
    LJTalkTableViewController *talkViewController = [LJTalkTableViewController new];
    talkViewController.talkingUserId = self.detailData.id.integerValue;
    talkViewController.talkUserName = self.detailData.sname;
    [self.navigationController pushViewController: talkViewController animated: YES];
}

- (void)LJUserDetailSendTableViewCellSendFocusMe
{
    [self postFocusSomeOne];
}
@end
