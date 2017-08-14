//
//  LJNavigationTipStatusBar.m
//  Demo
//
//  Created by chunhui on 15/10/28.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import "LJNavigationTipStatusBar.h"

@interface LJNavigationTipStatusBar ()

@property(nonatomic , strong) UILabel *contentLabel;

@end

@implementation LJNavigationTipStatusBar

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, frame.size.width, frame.size.height - 20)];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont systemFontOfSize:13];
        
        self.backgroundColor = [UIColor greenColor];
        [self addSubview:_contentLabel];
    }
    return self;
}

-(void)updateTip:(NSString *)tip
{
    _contentLabel.text = tip;
    
}

-(void)startFlash
{
    [self stopFlash];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];

    animation.duration = 1;
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    animation.toValue = [NSNumber numberWithFloat:0.0];
    animation.autoreverses = YES;
    animation.repeatCount= INT_MAX;
    
    [_contentLabel.layer addAnimation:animation forKey:@"flash"];
}


-(void)stopFlash
{
    [_contentLabel.layer removeAllAnimations];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
