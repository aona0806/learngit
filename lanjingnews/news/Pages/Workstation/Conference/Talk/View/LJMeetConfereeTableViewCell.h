//
//  LJMeetConfereeTableViewCell.h
//  news
//
//  Created by chunhui on 15/9/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJMeetTalkMsgItem.h"

/*
 * 与会者 讨论cell
 */
@interface LJMeetConfereeTableViewCell : UITableViewCell

+(CGFloat)CellHeightForModel:(LJMeetTalkMsgItem *)model;
-(void)updateWithModel:(LJMeetTalkMsgItem *)model;

@end
