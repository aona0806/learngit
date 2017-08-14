//
//  LJAddNoteSegmentTableViewCell.h
//  news
//
//  Created by 陈龙 on 15/12/19.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKRequestHandler+Workstation.h"

@protocol LJAddNoteSegmentTableViewCellDelegate <NSObject>

- (void)noteSegmentSelectedWithType:(LJPhoneBookType)type;

@end

@interface LJAddNoteSegmentTableViewCell : UITableViewCell

@property (nonatomic, assign, nullable) id<LJAddNoteSegmentTableViewCellDelegate> delegate;

@end
