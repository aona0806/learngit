//
//  LJConferenceDetailInfoView.m
//  news
//
//  Created by 陈龙 on 15/10/10.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJConferenceDetailInfoView.h"
#import "Masonry.h"
#import <NSString+TKSize.h>
#import "UIColor+Extension.h"

#define kTitleFont [UIFont systemFontOfSize:18]
#define KTitleColor [UIColor colorWithHex:0x333333]
#define kContentFont [UIFont systemFontOfSize:15]
#define KContentColor [UIColor RGBColorR:85 G:85 B:85]
@interface LJConferenceDetailInfoView ()
{
    BOOL isShowArrow;
}

@property (nonatomic,retain,nullable) UIImageView *arrowImageView;

@end

@implementation LJConferenceDetailInfoView

- (instancetype)init
{
    if (self = [super init]) {
        self.isExpand = NO;
        
        isShowArrow = NO;
        
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel = [UILabel new];
        self.titleLabel.textColor = KTitleColor;
        self.titleLabel.font = kTitleFont;
        
        self.titleLabel.numberOfLines = 1;
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(@20);
            make.left.mas_equalTo(self).offset(14);
            make.height.mas_equalTo(@21);
        }];
        
        self.arrowImageView = [UIImageView new];
        self.arrowImageView.image = [UIImage imageNamed:@"conference_detail_arrowdown"];
        self.arrowImageView.highlightedImage = [UIImage imageNamed:@"conference_detail_arrowup"];
        [self addSubview:self.arrowImageView];
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
            make.right.mas_equalTo(self.mas_right).offset(-14);
            make.left.mas_equalTo(self.titleLabel.mas_right).offset(5);
            make.size.mas_equalTo(CGSizeMake(15, 8));
        }];
        
        self.contentLabel = [UILabel new];
//        self.contentLabel.backgroundColor = [UIColor redColor];
        self.contentLabel.textColor = KContentColor;
        self.contentLabel.font = kContentFont;
        self.contentLabel.text = @"--";
        self.contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:self.contentLabel];
        self.contentLabel.numberOfLines = 3;
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(20);
            make.right.mas_equalTo(self.mas_right).offset(-14);
            make.left.mas_equalTo(self.mas_left).offset(14);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-20);
        }];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)singleTap:(UIGestureRecognizer *)gesture
{
    if (isShowArrow) {
        if (self.isExpand) {
            self.contentLabel.numberOfLines = 0;
            self.arrowImageView.highlighted = YES;
        } else {
            self.contentLabel.numberOfLines = 3;
            self.arrowImageView.highlighted = false;
        }
        self.isExpand = !self.isExpand;
    }
}

#pragma mark - public

- (void)updateTitle:(NSString * _Nonnull)titleString
         andContent:(NSString * _Nonnull)contentString
{
    self.titleLabel.text = titleString;
    self.contentLabel.text = contentString;
    CGFloat height = [contentString sizeWithMaxWidth:SCREEN_WIDTH - 20 font:kContentFont].height;
    if (height < 52) {
        self.arrowImageView.hidden = YES;
        isShowArrow = YES;
    } else {
        self.arrowImageView.hidden = NO;
        isShowArrow = NO;
    }
}

- (void)updateTitle:(NSString * _Nonnull)titleString
{
    self.titleLabel.text = titleString;
}

- (void)updateContent:(NSString * _Nonnull)contentString
{
    self.contentLabel.text = contentString;
    CGFloat height = [contentString sizeWithMaxWidth:SCREEN_HEIGHT - 20 font:kContentFont].height;
    if (height <= 52) {
        self.arrowImageView.hidden = YES;
        isShowArrow = NO;
    } else {
        self.arrowImageView.hidden = NO;
        isShowArrow = YES;
    }
}

@end
