//
//  LJFriendsTableViewCell.h
//  news
//
//  Created by 陈龙 on 15/12/20.
//  Copyright (c) 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJUserFriendModel.h"

@class  LJFriendsTableViewCell;

@protocol FriendsTableViewCellDelegate <NSObject>

-(void)AddFriendsDelegateWithCell:(LJFriendsTableViewCell * _Nonnull)cell;
-(void)AcceptFriendsDelegateWithCell:(LJFriendsTableViewCell * _Nonnull)cell;

@end


@interface LJFriendsTableViewCell : UITableViewCell

@property (nonatomic, weak, nullable) id <FriendsTableViewCellDelegate> delegate;

-(instancetype _Nonnull)initWithMessageStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * _Nonnull)reuseIdentifier;

- (void) setValueForCellAllValueWith:(LJUserFriendDataListModel * _Nonnull)noteData;

- (void) fourcesSomebodyWith:(LJUserFriendDataListModel * _Nonnull)noteData;

@end
