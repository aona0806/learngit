//
//  LJMeetConfereeInfoTableViewCell.h
//  news
//
//  Created by chunhui on 15/9/29.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJMeetOnlineUserItem.h"


typedef NS_ENUM(NSInteger , LJMeetRoleOperateType) {
    kLJMeetRoleAddFriend = 0,
    kLJMeetRoleDelFriend ,
    kLJMeetRoleSetAdmin  ,
    kLJMeetRoleCancelAdmin ,
    kLJMeetRoleSetGuest  ,
    kLJMeetRoleCancelGuest ,
};

/*
 * 与会者 在线信息
 */
@interface LJMeetConfereeInfoTableViewCell : UITableViewCell

@property(nonatomic , copy) void(^showUserInfoBlock)(LJMeetOnlineUserItem *model);
@property(nonatomic , copy) void(^showOrHideDetailBlock)(LJMeetOnlineUserItem *model);
@property(nonatomic , copy) void(^roleOpearteBlock)(LJMeetOnlineUserItem *model , LJMeetRoleOperateType op);

+(CGFloat)CellHeightForModel:(LJMeetOnlineUserItem *)model;
-(void)updateWithModel:(LJMeetOnlineUserItem *)model;

@end
