//
//  LJUserDetailTitleMoreTableViewCell.h
//  news
//
//  Created by 陈龙 on 15/12/16.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJUserDetailTitleMoreTableViewCell : UITableViewCell

+(CGFloat)cellHeightForTitleInfo:(NSString * _Nonnull)introString;

- (void)updatePersonNoteCell:(NSString * _Nonnull)introString;

@end
