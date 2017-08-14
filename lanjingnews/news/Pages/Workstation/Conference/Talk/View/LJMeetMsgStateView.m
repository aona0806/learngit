//
//  LJMeetMsgStateView.m
//  news
//
//  Created by chunhui on 15/10/19.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMeetMsgStateView.h"
#import "UIView+Utils.h"


@interface LJMeetMsgStateView ()

@property(nonatomic , strong) UIActivityIndicatorView *loadingView;
@property(nonatomic , strong) UIImageView *resultImageView;


@end

@implementation LJMeetMsgStateView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.loadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:_loadingView];
        
        UIImage *image = [UIImage imageNamed:@"meet_sendfailed"];
        self.resultImageView = [[UIImageView alloc]initWithImage:image];
        self.resultImageView.frame = CGRectMake(0, 0, 20, 20);
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resultImageTapGestion:)];
        [self.resultImageView addGestureRecognizer:recognizer];
        self.resultImageView.userInteractionEnabled = YES;
        [self addSubview:_resultImageView];
        _resultImageView.hidden = YES;                
    }
    return self;
}


-(void)setSendState:(LJMeetMsgSendState)state
{
    _sendState = state;
    
    switch (state) {
        case kMeetMsgSending:
            self.resultImageView.hidden= YES;
            self.loadingView.hidden = NO;
            [self.loadingView startAnimating];
            break;
        default:
        {
            [self.loadingView stopAnimating];
            self.loadingView.hidden = YES;
            self.resultImageView.hidden = NO;
            //update state image
        }
            break;
    }
    [self setNeedsLayout];
    
}

-(void)setDownloadState:(LJMeetAudioDownloadState)downloadState
{
    _downloadState = downloadState;
    switch (downloadState) {
        case kMeetAudioDownloading:
        {
            self.resultImageView.hidden= YES;
            self.loadingView.hidden = NO;
            [self.loadingView startAnimating];
        }
            break;
        case kMeetAudioDownloadDone:
        {
            [self.loadingView stopAnimating];
            self.loadingView.hidden = YES;
            self.resultImageView.hidden = YES;
        }
            break;
        case kMeetAudioDownloadFailed:
        {
            [self.loadingView stopAnimating];
            self.loadingView.hidden = YES;
            self.resultImageView.hidden = NO;
        }
            break;
        default:
            break;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
     CGPoint center = CGPointMake(self.width/2, self.height/2);
    self.loadingView.center = center;
    self.resultImageView.center = center;
    
}


-(void)resultImageTapGestion:(UITapGestureRecognizer *)recognizer
{
    if (_tapBlock) {
        _tapBlock();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
