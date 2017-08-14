//
//  LJMeetConfereeInfoTableViewCell.m
//  news
//
//  Created by chunhui on 15/9/29.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMeetConfereeInfoTableViewCell.h"
#import "UIColor+Util.h"
#import "UIView+Utils.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "LJMeetTalkMsgModel.h"
#import "news-Swift.h"
#import "LJRelationShip.h"

@interface LJMeetOnlineInfoView : UIControl

@property(nonatomic , strong) UIImageView *iconImageView;
@property(nonatomic , strong) UILabel *titleLabel;

-(instancetype)initWithImage:(UIImage *)image andTitle:(NSString *)title;

@end

@interface LJMeetConfereeInfoTableViewCell ()

@property(nonatomic , strong) LJMeetOnlineUserItem *model;
@property(nonatomic , strong) UIImageView *headImageView;
@property(nonatomic , strong) UILabel *nameLabel;
@property(nonatomic , strong) UIButton *indicator;
@property(nonatomic , strong) UIView *opBgView;
@property(nonatomic , strong) UIView *opTopLineView;
@property(nonatomic , strong) NSMutableArray *opIcons;
@property(nonatomic , strong) UIView *splitLine;//底部分割线

@end

@implementation LJMeetConfereeInfoTableViewCell

+(CGFloat)CellHeightForModel:(LJMeetOnlineUserItem *)model
{
    if (model.showDetail && model.canShowDetail) {
        return 106;
    }
    return 57;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 36, 36)];
        _headImageView.layer.cornerRadius = 18;
        _headImageView.layer.masksToBounds = YES;
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = HexColor(0x333333);
        _nameLabel.font = [UIFont fontWithName:@"Hiragino Sans" size:14];
        
        _headImageView.userInteractionEnabled = YES;
        _nameLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userInfoTap:)];
        [_headImageView addGestureRecognizer:tapRecognizer];
        tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userInfoTap:)];        
        [_nameLabel addGestureRecognizer:tapRecognizer];
        
        
        UIImage *rightImage = [UIImage imageNamed:@"meet_right_arrow"];
        _indicator = [UIButton buttonWithType:UIButtonTypeCustom];
        [_indicator setImage:rightImage forState:UIControlStateNormal];
        [_indicator addTarget:self action:@selector(indicatorTap:) forControlEvents:UIControlEventTouchUpInside];
                
        _splitLine = [[UIView alloc]initWithFrame:CGRectZero];
        _splitLine.backgroundColor = [UIColor colorWithInteger:0xd5d5d5];
        
        [self.contentView addSubview:_headImageView];
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_indicator];
        [self.contentView addSubview:_splitLine];        
        
        self.opIcons = [[NSMutableArray alloc]initWithCapacity:3];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(LJMeetOnlineInfoView *)iconWithImageName:(NSString *)imageName title:(NSString *)title touchSelector:(SEL)selector
{
    UIImage *image = [UIImage imageNamed:imageName];
    LJMeetOnlineInfoView *icon = [[LJMeetOnlineInfoView alloc]initWithImage:image andTitle:title];
    if (selector) {
        [icon addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    
    return icon;
}

-(UIView *)opBgView
{
    if (!_opBgView) {
        _opBgView = [[UIView alloc]initWithFrame:CGRectZero];
        _opBgView.backgroundColor = [UIColor colorWithInteger:0xf5f5f5];
        [self.contentView addSubview:_opBgView];
        
    }
    return _opBgView;
}

-(UIView *)opTopLineView
{
    if (!_opTopLineView) {
        _opTopLineView = [[UIView alloc]initWithFrame:CGRectZero];
        _opTopLineView.backgroundColor = [UIColor colorWithInteger:0xd5d5d5];
    }
    return _opTopLineView;
}

-(void)indicatorTap:(UIGestureRecognizer *)recognizer
{    
    if (_showOrHideDetailBlock) {
        _showOrHideDetailBlock(self.model);
    }
}

-(void)userInfoTap:(UITapGestureRecognizer *)recognizer
{
    if (_showUserInfoBlock) {
        _showUserInfoBlock(self.model);
    }
}


-(void)updateWithModel:(LJMeetOnlineUserItem *)model
{
    self.model = model;
    
    NSURL *url = [LJUrlHelper tryEncode:model.model.userInfo.avatar];
    UIImage *defaultHead = [UIImage imageNamed:@"user_default_head"];
    [self.headImageView sd_setImageWithURL:url placeholderImage:defaultHead];
    
    NSString *name = nil;
    LJMeetRoleType roleType = [model.model.role integerValue];
    if (roleType != kMeetRoleUser && roleType != kMeetRoleInvalid) {
        NSString *roleName = model.model.roleName;
        if (roleType == kMeetRoleCreator || roleType == kMeetRoleManager) {
            //管理员为主持人
            roleName = @"主持人";
        }else if (roleName.length == 0) {
            roleName = [LJMeetTalkMsgDataModel RoleNameWithType:roleType];
        }
        if (roleName.length > 0) {
            name = [NSString stringWithFormat:@"%@ - %@",roleName , model.model.userInfo.sname];
        }else{
            name = model.model.userInfo.sname;
        }
    }else{
        
        name = model.model.userInfo.sname;
    }
    self.nameLabel.text = name;
    
    if (model.canShowDetail) {
        
        if ( model.showDetail) {
            
            self.opBgView.hidden = NO;
            
            for (UIView * v in [self.opBgView subviews]) {
                [v removeFromSuperview];
            }
            [self.opIcons removeAllObjects];
            
            LJRelationFollowType followType = [model.model.userInfo.followType integerValue];
            
            LJMeetOnlineInfoView *icon = nil;
            /**
             *  typedef NS_ENUM(NSInteger , LJRelationFollowType ) {
             LJRelationFollowTypeInvalid = -1 , //无效
             LJRelationFollowTypeNoFollow = 0 ,  //无关注关系
             LJRelationFollowTypeMeFollowOther = 1, //我单向关注他人
             LJRelationFollowTypeEacher = 2 ,       //互相关注
             LJRelationFollowTypeOtherFollowMe = 3  //其他人关注我
             };
             */
            if (followType == LJRelationFollowTypeMeFollowOther || followType == LJRelationFollowTypeEacher ) {
                icon = [self iconWithImageName:@"meet_add_friend" title:@"已加好友" touchSelector:nil];
                icon.enabled = NO;
            }else{
                icon = [self iconWithImageName:@"meet_add_friend" title:@"加为好友" touchSelector:@selector(addFriend)];
            }
            [self.opIcons addObject:icon];
            
            LJMeetRoleType role = [model.model.role integerValue];
            
            if (role != kMeetRoleManager) {
                icon = [self iconWithImageName:@"meet_set_to_admin" title:@"设为主持人" touchSelector:@selector(setToAdmin)];
            }else{
                icon = [self iconWithImageName:@"meet_set_to_admin" title:@"取消主持人" touchSelector:@selector(cancelAdmin)];
                
            }
            [self.opIcons addObject:icon ];
            
            
            if (role == kMeetRoleGuest) {
                icon = [self iconWithImageName:@"meet_set_to_guest" title:@"取消嘉宾" touchSelector:@selector(cancelGuest)];
            }else{
                icon = [self iconWithImageName:@"meet_set_to_guest" title:@"设为嘉宾" touchSelector:@selector(setToGuest)];
            }
            [self.opIcons addObject:icon];
            
            for (icon in self.opIcons) {
                [self.opBgView addSubview:icon];
            }
            [self.opBgView addSubview:self.opTopLineView];
            [self.contentView bringSubviewToFront:self.splitLine];
            
        }else if (_opBgView){
            _opBgView.hidden = YES;
        }
        
        UIImage *image = nil;
        if (self.model.showDetail) {
            image = [UIImage imageNamed:@"meet_down_arrow"];
        }else{
            image = [UIImage imageNamed:@"meet_right_arrow"];
        }
        [self.indicator setImage:image forState:UIControlStateNormal];
        self.indicator.hidden = NO;
    }else{
        _indicator.hidden = YES;
        _opBgView.hidden = YES;
    }
        
    [self setNeedsUpdateConstraints];
}

-(void)updateConstraints
{
    CGFloat detailHeight = 0;
    if (self.model.canShowDetail &&  self.model.showDetail) {
        detailHeight = 49;
    }
    [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10));
        make.centerY.equalTo(self.headImageView.superview.mas_centerY).offset(-detailHeight/2);
        make.width.equalTo(@(36));
        make.height.equalTo(@(36));
    }];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(10);
        make.centerY.equalTo(self.headImageView.mas_centerY);
        make.right.lessThanOrEqualTo(self.nameLabel.superview.mas_right).offset(-10);
        make.height.equalTo(@(20));
    }];
    
    [self.indicator mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.indicator.superview.mas_right).offset(-5);
        make.centerY.equalTo(self.indicator.superview.mas_centerY).offset(-detailHeight/2);
        make.width.equalTo(@(30));
        make.height.equalTo(@(30));
    }];
    
    if (self.model.canShowDetail && self.model.showDetail) {
        if (_opBgView && !_opBgView.hidden) {
            [_opBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_opBgView.superview.mas_left);
                make.right.equalTo(_opBgView.superview.mas_right);
                make.bottom.equalTo(_opBgView.superview.mas_bottom);
                make.height.equalTo(@(detailHeight));
            }];
            
            [_opTopLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_opTopLineView.superview.mas_left);
                make.right.equalTo(_opTopLineView.superview.mas_right);
                make.top.equalTo(_opTopLineView.superview.mas_top);
                make.height.equalTo(@(0.5));
            }];
            
            if ([_opIcons count] > 0) {
                
                CGFloat width = self.width/[_opIcons count];
                CGFloat offset = 0;
                for (LJMeetOnlineInfoView *icon in _opIcons) {
                    [icon mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(@(offset));
                        make.width.equalTo(@(width));
                        make.top.equalTo(@(0));
                        make.bottom.equalTo(icon.superview.mas_bottom);
                    }];
                    offset += width;
                }
            }
        }
    }
    
    UIView *superview = self.splitLine.superview;
    [self.splitLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.bottom.equalTo(superview.mas_bottom);
        make.height.equalTo(@(.5));
    }];
    
    [super updateConstraints];
}


#pragma mark - role op action
-(void)addFriend
{
    [self roleOpAction:kLJMeetRoleAddFriend];
}

-(void)delFriend
{
    [self roleOpAction:kLJMeetRoleDelFriend];
}

-(void)setToAdmin
{
    [self roleOpAction:kLJMeetRoleSetAdmin];
}

-(void)cancelAdmin
{
    [self roleOpAction:kLJMeetRoleCancelAdmin];
}

-(void)setToGuest
{
    [self roleOpAction:kLJMeetRoleSetGuest];
}

-(void)cancelGuest
{
    [self roleOpAction:kLJMeetRoleCancelGuest];
}

-(void)roleOpAction:(LJMeetRoleOperateType)opType
{
    if (_roleOpearteBlock) {
        _roleOpearteBlock(self.model , opType);
    }
}

@end


@implementation LJMeetOnlineInfoView

-(instancetype)initWithImage:(UIImage *)image andTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.iconImageView = [[UIImageView alloc]initWithImage:image];
        self.titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont fontWithName:@"Hiragino Sans" size:12];
        _titleLabel.textColor = HexColor(0x141414);
        
        _titleLabel.text = title;
        [_titleLabel sizeToFit];
        
        [self addSubview:_iconImageView];
        [self addSubview:_titleLabel];
        
        CGRect frame = self.iconImageView.bounds;
        frame.size.width += _titleLabel.width + 10;
        
        self.bounds = frame;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.iconImageView.width + 10 + self.titleLabel.width;
    
    self.iconImageView.left = (self.width - width)/2;
    self.iconImageView.centerY = self.height/2;
    self.titleLabel.left = self.iconImageView.right + 10;
    self.titleLabel.centerY = _iconImageView.centerY;
    
}

@end
