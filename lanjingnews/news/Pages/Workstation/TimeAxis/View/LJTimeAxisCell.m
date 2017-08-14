//
//  LJTimeAxisCell.m
//  news
//
//  Created by 奥那 on 15/12/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJTimeAxisCell.h"
#import "TKCommonTools.h"

#define kTopTitleDefaultColor  [UIColor colorWithRed:89/255.0f green:89/255.0f blue:89/255.0f alpha:1.0f]

@implementation LJTimeAxisCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutMySubViews];
    }
    return self;
}

-(void)setModel:(LJTimeAxisDataListModel *)model{
    if (_model != model) {
        _model = model;
        [self setValueForSubViews];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutMySubViews{
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    self.dateBackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 81, 61)];
    [self.contentView addSubview:self.dateBackView];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 62, 25)];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.font = [UIFont boldSystemFontOfSize:17];
    self.timeLabel.textColor = [UIColor whiteColor];
    [self.dateBackView addSubview:self.timeLabel];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.dateBackView.frame) + 14, 5, SCREEN_WIDTH - CGRectGetMaxX(self.dateBackView.frame) - 14, 28)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = kTopTitleDefaultColor;
    self.titleLabel.text = @"";
    [self.contentView addSubview:self.titleLabel];
    
    UIImageView *locaitonLogo = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.dateBackView.frame) + 16, 38, 5, 8)];
    locaitonLogo.image = [UIImage imageNamed:@"workstation_position"];
    [self.contentView addSubview:locaitonLogo];
    
    self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.dateBackView.frame) + 25, 32, SCREEN_WIDTH - CGRectGetMaxX(self.dateBackView.frame) - 25, 20)];
    self.addressLabel.backgroundColor = [UIColor clearColor];
    self.addressLabel.textColor = RGBA(114, 121, 126, 1);
    self.addressLabel.text = @"";
    self.addressLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview: self.addressLabel];
    
    self.typeLogo = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20, 0, 20, 16)];
    [self.contentView addSubview:self.typeLogo];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 60.5, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = RGBA(235, 235, 235, 1);
    [self.contentView addSubview:lineView];
    
    UIView *verticalLineView = [[UIView alloc] initWithFrame:CGRectMake(81, 10, 1, 41)];
    verticalLineView.backgroundColor = RGBA(235, 235, 235, 1);
    [self.contentView addSubview:verticalLineView];

}

- (void)setValueForSubViews{
    NSString *typeString = _model.type;
    if ([typeString isEqualToString:@"0"])
    {
        self.dateBackView.image = [UIImage imageNamed:@"timeAxis_personal"];
        self.timeLabel.textColor = RGBACOLOR(254, 112, 111, 1);
        self.typeLogo.image = [UIImage imageNamed:@"timeAxis_redicon"];
    }
    else if ([typeString isEqualToString:@"1"])
    {
        self.dateBackView.image = [UIImage imageNamed:@"timeAxis_milestone"];
        self.timeLabel.textColor = RGBACOLOR(36, 138, 213, 1);
        self.typeLogo.image = [UIImage imageNamed:@"timeAxis_blueicon"];
    }
    else if ([typeString isEqualToString:@"2"])
    {
        self.dateBackView.image = [UIImage imageNamed:@"timeAxis_conference"];
        self.timeLabel.textColor = RGBACOLOR(255, 176, 119, 1);
        self.typeLogo.image = [UIImage imageNamed:@"icon_orange"];
    }

    self.titleLabel.text = _model.title;
    
    self.addressLabel.text = _model.address;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_model.timeShow.integerValue];
    
    self.timeLabel.text = [TKCommonTools dateStringWithFormat:TKDateFormatHHMM date:date];
}

@end
