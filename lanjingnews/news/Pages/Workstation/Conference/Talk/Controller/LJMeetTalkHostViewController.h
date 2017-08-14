//
//  LJMeetTalkHostViewController.h
//  news
//
//  Created by chunhui on 15/9/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJMeetExpandProtocol.h"
#import "ClientPush.pbobjc.h"
#import "LJMeetUserInfo.h"
#import "Data.pbobjc.h"


@class LJMeetTalkMsgItem;
/*
 * 管理员
 */
@interface LJMeetTalkHostViewController : UIViewController

//@property(nonatomic , strong) NSString *meetId;
@property(nonatomic , strong) LJMeetUserInfo *meetUserInfo;
@property(nonatomic , weak)   id<LJMeetExpandProtocol> delegate;
@property(nonatomic , copy)   void (^showOtherUserInfoBlock)(NSString *uid);
@property(nonatomic , copy)   void (^meetBgLoadDoneBlock)(UIImage *image);

-(void)loadData;

-(void)fullScreen:(LJMeetShowDegree)degree;

-(void)stopPlayAudio;

-(void)scrollToBottom;

/**
 *  接收长连接推送的消息
 *
 *  @param message 接收的消息
 */
-(void)receiveTalkMessage:(IMMessage *)message;
/**
 *  接收音频转换成文字的消息
 *
 *  @param message 接收的消息
 */
-(void)receiveAudioConvertMessage:(PlainTextMessage *)message;

-(void)sendMessage:(NSString *)message;

-(NSURLSessionTask *)sendPic:(UIImage *)pic index:(NSString *)index finish:(void (^)(NSString *result , NSString *error))finish;

-(void)sendAudioMessage:(NSString *)filePath duration:(NSTimeInterval)duration;

-(void)userRoleChanagedWithMessage:(RoleChangeMessage*)message;

@end
