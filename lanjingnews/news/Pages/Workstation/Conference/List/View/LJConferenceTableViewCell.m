//
//  ConferenceTableViewCell.m
//  news
//
//  Created by 陈龙 on 15/9/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJConferenceTableViewCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"
#import "news-Swift.h"
#import "NSString+TKSize.h"

@interface LJConferenceTableViewCell ()

@property (nonatomic,retain) JSONModel *shareJsonModel;

@property (nonatomic,retain) UIView *superView;
@property (nonatomic,retain) UIView *bottomSuperView;

@property (nonatomic,retain) UIImageView *image;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UILabel *sponsorLabel;
@property (nonatomic,retain) UILabel *timeLabel;

@property (nonatomic,retain) UIImageView *stageImageView;
@property (nonatomic,retain) UIButton *joinAppointmentButton;
@property (nonatomic,retain) UIButton *shareButton;
@property (nonatomic,retain) UIButton *enterConferenceButton;
@property (nonatomic,retain) UILabel *numberLabel;

@property (nonatomic,retain) UIImageView *shadowImageView;

@end

#define TitleFontSize 15
#define SponsorFontSize 11
#define ButtonFontSize 12
#define TitleColor RGB(51, 51, 51)
#define SponsorColor RGB(119, 119, 119)
#define StageButtonColor RGB(153, 153, 153)


@implementation LJConferenceTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self buildCell];
    }
    return self;
}

#pragma mark - private

- (void)buildCell{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    UIView *topSeperateView = [UIView new];
    topSeperateView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:topSeperateView];
    [topSeperateView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.contentView.mas_top);
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(@10);
    }];
    
    self.superView = [UIView new];
    _superView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_superView];
    [_superView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topSeperateView.mas_bottom);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    _image = [[UIImageView alloc] init];
    [_superView addSubview:_image];
    [_image mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_superView).offset(0);
        make.left.mas_equalTo(_superView.mas_left).offset(0);
        make.right.mas_equalTo(_superView.mas_right).offset(0);
        CGFloat imageHeight = (SCREEN_WIDTH - 20.0) * 330 / 710;
        make.height.mas_equalTo(imageHeight);
    }];
    
    _stageImageView = [UIImageView new];
    [_superView addSubview:_stageImageView];
    [_stageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_image.mas_right).offset(0);
        make.top.mas_equalTo(_image.mas_top).offset(10);
        make.height.mas_equalTo(@21);
    }];
    
    self.bottomSuperView = [UIView new];
    self.bottomSuperView.backgroundColor = [UIColor whiteColor];
    [self.superView addSubview:self.bottomSuperView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterConferenceGesture:)];
    [self.bottomSuperView addGestureRecognizer:tapGesture];
    [self.bottomSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.superView);
        make.top.mas_equalTo(self.image.mas_bottom);
        make.bottom.mas_equalTo(self.superView.mas_bottom);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = TitleColor;
    _titleLabel.font = [UIFont boldSystemFontOfSize:TitleFontSize];
    _titleLabel.numberOfLines = 2;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [_bottomSuperView addSubview:_titleLabel];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bottomSuperView.mas_top).offset(10);
        make.left.mas_equalTo(_bottomSuperView.mas_left).offset(12);
        make.right.mas_equalTo(_bottomSuperView.mas_right).offset(-14);
    }];
    
    UILabel *sponsorTitleLabel = [UILabel new];
    sponsorTitleLabel.font = [UIFont systemFontOfSize:SponsorFontSize];
    sponsorTitleLabel.textColor = SponsorColor;
    sponsorTitleLabel.textAlignment = NSTextAlignmentLeft;
    sponsorTitleLabel.numberOfLines = 1;
    NSString *sponsortitleString = @"主办方:";
    sponsorTitleLabel.text = sponsortitleString;
    [_bottomSuperView addSubview:sponsorTitleLabel];
    
    [sponsorTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(11);
        make.left.mas_equalTo(self.titleLabel.mas_left).offset(0);
        make.width.mas_equalTo(@40);
        CGFloat height = [sponsortitleString sizeWithMaxWidth:100 font:[UIFont systemFontOfSize:SponsorFontSize]].height;
        make.height.mas_equalTo(height);
    }];
    
    self.sponsorLabel = [[UILabel alloc] init];
    self.sponsorLabel.font = [UIFont systemFontOfSize:SponsorFontSize];
    self.sponsorLabel.textColor = SponsorColor;
    self.sponsorLabel.textAlignment = NSTextAlignmentLeft;
    self.sponsorLabel.numberOfLines = 2;
    [_bottomSuperView addSubview:self.sponsorLabel];
    [self.sponsorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sponsorTitleLabel.mas_top);
        make.left.mas_equalTo(sponsorTitleLabel.mas_right).offset(0);
        make.right.mas_equalTo(_bottomSuperView.mas_right).offset(-4);
    }];
    
    UILabel *timeTitleLabel = [UILabel new];
    timeTitleLabel.numberOfLines = 1;
    [_bottomSuperView addSubview:timeTitleLabel];
    NSDictionary *timeAttributes = @{ NSForegroundColorAttributeName : SponsorColor,
                                         NSFontAttributeName:[UIFont systemFontOfSize:SponsorFontSize]};
    NSMutableAttributedString *timeTitleString = [[NSMutableAttributedString alloc] initWithString:@"时时间:"
                                                                                           attributes:timeAttributes];
    [timeTitleString addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(1, 1)];
    timeTitleLabel.attributedText = timeTitleString;
    [_bottomSuperView addSubview:timeTitleLabel];

    [timeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sponsorLabel.mas_bottom);
        make.left.mas_equalTo(sponsorTitleLabel.mas_left).offset(0);
        make.width.mas_equalTo(@40);
//        make.bottom.mas_equalTo(self.bottomSuperView.mas_bottom).offset(-10);
    }];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:SponsorFontSize];
    self.timeLabel.textColor = SponsorColor;
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.numberOfLines = 1;
    [_bottomSuperView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeTitleLabel.mas_top);
        make.bottom.mas_equalTo(timeTitleLabel.mas_bottom);
        make.left.mas_equalTo(timeTitleLabel.mas_right).offset(0);
    }];
    
    self.numberLabel = [UILabel new];
    self.numberLabel.font = [UIFont systemFontOfSize:SponsorFontSize];
    self.numberLabel.textColor = SponsorColor;
    self.numberLabel.textAlignment = NSTextAlignmentLeft;
    self.numberLabel.numberOfLines = 2;
    [_bottomSuperView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeTitleLabel.mas_top);
        make.bottom.mas_equalTo(timeTitleLabel.mas_bottom);
        make.left.mas_equalTo(self.timeLabel.mas_right).offset(10);
        make.width.mas_greaterThanOrEqualTo(@0);
    }];
    
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:ButtonFontSize],
                                 NSForegroundColorAttributeName : StageButtonColor,};
    
    self.shareButton = [[UIButton alloc] init];
    self.shareButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    NSAttributedString *shareTitleAttributeString = [[NSAttributedString alloc] initWithString:@"分享" attributes:attributes];
    [self.shareButton setAttributedTitle:shareTitleAttributeString
                                          forState:UIControlStateNormal];
    [self.shareButton setImage:[UIImage imageNamed:@"conference_icon_share"]
                                forState:UIControlStateNormal];
    [_bottomSuperView addSubview:self.shareButton];
    self.shareButton.titleLabel.font = [UIFont systemFontOfSize:ButtonFontSize];
    [self.shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_bottomSuperView.mas_right).offset(-5);
        make.height.mas_equalTo(@20);
        make.top.mas_equalTo(timeTitleLabel.mas_top);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    self.joinAppointmentButton = [[UIButton alloc] init];
    self.joinAppointmentButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    NSAttributedString *joinTitleAttributeString = [[NSAttributedString alloc] initWithString:@"加入预约" attributes:attributes];
    NSAttributedString *cancelTitleAttributeString = [[NSAttributedString alloc] initWithString:@"取消预约" attributes:attributes];
    [self.joinAppointmentButton setAttributedTitle:joinTitleAttributeString
                                          forState:UIControlStateNormal];
    [self.joinAppointmentButton setAttributedTitle:cancelTitleAttributeString
                                          forState:UIControlStateSelected];
    [self.joinAppointmentButton setImage:[UIImage imageNamed:@"conference_list_icon_appointment"]
                                forState:UIControlStateNormal];
    [self.joinAppointmentButton setImage:[UIImage imageNamed:@"conference_list_icon_cancelappointment"]
                                forState:UIControlStateSelected];
    [self.joinAppointmentButton addTarget:self
                                   action:@selector(joinAppointmentAction:)
                         forControlEvents:UIControlEventTouchUpInside];
    [_bottomSuperView addSubview:self.joinAppointmentButton];
    [self.joinAppointmentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.shareButton.mas_top).offset(0);
        make.right.mas_equalTo(self.shareButton.mas_left).offset(-10);
        make.height.mas_equalTo(@20);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    self.enterConferenceButton = [UIButton new];
    [self.enterConferenceButton setImage:[UIImage imageNamed:@"conference_list_icon_join"] forState:UIControlStateNormal];
    self.enterConferenceButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    NSAttributedString *enterTitleAttributeString = [[NSAttributedString alloc] initWithString:@"进入会议"
                                                                                    attributes:attributes];
    [self.enterConferenceButton setAttributedTitle:enterTitleAttributeString forState:UIControlStateNormal];
    self.enterConferenceButton.userInteractionEnabled = NO;
    [_bottomSuperView addSubview:self.enterConferenceButton];
    [self.enterConferenceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_bottomSuperView.mas_right).offset(-5);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_equalTo(@20);
        make.top.mas_equalTo(timeTitleLabel.mas_top);
    }];
    
    
    self.shadowImageView = [UIImageView new];
    self.backgroundColor = [UIColor clearColor];
    self.shadowImageView.hidden = YES;
    [self.shadowImageView setImage:[UIImage imageNamed:@"conference_list_shadowback"]];
    [_superView addSubview:self.shadowImageView];
    [self.shadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_superView);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (float)heightForTheme:(NSString *)themeString
{
    CGFloat themeHeight = [themeString sizeWithMaxWidth:SCREEN_WIDTH - 46 font:[UIFont boldSystemFontOfSize:TitleFontSize]].height;
    themeHeight = themeHeight > 37 ? 37 : themeHeight;
    return themeHeight;
}

- (float)heightForSponsor:(NSString *)string
{
    CGFloat themeHeight = [string sizeWithMaxWidth:SCREEN_WIDTH - 88 font:[UIFont boldSystemFontOfSize:SponsorFontSize] maxLineNum:2].height;
    return themeHeight;
}

#pragma mark - action

- (void)shareAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(share:)]) {
        if (self.shareJsonModel) {
            [self.delegate share:self.shareJsonModel];
        }
    }
}

- (void)joinAppointmentAction:(id)sender
{
    
    JSONModel *model = self.shareJsonModel;
    NSInteger rStatus = 0;
    if ([model isKindOfClass:[LJMeetListDataModel class]]) {
        LJMeetListDataModel *jsonModel = (LJMeetListDataModel *)model;
        rStatus = jsonModel.rStatus.integerValue;
    } else if ([model isKindOfClass:[LJReservationMeetListDataModel class]]) {
        rStatus = 1;
    }
    
    if (rStatus == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(joinAppointment:)]) {
            [self.delegate joinAppointment:self.shareJsonModel];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cancelAppointment:)]) {
            [self.delegate cancelAppointment:self.shareJsonModel];
        }
    }
}

- (void)enterConferenceGesture:(UIGestureRecognizer *)gesture
{
    if (!self.enterConferenceButton.isHidden) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(enterConference:)]) {
            [self.delegate enterConference:self.shareJsonModel];
        }
    }
}

#pragma mark - public

+ (NSString *)reuseIdentifier
{
    return @"ConferenceTableViewCell";
}

+ (CGFloat)heightForCellWithData:(JSONModel * _Nonnull)model
{
    CGFloat imageHeight = (SCREEN_WIDTH - 20.0) * 330 / 710;
    
    NSString *themeString = nil;
    NSString *sponerString = nil;
    long long time = 0;
    if ([model isKindOfClass:[LJMeetListDataModel class]]) {
        LJMeetListDataModel *jsonModel = (LJMeetListDataModel *)model;
        themeString = jsonModel.theme;
        sponerString = jsonModel.sponsor;
        time = [jsonModel.startTime longLongValue];
    } else if ([model isKindOfClass:[LJReservationMeetListDataModel class]]) {
        LJReservationMeetListDataModel *jsonModel = (LJReservationMeetListDataModel *)model;
        themeString = jsonModel.theme;
        sponerString = jsonModel.sponsor;
        time = [jsonModel.startTime longLongValue];
    } else if ([model isKindOfClass:[LJHistoryMeetListDataModel class]]) {
        LJHistoryMeetListDataModel *jsonModel = (LJHistoryMeetListDataModel *)model;
        themeString = jsonModel.theme;
        sponerString = jsonModel.sponsor;
        time = [jsonModel.startTime longLongValue];
    }
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:startDate];
    
    CGFloat themeHeight = [themeString sizeWithMaxWidth:SCREEN_WIDTH - 46 font:[UIFont boldSystemFontOfSize:TitleFontSize]].height;
    themeHeight = themeHeight > 37 ? 37 : themeHeight;
    
    CGFloat sponerHeight = [sponerString sizeWithMaxWidth:SCREEN_WIDTH - 88 font:[UIFont boldSystemFontOfSize:SponsorFontSize]].height;
    sponerHeight = sponerHeight > 27 ? 27 : sponerHeight;
    
    CGFloat timeHeight = [dateString sizeWithMaxWidth:SCREEN_WIDTH - 88 font:[UIFont systemFontOfSize:SponsorFontSize]].height;
    timeHeight = timeHeight > 27 ? 27 : timeHeight;
    
    CGFloat height = 30 + themeHeight + imageHeight + 10 + sponerHeight + timeHeight;
    return height + 10;
}

- (void)updateCellWithData:(JSONModel *)model
{
    self.shareJsonModel = model;
    
    if ([model isKindOfClass:[LJMeetListDataModel class]]) {
        LJMeetListDataModel *jsonModel = (LJMeetListDataModel *)model;
        [self updateHotCellWithData:jsonModel];
    } else if ([model isKindOfClass:[LJReservationMeetListDataModel class]]) {
        LJReservationMeetListDataModel *jsonModel = (LJReservationMeetListDataModel *)model;
        [self updateReservationCellWithData:jsonModel];
    } else if ([model isKindOfClass:[LJHistoryMeetListDataModel class]]) {
        LJHistoryMeetListDataModel *jsonModel = (LJHistoryMeetListDataModel *)model;
        [self updateHistoryCellWithData:jsonModel];
    }
}

/**
 *  更新所有会议列表数据
 *
 *  @param model <#model description#>
 */
- (void)updateHotCellWithData:(LJMeetListDataModel *)model
{
    NSString *stageImageName = @"conference_list_stage_livein";
    NSInteger stage = [model.stage intValue];
    
    UIImage *defaultImage = [UIImage imageNamed:@"default_conference"];
    NSURL *imgUrl = [LJUrlHelper tryEncode:model.img];
    [self.image sd_setImageWithURL:imgUrl placeholderImage:defaultImage];
    self.titleLabel.text = model.theme;
    self.sponsorLabel.text = model.sponsor;
    [self.sponsorLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat height = [self heightForSponsor:model.sponsor];
        make.height.mas_equalTo(height);
    }];
    long long startTime = [model.startTime longLongValue];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:startDate];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",dateString];
    
    self.stageImageView.hidden = NO;
    NSInteger userId = [[AccountManager sharedInstance] uid].integerValue;
    switch (stage) {
        case 0:
            stageImageName = @"conference_list_stage_before";
            
            if (model.uid.integerValue != userId) {
                self.joinAppointmentButton.hidden = NO;
            } else {
                self.joinAppointmentButton.hidden = YES;
            }
            self.shareButton.hidden = NO;
            self.enterConferenceButton.hidden = YES;
            self.numberLabel.hidden = YES;
            BOOL isAppointment = [model.rStatus isEqualToNumber:[NSNumber numberWithInteger:1]];
            self.joinAppointmentButton.selected = isAppointment;
            break;
        case 1:{
            stageImageName = @"conference_list_stage_immediately";
            BOOL isAppointment = [model.rStatus isEqualToNumber:[NSNumber numberWithInteger:1]];
            self.joinAppointmentButton.hidden = YES;
            self.shareButton.hidden = YES;
            self.enterConferenceButton.hidden = NO;
            self.numberLabel.hidden = NO;
            self.numberLabel.text = [NSString stringWithFormat:@"%@人在线",model.online];
            if (!isAppointment) {
                self.joinAppointmentButton.selected = NO;
            } else {
                self.joinAppointmentButton.selected = YES;
            }

            break;
        }
        case 2:{
            stageImageName = @"conference_list_stage_livein";
            self.joinAppointmentButton.hidden = YES;
            self.shareButton.hidden = YES;
            self.enterConferenceButton.hidden = NO;
            self.numberLabel.hidden = NO;
            self.numberLabel.text = [NSString stringWithFormat:@"%@人在线",model.online];
            break;
        }
            
        default:{
            stageImageName = @"conference_list_stage_before";
            BOOL isAppointment = [model.rStatus isEqualToNumber:[NSNumber numberWithInteger:1]];
            if (model.uid.integerValue != userId) {
                self.joinAppointmentButton.hidden = NO;
            } else {
                self.joinAppointmentButton.hidden = YES;
            }
            self.shareButton.hidden = NO;
            self.enterConferenceButton.hidden = YES;
            self.numberLabel.hidden = YES;
            self.joinAppointmentButton.selected = isAppointment;
            break;
        }
            break;
    }
    self.stageImageView.image = [UIImage imageNamed:stageImageName];
}

/**
 *  更新我的预约cell
 *
 *  @param model <#model description#>
 */
- (void)updateReservationCellWithData:(LJReservationMeetListDataModel *)model
{
    NSInteger stage = [model.stage intValue];
    
    UIImage *defaultImage = [UIImage imageNamed:@"default_conference"];
    NSURL *imgUrl = [LJUrlHelper tryEncode:model.img];
    [self.image sd_setImageWithURL:imgUrl placeholderImage:defaultImage];
    self.titleLabel.text = model.theme;
    CGFloat themeHeight = [self heightForTheme:model.theme];
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(themeHeight);
    }];
    
    self.sponsorLabel.text = [NSString stringWithFormat:@"%@",model.sponsor];
    CGFloat sponerHeight = [self heightForSponsor:model.sponsor];
    [self.sponsorLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(sponerHeight);
    }];
    
    long long startTime = [model.startTime longLongValue];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:startDate];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",dateString];
    CGFloat timeHeight = [self heightForSponsor:dateString];
    [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(timeHeight);
    }];
    
    switch (stage) {
        case 0:
            self.stageImageView.hidden = YES;

            self.stageImageView.image = [UIImage imageNamed:@"conference_list_stage_before"];
            
            BOOL isAppointment = YES;
            self.joinAppointmentButton.hidden = NO;
            self.shareButton.hidden = NO;
            self.enterConferenceButton.hidden = YES;
            self.numberLabel.hidden = YES;
            if (!isAppointment) {
                self.joinAppointmentButton.selected = NO;
            } else {
                self.joinAppointmentButton.selected = YES;
            }
            self.shadowImageView.hidden = YES;
            break;
        case 1:{
            self.shadowImageView.hidden = YES;
            self.stageImageView.hidden = NO;

            self.stageImageView.image = [UIImage imageNamed:@"conference_list_stage_immediately"];

            self.joinAppointmentButton.hidden = YES;
            self.shareButton.hidden = YES;
            self.enterConferenceButton.hidden = NO;
            self.numberLabel.hidden = NO;
            self.numberLabel.text = [NSString stringWithFormat:@"%@人在线",model.online];
            break;
        }
        case 2:{
            self.stageImageView.hidden = NO;

            self.stageImageView.image = [UIImage imageNamed:@"conference_list_stage_livein"];

            self.joinAppointmentButton.hidden = YES;
            self.shareButton.hidden = YES;
            self.enterConferenceButton.hidden = NO;
            self.numberLabel.hidden = NO;
            self.numberLabel.text = [NSString stringWithFormat:@"%@人在线",model.online];
            self.shadowImageView.hidden = YES;
            break;
        }
        case 3:{
            self.stageImageView.hidden = NO;

            self.stageImageView.image = [UIImage imageNamed:@"conference_list_stage_besponer"];

            self.joinAppointmentButton.hidden = YES;
            self.shareButton.hidden = NO;
            self.enterConferenceButton.hidden = YES;
            self.numberLabel.hidden = YES;
            self.shadowImageView.hidden = YES;
            break;
        }
        case 4:{
            self.stageImageView.hidden = NO;

            self.stageImageView.image = [UIImage imageNamed:@"conference_list_stage_cancel"];

            BOOL isAppointment = YES;
            self.joinAppointmentButton.hidden = YES;
            self.shareButton.hidden = YES;
            self.enterConferenceButton.hidden = YES;
            self.numberLabel.hidden = YES;
            if (!isAppointment) {
                self.joinAppointmentButton.selected = NO;
            } else {
                self.joinAppointmentButton.selected = YES;
            }
            self.shadowImageView.hidden = NO;
            [self.superView bringSubviewToFront:self.stageImageView];
            break;
        }

        default:{
            self.stageImageView.hidden = YES;
            
            self.stageImageView.image = [UIImage imageNamed:@"conference_list_stage_before"];
            
            BOOL isAppointment = YES;
            self.joinAppointmentButton.hidden = NO;
            self.shareButton.hidden = NO;
            self.enterConferenceButton.hidden = YES;
            self.numberLabel.hidden = YES;
            if (!isAppointment) {
                self.joinAppointmentButton.selected = NO;
            } else {
                self.joinAppointmentButton.selected = YES;
            }
            self.shadowImageView.hidden = YES;
            break;
        }
    }
}

/**
 *  更新历史会议列表数据
 *
 *  @param model <#model description#>
 */
- (void)updateHistoryCellWithData:(LJHistoryMeetListDataModel *)model
{
    NSString *stageImageName = @"conference_list_stage_livein";
    NSInteger stage = [model.myaction intValue];
    
    UIImage *defaultImage = [UIImage imageNamed:@"default_conference"];
    NSURL *imgUrl = [LJUrlHelper tryEncode:model.img];
    [self.image sd_setImageWithURL:imgUrl placeholderImage:defaultImage];
    self.titleLabel.text = model.theme;
    CGFloat themeHeight = [self heightForTheme:model.theme];
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(themeHeight);
    }];
    
    self.sponsorLabel.text = [NSString stringWithFormat:@"%@",model.sponsor];
    CGFloat sponerHeight = [self heightForSponsor:model.sponsor];
    [self.sponsorLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(sponerHeight);
    }];
    
    long long startTime = [model.startTime longLongValue];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:startDate];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",dateString];
    CGFloat timeHeight = [self heightForSponsor:dateString];
    [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(timeHeight);
    }];
    
    self.joinAppointmentButton.hidden = YES;
    self.shareButton.hidden = NO;
    self.numberLabel.hidden = YES;
    self.enterConferenceButton.hidden = YES;
    self.stageImageView.hidden = NO;
    
    switch (stage) {
        case 0:
            stageImageName = @"conference_list_stage_end";
            break;
        case 1:{
            stageImageName = @"conference_list_stage_attended";
            break;
        }
        case 2:{
            stageImageName = @"conference_list_stage_sponsored";
            break;
        }
            
        default:
            stageImageName = @"conference_list_stage_end";
            break;
    }
    self.stageImageView.image = [UIImage imageNamed:stageImageName];
}

@end
