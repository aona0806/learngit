//
//  LJAddNoteSegmentTableViewCell.m
//  news
//
//  Created by 陈龙 on 15/12/19.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJAddNoteSegmentTableViewCell.h"

@interface LJAddNoteSegmentTableViewCell ()

@property(nonatomic, strong) UIImageView *jiantouIV;
@property(nonatomic, strong) UIButton *totalButton;
@property(nonatomic, strong) UIButton *persionalButton;
@property(nonatomic, strong) UIButton *specialistButton;

@end
@implementation LJAddNoteSegmentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIColor *titleColor = HexColor(0xffffff);
        UIFont *titleFont = [UIFont systemFontOfSize:15];
        self.specialistButton = [UIButton buttonWithType: UIButtonTypeCustom];
        self.specialistButton.backgroundColor = HexColor(0x8fc31f);
        [self.specialistButton setTitle:@"热门专家" forState: UIControlStateNormal];
        [self.specialistButton setTitleColor:titleColor forState:UIControlStateNormal];
        self.specialistButton.titleLabel.font = titleFont;
        [self.specialistButton addTarget: self action:@selector(chooseButtonClick:) forControlEvents: UIControlEventTouchUpInside];
        [self.contentView addSubview:self.specialistButton];
        [self.specialistButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.mas_equalTo(self.contentView);
        }];
        
        self.totalButton = [UIButton buttonWithType: UIButtonTypeCustom];
        self.totalButton.backgroundColor = HexColor(0x0d6494);
        [self.totalButton setTitle:@"全部数据" forState: UIControlStateNormal];
        [self.totalButton addTarget: self action:@selector(chooseButtonClick:)
                   forControlEvents: UIControlEventTouchUpInside];
        [self.totalButton setTitleColor:titleColor forState:UIControlStateNormal];
        self.totalButton.titleLabel.font = titleFont;

        [self.contentView addSubview:self.totalButton];
        [self.totalButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.specialistButton.mas_right);
            make.width.mas_equalTo(self.specialistButton.mas_width);
        }];
        
        self.persionalButton = [UIButton buttonWithType: UIButtonTypeCustom];
        self.persionalButton.backgroundColor = HexColor(0x33c0d0);

        [self.persionalButton setTitle:@"我的数据" forState: UIControlStateNormal];
        [self.persionalButton addTarget: self action:@selector(chooseButtonClick:) forControlEvents: UIControlEventTouchUpInside];
        [self.persionalButton setTitleColor:titleColor forState:UIControlStateNormal];
        self.persionalButton.titleLabel.font = titleFont;

        [self.contentView addSubview:self.persionalButton];
        [self.persionalButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.totalButton.mas_right);
            make.width.mas_equalTo(self.specialistButton.mas_width);
        }];
        
        self.jiantouIV = [[UIImageView alloc] initWithFrame: CGRectMake(SCREEN_WIDTH / 4 - 5.25, 40 - 5.5, 10.5, 5.5)];
        self.jiantouIV.image = [UIImage imageNamed: @"t_arrow_white"];
        self.jiantouIV.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.jiantouIV];
        [self.jiantouIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.centerX.mas_equalTo(self.specialistButton.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(10.5, 5.5));
        }];

    }
    return self;
}

- (void)chooseButtonClick:(UIButton *)button
{
    if (button == self.totalButton) {
        [self.jiantouIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.totalButton.mas_centerX);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(10.5, 5.5));

        }];
    } else if (button == self.specialistButton) {
        [self.jiantouIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.specialistButton.mas_centerX);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(10.5, 5.5));
        }];

    } else {
        [self.jiantouIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.persionalButton.mas_centerX);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(10.5, 5.5));
        }];
    }

    
    if (self.delegate && [self.delegate respondsToSelector:@selector(noteSegmentSelectedWithType:)]) {
        if (button == self.totalButton) {
            [self.delegate noteSegmentSelectedWithType:LJPhoneBookTypeTotal];
        } else if (button == self.specialistButton) {
            [self.delegate noteSegmentSelectedWithType:LJPhoneBookTypeSpecialist];
        } else {
            [self.delegate noteSegmentSelectedWithType:LJPhoneBookTypePersional];
        }
    }
}

@end
