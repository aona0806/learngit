//
//  LJSegmentView.h
//  news
//
//  Created by chunhui on 15/9/30.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LJSegmentViewDelegate;
@interface LJSegmentView : UIView

@property(nonatomic , assign) NSInteger selectedIndex;

@property(nonatomic , weak) id<LJSegmentViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame andItems:(NSArray *)itemNames;

-(void)updateAtIndext:(NSInteger)index withName:(NSString *)name;

@end

@protocol LJSegmentViewDelegate <NSObject>

-(void)selecteAtIndex:(NSInteger)index;

@end