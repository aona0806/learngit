//
//  LJUserDetailHeaderTableViewCell.m
//  news
//
//  Created by 陈龙 on 15/12/11.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJUserDetailHeaderTableViewCell.h"
#import "TKRequestHandler+Message.h"
#import "BlocksKit+UIKit.h"
#import "news-Swift.h"


@interface LJUserDetailHeaderTableViewCell ()
{
    UIImageView *littleVImageV;
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *fanSiLabel;
@property (nonatomic, strong) UILabel *jinbiLabel;
@property (nonatomic, strong) UIImageView *vipImageView;

@property (nonatomic, strong) UIButton *moreButton;

@property (nonatomic, strong) LJUserInfoModel *model;

@end

@implementation LJUserDetailHeaderTableViewCell

#pragma mark - lifCycle

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *bgImageView = [UIImageView new];
        bgImageView.image = [UIImage imageNamed: @"background_people_information"];
        [self.contentView addSubview: bgImageView];
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top);
            make.left.mas_equalTo(self.contentView.mas_left);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
        }];
        
        UIView *naviBar = [UIView new];
        naviBar.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview: naviBar];
        [naviBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(20);;
            make.left.right.mas_equalTo(self.contentView);
            make.height.mas_equalTo(@64);
        }];
        
        UIButton *leftButton = [UIButton  buttonWithType: UIButtonTypeCustom];
        leftButton.backgroundColor = [UIColor clearColor];
        [leftButton setImage:[UIImage imageNamed: @"nav_back_white"] forState: UIControlStateNormal];
        [leftButton addTarget: self action:@selector(gobackAction:) forControlEvents:UIControlEventTouchUpInside];
        [naviBar addSubview: leftButton];
        [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(naviBar.mas_top).offset(0);
            make.left.mas_equalTo(naviBar);
            make.size.mas_equalTo(CGSizeMake(60, 44));
        }];
        
        _moreButton = [UIButton buttonWithType: UIButtonTypeCustom];
        _moreButton.backgroundColor = [UIColor clearColor];
        [_moreButton setImage:[UIImage imageNamed: @"button_people_more"] forState: UIControlStateNormal];
        [_moreButton addTarget: self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [naviBar addSubview: _moreButton];
        [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(naviBar.mas_right);
            make.top.mas_equalTo(naviBar.mas_top).offset(10);
            make.size.mas_equalTo(CGSizeMake(60, 44));
        }];

        
        UIView *headView = [UIView new];
        headView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview: headView];
        
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(self.contentView.mas_top).offset(46);
            make.size.mas_equalTo(CGSizeMake(56, 56));
        }];
        
        self.headImageView = [UIImageView new];
        self.headImageView.layer.masksToBounds = YES;
        self.headImageView.backgroundColor = [UIColor lightGrayColor];
        self.headImageView.layer.masksToBounds = YES;
        self.headImageView.layer.cornerRadius = 56/2;
        self.headImageView.layer.shadowRadius = 1;
        self.headImageView.layer.borderWidth = 0.5;
        self.headImageView.userInteractionEnabled = YES;
        self.headImageView.layer.borderColor = [UIColor blackColor].CGColor;
        UITapGestureRecognizer *avatarTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(headButtonClick)];
        [self.headImageView  addGestureRecognizer:avatarTapGesture];
        [headView addSubview: self.headImageView];
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(headView).insets(UIEdgeInsetsZero);
        }];
        
        littleVImageV = [UIImageView new];
        littleVImageV.image = [UIImage imageNamed:@"people_V_circle"];
        littleVImageV.backgroundColor = [UIColor clearColor];
        [headView addSubview:littleVImageV];
        [littleVImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(15, 15));
            make.right.mas_equalTo(self.headImageView.mas_right);
            make.bottom.mas_equalTo(self.headImageView.mas_bottom);
        }];
        
        self.vipImageView = [UIImageView new];
        self.vipImageView.backgroundColor = [UIColor clearColor];
        self.vipImageView.layer.masksToBounds = YES;
        self.vipImageView.layer.cornerRadius = 7.5;
        [littleVImageV addSubview: self.vipImageView];
        [self.vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(littleVImageV.mas_left).offset(3);
            make.top.mas_equalTo(littleVImageV.mas_top).offset(4);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        

        self.titleLabel = [UILabel new];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = @"";
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize: 15];
        [self.contentView addSubview: self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.top.mas_equalTo(headView.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(200, 20));
        }];
        
        UIView *infoView = [UIView new];
        infoView.backgroundColor = [UIColor colorWithRed:32.0/256.0f green:51.0/256.0f blue:71.0/256.0f alpha:1];
        [self.contentView addSubview: infoView];
        [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.contentView);
            make.height.mas_equalTo(@43);
        }];
        
        UIImageView *lineImageView = [UIImageView new];
        lineImageView.backgroundColor = [UIColor whiteColor];
        [infoView addSubview: lineImageView];
        [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(infoView.mas_centerX);
            make.top.mas_equalTo(infoView.mas_top).offset(10);
            make.size.mas_equalTo(CGSizeMake(0.5, 22));
        }];
        
        self.fanSiLabel = [UILabel new];
        self.fanSiLabel.backgroundColor = [UIColor clearColor];
        self.fanSiLabel.textColor = [UIColor whiteColor];
        self.fanSiLabel.text = @"好友   －－";
        self.fanSiLabel.textAlignment = NSTextAlignmentCenter;
        self.fanSiLabel.font = [UIFont systemFontOfSize: 14];
        [infoView addSubview: self.fanSiLabel];
        [self.fanSiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_equalTo(infoView);
            make.right.mas_equalTo(lineImageView.mas_left);
        }];
        
        UIImageView *jinbiImageView = [UIImageView new];
        jinbiImageView.backgroundColor = [UIColor clearColor];
        jinbiImageView.image = [UIImage imageNamed:@"lanjingbi_image"];
        [infoView addSubview: jinbiImageView];
        [jinbiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(lineImageView.mas_right).offset(SCREEN_WIDTH / 4 - 55);
            make.size.mas_equalTo(CGSizeMake(13, 16));
            make.centerY.mas_equalTo(lineImageView.mas_centerY);
        }];
        
        _jinbiLabel = [UILabel new];
        _jinbiLabel.backgroundColor = [UIColor clearColor];
        _jinbiLabel.textColor = [UIColor whiteColor];
        _jinbiLabel.text = @"蓝鲸币 --";
        _jinbiLabel.font = [UIFont systemFontOfSize: 14];
        [infoView addSubview: _jinbiLabel];
        [self.jinbiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(jinbiImageView.mas_right).offset(10);
            make.width.mas_equalTo(@110);
            make.height.mas_equalTo(infoView.mas_height);
            make.centerY.mas_equalTo(infoView.mas_centerY);
        }];
    }
    return self;
}

#pragma mark - public 
-(void)changeTheVipLogoWithVIPString:(NSString *)vipString withGetVip:(NSString *)isVipString
{
    littleVImageV.hidden = NO;
    
    if ([isVipString isEqualToString: @"1"])
    {
        if ([vipString isEqualToString: @"1"]) {
            self.vipImageView.image = [UIImage imageNamed: @"new_yellowVip"];
        }else if ([vipString isEqualToString: @"2"])
        {
            //蓝v表示专家
            self.vipImageView.image = [UIImage imageNamed: @"new_blueVip"];
        }else
        {
            littleVImageV.hidden = YES;
        }
    }else
    {
        littleVImageV.hidden = YES;
    }
}

- (void) updateInfo:(LJUserInfoModel *)info
{
    self.model = info;
    
    NSString *userId = [AccountManager.sharedInstance uid];
    if ([[NSString stringWithFormat:@"%@",userId] isEqualToString: info.uid])
    {
        //如果是自己，就隐藏
        self.moreButton.hidden = YES;
    } else{
        
        NSNumber *myFocusString  = info.userRelation.followType;
        BOOL isFollow = myFocusString.integerValue == 2;
        self.moreButton.hidden = !isFollow;
    }
    
    NSString *vipString = [NSString stringWithFormat: @"%@",info.ukind];
    NSString *isVipString = [NSString stringWithFormat: @"%@",info.ukindVerify];
    [self changeTheVipLogoWithVIPString:vipString withGetVip: isVipString];
    
    self.titleLabel.text = info.sname;
    
    NSString *avatarString = @"";
    if (info.avatar) {
        avatarString = [NSString stringWithFormat:@"%@%@",info.avatar,@"@!thumb0"];
    }
    
    [self.headImageView sd_setImageWithURL:[LJUrlHelper tryEncode:avatarString] placeholderImage:[UIImage imageNamed:@"new_defaultHeader"]];

    //!!!: 默认数据改为"--"
    NSString *friendsNumString = (info.friendsNum == nil) ? @"--" : info.friendsNum.stringValue;
    NSString *goldString = info.friendsNum == nil ? @"--" : info.gold;
    self.fanSiLabel.text = [NSString stringWithFormat: @"好友   %@",friendsNumString];
    self.jinbiLabel.text = [NSString stringWithFormat:@"蓝鲸币 %@",goldString];
}

#pragma mark - private

-(void)headButtonClick
{
    
    if (self.ljDelegate && [self.ljDelegate respondsToSelector:@selector(avatarCheckWithUserDetailHeaderTableViewCell:)]) {
        [self.ljDelegate avatarCheckWithUserDetailHeaderTableViewCell:self];
    }
}

#pragma mark - action

-(void)focusMeButtonClick:(UIButton *)button
{
    NSNumber *followType = self.model.userRelation.followType;
    BOOL isFollow = followType.integerValue == 1 || followType.integerValue == 2;
    
    __weak typeof(self) weakSelf = self;
    
    NSString *myUid = [[AccountManager sharedInstance] uid];
    
    [[TKRequestHandler sharedInstance] postModifyUserRelation:!isFollow myUid:myUid  followerUid:self.model.uid completion:^(NSURLSessionDataTask *sessionDataTask, LJRelationFollowModel *model, NSError *error) {
        
        if (!error) {
            if (model.dErrno.integerValue == 0) {
                
                LJRelationFollowDataModel *relationFollowDataModel = (LJRelationFollowDataModel *)model.data[0];
                if (relationFollowDataModel) {
                    weakSelf.model.userRelation.followType = relationFollowDataModel.type;
                }
                
                if (weakSelf.ljDelegate && [weakSelf.ljDelegate respondsToSelector:@selector(changeTheFocunRelationWithType:userDetailHeaderTableViewCell:)]) {
                    [weakSelf.ljDelegate changeTheFocunRelationWithType:weakSelf.model.userRelation.followType userDetailHeaderTableViewCell:weakSelf];
                }
            }
        }
    }];
}

-(void)gobackAction:(id)sender
{
    if (self.ljDelegate && [self.ljDelegate respondsToSelector:@selector(userDetailHeaderTableViewCellBack)]) {
        [self.ljDelegate userDetailHeaderTableViewCellBack];
    }
}

-(void)moreButtonClick:(UIButton *)button
{
    if (self.ljDelegate && [self.ljDelegate respondsToSelector:@selector(changeRelationTypeWithuserDetailHeaderTableViewCell:)]) {
        [self.ljDelegate changeRelationTypeWithuserDetailHeaderTableViewCell:self];
    }
}

@end
