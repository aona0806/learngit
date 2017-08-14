//
//  LJInputTextViewTableViewCell.h
//  news
//
//  Created by 陈龙 on 15/12/21.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LJInputTextViewTableViewCellDelegate <NSObject>

- (void)LJInputTextViewUpdateWithTitle:(NSString * _Nonnull)title content:(NSString * _Nonnull)content;

@end

@interface LJInputTextViewTableViewCell : UITableViewCell

@property (nonatomic, strong, nonnull) UITextView *contentTextView;
@property (nonatomic, weak, nullable) id<LJInputTextViewTableViewCellDelegate> delegate;
@property (nonatomic, strong, nonnull) NSString * placeHolder;

- (void)updateInfo:(NSString * _Nullable)content;

@end
