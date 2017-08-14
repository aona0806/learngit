//
//  LJWorkTableViewCell.m
//  news
//
//  Created by 陈龙 on 15/12/18.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJWorkTableViewCell.h"

@interface LJWorkTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *headImageView;

@end

@implementation LJWorkTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        _headImageView = [[UIImageView alloc] initWithFrame: CGRectMake(15, 15, 50, 50)];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 25;
        _headImageView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview: _headImageView];
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.top.mas_equalTo(self.contentView.mas_top).offset(15);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        _titleLabel = [UILabel new];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = @"";
        [self.contentView addSubview: _titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImageView.mas_right).offset(20);
            make.top.mas_equalTo(self.contentView.mas_top).offset(20);
            make.size.mas_equalTo(CGSizeMake(200, 20));
        }];
        
        _detailLabel = [[UILabel alloc] initWithFrame: CGRectMake(85, 45, SCREEN_WIDTH - 100, 20)];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.font = [UIFont systemFontOfSize: 13];
        _detailLabel.textColor = [UIColor lightGrayColor];
        _detailLabel.text = @"";
        [self.contentView addSubview: _detailLabel];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_left);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.height.mas_equalTo(@20);
        }];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 79.5, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = [UIColor colorWithRed:228/255.0f green:228/255.0f blue:228/255.0f alpha:1];
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_left);
            make.top.mas_equalTo(self.detailLabel.mas_bottom).offset(14.5);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.height.mas_equalTo(@0.5);
        }];
        
    }
    return self;
}

- (void)updateInfo:(LJWorkStationDataModel * _Nullable)info
{
    if (info) {
        self.titleLabel.text = info.title;
        NSArray *paramsArray = info.params;
        NSString *infoString = info.intro;
        
        for (NSInteger index = 0; index < paramsArray.count; index ++) {
            NSString *replaceString = [NSString stringWithFormat:@"{%ld}",(long)index + 1];
            infoString = [infoString stringByReplacingOccurrencesOfString:replaceString
                                                               withString:[NSString stringWithFormat:@"%@",paramsArray[index]]];
        }
        
        self.detailLabel.text = infoString;
        NSURL *imageUrl = [LJUrlHelper tryEncode:info.img];
        [self.headImageView sd_setImageWithURL:imageUrl placeholderImage:nil];
    } else {
    }
}

@end
