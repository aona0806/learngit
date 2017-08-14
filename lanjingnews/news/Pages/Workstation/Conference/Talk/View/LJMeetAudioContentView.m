//
//  LJMeetAudioContentView.m
//  news
//
//  Created by chunhui on 15/10/11.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMeetAudioContentView.h"
#import "UIColor+Util.h"
#import "UIView+Utils.h"
#import "NSString+TKSize.h"

@interface LJMeetAudioContentView()

@property(nonatomic , strong) UILabel *contentLabel;
@property(nonatomic , strong) UIImageView *bgImageView;

@end

@implementation LJMeetAudioContentView

#define kContentMargin  10

+(CGFloat)HeightForContent:(NSString *)content andWidth:(CGFloat)width
{
    return [content sizeWithMaxWidth:width - 2*kContentMargin font:[UIFont systemFontOfSize:12]].height + 2*kContentMargin;
}

-(UILabel *)contentLabel
{
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = HexColor(0x777777);
        _contentLabel.font = [UIFont systemFontOfSize:12];
        
        [self addSubview:_contentLabel];
    }
    return _contentLabel;
}

-(UIImageView *)bgImageView
{
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc]init];
        UIImage *image = [UIImage imageNamed:@"meet_talk_audio_wordbg"];
        _bgImageView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        
        [self addSubview:_bgImageView];
    }
    return  _bgImageView;
}

-(void)setContent:(NSString *)content
{
    self.contentLabel.text = content;
}

-(CGSize)sizeThatFits:(CGSize)size
{
    CGSize contentSize = CGSizeMake(size.width - 2*kContentMargin , size.height - 2*kContentMargin);
    contentSize = [self.contentLabel sizeThatFits:contentSize];
    return CGSizeMake(contentSize.width + 2*kContentMargin, contentSize.height + 2*kContentMargin);
}

-(void)layoutSubviews
{
    [self sendSubviewToBack:self.bgImageView];
    
    _bgImageView.frame = self.bounds;
    
    _contentLabel.frame = CGRectMake(kContentMargin, kContentMargin, self.width - 2*kContentMargin, self.height - 2*kContentMargin);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
