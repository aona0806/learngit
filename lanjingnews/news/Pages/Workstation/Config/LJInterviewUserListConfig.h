//
//  LJInterviewUserListConfig.h
//  news
//
//  Created by 陈龙 on 16/5/11.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJInterviewUserListConfig : NSObject

@property (nonatomic, readonly) CGFloat titleHorizontalSpace;
@property (nonatomic, readonly) CGFloat titleTopSpace;
@property (nonatomic, readonly, nonnull) UIFont *titleFont;
@property (nonatomic, readonly, nonnull) UIColor *titleColor;
@property (nonatomic, readonly, nonnull) UIFont *detailFont;
@property (nonatomic, readonly, nonnull) UIColor *detailColor;
@property (nonatomic, readonly) CGFloat detailTopSpace;
@property (nonatomic, readonly) CGFloat detailLeftSpace;
@property (nonatomic, readonly) CGFloat detailButtomSpace;
@property (nonatomic, readonly, nonnull) UIColor *seperateLineColor;

+(nonnull instancetype)sharedInstance;

@end
