//
//  LJAddressBookSearchTableViewCell.m
//  news
//
//  Created by 陈龙 on 15/12/19.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJAddressBookSearchTableViewCell.h"
#import "news-Swift.h"
#import "NSString+TKSize.h"
#import "LJInterviewUserListConfig.h"

@interface LJAddressBookSearchTableViewCell ()

@property (nonatomic, strong, nonnull) UILabel *titleLabel;
@property (nonatomic, strong, nonnull) UILabel *detailLabel;
@property (nonatomic, strong, nonnull) UILabel *induLabel;

@end

@implementation LJAddressBookSearchTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        LJInterviewUserListConfig *config = [LJInterviewUserListConfig sharedInstance];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLabel = [UILabel new];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize: 16];
        self.titleLabel.numberOfLines = 1;
        self.titleLabel.textColor = config.titleColor;
        [self.contentView addSubview: self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(config.titleHorizontalSpace);
            make.top.mas_equalTo(self.contentView.mas_top).offset(config.titleTopSpace);
            make.width.mas_greaterThanOrEqualTo(@0);
            make.height.mas_equalTo(config.titleFont.lineHeight);
        }];
        
        self.detailLabel = [UILabel new];
        self.detailLabel.backgroundColor = [UIColor clearColor];
        self.detailLabel.font = [UIFont systemFontOfSize: 12];
        self.detailLabel.textColor = config.detailColor;
        self.detailLabel.text = @"";
        self.detailLabel.numberOfLines = 1;
        [self.contentView addSubview: self.detailLabel];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_left);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(config.detailTopSpace);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-config.titleHorizontalSpace);
            make.height.mas_equalTo(config.detailFont.lineHeight);
        }];
        
        self.induLabel = [UILabel new];
        self.induLabel.backgroundColor = [UIColor clearColor];
        self.induLabel.textAlignment = NSTextAlignmentRight;
        self.induLabel.font = [UIFont systemFontOfSize: 12];
        self.induLabel.textColor = [UIColor lightGrayColor];
        self.induLabel.text = @"";
        [self.contentView addSubview: self.induLabel];
        [self.induLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_right).offset(10);
            make.top.mas_equalTo(self.titleLabel.mas_top);
            make.width.mas_greaterThanOrEqualTo(0);
            make.height.mas_equalTo(20);
        }];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = config.seperateLineColor;
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_left);
            make.bottom.mas_equalTo(self.detailLabel.mas_bottom).offset(config.detailButtomSpace);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.height.mas_equalTo(@0.5);
        }];
    }
    return self;
}

- (void)updateInfo:(LJPhoneBookDataDataModel * _Nullable)info
{
    if (info) {
        self.titleLabel.text = info.name;
        NSString *jobString = info.job;
        NSString *companyString = info.company;
        self.detailLabel.text = [NSString stringWithFormat: @"%@   %@",companyString,jobString];
//        NSString *industryString = info.industry;
//        if ([industryString isKindOfClass:[NSNull class]] || !industryString || [industryString isEqualToString: @""])
//        {
//            industryString = 0;
//        }else{
//            industryString = [NSString stringWithFormat: @"%@",industryString];
//        }
//        self.induLabel.text = [GlobalConsts Industry][industryString.integerValue];
        
        self.induLabel.hidden = YES;
        
    }
}

+ (CGFloat)heightForInfo {
    LJInterviewUserListConfig *config = [LJInterviewUserListConfig sharedInstance];

    CGFloat height = config.titleTopSpace + config.titleFont.lineHeight + config.detailTopSpace + config.detailFont.lineHeight + config.detailButtomSpace + 1;
    return height;
}

@end
