//
//  LJConferenceDetailInfoView.h
//  news
//
//  Created by 陈龙 on 15/10/10.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJConferenceDetailInfoView : UIView

@property (nonnull,nonatomic,retain) UILabel *titleLabel;
@property (nonnull,nonatomic,retain) UILabel *contentLabel;

@property (nonatomic) BOOL isExpand;

- (void)updateTitle:(NSString * _Nonnull)titleString
         andContent:(NSString * _Nonnull)contentString;

- (void)updateTitle:(NSString * _Nonnull)titleString;
- (void)updateContent:(NSString * _Nonnull)contentString;


@end
