//
//  LJMeetConfereeTableViewCell.m
//  news
//
//  Created by chunhui on 15/9/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMeetConfereeTableViewCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "UIView+Utils.h"
//#import "NSDate+Category.h"
//#import "NSString+SizeUtil.h"
#import "UIColor+Util.h"
#import "NSString+Attribute.h"
#import "NSString+TKSize.h"
#import "NSDate+Category.h"


@interface LJMeetConfereeTableViewCell ()

@property(nonatomic , strong) LJMeetTalkMsgItem *model;
@property(nonatomic , strong) UILabel *dateLabel;
@property(nonatomic , strong) UIImageView *headImageView;
@property(nonatomic , strong) UILabel *nameLabel;
@property(nonatomic , strong) UILabel *contentLabel;
@property(nonatomic , strong) UIView *splitLine;

@end

@implementation LJMeetConfereeTableViewCell

#define  kContentWith CGRectGetWidth([[UIScreen mainScreen]bounds]) -70
#define  kContentFontSize  14
#define kLineSpace       2
#define kWidthRaite      1.05
#define kUIOffset        UIOffsetMake(0, -4)


+(CGFloat)CellHeightForModel:(LJMeetTalkMsgItem *)model
{
    CGFloat height = 0;
    if (model.showDate) {
        height += 53;
    }else{
        height += 10;
    }
    
    height += 22;//name
    CGFloat width = kContentWith;
    UIFont *font = [UIFont systemFontOfSize:kContentFontSize];
    NSMutableAttributedString *content = [model.data.content showWithFont:font imageOffSet:kUIOffset lineSpace:kLineSpace imageWidthRatio:kWidthRaite];
    
    CGFloat contentHeight = [content.string sizeWithMaxWidth:width font:font ].height;
    height += contentHeight;
    
    height += 20;//bottom margin
    
    return height;
}

-(UILabel *)dateLabel
{
    if (_dateLabel == nil) {
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _dateLabel;
}

-(UIImageView *)headImageView
{
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 36, 36)];
        _headImageView.layer.cornerRadius = 18;
        _headImageView.layer.masksToBounds = YES;
        
        [self.contentView addSubview:_headImageView];
        
    }
    return _headImageView;
}

-(UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = HexColor(0x333333);
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

-(UILabel *)contentLabel
{
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:kContentFontSize];
        _contentLabel.preferredMaxLayoutWidth = kContentWith;
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

-(UIView *)splitLine
{
    if (_splitLine == nil) {
        _splitLine = [[UIView alloc] init];
        _splitLine.backgroundColor = [UIColor colorWithInteger:0xd5d5d5];
        
        [self.contentView addSubview:_splitLine];
    }
    return _splitLine;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)updateWithModel:(LJMeetTalkMsgItem *)model
{
    self.model = model;
    LJMeetTalkMsgDataModel *msg =  model.data;
    
    if (model.showDate) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[msg.createdt longLongValue]];
        self.dateLabel.text = [date minuteDescription];
        if (self.dateLabel.superview == nil) {
            [self.contentView addSubview:self.dateLabel];
        }
        self.dateLabel.hidden = NO;
        [_dateLabel sizeToFit];
        CGFloat width = _dateLabel.width;
        _dateLabel.width = width + 20;
    }else{
        self.dateLabel.hidden = YES;
    }
    

    NSURL *url = [LJUrlHelper tryEncode:msg.userInfo.avatar];
    [self.headImageView sd_setImageWithURL:url];
    
    self.nameLabel.text = msg.userInfo.sname;
    self.contentLabel.attributedText = [msg.content showWithFont:self.contentLabel.font imageOffSet:kUIOffset lineSpace:kLineSpace imageWidthRatio:kWidthRaite];
    
    [self.contentLabel sizeToFit];
    
    [self setNeedsUpdateConstraints];
}

-(void)updateConstraints
{
    [super updateConstraints];
    
    if (self.model.showDate) {
        CGFloat width = _dateLabel.width;
        [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dateLabel.superview.mas_top).offset(10);
            make.centerX.equalTo(self.dateLabel.superview.mas_centerX);
            make.height.equalTo(@(18));
            make.width.equalTo(@(width));
        }];
    }
    
    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10));
        
        if (self.model.showDate) {
            //show date
            make.top.equalTo(self.dateLabel.mas_bottom).offset(25);
        }else{
            //or not
            make.top.equalTo(@(10));
        }
        make.width.equalTo(@(36));
        make.height.equalTo(@(36));
        
    }];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.headImageView.mas_top);
        make.left.equalTo(self.headImageView.mas_right).offset(15);
        make.right.lessThanOrEqualTo(self.mas_right).offset(-15);
        make.height.equalTo(@(20));
    }];
    CGFloat contentHeight = self.contentLabel.height;
    
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.right.lessThanOrEqualTo(self.mas_right).offset(-15);
        make.height.equalTo(@(contentHeight));
    }];
    
    [self.splitLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@(0.5));
    }];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

@end

