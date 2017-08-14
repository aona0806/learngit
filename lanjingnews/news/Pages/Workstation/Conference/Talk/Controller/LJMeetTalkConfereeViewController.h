//
//  LJMeetTalkConfereeViewController.h
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


/*
 * 与会者
 */
@interface LJMeetTalkConfereeViewController : UIViewController

//@property(nonatomic , strong) NSString *meetId;
@property(nonatomic , strong) LJMeetUserInfo *meetUserInfo;
@property(nonatomic , weak)   id<LJMeetExpandProtocol> delegate;
@property(nonatomic , copy)   void (^showOtherUserInfoBlock)(NSString *uid);

-(void)loadData;
/**
 *  设置显示的程度
 *
 *  @param degree 全屏 半屏 最小化
 */
-(void)fullScreen:(LJMeetShowDegree)degree;
-(void)updateBgImage:(UIImage *)image;
/**
 *  显示对话区
 *
 *  @param toTalk yes 滑动到对话 no 滑动到在线
 */
-(void)scrollToTalk:(BOOL)toTalk;
-(void)stopPlayAudio;

-(void)receiveTalkMessage:(IMMessage *)message;
-(void)roleChangeMessage:(RoleChangeMessage *)message;
-(void)onlineStatusChangeMessage:(StatusMessage *)message;
-(void)sendMessage:(NSString *)message;
-(void)sendAudioMessage:(NSString *)filePath duration:(NSTimeInterval)duration;


@end
