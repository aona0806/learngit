//
//  LJMeetTalkMsgItem.m
//  news
//
//  Created by chunhui on 15/10/8.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMeetTalkMsgItem.h"

@implementation LJMeetTalkMsgItem


-(instancetype)init
{
    self = [super init];
    if (self) {
        _sendState = kMeetMsgSendDone;
        _canShowDelete = NO;
        _audioDownloadState = kMeetAudioDownloadDone;
    }
    return self;
}

@end
