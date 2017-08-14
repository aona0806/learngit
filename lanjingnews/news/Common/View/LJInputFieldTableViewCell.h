//
//  LJInputFieldTableViewCell.h
//  news
//
//  Created by 陈龙 on 15/12/19.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LJInputFieldTableViewCellDelegate <NSObject>

- (void)LJInputFieldUpdateWithTitle:(NSString * _Nonnull)title content:(NSString * _Nonnull)content;

@end

@interface LJInputFieldTableViewCell : UITableViewCell

/**
 *  显示分界线
 */
@property (nonatomic, assign) BOOL isShowSeperateLine;
@property (nonatomic, assign) UIKeyboardType keytboardType;
@property (nonatomic, weak, nullable) id<LJInputFieldTableViewCellDelegate> delegate;

- (instancetype _Nonnull)initWithTitle:(NSString * _Nonnull)title
                  placeholder:(NSString * _Nullable)placreholder
              reuseIdentifier:(NSString * _Nonnull)reuseIdentifier;

- (instancetype _Nonnull)initWithTitle:(NSString * _Nonnull)title
                           placeholder:(NSString * _Nullable)placreholder
                           animoteText:(NSString * _Nonnull)animoteString
                       reuseIdentifier:(NSString * _Nonnull)reuseIdentifier;

/**
 *  添加成功画面
 *
 *  @param completion <#completion description#>
 */
- (void)animation:(void (^ __nullable)(BOOL finished))completion;

- (void)updateInfo:(NSString * _Nullable)content;

@end
