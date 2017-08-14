//
//  LJUserDetailTitleArrowTableViewCell.h
//  news
//
//  Created by 陈龙 on 15/12/15.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJUserDetailTitleArrowTableViewCell : UITableViewCell

- (instancetype _Nonnull)initWithTitle:(NSString * _Nonnull)title reuseIdentifier:(NSString * _Nonnull)reuseIdentifier;
- (void) updateDataWithTitle:(NSString * _Nonnull)title andContent:(NSString * _Nonnull)content;
- (void) updateContent:(NSString * _Nonnull) content;

@end
