//
//  LJConferenceDetailTitleView.m
//  news
//
//  Created by 陈龙 on 15/10/10.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJConferenceDetailTitleView.h"
#import "UIColor+Extension.h"

@implementation LJConferenceDetailTitleView

#define kNormalFont [UIFont systemFontOfSize:15]
#define KNormalColor [UIColor colorWithHex:0x333333]

- (instancetype)init
{
    if (self = [super init]) {
        
        self.titleLabel = [UILabel new];
        self.titleLabel.textColor = KNormalColor;
        self.titleLabel.font = kNormalFont;
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(15);
            make.left.mas_equalTo(self).offset(14);
        }];
        
        self.contentLabel = [UILabel new];
        self.contentLabel.textColor = KNormalColor;
        self.contentLabel.font = kNormalFont;
        self.contentLabel.text = @"--";
        self.contentLabel.numberOfLines = 0;
        [self addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {

            make.right.mas_equalTo(self.mas_right).offset(-14);
            make.top.mas_equalTo(self.titleLabel.mas_top);
            make.left.mas_equalTo(self.titleLabel.mas_right).offset(14);
        }];
    }
    return self;
}

#pragma mark - public

- (void)updateTitle:(NSString * _Nonnull)titleString
         andContent:(NSString * _Nonnull)contentString
{
    if (self.titleLabel && self.contentLabel) {

        self.titleLabel.text = [NSString stringWithFormat:@"%@:",titleString];
        CGRect rect = [titleString boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                                options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                             attributes:@{NSFontAttributeName: kNormalFont}
                                                context:nil];
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(rect.size.width + 5);
        }];
        
        [self updateContent:contentString];
    }
}

+ (NSAttributedString *)attributeStringFromString:(NSString *)string
{
    NSRange range = NSMakeRange(0, string.length);
    NSMutableAttributedString *contentAttributeString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:2];
    [contentAttributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [contentAttributeString addAttribute:NSForegroundColorAttributeName value:KNormalColor range:range];
    
    [contentAttributeString addAttribute:NSFontAttributeName value:kNormalFont range:range];
    return contentAttributeString;
}

- (void)updateContent:(NSString * _Nonnull)contentString
{
    if (self.contentLabel) {
        NSAttributedString *attributeString = [LJConferenceDetailTitleView attributeStringFromString:contentString];

        self.contentLabel.attributedText = attributeString;
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            NSAttributedString *attributeString = [LJConferenceDetailTitleView attributeStringFromString:contentString];

            CGFloat width = self.contentLabel.bounds.size.width;
            CGRect rect = [attributeString boundingRectWithSize:CGSizeMake(width, 0)
                                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                        context:nil];
            CGFloat height = rect.size.height + 29;
            make.height.mas_equalTo(height);
        }];
    }
}

@end
