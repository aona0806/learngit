//
//  TelTableViewCell.h
//  news
//
//  Created by Vison_Cui on 15/4/12.
//  Copyright (c) 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJPhoneBookFeedBackModel.h"

@protocol LJAddressBookDetailViewCellDelegate <NSObject>

@optional
- (void)pushToUserDetailWithUid:(NSString * _Nonnull)uid;

@end
@interface LJAddressBookDetailViewCell : UITableViewCell

@property (nonatomic, weak, nullable) id<LJAddressBookDetailViewCellDelegate> delegate;

- (void)updateInfo:(LJPhoneBookFeedBackDataListModel * _Nullable)info;
+ (CGFloat)heightForCell:(LJPhoneBookFeedBackDataListModel * _Nonnull)info;

@end
