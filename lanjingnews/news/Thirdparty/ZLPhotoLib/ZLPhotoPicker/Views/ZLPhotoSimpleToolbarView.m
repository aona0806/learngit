//
//  ZLPhotoSimpleToolbarView.m
//  CaiLianShe
//
//  Created by chunhui on 2016/10/17.
//  Copyright © 2016年 chenny. All rights reserved.
//

#import "ZLPhotoSimpleToolbarView.h"

@interface ZLPhotoSimpleToolbarView ()

@property(nonatomic , strong) UIButton *doneButton;

@end

@implementation ZLPhotoSimpleToolbarView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.doneButton];
    }
    return self;
}

-(UIButton *)doneButton
{
    if (!_doneButton) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        _doneButton.layer.cornerRadius = 4;
        _doneButton.layer.masksToBounds = true;
        _doneButton.backgroundColor = RGB(0xff, 0x38, 0x24);
        _doneButton.bounds = CGRectMake(0, 0, 85, 24);
        
    }
    return _doneButton;
}

-(void)updateChooseImage:(NSInteger)choosed total:(NSInteger)total
{
    
    NSString * text = nil;
    if (choosed > 0) {        
        text = [NSString stringWithFormat:@"完成(%d)",(int)choosed];//[NSString stringWithFormat:@"完成(%d/%d)",(int)choosed,(int)total];
    }else{
        text = @"完成";
    }
    
    [self.doneButton setTitle:text forState:UIControlStateNormal];
    
    [self setNeedsLayout];
    
}

-(void)doneAction:(id)sender
{
    if (_doneBlock) {
        _doneBlock();
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _doneButton.centerY = self.height/2;
    _doneButton.right = self.width - 15;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
