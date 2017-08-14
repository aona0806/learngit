//
//  LJMeetHostTableViewCell.m
//  news
//
//  Created by chunhui on 15/9/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMeetTalkTableViewCell.h"
#import <Masonry.h>
#import "UIView+Utils.h"
#import "LJMeetVoiceItemView.h"
#import "LJMeetTalkMsgItem.h"
#import "UIImageView+WebCache.h"
#import "TKRequestHandler+MeetTalk.h"
#import "NSDate+Category.h"
#import "LJMeetAudioContentView.h"
#import "PlayerManager.h"
#import "NSAttributedString+TKSize.h"
#import "LJMeetMsgStateView.h"
#import "NSDate+MeetDisplay.h"
#import "news-Swift.h"

extern NSString *kLJMeetShowMenuNotification ;

@interface LJMeetTalkTableViewCell()<ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate>

@property(nonatomic , strong) LJMeetTalkMsgItem *model;
@property(nonatomic , strong) UILabel *dateLabel;
@property(nonatomic , strong) UIImageView *headImageView;
@property(nonatomic , strong) UILabel *tagLabel;
@property(nonatomic , strong) UILabel *nameLabel;
@property(nonatomic , strong) UILabel *companyInfoLabel;//公司职位信息
@property(nonatomic , strong) UIImageView *leftTalkBgView; //左边带角的讨论view
@property(nonatomic , strong) UIImageView *rightTalkBgView;//右边带角的讨论view
@property(nonatomic , strong) UIButton *wordActionButton;
@property(nonatomic , strong) LJMeetMsgStateView *stateView;
@property(nonatomic , strong) LJMeetVoiceItemView *voiceItemView;
@property(nonatomic , strong) UILabel *contentLabel;//内容

@property(nonatomic , strong) LJMeetAudioContentView *audioTextView;//音频转换文字的view

@property(nonatomic , strong) UIImageView *showImageView;//图片

@property(nonatomic , strong) UIMenuController *menuController;

@end

@implementation LJMeetTalkTableViewCell

#define kContentFontSize 14
#define kContentBgWidth  (SCREEN_WIDTH  - 150)
#define kLineSpace       2
#define kWidthRaite      1.5
#define kUIOffset        UIOffsetMake(0, -4)
#define kAudioContentWidth (SCREEN_WIDTH - 55 - 10)
#define kHeadWidth       36

#define kPicMaxHeight (SCREEN_WIDTH/2 - 10)

+(CGFloat)CellHeightForModel:(LJMeetTalkMsgItem *)model
{
    
    CGFloat height = 0;
    if (model.showDate) {
        height += 35;
    }
    height += 25;//25 + 22;//name company

    if ([model.data.mtype integerValue] == kMeetMsgTypeAudio) {
        height += 35;
        
        if(model.data.audioText.length > 0 && model.showWord){
            height += 10;
            height += [LJMeetAudioContentView HeightForContent:model.data.audioText andWidth:kAudioContentWidth];
        }
        
    }else if (model.data.mtype.integerValue == kMeetMsgTypeImage){
        if (model.data.content.length > 0) {
            height += [self getPicSizeWithModel:model].height;
        }
    }else{
        
        CGFloat width = kContentBgWidth;
        UIFont *font = [UIFont systemFontOfSize:kContentFontSize];
        NSMutableAttributedString *content = [model.data.content showWithFont:font imageOffSet:kUIOffset lineSpace:kLineSpace imageWidthRatio:kWidthRaite];
        CGFloat contentHeight = [content sizeWithMaxWidth:width font:font].height;
        if (contentHeight < 30) {
            height += 40;
        }else{
            height += contentHeight + 10;
        }
    }
    
    height += 5;
        
    return height;
}

+ (CGSize)getPicSizeWithModel:(LJMeetTalkMsgItem *)model{
    
    CGFloat picWidth = model.data.width.floatValue;
    CGFloat picHeight = model.data.height.floatValue;
    
    if (picWidth < 0 && picHeight < 0) {
        return CGSizeZero;
    }
    
    CGFloat h = model.data.height.floatValue;
    CGFloat w = model.data.width.floatValue;

    if (picHeight > kPicMaxHeight) {
        h = kPicMaxHeight;
        w = picWidth / picHeight * h;
    }
    
    if (w > kContentBgWidth) {
        w = kContentBgWidth;
        h = picHeight / picWidth * w;
    }
    
    CGSize size = CGSizeMake(w, h);
    
    return size;
}

-(UILabel *)defaultLabel
{
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

-(UILabel *)dateLabel
{
    if (_dateLabel == nil) {
        _dateLabel = [self defaultLabel];
        _dateLabel.layer.cornerRadius = 5;
        _dateLabel.layer.masksToBounds = YES;
        _dateLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _dateLabel.textColor = [UIColor whiteColor];
        _dateLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_dateLabel];
    }
    
    return _dateLabel;
    
}

-(UIImageView *)headImageView
{
    if (_headImageView == nil) {
        
        _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kHeadWidth, kHeadWidth)];
        _headImageView.layer.cornerRadius = kHeadWidth/2;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeadAction)];
        [_headImageView addGestureRecognizer:recognizer];
    }
    
    return _headImageView;
}

-(UILabel *)tagLabel
{
    if (_tagLabel == nil) {
        _tagLabel = [self defaultLabel];
        _tagLabel.font = [UIFont systemFontOfSize:8];
        _tagLabel.layer.cornerRadius = 5;
        _tagLabel.layer.masksToBounds = YES;
    }
    return _tagLabel;
}

-(UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        _nameLabel = [self defaultLabel];
        _nameLabel.font = [UIFont fontWithName:@"Hiragino Sans" size:12];
        
    }
    return _nameLabel;
}

-(UILabel *)companyInfoLabel
{
    if (_companyInfoLabel == nil) {
        _companyInfoLabel = [self defaultLabel];
        _companyInfoLabel.font = [UIFont systemFontOfSize:10];
        _companyInfoLabel.textColor = RGB(0x6e, 0x6e, 0x6e);
    }
    return _companyInfoLabel;
}

-(UILabel *)contentLabel
{
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = [UIFont systemFontOfSize:kContentFontSize];//[UIFont fontWithName:@"Hiragino Sans" size:kContentFontSize];
        _contentLabel.preferredMaxLayoutWidth = kContentBgWidth;
        _contentLabel.numberOfLines = 0;
        
        _contentLabel.textColor = [UIColor whiteColor];                
    }
    return _contentLabel;
}

-(LJMeetVoiceItemView *)voiceItemView
{
    if (_voiceItemView == nil) {
        _voiceItemView = [[LJMeetVoiceItemView alloc]init];
        
        _voiceItemView.backgroundColor = [UIColor clearColor];
        
        [_voiceItemView addTarget:self action:@selector(playSpeechAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceItemView;
}

-(UIImageView *)leftTalkBgView
{
    if (_leftTalkBgView == nil) {
        _leftTalkBgView = [[UIImageView alloc]init];
        UIImage *image = [UIImage imageNamed:@"meet_talk_white_bg"];
        _leftTalkBgView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 13, 10, 7)];
        
        UILongPressGestureRecognizer *recoginzer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(msgLongPressAction:)];
        [_leftTalkBgView addGestureRecognizer:recoginzer];
        
        [self.contentView addSubview:_leftTalkBgView];
        
    }
    return _leftTalkBgView;
}

-(UIImageView *)rightTalkBgView
{
    if (_rightTalkBgView == nil) {
        _rightTalkBgView = [[UIImageView alloc]init];
        UIImage *image = [UIImage imageNamed:@"meet_talk_blue_bg"];
        _rightTalkBgView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(20, 7, 10, 13)];
        
        UILongPressGestureRecognizer *recoginzer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(msgLongPressAction:)];
        [_rightTalkBgView addGestureRecognizer:recoginzer];
        
        [self.contentView addSubview:_rightTalkBgView];
        
    }
    return _rightTalkBgView;
}

-(LJMeetMsgStateView *)stateView
{
    if (_stateView == nil) {
        _stateView = [[LJMeetMsgStateView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        __weak typeof(self) weakSelf = self;
        _stateView.tapBlock = ^{
            if (weakSelf.reloadBlock) {
                weakSelf.reloadBlock(weakSelf.model);
            }
        };
        [self.contentView addSubview:_stateView];
        
        _stateView.backgroundColor = [UIColor clearColor];
    }
    return _stateView;
}

-(UIButton *)wordActionButton
{
    if (_wordActionButton == nil) {
        
        _wordActionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *image = [UIImage imageNamed:@"meet_talk_convert_word"];
        [_wordActionButton setBackgroundImage:image forState:UIControlStateNormal];
        
        image = [UIImage imageNamed:@"meet_talk_convert_word_high"];
        [_wordActionButton setBackgroundImage:image forState:UIControlStateSelected];
        
        [_wordActionButton addTarget:self action:@selector(showAudioContentAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_wordActionButton];
    }
    return _wordActionButton;
}

-(LJMeetAudioContentView *)audioTextView
{
    if (_audioTextView == nil) {
        _audioTextView = [[LJMeetAudioContentView alloc]init];
        [self.contentView addSubview:_audioTextView];
    }
    return _audioTextView;
}

-(UIMenuController *)menuController
{
    if (_menuController == nil) {
        _menuController = [UIMenuController sharedMenuController];
        
        UIMenuItem *item = [[UIMenuItem alloc]initWithTitle:@"设为问题" action:@selector(menuSetToQuesetionAction:)];
//        UIMenuItem *copyItem = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(menuCopyAction:)];
        [_menuController setMenuItems:@[item]];
    }
    return _menuController;
}

-(UIImageView *)showImageView{
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc] init];
        _showImageView.backgroundColor = [UIColor lightGrayColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrgPic)];
        _showImageView.userInteractionEnabled = YES;
        [_showImageView addGestureRecognizer:tap];
    }
    return _showImageView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.tagLabel];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.companyInfoLabel];
        [self.contentView addSubview:self.voiceItemView];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.showImageView];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(menuWillHideNotification:) name:UIMenuControllerWillHideMenuNotification object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - operate
-(void)msgLongPressAction:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {

        UIImageView *bgImageView = nil;
        if (_alignLeft) {
            bgImageView = self.leftTalkBgView;
        }else{
            bgImageView = self.rightTalkBgView;
        }
        //判定进行becomefirstrespondser
        NSDictionary *userInfo = @{@"baseview":bgImageView,@"cell":self};
        [[NSNotificationCenter defaultCenter]postNotificationName:kLJMeetShowMenuNotification object:nil userInfo:userInfo];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //待通知应用完毕
            CGRect showFrame = [self convertRect:bgImageView.frame toView:self.superview];
            [self.menuController setTargetRect:showFrame inView:self.superview];
            [self.menuController setMenuVisible:YES animated:YES];
            [self addTalkBgMask];
        });
    
    }
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(menuSetToQuesetionAction:)){
        if (self.model.canSetProblem) {
            return YES;
        }
        return NO;
    }
    if ( action == @selector(copy:)) {
        return YES;
    }
    return NO;
}

-(void)menuWillHideNotification:(NSNotification *)notification
{
    UIImageView *bgImageView = [self talkBgView];
    bgImageView.layer.mask = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.menuController.menuVisible) {
            self.menuController.menuVisible = YES;
        }
    });
    
}
-(UIImageView *)talkBgView
{
    if (_alignLeft) {
        return self.leftTalkBgView;
    }
    return self.rightTalkBgView;
}

-(void)addTalkBgMask
{
    UIImageView *bgImageView = [self talkBgView];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.backgroundColor = [[UIColor grayColor]CGColor];
    maskLayer.path = [[UIBezierPath bezierPathWithRect:bgImageView.bounds] CGPath];
    maskLayer.opacity = .5;
    bgImageView.layer.mask = maskLayer;
}

-(void)delTalkBgMask
{
    _leftTalkBgView.layer.mask = nil;
    _rightTalkBgView.layer.mask = nil;
}

-(void)menuSetToQuesetionAction:(id)sender
{
    [self delTalkBgMask];
    
    if(self.msgOperateBlock){
        self.msgOperateBlock(self.model,kMeetMsgSetToQuestion);
    }
}

-(void)copy:(id)sender
{
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = self.model.data.content;
    
}
-(void)updateWithModel:(LJMeetTalkMsgItem *)model
{
    self.alignLeft = YES;
    
    self.model = model;
    
    if (model.showDate) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.data.createdt longLongValue]];
        self.dateLabel.text = [date meetTalkMeetDescription];
        [self.dateLabel sizeToFit];
        self.dateLabel.hidden = NO;
    }else{
        self.dateLabel.hidden = YES;
    }
    
    LJMeetTalkMsgDataModel *msg = model.data;
    BOOL isQuestion = NO;
    
    if (model.isHost) {
        //上方
        if ([msg.fromChatting integerValue] > 0) {
            //大于0时是问题
            self.alignLeft = NO;
            isQuestion = YES;
        }else{
            self.alignLeft = YES;
        }
    }else{
        //下方我说的在右边
        if ([model.data.userInfo.uid isEqualToString: [AccountManager sharedInstance].uid ]){
            self.alignLeft = NO;
        }else{
            self.alignLeft = YES;
        }
    }
    
    NSURL *url = [LJUrlHelper tryEncode:msg.userInfo.avatar];
    UIImage *defaultHead = [UIImage imageNamed:@"user_default_head"];
    [self.headImageView sd_setImageWithURL:url placeholderImage:defaultHead];
    
    self.nameLabel.text = msg.userInfo.sname;//[NSString stringWithFormat:@"%@ %@",msg.userInfo.sname,model.data.userInfo.company];
    [self.nameLabel sizeToFit];
    self.companyInfoLabel.text = msg.userInfo.company;
    [self.companyInfoLabel sizeToFit];
    
    NSString *roleName = nil;
    
    UIColor *tagBgColor = nil;
    UIColor *tagTextColor = nil;
    if (isQuestion) {
        roleName = @"提问";
        tagBgColor = [UIColor whiteColor];
        tagTextColor =  [UIColor blackColor];
    }else{
        roleName  = [LJMeetTalkMsgDataModel RoleNameWithType:[msg.role integerValue]];
        if (self.model.isHost &&  roleName.length == 0) {
            roleName = @"观众";
        }
        
        switch ([msg.role integerValue]) {
            case kMeetRoleCreator:
            case kMeetRoleManager:
                tagBgColor = RGB(253, 174, 11);
                tagTextColor = [UIColor whiteColor];
                break;
            case kMeetRoleGuest:
                tagBgColor = RGB(121, 85, 203);
                tagTextColor = [UIColor whiteColor];
                break;
            default:
                tagBgColor = [UIColor whiteColor];
                break;
        }
    }
    
    self.tagLabel.text = roleName;
    
    if (roleName.length > 0) {
        self.tagLabel.backgroundColor = tagBgColor;
        self.tagLabel.textColor = tagTextColor;
        
        [self.tagLabel sizeToFit];
    }else{
        self.tagLabel.width = 0;
    }
    
    _voiceItemView.hidden = YES;
    self.contentLabel.hidden = YES;
    _showImageView.hidden = YES;
    
    switch ([msg.mtype integerValue]) {
        case kMeetMsgTypeText:
        {
            self.contentLabel.attributedText = [msg.content showWithFont:self.contentLabel.font imageOffSet:kUIOffset lineSpace:kLineSpace imageWidthRatio:kWidthRaite];
            self.contentLabel.bounds = CGRectMake(0, 0, kContentBgWidth, 1000000);
            self.contentLabel.preferredMaxLayoutWidth = kContentBgWidth;
            [self.contentLabel sizeToFit];
            [self.contentView bringSubviewToFront:self.contentLabel];
            _contentLabel.hidden = NO;
        }
            break;
        case kMeetMsgTypeAudio:
        {
            self.voiceItemView.duration = msg.audioDuration;
            self.voiceItemView.alignLeft = self.alignLeft;
            [self.contentView bringSubviewToFront:self.voiceItemView];
            [self.voiceItemView playAnimate:model.isPlayingAudio];
            
            _voiceItemView.hidden = NO;
            
            self.voiceItemView.duration = msg.audioDuration;
           
        }
            break;
        case kMeetMsgTypeImage:{
            _showImageView.hidden = NO;
            [_showImageView sd_setImageWithURL:[NSURL URLWithString:model.data.content]];
        }
            break;
        default:
            break;
    }
        
    self.wordActionButton.hidden = (msg.audioText.length == 0);
    
    if (model.showWord && msg.audioText.length > 0) {
        [self.audioTextView setContent:msg.audioText];
        CGSize size  =  [self.audioTextView sizeThatFits:CGSizeMake(kAudioContentWidth, 10000000) ];
        self.audioTextView.size = size;
        self.audioTextView.hidden = NO;
    }else{
        self.audioTextView.hidden = YES;
    }
    
    if (!_wordActionButton.hidden) {
        _wordActionButton.selected = !self.audioTextView.hidden;
    }
    
    self.stateView.hidden = (self.model.sendState == kMeetMsgSendDone && self.model.audioDownloadState == kMeetAudioDownloadDone);
    if (!self.stateView.hidden) {
        if([msg.mtype integerValue] == kMeetMsgTypeAudio){
            self.stateView.downloadState = self.model.audioDownloadState;
        }else{
            self.stateView.sendState = self.model.sendState;
            
        }
    }
    
    if (self.alignLeft) {
        self.rightTalkBgView.hidden = YES;
    }else{
        self.rightTalkBgView.hidden = NO;
    }
    self.leftTalkBgView.hidden = !_rightTalkBgView.hidden;
    
    [self.contentView sendSubviewToBack:self.leftTalkBgView];
    [self.contentView sendSubviewToBack:self.rightTalkBgView];
    
    if (self.alignLeft) {
        self.contentLabel.textColor = [UIColor blackColor];
    }else{
        self.contentLabel.textColor = [UIColor whiteColor];
    }    
    
    self.leftTalkBgView.userInteractionEnabled = YES;//self.model.canSetProblem;
    self.rightTalkBgView.userInteractionEnabled = YES;//self.model.canSetProblem;
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self setNeedsUpdateConstraints];
}


-(CGFloat)audioBgWidth
{
    CGFloat width = 45 + (kContentBgWidth - 45)*([self.model.data.audioDuration floatValue]/60) ;
    return width;
}

-(void)updateConstraints
{
    CGSize tagSize = _tagLabel.size;
    CGSize contentSize = _contentLabel.size;
    CGFloat nameHeight = 15;
    
    if (self.model.showDate) {
        CGSize dateSize = self.dateLabel.size;
        
        [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.dateLabel.superview.mas_centerX);
            make.top.equalTo(self.dateLabel.superview.mas_top).offset(5);
            make.width.equalTo(@(dateSize.width + 20));
            make.height.equalTo(@(20));
        }];
    }
    
    if (_alignLeft) {
        
        [_headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headImageView.superview.mas_left).offset(10);
            if (self.model.showDate) {
                make.top.equalTo(self.dateLabel.mas_bottom).offset(15);
            }else{
                make.top.equalTo(self.headImageView.superview.mas_top).offset(5);
            }
            make.width.equalTo(@(kHeadWidth));
            make.height.equalTo(@(kHeadWidth));
        }];
        
        [_tagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headImageView.mas_right).offset(10);
            make.top.equalTo(_headImageView.mas_top);
            if(tagSize.width > 0){
                make.width.equalTo(@(tagSize.width+10));
                make.height.equalTo(@(tagSize.height+2));
            }else{
                make.width.equalTo(@(0));
                make.height.equalTo(@(0));
            }
        }];
        [_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_tagLabel.mas_right).offset(5);
            if (tagSize.width > 0) {
                make.bottom.equalTo(_tagLabel.mas_bottom);
            }else{
                make.top.equalTo(_headImageView.mas_top);
            }
            make.height.equalTo(@(nameHeight));
        }];
        
        [_companyInfoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel.mas_right).offset(5);
            make.bottom.equalTo(_nameLabel.mas_bottom).offset(-1);
            make.height.equalTo(@(10));
        }];
        
       
        NSInteger type = self.model.data.mtype.integerValue;

        CGSize imgSize = [[self class] getPicSizeWithModel:self.model];
        [self.leftTalkBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headImageView.mas_right).offset(5);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(6);
            
            if (type == kMeetMsgTypeImage) {
                make.size.mas_equalTo(CGSizeMake(imgSize.width + 8, imgSize.height + 2));
                
            }else if (type == kMeetMsgTypeText){
                make.width.equalTo(@(contentSize.width+30));
                if (contentSize.height < 25) {
                    make.height.equalTo(@(35));
                }else{
                    make.height.equalTo(@(contentSize.height+10));
                }
            }else if (type == kMeetMsgTypeAudio){
                make.width.equalTo(@([self audioBgWidth]));
                make.height.equalTo(@(33));
            }
        }];

        if (type == kMeetMsgTypeAudio) {
            [self.voiceItemView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.leftTalkBgView.mas_left).offset(15);
                make.top.equalTo(self.leftTalkBgView.mas_top);
                make.bottom.equalTo(self.leftTalkBgView.mas_bottom);
                make.right.equalTo(self.leftTalkBgView.mas_right).offset(-10);
            }];
        }else if (type == kMeetMsgTypeText){
            [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.leftTalkBgView.mas_left).offset(15);
                make.right.equalTo(self.leftTalkBgView.mas_right).offset(-10);
                make.centerY.equalTo(self.leftTalkBgView.mas_centerY);
                make.height.equalTo(@(contentSize.height));
            }];

        }else if (type == kMeetMsgTypeImage){
            [self.showImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.leftTalkBgView.mas_left).offset(7);
                make.right.equalTo(self.leftTalkBgView.mas_right).offset(-1);
                make.centerY.equalTo(self.leftTalkBgView.mas_centerY);
                make.height.mas_equalTo(imgSize.height);
            }];

        }
        
        
        if (!self.wordActionButton.hidden) {
            [self.wordActionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.leftTalkBgView.mas_right).offset(10);
                make.centerY.equalTo(self.leftTalkBgView.mas_centerY);
                make.width.equalTo(@(25));
                make.height.equalTo(@(26));
            }];
        }
        if (!self.stateView.hidden) {
            [self.stateView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.leftTalkBgView.mas_right).offset(10);
                make.centerY.equalTo(self.leftTalkBgView.mas_centerY);
                make.width.equalTo(@(25));
                make.height.equalTo(@(25));
            }];
        }
        
        
        if (_audioTextView && !_audioTextView.hidden) {
            CGSize audioSize = _audioTextView.size;
            [self.audioTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@(55));
                make.top.equalTo(self.leftTalkBgView.mas_bottom).offset(10);
                make.width.equalTo(@(audioSize.width));
                make.height.equalTo(@(audioSize.height));
            }];
        }
        
    }else{
        
        [_headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_headImageView.superview.mas_right).offset(-10);
            if (self.model.showDate) {
                make.top.equalTo(self.dateLabel.mas_bottom).offset(15);
            }else{
                make.top.equalTo(self.headImageView.superview.mas_top).offset(5);
            }
            make.width.equalTo(@(kHeadWidth));
            make.height.equalTo(@(kHeadWidth));
        }];
        
        
        [_tagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.headImageView.mas_left).offset(-10);
            make.top.equalTo(self.headImageView.mas_top);
            if(tagSize.width > 0){
                make.width.equalTo(@(tagSize.width+10));
                make.height.equalTo(@(tagSize.height+2));
            }else{
                make.width.equalTo(@(0));
                make.height.equalTo(@(0));
            }
        }];
        
        [_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.tagLabel.mas_left).offset(-5);
            if (tagSize.width > 0) {
                make.bottom.equalTo(_tagLabel.mas_bottom);
            }else{
                make.top.equalTo(_headImageView.mas_top);
            }
            make.height.equalTo(@(nameHeight));
        }];
        
        
        [_companyInfoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_nameLabel.mas_left).offset(-2);
            make.bottom.equalTo(_nameLabel.mas_bottom).offset(-1);
            make.height.equalTo(@(10));
        }];
        
        
        [self.rightTalkBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.headImageView.mas_left).offset(-5);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(6);
            if (!self.voiceItemView.hidden) {
                
                make.width.equalTo(@([self audioBgWidth]));
                make.height.equalTo(@(33));
            }else{
                make.width.equalTo(@(contentSize.width+30));
                if (contentSize.height < 25) {
                    make.height.equalTo(@(35));
                }else{
                    make.height.equalTo(@(contentSize.height+10));
                }
            }
        }];
        
        NSInteger type = self.model.data.mtype.integerValue;

        if (type == kMeetMsgTypeAudio) {
            [self.voiceItemView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.rightTalkBgView.mas_left).offset(10);
                make.top.equalTo(self.rightTalkBgView.mas_top);
                make.right.equalTo(self.rightTalkBgView.mas_right).offset(-15);
                make.bottom.equalTo(self.rightTalkBgView.mas_bottom);
            }];
        }else if(type == kMeetMsgTypeText){
            [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.rightTalkBgView.mas_left).offset(10);
                make.right.equalTo(self.rightTalkBgView.mas_right).offset(-15);
                make.centerY.equalTo(self.rightTalkBgView.mas_centerY);
                make.height.equalTo(@(contentSize.height));
            }];
        }
        
        
        if (!self.wordActionButton.hidden) {
            [self.wordActionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.rightTalkBgView.mas_left).offset(-10);
                make.centerY.equalTo(self.rightTalkBgView.mas_centerY);
                make.width.equalTo(@(25));
                make.height.equalTo(@(26));
            }];
        }
        if (!self.stateView.hidden) {
            [self.stateView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.rightTalkBgView.mas_left).offset(-10);
                make.centerY.equalTo(self.rightTalkBgView.mas_centerY);
                make.width.equalTo(@(25));
                make.height.equalTo(@(25));
            }];
        }
        
        
        if (_audioTextView && !_audioTextView.hidden) {
            CGSize audioSize = _audioTextView.size;
            [self.audioTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.rightTalkBgView.mas_bottom).offset(10);
                make.right.equalTo(self.audioTextView.superview.mas_right).offset(-55);
                make.width.equalTo(@(audioSize.width));
                make.height.equalTo(@(audioSize.height));
            }];
        }
    }
    
    [super updateConstraints];
}
/**
 *  显示语音内容
 */
-(void)showAudioContentAction:(UIButton *)button
{
    self.model.showWord = !self.model.showWord;
    if (self.showOrHideAudioWordBlock) {
        self.showOrHideAudioWordBlock(self.model,self);
    }
    
}

-(void)playSpeechAction
{
//    if (self.model.audioDownloadState == kMeetMsgSendDone && self.playSpeech) {
    if (self.playSpeech){
        self.playSpeech(self.model);
    }
}

-(void)tapHeadAction
{
    if (_tapHeadBlock) {
        _tapHeadBlock(self.model);
    }
}

-(void)redownloadAction
{
    if (self.model.audioDownloadState == kMeetAudioDownloadFailed && self.reloadBlock) {
        //
        self.reloadBlock(self.model);
    }
}

- (void)showOrgPic{
    ZLPhotoPickerBrowserViewController *controller = [[ZLPhotoPickerBrowserViewController alloc]init];
//    controller.currentIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    controller.status = UIViewAnimationAnimationStatusZoom;
    controller.delegate = self;
    controller.dataSource = self;
    
    [controller show];
}

#pragma mark - ZLPhotoPickerBrowserViewControllerDelegate
/**
 *  每个组多少个图片
 */
- (NSInteger) photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section
{
    return 1;
}
/**
 *  每个对应的IndexPath展示什么内容
 */
- (ZLPhotoPickerBrowserPhoto *)photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath
{
    ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc]init];
    
    UIImageView *imageView = self.showImageView;
    photo.toView = imageView;
    
    
    NSURL *url = [NSURL URLWithString:self.model.data.content];
    photo.photoURL = url;
    
    photo.photoImage = imageView.highlightedImage;
    photo.thumbImage = imageView.image;
    
    
    return photo;
}

@end
