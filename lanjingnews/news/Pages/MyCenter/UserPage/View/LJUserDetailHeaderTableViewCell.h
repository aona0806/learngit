//
//  LJUserDetailHeaderTableViewCell.h
//  news
//
//  Created by 陈龙 on 15/12/11.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJUserInfoModel.h"

@class LJUserDetailHeaderTableViewCell;

@protocol LJUserDetailHeaderTableViewCellDelegate <NSObject>

@optional
- (void)avatarCheckWithUserDetailHeaderTableViewCell:(LJUserDetailHeaderTableViewCell * _Nonnull)cell;
- (void)changeTheFocunRelationWithType:(NSNumber * _Nonnull)type userDetailHeaderTableViewCell:(LJUserDetailHeaderTableViewCell * _Nonnull)cell;
- (void)changeRelationTypeWithuserDetailHeaderTableViewCell:(LJUserDetailHeaderTableViewCell * _Nonnull)cell;
- (void)userDetailHeaderTableViewCellBack;

@end

@interface LJUserDetailHeaderTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView * _Nonnull headImageView;

@property (nonatomic, nullable, weak) id<LJUserDetailHeaderTableViewCellDelegate> ljDelegate;

- (void) updateInfo:(LJUserInfoModel * _Nullable)info;

@end
