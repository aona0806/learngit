//
//  LJMeetConfereeOnlineViewModel.m
//  news
//
//  Created by chunhui on 15/9/29.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMeetConfereeOnlineViewModel.h"
#import "LJMeetConfereeInfoTableViewCell.h"
#import "TKRequestHandler+MeetTalk.h"
#import "LJMeetTalkMsgModel.h"
#import "news-Swift.h"
#import "LJRelationShip.h"
#import "TKRequestHandler+userinfo.h"

@interface LJMeetConfereeOnlineViewModel()

@property(nonatomic , strong) NSMutableArray *userList;
@property(atomic    , assign) BOOL loadingData;

@end

@implementation LJMeetConfereeOnlineViewModel

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.userList = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)setOnlineTableView:(UITableView *)onlineTableView
{
    _onlineTableView = onlineTableView;
    onlineTableView.dataSource = self;
}
/**
 *  打开正在显示详情的用户列表
 *
 *  @return 用户列表
 */
-(NSArray *)showDetailUserList
{
    NSMutableArray *list = [[NSMutableArray alloc]init];
    for (LJMeetOnlineUserItem *item in self.userList) {
        if (item.canShowDetail && item.showDetail) {
            [list addObject:item];
        }
    }
    if ([list count] > 0) {
        return list;
    }
    return nil;
}

-(BOOL)canShowDetail:(NSInteger)role
{
    switch (role) {
        case kMeetRoleManager:
        case kMeetRoleCreator:
            return YES;
        default:
            break;
    }
    return NO;
}

-(void)showErrorToast:(NSString *)msg
{
    if (self.onlineTableView) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.onlineTableView animated:YES];
        hud.detailsLabel.text = msg;
        hud.mode = MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:1.5];
    }
}

-(void)loadData
{
    if (self.loadingData) {
        return;
    }
    self.loadingData = YES;
    
    __weak typeof(self) weakSelf = self;
    [[TKRequestHandler sharedInstance]getMeetOnlineListWithMeetingId:self.meetUserInfo.meetId finish:^(NSURLSessionTask *task, LJMeetOnlineListModel *model, NSError *error) {
        
        weakSelf.loadingData = NO;
        if (error == nil && [model.dErrno integerValue] ==0) {
            
            NSArray *showDetailList = [self showDetailUserList];
            
            [weakSelf.userList removeAllObjects];
            LJMeetOnlineUserItem *item;
            BOOL canShowDetail = [weakSelf canShowDetail:weakSelf.meetUserInfo.role];
            
            NSInteger myId = [[[AccountManager sharedInstance] uid] integerValue];
            
            for (LJMeetOnlineListDataDataModel *user in model.data.data) {
                item = [[LJMeetOnlineUserItem alloc]init];
                item.model = user;
                item.showDetail = NO;
                
                if (showDetailList) {
                    [showDetailList enumerateObjectsUsingBlock:^(LJMeetOnlineUserItem *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj.model.uid isEqualToString:item.model.uid]) {
                            item.showDetail = obj.showDetail;
                            *stop = YES;
                        }
                    }];
                }
                
                if ([user.role integerValue] == kMeetRoleCreator ||  [user.uid integerValue] == myId) {
                    //不能更改创建者和我的角色
                    item.canShowDetail = NO;
                }else{
                    item.canShowDetail = canShowDetail;
                }
                [weakSelf.userList addObject:item];
            }
            [weakSelf.onlineTableView reloadData];
            if (_loadDoneBlock) {
                _loadDoneBlock();
            }
        } else {
            NSString *errMsg = error.domain;
            if (errMsg.length == 0) {
                errMsg = @"在线信息获取错误";
            }
            [weakSelf showErrorToast:errMsg];
            
            if (_loadDoneBlock){
                _loadDoneBlock();
            }
        }
    }];
}

-(void)roleChangeMessage:(RoleChangeMessage *)message
{
    BOOL isMy = NO;
    BOOL canShowDetail = [self canShowDetail:self.meetUserInfo.role];
    if (message.user.uid == [self.meetUserInfo.uid integerValue]) {
        isMy = YES;
    }
    for (LJMeetOnlineUserItem *item in self.userList) {
        if (isMy) {
            if ([item.model.uid integerValue] == message.user.uid || [item.model.role integerValue] == kMeetRoleCreator) {
                //我和创建者不需要显示
                item.canShowDetail = NO;
            }else{
                item.canShowDetail = canShowDetail;
                if (!canShowDetail) {
                    //被设置为参会者，其他用户关闭查看详情
                    item.showDetail = NO;
                }
            }
        }
        if ([item.model.uid longLongValue] == message.user.uid) {
            item.model.role = @(message.user.role).description;
            item.model.roleName = [LJMeetTalkMsgDataModel RoleNameWithType:message.user.role];
            
            if (!isMy) {
                break;
            }
        }
    }
    
    [self.onlineTableView reloadData];
    
}

-(void)onlineStatusChangeMessage:(StatusMessage *)message
{
    [self loadData];
}

-(void)showOrHideUserDetail:(LJMeetOnlineUserItem *)model
{
    model.showDetail = !model.showDetail;
    NSInteger index = [self.userList indexOfObject:model];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.onlineTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)modifyUser:(LJMeetOnlineUserItem *)item toRole:(LJMeetRoleOperateType)opType
{
    NSInteger index = [self.userList indexOfObject:item];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    if (opType == kLJMeetRoleAddFriend || opType == kLJMeetRoleDelFriend) {
        
        if (opType == kLJMeetRoleAddFriend) {
            
            NSString *followUid = item.model.userInfo.uid;
            NSString *myUid =  [[AccountManager sharedInstance] uid];
            
            item.model.userInfo.followType = @(LJRelationFollowTypeMeFollowOther).description;
            
            __weak typeof(self) weakSelf = self;
            [[TKRequestHandler sharedInstance]postModifyUserRelation:YES myUid:myUid followerUid:followUid completion:^(NSURLSessionDataTask *sessionDataTask, LJRelationFollowModel *model, NSError *error) {
                
                if (error) {                    
                    item.model.userInfo.followType = @(LJRelationFollowTypeNoFollow).description;
                    [weakSelf.onlineTableView reloadRowsAtIndexPaths:@[indexPath]
                                                withRowAnimation:UITableViewRowAnimationNone];
                }
            }];
            
            [self.onlineTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        
    }else{
        LJMeetRoleType roleType = kMeetRoleUser;
        switch (opType) {
            case kLJMeetRoleSetAdmin:
                roleType = kMeetRoleManager;
                break;
            case kLJMeetRoleSetGuest:
                roleType = kMeetRoleGuest;
                break;
            case kLJMeetRoleCancelAdmin:
            case kLJMeetRoleCancelGuest:
                roleType = kMeetRoleUser;
                break;
            default:
                return;
        }
        
        LJMeetRoleType orignRoleType = [item.model.role integerValue];
        
        //update ui
        item.model.role = @(roleType).description;
        item.model.roleName = [LJMeetTalkMsgDataModel RoleNameWithType:roleType];

        [self.onlineTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        __weak typeof(self) weakSelf = self;
        [[TKRequestHandler sharedInstance]meetChangeRoleWithMeetId:item.model.meetingId changeUid:item.model.uid.description role:@(roleType).description finish:^(NSURLSessionTask *task, LJMeetChangeRoleModel *model, NSError *error) {
            
            if (error) {
                NSString *errMsg = error.domain;
                if (errMsg.length == 0) {
                    errMsg = @"更改用户角色失败";
                }
                
                [weakSelf showErrorToast:errMsg];
            } else {
                if (model.data == nil || error) {
                    //请求失败
                    item.model.role = @(orignRoleType).description;
                    item.model.roleName = [LJMeetTalkMsgDataModel RoleNameWithType:orignRoleType];
                    [weakSelf.onlineTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    
                    NSString *errMsg = model.msg;
                    if (errMsg.length == 0) {
                        errMsg = @"更改用户角色失败";
                    }
                    
                    [weakSelf showErrorToast:errMsg];
                }
            }            
        }];
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.userList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    
    LJMeetConfereeInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[LJMeetConfereeInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        __weak typeof(self) weakSelf = self;
        cell.showOrHideDetailBlock = ^(LJMeetOnlineUserItem *model){
            [weakSelf showOrHideUserDetail:model];
        };
        cell.showUserInfoBlock = ^(LJMeetOnlineUserItem *model){
            if (weakSelf.showUserInfoBlock) {
                weakSelf.showUserInfoBlock(model);
            }
        };
        cell.roleOpearteBlock = ^(LJMeetOnlineUserItem *model , LJMeetRoleOperateType opType){
            [weakSelf modifyUser:model toRole:opType];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    LJMeetOnlineUserItem *item = [self.userList objectAtIndex:indexPath.row];
    [cell updateWithModel:item];
    
    return cell;
}

-(CGFloat)CellHeightFromIndexPath:(NSIndexPath *)indexPath
{
    LJMeetOnlineUserItem *item = [self.userList objectAtIndex:indexPath.row];
    return [LJMeetConfereeInfoTableViewCell CellHeightForModel:item];
}

@end
