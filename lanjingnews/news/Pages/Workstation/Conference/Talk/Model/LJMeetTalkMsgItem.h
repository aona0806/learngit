//
//  LJMeetTalkMsgItem.h
//  news
//
//  Created by chunhui on 15/10/8.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJMeetTalkMsgModel.h"

typedef NS_ENUM(NSInteger , LJMeetMsgSendState) {
    kMeetMsgSendDone = 0 ,
    kMeetMsgSending = 1 ,
    kMeetMsgSendFailed = 2,
};
typedef NS_ENUM(NSInteger , LJMeetAudioDownloadState) {
    kMeetAudioDownloadDone = 0,
    kMeetAudioDownloading  = 1,
    kMeetAudioDownloadFailed = 2,
};

typedef NS_ENUM(NSInteger , LJMeetMsgOperate) {
    kMeetMsgSetToQuestion = 0,
};

//typedef NS_ENUM(NSInteger , LJMeetMsgPlayState) {
//    
//};

@interface LJMeetTalkMsgItem : NSObject

@property(nonatomic , strong) LJMeetTalkMsgDataModel *data;
/**
 * 是否是上方显示的讨论
 */
@property(nonatomic , assign) BOOL isHost;

/**
 *  是否显示日期
 */
@property(nonatomic , assign) BOOL showDate;
/**
 *  当为音频时是否显示文字
 */
@property(nonatomic , assign) BOOL showWord;
/**
 *  是否可以显示删除
 */
@property(nonatomic , assign) BOOL canShowDelete;

/**
 *  是否可以设置为问题
 */
@property(nonatomic , assign) BOOL canSetProblem;

@property(nonatomic , assign) BOOL isPlayingAudio;

@property(nonatomic , assign) LJMeetMsgSendState sendState;


@property(nonatomic , assign) LJMeetAudioDownloadState audioDownloadState;

//native audio path
@property(nonatomic , strong) NSString *nativeAudioPath;



@end
