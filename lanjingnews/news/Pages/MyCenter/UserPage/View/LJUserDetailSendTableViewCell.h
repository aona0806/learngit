//
//  LJUserDetailSendTableViewCell.h
//  news
//
//  Created by 陈龙 on 15/12/16.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LJUserDetailSendTableViewCellDelegate <NSObject>

- (void)LJUserDetailSendTableViewCellSendMessage;
- (void)LJUserDetailSendTableViewCellSendFocusMe;

@end

@interface LJUserDetailSendTableViewCell : UITableViewCell

@property (nonatomic, weak, nullable) id<LJUserDetailSendTableViewCellDelegate> delegate;

- (void)updateWithType:(NSString * _Nonnull)type uid:(NSString * _Nonnull)uid;

@end
