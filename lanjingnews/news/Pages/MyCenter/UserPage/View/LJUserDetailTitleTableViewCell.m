//
//  LJUserDetailTitleTableViewCell.m
//  news
//
//  Created by 陈龙 on 15/12/15.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJUserDetailTitleTableViewCell.h"
#import "NSString+TKSize.h"

@interface LJUserDetailTitleTableViewCell ()

@property (nonatomic, strong, nonnull) UILabel *titleLabel;
@property (nonatomic, strong, nonnull) UILabel *detailLabel;
@end

@implementation LJUserDetailTitleTableViewCell

- (instancetype)initWithTitle:(NSString *)title reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel.text = title;
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize: 15];
        _titleLabel.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
        _titleLabel.numberOfLines = 1;
        [self.contentView addSubview: _titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(20);
            make.top.mas_equalTo(self.contentView.mas_top).offset(15);
            make.size.mas_equalTo(CGSizeMake(70, 20));
        }];
        
        _detailLabel = [UILabel new];

        _detailLabel.font = [UIFont systemFontOfSize: 15];
        _detailLabel.textColor = [UIColor blackColor];
        _detailLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 120;
        _detailLabel.numberOfLines = 0;
        [self.contentView addSubview: _detailLabel];
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_titleLabel.mas_top);
            make.left.mas_equalTo(_titleLabel.mas_right).offset(10);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 120, 20));
        }];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = RGBACOLOR(228, 228, 228, 1);
        [self.contentView addSubview:lineView];
        [lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@(100));
            make.right.mas_equalTo(self.contentView.mas_right);
            make.height.mas_equalTo(@(0.5));
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
        }];
    }
    return self;
}

+(CGFloat)cellHeightForTitleInfo:(NSString *)info
{
    CGFloat height = [info sizeWithMaxWidth:SCREEN_WIDTH - 120 font:[UIFont systemFontOfSize:15]].height;
    return height > 50 ? height : 50;
}

- (void) updateDataWithTitle:(NSString * _Nonnull)title andContent:(NSString * _Nonnull)content
{
    if (self.titleLabel && self.detailLabel) {
        self.titleLabel.text = [title validStringWithDefault:@"--"];
        self.detailLabel.text = [content validStringWithDefault:@"--"];
    }
}

- (void) updateContent:(NSString * _Nonnull) content
{
    content = [content validStringWithDefault:@"--"];
    self.detailLabel.text = content;
}

@end
    
