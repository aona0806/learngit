//
//  LYKeyBoardView.m
//  6park
//
//  Created by TI on 15/5/5.
//  Copyright (c) 2015年 6park. All rights reserved.
//

#import "LYKeyBoardView.h"
#import "UIColor+Extension.h"
#import "NSString+Attribute.h"
#import "LYTextView.h"

#define   w_h     51.0f
#define   i_lf    8.0f
#define   i_text_lf 10.0f
#define   i_top   8.0f
#define   i_w_h   25.0f
#define   p_top   13.0f
#define   Fit_Num 16.0f
#define   maxLineCount 3 //最多显示的行数

#define   W_D     ([UIScreen mainScreen].bounds.size.width)
@interface LYKeyBoardView()<UITextViewDelegate,ChatEmojiViewDelegate,ChatOtherIconsViewDelegate,PasteDelegate>
{
    NSArray * icons;
    CGFloat hight_text_one;
    CGFloat end_text_hight;
    
    ChatEmojiView * _emojiView;
    UIView * _audioView;
    ChatOtherIconsView * _otherView;
    
    BOOL  keyBoardTap;
    //音频处理
    CGFloat start_TopH;
    CGFloat end_TopH;
    UIButton * audioBt;
    BOOL audioStatus;
}

@property (nonatomic,strong)UIButton * audio;
@property (nonatomic,strong)UIButton * emoji;
@property (nonatomic,strong)UIButton * other;

@property (nonatomic,strong)KeyBoardAnimationV * bottomView;

@property (nonatomic) BOOL isShowPic;
@property (nonatomic, assign) LYKeyBoardType boardType;

@end

@implementation LYKeyBoardView

#pragma mark - init 初始化
-(instancetype)initDelegate:(id)delegate superView:(UIView *)superView{
    return [self initDelegate:delegate superView:superView type:kLYKeyBoardNormal];
}

-(instancetype)initDelegate:(id)delegate superView:(UIView *)superView andIsShowPic:(BOOL) isShowPic{
    if (self = [super init]) {
        self.boardType = kLYKeyBoardEmojiOnlyRight;
        self.isShowPic = isShowPic;
        [self initUI];
        [self addNotifations];
        [self addToSuperView:superView];
        self.delegate = delegate;
        self.maxInputCount = INT_MAX;
        self.maxValidCount = _maxInputCount;
    }
    return self;
}

-(instancetype)initDelegate:(id)delegate superView:(UIView *)superView type:(LYKeyBoardType)type
{
    if (self = [super init]) {
        self.boardType = type;
        [self initUI];
        [self addNotifations];
        [self addToSuperView:superView];
        self.delegate = delegate;
        self.maxInputCount = INT_MAX;
        self.maxValidCount = _maxInputCount;
    }
    return self;
}

-(void)initUI{
    [self addTopAndBot];
    [self addIcons];
    [self addTextView];
    [self addAudionButton];
    [self initIconsContentView];
}

-(void)updateType:(LYKeyBoardType)type
{
    if (type == _boardType) {
        return;
    }
    _boardType = type;
    
    [self tapAction];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
        for (UIView * v in self.subviews) {
            [v removeFromSuperview];
        }
        [self initUI];
    });
}

-(void)addTopAndBot{
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(-1, 0, W_D + 2, w_h)];
    self.topView.backgroundColor = RGB(250, 250, 250);
    self.topView.layer.borderWidth = 0.7f;
    self.topView.layer.borderColor = RGB(196, 196, 196).CGColor;
    start_TopH = _topView.frame.size.height;
    [self addSubview:self.topView];
    
    self.bottomView = [[KeyBoardAnimationV alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.topView.frame), W_D, ChatEmojiView_Hight)];
    self.bottomView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bottomView];
}

-(void)addIcons{
    
    CGFloat emojiWidth = i_w_h + 10;
    if (_boardType == kLYKeyBoardEmojiOnlyLeft){
        
        CGFloat audioWidth = 0.0f;
        
        self.audio = [[UIButton alloc]initWithFrame:CGRectMake(i_lf, i_top, audioWidth, audioWidth)];
        self.audio.tag = 1;
        self.emoji = [[UIButton alloc]initWithFrame:CGRectMake(i_lf , p_top, emojiWidth, emojiWidth)];
        self.emoji.tag = 2;
        
        self.other = [[UIButton alloc]initWithFrame:CGRectMake(W_D - i_lf - i_w_h, p_top, i_w_h, i_w_h)];
        self.other.tag = 3;
        
        if (!self.isShowPic) {
            self.emoji.frame = CGRectMake( i_lf , p_top, i_w_h, i_w_h);
            self.other.hidden = YES;
        }
        
    }else if (_boardType == kLYKeyBoardAudioAndEmojiLeft) {
        
        self.audio = [[UIButton alloc]initWithFrame:CGRectMake(i_lf, p_top, i_w_h, i_w_h)];
        self.audio.tag = 1;
        self.emoji = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.audio.frame)+i_lf , p_top, i_w_h, i_w_h)];
        self.emoji.tag = 2;
        
        self.other = [[UIButton alloc]initWithFrame:CGRectMake(W_D - i_lf - i_w_h , p_top, i_w_h, i_w_h)];
        self.other.tag = 3;
//        self.other.hidden = YES;
        
    }else{
        
        CGFloat audioWidth = 0.0f;
        self.audio = [[UIButton alloc]initWithFrame:CGRectMake(i_lf, i_top, audioWidth, audioWidth)];
        self.audio.tag = 1;
        self.emoji = [[UIButton alloc]initWithFrame:CGRectMake(W_D - (i_lf + emojiWidth) * 2, p_top, emojiWidth, emojiWidth)];
        self.emoji.tag = 2;
        self.other = [[UIButton alloc]initWithFrame:CGRectMake(W_D - i_lf - i_w_h, p_top, i_w_h, i_w_h)];
        self.other.tag = 3;
        
        
        if (!self.isShowPic) {
            
            self.emoji.frame = CGRectMake(W_D - i_lf - emojiWidth + 5, p_top - (emojiWidth - i_w_h)/2, emojiWidth, emojiWidth);
            self.other.hidden = YES;
        }
    }
    
    [self.audio setBackgroundImage:[UIImage imageNamed:@"keyboard_button_audio"] forState:UIControlStateNormal];
    [self.emoji setImage:[UIImage imageNamed:@"keyboard_keyboard"] forState:UIControlStateSelected];
    [self.emoji setImage:[UIImage imageNamed:@"keyboard_button_face_gray"] forState:UIControlStateNormal];
    [self.other setBackgroundImage:[UIImage imageNamed:@"keyboard_button_add_gray"] forState:UIControlStateNormal];
    
    icons = @[self.audio,self.emoji,self.other];
    for (UIButton * b in icons) {
        [b addTarget:self action:@selector(iconsAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:b];
    }
    

}

-(void)addTextView{
    self.inputText = [[LYTextView alloc]init];
    [_inputText cornerRadius:5.0f];
    _inputText.font = [UIFont systemFontOfSize:16.0];
    _inputText.layer.borderColor = RGB(176, 176, 176).CGColor;
    _inputText.layer.borderWidth = 0.5f;
    _inputText.backgroundColor = [UIColor whiteColor];
    _inputText.delegate = self;
    _inputText.pasteDelegate = self;
    _inputText.returnKeyType = UIReturnKeySend;
    _inputText.enablesReturnKeyAutomatically = YES;
    hight_text_one = [_inputText.layoutManager usedRectForTextContainer:_inputText.textContainer].size.height;
    CGFloat padding_top = Fit_Num / 2;
    _inputText.textContainerInset = UIEdgeInsetsMake(padding_top, 4.5, padding_top, 0);
    
    CGRect frame ;
    if (self.boardType == kLYKeyBoardEmojiOnlyLeft) {
        
        CGFloat left = CGRectGetMaxX(self.emoji.frame)+i_lf;
        frame = CGRectMake(left , i_top, W_D - left - i_text_lf , hight_text_one+ Fit_Num);
        
    }else if(self.boardType == kLYKeyBoardAudioAndEmojiLeft){
        CGFloat left = CGRectGetMaxX(self.emoji.frame)+i_lf;
        frame = CGRectMake(left , i_top, W_D - left * 1.5 - i_text_lf , hight_text_one+ Fit_Num);
    }else{
        
        if (self.isShowPic) {
            frame = CGRectMake(i_text_lf, i_top, W_D - i_w_h * 2 - i_lf * 3 - i_text_lf, hight_text_one + Fit_Num);
        } else {
            frame = CGRectMake(i_text_lf, i_top, W_D - i_w_h - i_lf * 2 - i_text_lf, hight_text_one + Fit_Num);
        }
    }
    
    _inputText.frame = frame;
    [self.topView addSubview:self.inputText];
}

-(void)addAudionButton{
    
    audioBt = [[UIButton alloc]initWithFrame:_inputText.frame];
    [audioBt setTitle:@"按住说话" forState:UIControlStateNormal];
    [audioBt setTitle:@"松开结束" forState:UIControlStateSelected];
    [audioBt setTitleColor:[UIColor Grey] forState:UIControlStateNormal];
    [audioBt cornerRadius:5.0f];
    [audioBt borderWithColor:[UIColor Grey] borderWidth:0.7];
    audioBt.backgroundColor = [UIColor whiteColor];
    
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(audionRecord:)];
    longPress.minimumPressDuration = 0.09;
    [audioBt addGestureRecognizer:longPress];
}

-(void)initIconsContentView{
    _emojiView = [[ChatEmojiView alloc] init];
    _emojiView.delegate = self;
    
    _audioView = [[UIView alloc]init];
    _otherView = [[ChatOtherIconsView alloc]init];
    _otherView.delegate = self;
}

-(void)addNotifations{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardHiden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
}

-(void)addToSuperView:(UIView *)superView{
    CGFloat s_h = ScreenH - 64;
    CGRect frame = CGRectMake(0,s_h - w_h,W_D, s_h);
    self.frame = frame;
    self.backgroundColor = [UIColor whiteColor];
    [superView addSubview:self];
}

#pragma mark - keyBoard button action
-(void)iconsAction:(UIButton*)sender{
    [self audionDispose];
    if (sender.selected) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardView:changeKeyBoardHeight:)]) {
            [self.delegate keyBoardView:self changeKeyBoardHeight:0];
        }
        [self.inputText becomeFirstResponder];
        return;
    }else{
        keyBoardTap = YES;
        [self.inputText resignFirstResponder];
    }
    
    for (UIButton * b in icons) {
        if ([b isEqual:sender]) {
            sender.selected = !sender.selected;
        }else{
            b.selected = NO;
        }
    }
    UIView * visiableView;
    
    switch (sender.tag) {
        case 1://录音
        {
            visiableView = _audioView;
            audioStatus = YES;
            end_TopH = self.topView.bounds.size.height;
            self.inputText.hidden = YES;
            CGRect frame = self.inputText.frame;

            frame.size.height = 35.0f;
            frame.origin.y = self.inputText.center.y - frame.size.height/2;
            audioBt.frame = frame;
            [self.topView addSubview:audioBt];
            frame = self.topView.frame;
            frame.size.height = start_TopH;
            self.topView.frame = frame;
            frame = self.frame;
            frame.origin.y += (end_TopH - start_TopH);
            [self duration:0 EndF:frame];
        }
            break;
        case 2://表情
            visiableView = _emojiView;
            break;
        case 3://其他+
            if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardViewClickImgPic:)]) {
                [self.delegate keyBoardViewClickImgPic:self];
            }
//            visiableView = _otherView;
            break;
        default:
            visiableView = [[UIView alloc]init];
            break;
    }
    [self.bottomView addSubview:visiableView];
    CGRect fram = self.frame;
    fram.origin.y = [UIScreen mainScreen].bounds.size.height - (CGRectGetHeight(visiableView.frame) + self.topView.bounds.size.height) - 64;
    [self duration:DURTAION EndF:fram];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardView:changeKeyBoardHeight:)]) {
        CGFloat height = CGRectGetHeight(visiableView.frame);
        [self.delegate keyBoardView:self changeKeyBoardHeight:height];
    }
}

- (void)audionDispose
{
    if (audioStatus==NO) return;
    audioStatus = NO;
    self.inputText.hidden = NO;
    [audioBt removeFromSuperview];
    CGRect frame = self.topView.frame;
    frame.size.height = end_TopH;
    self.topView.frame = frame;
    frame = self.frame;
    frame.origin.y -= (end_TopH - start_TopH);
    [self duration:0 EndF:frame];
}

-(void)audioButtonActoin:(id)sender
{
    
}

#pragma mark - 系统键盘通知事件
-(void)keyBoardHiden:(NSNotification*)noti{
    if (keyBoardTap==NO) {
        CGRect endF = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat duration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGRect frame = self.frame;
        frame.origin.y = (endF.origin.y - _topView.frame.size.height - 64);
        [self duration:duration EndF:frame];
        
        if ([self.inputText isFirstResponder]) {
            [self.inputText resignFirstResponder];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardView:changeKeyBoardHeight:)]) {
            
            CGFloat height = 0.0f;
            [self.delegate keyBoardView:self changeKeyBoardHeight:height];
        }
    }else{
        keyBoardTap = NO;
    }
}

-(void)keyBoardShow:(NSNotification*)noti{
    CGRect endF = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    if (keyBoardTap==NO) {
        for (UIButton * b in icons) {
            b.selected = NO;
        }
        [self.bottomView addSubview:[UIView new]];
        
        NSTimeInterval duration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        CGRect fram = self.frame;
        fram.origin.y = (endF.origin.y - _topView.frame.size.height - 64);
        [self duration:duration EndF:fram];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardView:changeKeyBoardHeight:)]) {
            
            CGFloat height = endF.size.height;
            [self.delegate keyBoardView:self changeKeyBoardHeight:height];
        }
    }else{
        keyBoardTap = NO;
    }
}

#pragma mark - chat Emoji View Delegate
-(void)chatEmojiViewSelectEmojiIcon:(EmojiObj *)objIcon{
    UIFont *currentFont = [UIFont systemFontOfSize:16];

    
    EmoTaxtAttachment *attach = [[EmoTaxtAttachment alloc] initWithData:nil ofType:nil];
    attach.Top = -3.5;
    attach.image = [UIImage imageNamed:objIcon.emojiImgName];
    NSMutableAttributedString * attributeString =[[NSMutableAttributedString alloc]initWithAttributedString:self.inputText.attributedText];
    NSRange selectedRange = self.inputText.selectedRange;
    if (attach.image && attach.image.size.width > 1.0f) {
        attach.emoName = objIcon.emojiString;
        NSAttributedString *imageAttributeString = [NSAttributedString attributedStringWithAttachment:attach];
        [attributeString replaceCharactersInRange:selectedRange withAttributedString:imageAttributeString];
        
        NSRange range;
        range.location = attributeString.length - 1;
        range.length = 1;
        
//        NSParagraphStyle *paragraph = [NSParagraphStyle defaultParagraphStyle];
//        
//        [attributeString setAttributes:@{NSAttachmentAttributeName:attach, NSFontAttributeName:currentFont, NSBaselineOffsetAttributeName:[NSNumber numberWithInt:0.0], NSParagraphStyleAttributeName:paragraph} range:range];
    }
    self.inputText.attributedText = attributeString;
    NSRange currentRange = NSMakeRange(selectedRange.location + 1, 0);
    self.inputText.selectedRange = currentRange;
    self.inputText.font = currentFont;
    [self textViewChangeText];
}

-(void)chatEmojiViewTouchUpinsideDeleteButton{
    NSRange range = self.inputText.selectedRange;
    NSInteger location = (NSInteger)range.location;
    if (location == 0) {
        return;
    }
    range.location = location-1;
    range.length = 1;
    
    NSMutableAttributedString *attStr = [self.inputText.attributedText mutableCopy];
    [attStr deleteCharactersInRange:range];
    self.inputText.attributedText = attStr;
    self.inputText.selectedRange = range;
    [self textViewChangeText];
}

-(void)chatEmojiViewTouchUpinsideSendButton{
    [self sendMessage];
}

#pragma mark - text View Delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if(![textView hasText] && [text isEqualToString:@""]) {
        return NO;
    }
    if ([text isEqualToString:@"\n"]) {
        [self sendMessage];
        return NO;
    }
    NSMutableString *content = [[NSMutableString alloc]initWithString:textView.text];
    [content replaceCharactersInRange:range withString:text];

    //输入字数超限后提示
    if (content.length>_maxValidCount && self.maxCountBlock) {
        self.maxCountBlock(content.length);
        return NO;
    }
    
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    
    NSString *content = textView.text;
    if (content.length > _maxInputCount) {
        textView.text = [content substringToIndex:_maxInputCount];
        [textView scrollRangeToVisible:NSMakeRange(_maxInputCount-1, 1)];
    }
    [self textViewChangeText];
    
    //输入字数超限后提示
    if (content.length>_maxValidCount && self.maxCountBlock) {
        self.maxCountBlock(content.length);
    }
}


#pragma mark - audio action

-(void)audionRecord:(UILongPressGestureRecognizer*)longPress{
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
        {
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
            switch (status) {
                case AVAuthorizationStatusNotDetermined:
                {
                    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
                        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                            if (granted) {
                                
                            }else {
                                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"无法访问麦克风" message:@"请在iPhone的“设置-隐私-麦克风”中允许访问您的麦克风" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                [alertView show];
                            }
                        }];
                    }
                }
                    break;
                case AVAuthorizationStatusAuthorized:
                    break;
                case AVAuthorizationStatusDenied:
                case AVAuthorizationStatusRestricted:
                {
                    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"无法访问麦克风" message:@"请在iPhone的“设置-隐私-麦克风”中允许访问您的麦克风" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView show];
                }
                    return;
                default:break;
            }
            
            audioBt.selected = YES;
            [audioBt setBackgroundColor:[UIColor LightGrey]];
            for (UIButton * b in icons) {
                b.enabled = NO;
            }
            

            
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            audioBt.selected = NO;
            [audioBt setBackgroundColor:[UIColor whiteColor]];
            for (UIButton * b in icons) {
                b.enabled = YES;
            }
        }
            break;
        default:
            break;
    }
    
    [self audioRuning:longPress];
}



#pragma mark - other logic
-(void)topLayoutSubViewWithH:(CGFloat)hight{
    CGRect frame = self.topView.frame;
    CGFloat diff = hight - frame.size.height;
    frame.size.height = hight;
    self.topView.frame = frame;
    
    frame = self.bottomView.frame;
    frame.origin.y = CGRectGetHeight(self.topView.bounds);
    self.bottomView.frame = frame;
    
    frame = self.frame;
    frame.origin.y -= diff;
    
    [self duration:DURTAION EndF:frame];
}

-(void)duration:(CGFloat)duration EndF:(CGRect)endF{
    [UIView animateWithDuration:duration animations:^{
        keyBoardTap = NO;
        self.frame = endF;
    }];
    [self changeDuration:duration];
}

-(void)sendMessage{
    if (![self.inputText hasText]&&(self.inputText.text.length==0)) {
        return;
    }
    NSString *plainText = self.inputText.plainText;
    //空格处理
    NSString *text = [plainText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (text.length) {
        [self sendMessage:text];
        self.inputText.text = @"";
//        CGFloat top = self.frame.origin.y;
//        CGFloat contentHeight = self.inputText.frame.size.height;
        [self textViewChangeText];
//        if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardView:changeKeyBoardHeight:)]) {
//                        
//            CGFloat height = _emojiView.bounds.size.height;
//            if ([_inputText isFirstResponder]) {
//                height = _otherView.bounds.size.height;
//            }
//            [self.delegate keyBoardView:self changeKeyBoardHeight:height];
//        }
    }else{
        //输入内容为空
        if (self.delegate && [self.delegate  respondsToSelector:@selector(keyBoardView:allSpace:)]) {
            [self.delegate keyBoardView:self allSpace:plainText];
        }
    }
}

#pragma mark - self public api action
-(void)tapAction{
    UIButton * b = [[UIButton alloc] init];
    b.selected = NO;
    [self iconsAction:b];
}

-(void)textViewChangeText{
    
    CGFloat h = [self.inputText.layoutManager usedRectForTextContainer:self.inputText.textContainer].size.height;
    self.inputText.contentSize = CGSizeMake(self.inputText.contentSize.width, h+Fit_Num);
    CGFloat maxLineHeight = hight_text_one*maxLineCount;
    h = h>maxLineHeight?maxLineHeight:h;
    CGRect frame = self.inputText.frame;
    if ( fabs(frame.size.height - (h+Fit_Num)) < 0.5){
        return;
    }
    
    CGFloat diff = self.topView.frame.size.height - self.inputText.frame.size.height;
    frame.size.height = h+Fit_Num;
    self.inputText.frame = frame;
    [self topLayoutSubViewWithH:(frame.size.height+diff)];
    [self.inputText setContentOffset:CGPointZero animated:YES];
}

#pragma mark - self delegate action
-(void)changeDuration:(CGFloat)duration{
    if ([self.delegate respondsToSelector:@selector(keyBoardView:ChangeDuration:)]) {
        [self.delegate keyBoardView:self ChangeDuration:duration];
    }
}

-(void)sendMessage:(NSString*)message{
    if ([self.delegate respondsToSelector:@selector(keyBoardView:sendMessage:)]) {
        [self.delegate keyBoardView:self sendMessage:message];
    }
}

-(void)imagePickerControllerSourceType:(UIImagePickerControllerSourceType)sourceType{
    if ([self.delegate respondsToSelector:@selector(keyBoardView:imgPicType:)]) {
        [self.delegate keyBoardView:self imgPicType:sourceType];
    }
}

-(void)audioRuning:(UILongPressGestureRecognizer*)longPress{
    if ([self.delegate respondsToSelector:@selector(keyBoardView:audioRuning:)]) {
        [self.delegate keyBoardView:self audioRuning:longPress];
    }
}

#pragma mark - PasteDelegate

- (void)VSPaste:(NSString *)text
{
    if (text) {
        UIFont *currentFont = [UIFont systemFontOfSize:16];
        
        NSAttributedString *contentAttributeString = [LYTextView showFace:text WithFont:currentFont imageOffSet:UIOffsetMake(0, -4) lineSpace:0];
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithAttributedString:_inputText.attributedText];
        NSRange range = _inputText.selectedRange;
        range = NSMakeRange(range.location - 1, 1);
        [attributeString replaceCharactersInRange:range withAttributedString:contentAttributeString];
        
        if (attributeString.length > self.maxInputCount) {
            [attributeString replaceCharactersInRange:NSMakeRange(self.maxInputCount - 1, attributeString.length - self.maxInputCount) withString:@""];
        }
        
        if (attributeString.length>_maxValidCount && self.maxCountBlock) {
            
            self.maxCountBlock(attributeString.length);
            
        }
        
        _inputText.attributedText = attributeString;
        
        NSUInteger length = contentAttributeString.length;
        NSRange currentRange = NSMakeRange(range.location + length, 0);
        
        _inputText.selectedRange = currentRange;
        _inputText.font = currentFont;
//        _inputText.enablesReturnKeyAutomatically = NO;
        
        [self textViewChangeText];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
