//
//  LJMeetConfereeOnlineViewModel.h
//  news
//
//  Created by chunhui on 15/9/29.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJMeetOnlineListModel.h"
#import "Data.pbobjc.h"
#import "LJMeetUserInfo.h"

@import UIKit;

@class LJMeetOnlineUserItem;
@interface LJMeetConfereeOnlineViewModel : NSObject<UITableViewDataSource>

@property(nonatomic , weak) UITableView *onlineTableView;
//@property(nonatomic , strong) NSString *meetId;
@property(nonatomic , strong) LJMeetUserInfo *meetUserInfo;

@property(nonatomic , copy)   void (^loadDoneBlock)();
@property(nonatomic , copy)   void (^showUserInfoBlock)(LJMeetOnlineUserItem *model);

@property(nonatomic , strong , readonly) NSMutableArray *userList;

-(void)loadData;
-(CGFloat)CellHeightFromIndexPath:(NSIndexPath *)indexPath;

-(void)roleChangeMessage:(RoleChangeMessage *)message;

-(void)onlineStatusChangeMessage:(StatusMessage *)message;


@end
