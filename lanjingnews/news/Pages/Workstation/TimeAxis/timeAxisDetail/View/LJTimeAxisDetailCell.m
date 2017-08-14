//
//  LJTimeAxisDetailCell.m
//  news
//
//  Created by 奥那 on 15/12/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJTimeAxisDetailCell.h"
#import "NSString+TKSize.h"

@implementation LJTimeAxisDetailCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupMySubViews];
    }
    return self;
}

- (void)setupMySubViews{
    self.titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_titleLabel];
    self.titleLabel.textColor = [UIColor colorWithRed:144/255.0 green:168/255.0 blue:201/255.0 alpha:1];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.numberOfLines = 1;
    
    self.contentLabel = [[KILabel alloc] init];
    self.contentLabel.copyingEnabled = NO;

    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.textColor = [UIColor colorWithRed:41/255.0 green:41/255.0 blue:41/255.0 alpha:1];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.autoConvertUrlLink = NO;
    self.contentLabel.linkDetectionTypes = KILinkTypeOptionURL;
    [self.contentView addSubview:_contentLabel];
    
    [self initViewConstraints];
}

- (void)setTitle:(NSString *)title{
    if (_title != title) {
        _title = title;
        self.titleLabel.text = title;
        CGFloat width = [title sizeWithMaxHeight:20 font:self.titleLabel.font].width;
        
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
        }];
        
    }
}

- (void)initViewConstraints {
    
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.top.mas_equalTo(self.contentView.mas_top).offset(11);
        make.width.mas_equalTo(40);
        UIFont *font = [UIFont systemFontOfSize:14];
        make.height.mas_equalTo(font.lineHeight);
    }];
    
    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.top.mas_equalTo(self.titleLabel.mas_top);
        make.height.mas_equalTo(20);
    }];
}

-(void)setDetailString:(NSString *)detailString{
    if (_detailString != detailString) {
        _detailString = detailString;
        
        UIFont *titleFont = [UIFont systemFontOfSize:14];
        CGFloat titleWidth = [_title sizeWithMaxHeight:20 font:titleFont].width;
        CGFloat contentWidth = SCREEN_WIDTH - 15 - titleWidth - 20;

        self.contentLabel.text = detailString;
        CGFloat height = [detailString sizeWithMaxWidth:contentWidth font:self.contentLabel.font].height;
        
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
    }
}

+ (CGFloat)cellHeightForTitle:(NSString *)title Content:(NSString *)content {
    UIFont *titleFont = [UIFont systemFontOfSize:14];
    CGFloat titleWidth = [title sizeWithMaxHeight:20 font:titleFont].width;
    CGFloat contentWidth = SCREEN_WIDTH - 15 - titleWidth - 20;
    UIFont *contentFont = [UIFont systemFontOfSize:14];
    CGFloat minHeight = contentFont.lineHeight;
    CGFloat contentHeight = [content sizeWithMaxWidth:contentWidth font:contentFont].height;
    contentHeight = MAX(minHeight, contentHeight);
    CGFloat height = contentHeight + 22;
    return height;
}


@end
