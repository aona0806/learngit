//
//  LJMeetHostViewModel.h
//  news
//
//  Created by chunhui on 15/9/28.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientPush.pbobjc.h"
#import "LJMeetVoiceManager.h"
#import "LJMeetTalkMsgModel.h"
#import "LJMeetUserInfo.h"
#import "Data.pbobjc.h"


@import UIKit;

extern NSString *const SetToQuestionNotification;
extern NSString *const SetToQuestionState ;
extern NSString *const SetTOQuestionItem  ;


@class LJMeetTalkMsgItem;

@interface LJMeetHostViewModel : NSObject<UITableViewDataSource>

@property(nonatomic , weak) UITableView *tableView;

@property(nonatomic , strong) LJMeetUserInfo *meetUserInfo;
@property(nonatomic , strong) NSString *lastMsgId;//最后一条消息的id
@property(nonatomic , assign) BOOL isHost;//是否是上面管理员区域

@property(nonatomic , strong) LJMeetVoiceManager *speechManager;
@property(nonatomic , copy)   void (^showOtherUserInfoBlock)(NSString *uid);

-(void)loadData;
-(CGFloat)CellHeightFromIndexPath:(NSIndexPath *)indexPath;

-(void)stopPlayAudio;
/**
 *  滑动内容到最下面
 */
-(void)scrollToBottom;

-(void)setToQuestion:(LJMeetTalkMsgDataModel *)model state:(BOOL)isOK;

-(void)receiveTalkMessage:(IMMessage *)message;

-(void)receiveAudioConvertMessage:(PlainTextMessage *)message;
/**
 *  发送文字消息
 *
 *  @param message 消息内容
 */
-(void)sendMessage:(NSString *)message;
/**
 *  发送语音消息
 *
 *  @param filePath 语音路径
 *  @param duration 语音时长
 */
-(void)sendAudioMessage:(NSString *)filePath duration:(NSTimeInterval)duration;

/**
 *  发送图片消息
 *
 *  @param message 消息内容
 */
-(NSURLSessionTask *)sendPic:(UIImage *)pic index:(NSString *)index  finish:(void (^)(NSString *result , NSString *error))finish;


-(void)userRoleChanagedWithMessage:(RoleChangeMessage*)message;

@end
