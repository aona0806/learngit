//
//  LJUserNoteSearchTableViewCell.m
//  news
//
//  Created by 陈龙 on 15/12/22.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJUserNoteSearchTableViewCell.h"
#import "NSString+TKSize.h"

@interface LJUserNoteSearchTableViewCell ()

@property (nonatomic, strong, nonnull) UIImageView *headImageView;
@property (nonatomic, strong, nonnull) UIImageView *vipImageView;
@property (nonatomic, strong, nonnull) UILabel *titleLabel;
@property (nonatomic, strong, nonnull) UILabel *detailLabel;

@end

@implementation LJUserNoteSearchTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.headImageView  = [UIImageView new];
        [self.headImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"new_defaultHeader"]];
        self.headImageView.layer.masksToBounds = YES;
        self.headImageView.layer.cornerRadius = 20;
        self.headImageView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview: self.headImageView];
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(10);
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        }];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize: 16];
        self.titleLabel.text = @"";
        self.titleLabel.numberOfLines = 1;
        [self.contentView addSubview: self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImageView.mas_right).offset(10);
            make.top.mas_equalTo(self.contentView.mas_top).offset(10);
            make.width.mas_greaterThanOrEqualTo(0);
            make.height.mas_equalTo(20);
        }];
        
        self.vipImageView = [UIImageView new];
        self.vipImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview: self.vipImageView];
        [self.vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_right).offset(3);
            make.bottom.mas_equalTo(self.titleLabel.mas_bottom).offset(-3);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        
        self.detailLabel = [UILabel new];
        self.detailLabel.backgroundColor = [UIColor clearColor];
        self.detailLabel.font = [UIFont systemFontOfSize: 12];
        self.detailLabel.textColor = [UIColor lightGrayColor];
        self.detailLabel.text = @"";
        self.detailLabel.numberOfLines = 1;
        [self.contentView addSubview: self.detailLabel];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_left);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(2);
            make.right.mas_equalTo(self.contentView.mas_right).offset(10);
            make.height.mas_equalTo(20);
        }];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor colorWithRed:228/255.0f green:228/255.0f blue:228/255.0f alpha:1];
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-0.5);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.height.mas_equalTo(@0.5);
        }];
    }
    return self;
}

- (void)updateInfo:(LJUserPhoneBookDataListModel * _Nullable)info
{
    if (info) {
        NSURL *avatarUrl = [LJUrlHelper tryEncode:info.avatar];
        [self.headImageView sd_setImageWithURL:avatarUrl placeholderImage:[UIImage imageNamed:@"new_defaultHeader"]];
        
        self.titleLabel.text = info.sname;
        CGSize size = [info.sname sizeWithMaxWidth:1000 font:self.titleLabel.font];
        CGFloat width = MIN(size.width + 1, 200);
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
        }];
        
        NSString *jobString = info.companyJob;
        NSString *companyString = info.company;
        self.detailLabel.text = [NSString stringWithFormat: @"%@   %@",companyString,jobString];
        NSString *vipString = [NSString stringWithFormat: @"%@",info.ukind];
        NSString *isVipString = [NSString stringWithFormat: @"%@",info.ukindVerify];

        if ([isVipString isEqualToString: @"1"])
        {
            if ([vipString isEqualToString: @"1"]) {
                _vipImageView.image = [UIImage imageNamed: @"new_yellowVip"];
            }else if ([vipString isEqualToString: @"2"])
            {
                //蓝v表示专家
                _vipImageView.image = [UIImage imageNamed: @"new_blueVip"];
            }else
            {
                _vipImageView.image = nil;
            }
        }else
        {
            _vipImageView.image = nil;
        }
    }
}

@end
