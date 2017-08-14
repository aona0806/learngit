//
//  LJFriendsTableViewCell.m
//  news
//
//  Created by 陈龙 on 15/12/20.
//  Copyright (c) 2015年 lanjing. All rights reserved.
//

#import "LJFriendsTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "news-Swift.h"
#import "TKRequestHandler+Message.h"

@interface LJFriendsTableViewCell ()

@property (nonatomic, strong, nonnull) UIImageView *leftImg;
@property (nonatomic, strong, nonnull) UILabel *nameLabel;
@property (nonatomic, strong, nonnull) UILabel *companyLabel;

@property (nonatomic, strong, nonnull) UIButton *addButton;
@property (nonatomic, strong, nonnull) UILabel *waitLabel;
@property (nonatomic, strong, nonnull) UIButton *acceptButton;

@end

@implementation LJFriendsTableViewCell

#pragma mark - lifcycle
-(instancetype _Nonnull)initWithMessageStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString * _Nonnull)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.leftImg = [[UIImageView alloc] init];
        self.leftImg.backgroundColor = [UIColor clearColor];
        self.leftImg.layer.cornerRadius = 18;
        self.leftImg.layer.masksToBounds = YES;
        [self.contentView addSubview:self.leftImg];
        [self.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(12);
            make.size.mas_equalTo(CGSizeMake(36, 36));
            make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        }];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        self.nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftImg.mas_right).offset(15);
            make.top.mas_equalTo(self.leftImg.mas_top);
            make.height.mas_equalTo(@16);
            make.right.mas_equalTo(@59);
        }];
        
        self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addButton.backgroundColor = [UIColor clearColor];
        [self.addButton setImage:[UIImage imageNamed:@"button_add"] forState:UIControlStateNormal];
        [self.addButton addTarget:self action:@selector(addFriendAciton) forControlEvents:UIControlEventTouchUpInside];
        self.addButton.hidden = YES;
        [self.contentView addSubview:self.addButton];
        [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right);
            make.top.mas_equalTo(self.contentView.mas_top);
            make.size.mas_equalTo(CGSizeMake(67, 51));
        }];
        
        self.waitLabel = [[UILabel alloc] init];
        self.waitLabel.backgroundColor = [UIColor clearColor];
        self.waitLabel.textColor = RGBACOLOR(151, 151, 151, 1);
        self.waitLabel.font = [UIFont systemFontOfSize:11];
        self.waitLabel.textAlignment = NSTextAlignmentRight;
        self.waitLabel.hidden = YES;
        [self.contentView addSubview:self.waitLabel];
        [self.waitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-13);
            make.top.mas_equalTo(@0);
            make.size.mas_equalTo(CGSizeMake(70, 51));
        }];
        
        self.acceptButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.acceptButton.backgroundColor = [UIColor clearColor];
        [self.acceptButton setImage:[UIImage imageNamed:@"button_ok"] forState:UIControlStateNormal];
        [self.acceptButton addTarget:self
                              action:@selector(acceptFriendAciton)
                    forControlEvents:UIControlEventTouchUpInside];
        self.acceptButton.hidden = YES;
        [self.contentView addSubview:self.acceptButton];
        [self.acceptButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(67, 51));
        }];
        
        self.companyLabel = [[UILabel alloc] init];
        self.companyLabel.backgroundColor = [UIColor clearColor];
        self.companyLabel.font = [UIFont systemFontOfSize:12];
        self.companyLabel.textColor = RGBACOLOR(114, 114, 114, 1);
        [self.contentView addSubview:self.companyLabel];
        self.companyLabel.numberOfLines = 1;
        [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel.mas_left);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(2);
            make.right.mas_equalTo(self.waitLabel.mas_left).offset(0);
            make.height.mas_equalTo(@20);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = RGBACOLOR(221, 221, 221, 1);
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(61);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-0.5);
            make.height.mas_equalTo(0.5);
            make.right.mas_equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - private

- (void) setValueForCellAllValueWith:(LJUserFriendDataListModel * _Nonnull)noteData
{
    NSURL *avatarUrl = [LJUrlHelper tryEncode:noteData.avatar];
    [self.leftImg sd_setImageWithURL:avatarUrl];
    
    NSString *isFriendStr = noteData.userRelation.friendType;
    NSString *tipsFriendStr = @"来自手机通讯录";
    NSString *nameStr = [NSString stringWithFormat:@"%@  %@",noteData.sname,tipsFriendStr];
    if ([isFriendStr isEqualToString:@"0"])
    {
        nameStr = [NSString stringWithFormat:@"%@",noteData.sname];
    }
    
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:nameStr];
    NSRange range = [nameStr rangeOfString:tipsFriendStr];
    [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:28/255.0 green:157/255.0 blue:214/255.0 alpha:1] range:range];
    [attriString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:range];
    
    self.nameLabel.attributedText = attriString;
    
    NSString *companyString = [NSString stringWithFormat:@"%@  %@",noteData.company,noteData.companyJob];
    self.companyLabel.text = companyString;
    
    NSInteger followNumber = [noteData.userRelation.followType integerValue];
    switch (followNumber)
    {
        case 0:
            self.addButton.hidden = NO;
            self.waitLabel.hidden = YES;
            self.acceptButton.hidden = YES;
            break;
        case 1:
            self.addButton.hidden = YES;
            self.waitLabel.hidden = NO;
            self.waitLabel.text = @"等待验证";
            self.acceptButton.hidden = YES;
            break;
        case 2:
            self.addButton.hidden = YES;
            self.waitLabel.hidden = NO;
            self.waitLabel.text = @"好友";
            self.acceptButton.hidden = YES;
            break;
        case 3:
            self.addButton.hidden = YES;
            self.waitLabel.hidden = YES;
            self.acceptButton.hidden = NO;
            break;
            
        default:
            break;
    }

}

#pragma mark - download

- (void) fourcesSomebodyWith:(LJUserFriendDataListModel * _Nonnull)noteData
{
    __weak typeof(self) waekSelf = self;
    [[TKRequestHandler sharedInstance] postModifyUserRelation:YES myUid:nil followerUid:noteData.id completion:^(NSURLSessionDataTask *sessionDataTask, LJRelationFollowModel *model, NSError *error) {        
        if (!error) {
            if (model.dErrno.integerValue == 0) {
                if ([noteData.userRelation.followType isEqualToString:@"0"]) {
                    noteData.userRelation.followType = @"1";
                } else if ( [noteData.userRelation.followType isEqualToString:@"3"]) {
                    
                    noteData.userRelation.followType = @"2";
                    
                    NSString *tipsStr = [[[[ConfigManager sharedInstance] config] tips] agreeRelation];
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:tipsStr
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil, nil];
                    [alertView show];
                }
                [waekSelf setValueForCellAllValueWith:noteData];
            }
        }

    }];
}

#pragma mark - action

- (void) addFriendAciton
{
    if (self.delegate && [self.delegate respondsToSelector: @selector(AddFriendsDelegateWithCell:)]) {
        [self.delegate performSelector: @selector(AddFriendsDelegateWithCell:) withObject: self];
    }
}

-(void) acceptFriendAciton
{
    if (self.delegate && [self.delegate respondsToSelector: @selector(AcceptFriendsDelegateWithCell:)]) {
        [self.delegate performSelector: @selector(AcceptFriendsDelegateWithCell:) withObject: self];
    }
}



@end
