//
//  LJUserDetailTitleMoreTableViewCell.m
//  news
//
//  Created by 陈龙 on 15/12/16.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJUserDetailTitleMoreTableViewCell.h"
#import "NSString+TKSize.h"

@interface LJUserDetailTitleMoreTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation LJUserDetailTitleMoreTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        
    }
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.titleLabel = [UILabel new];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize: 15];
        self.titleLabel.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
        
        CGFloat titleHeight = ceilf(self.titleLabel.font.lineHeight);
        
        
        [self.contentView addSubview: self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@20);
            make.top.mas_equalTo(@15);
            make.width.mas_equalTo(@70);
            make.height.mas_equalTo(titleHeight);
        }];
        
        
        self.detailLabel = [UILabel new];
        self.detailLabel.backgroundColor = [UIColor clearColor];
        self.detailLabel.font = [UIFont systemFontOfSize: 15];
        self.detailLabel.text = @"";
        self.detailLabel.numberOfLines = 0;
        self.detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.detailLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview: self.detailLabel];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_right).offset(20);
            make.top.mas_equalTo(self.titleLabel.mas_top);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH -110, 20));
        }];
        
        self.lineView = [UIView new];
        self.lineView.backgroundColor = RGBA(228, 228, 228, 1);
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_detailLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(0.5);
            make.width.mas_equalTo(SCREEN_WIDTH - 110);
            make.left.mas_equalTo(100);
        }];
    }
    return self;
}

#pragma mark - public

+(CGFloat)cellHeightForTitleInfo:(NSString *)introString
{
//    introString = @"这个是测试数据这个是测试数据这个是测试数据这个是测试数据这个是测试数据";
    CGFloat height = [introString sizeWithMaxWidth:SCREEN_WIDTH - 110
                                              font:[UIFont systemFontOfSize:15]].height;
    height += 15;
    return height > 50 ? height : 50;
}

- (void)updatePersonNoteCell:(NSString *)introString title:(NSString*)title
{
//    introString = @"这个是测试数据这个是测试数据这个是测试数据这个是测试数据这个是测试数据";
    if (title.length > 0) {
        self.titleLabel.text = title;
    }
    
    if (introString && introString.length > 0) {
        _detailLabel.text = introString;
        CGFloat textHeight = [introString sizeWithMaxWidth:SCREEN_WIDTH - 110 font:[UIFont systemFontOfSize:15]].height;
        [_detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(textHeight);
            make.width.mas_equalTo(SCREEN_WIDTH - 110);
            make.left.mas_equalTo(_titleLabel.mas_right).offset(20);
            make.top.mas_equalTo(self.titleLabel.mas_top);
        }];
    }
}

@end
