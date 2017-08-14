//
//  TelTableViewCell.m
//  news
//
//  Created by Vison_Cui on 15/4/12.
//  Copyright (c) 2015年 lanjing. All rights reserved.
//

#import "LJAddressBookDetailViewCell.h"
#import <NSString+TKSize.h>

@interface LJAddressBookDetailViewCell ()
{
    UIImageView *headImageView;
    UILabel *titleLabel;
    UILabel *timeLabel;
    UILabel *detailLabel;
    UILabel *companyLabel;
}

@property (nonatomic, strong) NSString *uid;

@end

@implementation LJAddressBookDetailViewCell

#define ContentWidth SCREEN_WIDTH - 100

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(tapGesture:)];
        headImageView = [UIImageView new];
        headImageView.image = [UIImage imageNamed:@"new_defaultHeader"];
        headImageView.layer.masksToBounds = YES;
        headImageView.layer.cornerRadius = 3;
        headImageView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview: headImageView];
        headImageView.userInteractionEnabled = YES;
        [headImageView addGestureRecognizer:tapGesture];
        [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(20);
            make.top.mas_equalTo(self.contentView.mas_top).offset(10);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        UITapGestureRecognizer *titleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(tapGesture:)];
        titleLabel = [UILabel new];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize: 13];
        titleLabel.textColor = [UIColor colorWithRed:0/255.0f green:158/255.0f blue:209/255.0f alpha:1];
        titleLabel.userInteractionEnabled = NO;
        [self.contentView addSubview: titleLabel];
        [titleLabel addGestureRecognizer:titleTapGesture];
        titleLabel.userInteractionEnabled = YES;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headImageView.mas_right).offset(10);
            make.top.mas_equalTo(headImageView.mas_top);
            make.height.mas_equalTo(@15);
            make.width.mas_greaterThanOrEqualTo(@0);
        }];
        
        companyLabel = [UILabel new];
        companyLabel.backgroundColor = [UIColor clearColor];
        companyLabel.textColor = [UIColor lightGrayColor];
        companyLabel.font = [UIFont systemFontOfSize: 12];
        [self.contentView addSubview: companyLabel];
        [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_top).offset(0);
            make.left.mas_equalTo(titleLabel.mas_right).offset(10);
            make.height.mas_equalTo(@15);
            make.width.mas_greaterThanOrEqualTo(@0);
        }];
        
        timeLabel = [UILabel new];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textColor = [UIColor lightGrayColor];
        timeLabel.font = [UIFont systemFontOfSize: 12];
        timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview: timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
            make.height.mas_equalTo(@15);
            make.width.mas_equalTo(55);
            make.top.mas_equalTo(companyLabel.mas_top);
        }];
        
        detailLabel = [UILabel new];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.font = [UIFont systemFontOfSize: 13];
        detailLabel.textColor = [UIColor lightGrayColor];
        detailLabel.numberOfLines = 0;
        
        [self.contentView addSubview: detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_left);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(0);
            make.width.mas_equalTo(ContentWidth);
        }];
    }
    return self;
}

#pragma mark - public

+ (CGFloat) heightForCell:(LJPhoneBookFeedBackDataListModel * _Nonnull)info {
    
    CGFloat height = 10 + 15 + 10;
    CGFloat contentHeight = [info.comment sizeWithMaxWidth:ContentWidth font:[UIFont systemFontOfSize: 13]].height;

    height += contentHeight;
    return height;
}

- (void)updateInfo:(LJPhoneBookFeedBackDataListModel * _Nullable)info
{
    if (info) {
        self.uid = info.uid;
        
        NSURL *avatarUrl = [LJUrlHelper tryEncode:info.userinfo.avatar];
        [headImageView sd_setImageWithURL:avatarUrl placeholderImage:[UIImage imageNamed:@"new_defaultHeader"]];
        
        titleLabel.text = info.userinfo.sname;
        [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            CGFloat width = [info.userinfo.sname sizeWithMaxWidth:200 font:titleLabel.font].width;
            make.width.mas_equalTo(width);
        }];
        
        companyLabel.text = info.userinfo.company;
        [companyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            CGFloat width = [info.userinfo.company sizeWithMaxWidth:120 font:titleLabel.font].width;
            make.width.mas_equalTo(width);
        }];
        
        timeLabel.text = info.timeAgo;
        
        detailLabel.text = info.comment;
        [detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            CGFloat height = [info.comment sizeWithMaxWidth:ContentWidth font:detailLabel.font].height;
            make.height.mas_equalTo(height);
        }];

    }
}

#pragma mark - action

- (void)tapGesture:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushToUserDetailWithUid:)]) {
        [self.delegate pushToUserDetailWithUid:self.uid];
    }
}

@end
