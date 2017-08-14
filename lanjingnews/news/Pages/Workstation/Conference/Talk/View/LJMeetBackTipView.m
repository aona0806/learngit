//
//  LJMeetBackTipView.m
//  ViewModelTest
//
//  Created by chunhui on 15/10/23.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import "LJMeetBackTipView.h"
#import "UIView+Utils.h"
#import "UIColor+Util.h"

@interface LJMeetBackTipView()

@property(nonatomic , strong) UILabel *titleLabel;
@property(nonatomic , strong) UIImageView *indictorImageView;

@end

@implementation LJMeetBackTipView

-(UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:10];
        _titleLabel.textColor = RGB(33, 115, 200);
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

-(UIImageView *)indictorImageView
{
    if (_indictorImageView == nil) {
        UIImage *image = [UIImage imageNamed:@"meet_back_tip"];
        _indictorImageView = [[UIImageView alloc]initWithImage:image];
        [self addSubview:_indictorImageView];
    }
    return _indictorImageView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    CGRect statusFrame = [[UIApplication sharedApplication]statusBarFrame];
    frame.size = CGSizeMake(80, statusFrame.size.height);
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.text = @"回到会议";
        self.backgroundColor = [UIColor whiteColor];
    }
    return  self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.indictorImageView.centerY = self.height/2;
    _indictorImageView.right    = self.width - 6;
    
    [_titleLabel sizeToFit];
    
    _titleLabel.center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
}

-(void)show
{
    CGRect statusFrame = [[UIApplication sharedApplication]statusBarFrame];
    CGRect frame = self.frame;
    frame.origin = CGPointMake(CGRectGetWidth(statusFrame), 0);
    self.frame = frame;
    NSString *key = [NSString stringWithFormat:@"%@BarW%@",@"status",@"indow"];//statusBarWindow
    UIWindow *statusBarWindow = (UIWindow *)[[UIApplication sharedApplication] valueForKey:key];
    
    [statusBarWindow addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect nFrame = self.frame;
        nFrame.origin.x = CGRectGetWidth(statusFrame) - CGRectGetWidth(frame);
        self.frame = nFrame;
    } completion:^(BOOL finished) {
        
    }];
    
    
}


-(void)hide
{
    [UIView animateWithDuration:.3 animations:^{
        CGRect frame = self.frame;
        frame.origin.x = CGRectGetWidth(self.superview.frame);
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
