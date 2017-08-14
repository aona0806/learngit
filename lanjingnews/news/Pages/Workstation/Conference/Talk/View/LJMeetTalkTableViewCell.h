//
//  LJMeetHostTableViewCell.h
//  news
//
//  Created by chunhui on 15/9/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJMeetTalkMsgItem.h"
/*
 * 管理员 嘉宾 cell
 */
@interface LJMeetTalkTableViewCell : UITableViewCell

@property(nonatomic , assign) BOOL alignLeft;
@property(nonatomic , copy) void (^playSpeech)(LJMeetTalkMsgItem *model);
@property(nonatomic , copy) void (^tapHeadBlock)(LJMeetTalkMsgItem *model);
@property(nonatomic , copy) void (^msgOperateBlock)(LJMeetTalkMsgItem *model , LJMeetMsgOperate operate);
@property(nonatomic , copy) void (^showOrHideAudioWordBlock)(LJMeetTalkMsgItem *model , LJMeetTalkTableViewCell * cell);
//@property(nonatomic , copy) LJMeetRoleType (^myRoleBlock)();
@property(nonatomic , copy) void (^reloadBlock)(LJMeetTalkMsgItem *model);
@property(nonatomic , copy) void (^copyBlock)(LJMeetTalkMsgItem *model);

+(CGFloat)CellHeightForModel:(LJMeetTalkMsgItem *)model;
-(void)updateWithModel:(LJMeetTalkMsgItem *)model;

@end
