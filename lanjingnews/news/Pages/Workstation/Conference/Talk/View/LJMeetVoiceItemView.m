//
//  LJMeetVoiceItemView.m
//  news
//
//  Created by chunhui on 15/9/26.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMeetVoiceItemView.h"
#import "UIView+Utils.h"

@interface LJMeetVoiceItemView ()

@property(nonatomic , strong) UIImageView *voiceImageView;
@property(nonatomic , strong) UILabel *durationLabel;

@end

@implementation LJMeetVoiceItemView


-(UIImageView *)voiceImageView
{
    if (_voiceImageView == nil) {
        _voiceImageView = [[UIImageView alloc]init];
        _voiceImageView.frame = CGRectMake(0, 0, 8, 10);
        _voiceImageView.animationDuration = 1;
        
        [self addSubview:_voiceImageView];
    }
    return _voiceImageView;
}

-(UILabel *)durationLabel
{
    if (_durationLabel == nil) {
        _durationLabel = [[UILabel alloc]init];
        _durationLabel.backgroundColor = [UIColor clearColor];
        _durationLabel.textAlignment = NSTextAlignmentRight;
        _durationLabel.font = [UIFont systemFontOfSize:10];
        
        [self addSubview:_durationLabel];
    }
    return _durationLabel;
}

-(void)setAlignLeft:(BOOL)alignLeft
{
    _alignLeft = alignLeft;
    NSMutableArray *images = [NSMutableArray new];
    if (alignLeft) {
        
        UIImage *image = [UIImage imageNamed:@"meet_left_voice_one"];
        if (image) {
            [images addObject:image];
        }
        image = [UIImage imageNamed:@"meet_left_voice_two"];
        if (image) {
            [images addObject:image];
        }
        image = [UIImage imageNamed:@"meet_left_voice_three"];
        if (image) {
            [images addObject:image];
        }
        
    }else{
        UIImage *image = [UIImage imageNamed:@"meet_right_voice_one"];
        if (image) {
            [images addObject:image];
        }
        image = [UIImage imageNamed:@"meet_right_voice_two"];
        if (image) {
            [images addObject:image];
        }
        image = [UIImage imageNamed:@"meet_right_voice_three"];
        if (image) {
            [images addObject:image];
        }
        

    }
    
    [self.voiceImageView setAnimationImages:images];
    self.voiceImageView.image = [images lastObject];
    
}

-(void)setDuration:(NSString *)duration
{
    if (![duration hasSuffix:@"\""]) {
        _duration = [duration stringByAppendingString:@"\""];
    }else{
        _duration = duration;
    }
    
    self.durationLabel.text = _duration;
    [self.durationLabel sizeToFit];
    
    [self setNeedsLayout];
}

-(void)layoutSubviews
{    
    self.voiceImageView.centerY = self.height/2;
    
    if (_alignLeft) {
        self.voiceImageView.left = 0;
//        self.durationLabel.left = self.voiceImageView.right;
        self.durationLabel.right = self.width;
        self.durationLabel.textAlignment = NSTextAlignmentRight;
        
    }else{
        self.voiceImageView.right = self.width;
        self.durationLabel.left = 0;
//        self.durationLabel.right = self.voiceImageView.left ;
        self.durationLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    self.durationLabel.centerY = self.voiceImageView.centerY;
    
    [super layoutSubviews];
}

-(void)playAnimate:(BOOL)play
{
    if (play) {
        [self.voiceImageView startAnimating];
    }else{
        [self.voiceImageView stopAnimating];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
