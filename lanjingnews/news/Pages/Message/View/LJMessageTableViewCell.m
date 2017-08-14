//
//  LJMessageTableViewCell.m
//  news
//
//  Created by 陈龙 on 15/12/20.
//  Copyright (c) 2015年 lanjing. All rights reserved.
//

#import "LJMessageTableViewCell.h"
#import "NSString+Attribute.h"

@interface LJMessageTableViewCell ()

@property (nonatomic, strong, nonnull) UIImageView *leftImg;
@property (nonatomic, strong, nonnull) UILabel *nameLabel;
@property (nonatomic, strong, nonnull) UILabel *contentLabel;
@property (nonatomic, strong, nonnull) UILabel *timeLabel;
@property (nonatomic, strong, nonnull) UIView *hongDianView;
@property (nonatomic, strong, nonnull) UIView *line;

@end

@implementation LJMessageTableViewCell

-(instancetype _Nonnull)initWithMessageStyle:(UITableViewCellStyle)style
                             reuseIdentifier:(NSString * _Nonnull)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.leftImg = [[UIImageView alloc] init];
        self.leftImg.backgroundColor = [UIColor clearColor];
        self.leftImg.layer.cornerRadius = 20;
        self.leftImg.layer.masksToBounds = YES;
        [self.contentView addSubview:self.leftImg];
        [self.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(10);
            make.top.mas_equalTo(self.contentView.mas_top).offset(15);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        self.hongDianView = [[UIView alloc] init];
        self.hongDianView.backgroundColor = RGBA(250, 98, 93, 1);
        self.hongDianView.layer.cornerRadius = 5;
        self.hongDianView.layer.masksToBounds = YES;
        self.hongDianView.hidden = YES;
        [self.contentView addSubview:self.hongDianView];
        [self.hongDianView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftImg.mas_right);
            make.top.mas_equalTo(self.leftImg.mas_top).offset(-3);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];

        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.font = [UIFont systemFontOfSize:11];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.textColor = RGBA(186, 186, 186, 1);
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
            make.top.mas_equalTo(self.leftImg.mas_top);
            make.width.mas_equalTo(@80);
            make.height.mas_equalTo(@16);
        }];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.hongDianView.mas_right).offset(4);
            make.top.mas_equalTo(self.timeLabel.mas_top).offset(-1);
            make.right.mas_equalTo(self.timeLabel.mas_left);
            make.height.mas_equalTo(@20);
        }];
        
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.font = [UIFont systemFontOfSize:14];
        self.contentLabel.textColor = RGBA(153, 153, 153, 1);
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-16);
            make.height.mas_equalTo(@20);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(4);
        }];
        
        self.line = [[UIView alloc] init];
        self.line.backgroundColor = RGBA(230, 229, 234, 1);
        [self.contentView addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(- 0.5);
            make.left.mas_equalTo(self.nameLabel.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.height.mas_equalTo(@0.5);
        }];
    }
    return self;
}

#pragma mark - public

- (void)updateInfo:(MessageData * _Nullable)info {
    
    if (info) {
        
        UIImage *defaultImage = [UIImage imageNamed:@"new_defaultHeader"];
        [self.leftImg sd_setImageWithURL:info.headUrl placeholderImage:defaultImage];
        self.nameLabel.text = info.nameStr;
        NSMutableAttributedString *contentAttributeString = [info.contentStr showWithFont:self.contentLabel.font imageOffSet:UIOffsetMake(0, -5) lineSpace:2 imageWidthRatio:1.3];
        self.contentLabel.attributedText = contentAttributeString;
        self.timeLabel.text = info.timeStr;
        
        if ([info.has_new_msg isEqualToString:@"0"])
        {
            self.hongDianView.hidden = YES;
        }
        else if ([info.has_new_msg isEqualToString:@"1"])
        {
            self.hongDianView.hidden = NO;
        }
    }
}

@end
