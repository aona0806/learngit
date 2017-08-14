//
//  TKRequestHandler+MeetTalk.h
//  news
//
//  Created by chunhui on 15/12/25.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"
#import "LJMeetSendModel.h"
#import "LJMeetChangeRoleModel.h"
#import "LJMeetJoinMeetInfoModel.h"
#import "LJMeetOnlineListModel.h"
#import "LJMeetTalkMsgModel.h"
#import "LJMeetUploadAudioModel.h"


typedef NS_ENUM(NSInteger , LJMeetMsgType) {
    kMeetMsgTypeText = 1,
    kMeetMsgTypeImage = 2,
    kMeetMsgTypeAudio = 3,
};

@interface TKRequestHandler (MeetTalk)


/**
 *  获取会议在线列表西西呢
 *
 *  @param meetId 会议id
 *  @param finish 完成会滴
 *
 *  @return 请求对象
 */
-(NSURLSessionTask *)getMeetOnlineListWithMeetingId:(NSString *)meetId
                                             finish:(void (^)(NSURLSessionTask *task , LJMeetOnlineListModel *model, NSError* error))finish;


/**
 *  获取在线会议消息
 *
 *  @param mid        会议id
 *  @param msgId      获取的最后一条消息的id，当开始时为nil
 *  @param isHost     yes 时为上方的管理员消息，no 时为下面的与会者消息
 *  @param complation 执行完成回调block
 *
 *  @return 请求的request
 */
-(NSURLSessionTask *)getMeetMsgWithMeetId:(NSString *)mid msgId:(NSString *)msgId uid:(NSString *)uid isHost:(BOOL)isHost finish:(void (^)(NSURLSessionTask *task , LJMeetTalkMsgModel *model, NSError* error))finish;

/**
 *  发送会议消息
 *
 *  @param mid        会议id
 *  @param uid        用户id
 *  @param content    消息内容
 *  @param type       消息类型
 *  @param duration   当为音频时的时长
 *  @param format     音频格式
 *  @param completion 完成回调
 *
 *  @return 请求request
 */
-(NSURLSessionTask *)postMeetMsgWithMeetId:(NSString *)mid uid:(NSString *)uid msgUUID:(NSString *)uuid content:(NSString *)content type:(LJMeetMsgType)type duration:(NSInteger)duration format:(NSString *)format finish:(void(^)(NSURLSessionTask *task ,LJMeetSendModel *model , NSError *error))finish;


/**
 *  更改与会者角色，由管理员操作
 *
 *  @param meetId     会议id
 *  @param uid        要更改觉得的用户id
 *  @param role       要更改的角色
 *  @param complation 执行完成回调
 *
 *  @return 请求request
 */
-(NSURLSessionTask *)meetChangeRoleWithMeetId:(NSString *)meetId changeUid:(NSString *)uid role:(NSString *)role finish:(void (^)(NSURLSessionTask *task , LJMeetChangeRoleModel *model, NSError* error))finish;

/**
 *  进入会议
 *
 *  @param meetId     会议id
 *  @param completion 请求完成回调
 *
 *  @return 请求实例
 */
-(NSURLSessionTask *)meetJoinMeetWithMeetId:(NSString *)meetId finish:(void (^)(NSURLSessionTask *task , LJMeetJoinMeetInfoModel *model , NSError *error))finish;

/**
 *  退出会议
 *
 *  @param meetId     会议id
 *  @param completion 请求完成回调
 *
 *  @return 请求request实例
 */
-(NSURLSessionTask *)meetQuitMeetWithMeetId:(NSString *)meetId completion:(void(^)( NSError *error))completion;

/**
 *  管理员收集问题
 *
 *  @param meetId     会议id
 *  @param chatId     消息id
 *  @param completion 请求返回的回调
 *
 *  @return 请求的实例
 */
-(NSURLSessionTask *)meetCollectProblemWithMeetId:(NSString *)meetId chatId:(NSString *)chatId completion:(void (^)(NSError *error,NSString *errMsg , NSString *msgId , NSString *chatId ))completion;


/**
 *  上传音频请求
 *
 *  @param filePath   音频文件路径
 *  @param completion 请求完成回调
 *
 *  @return 请求的request
 */
-(NSURLSessionTask *)meetUploadAudio:(NSString *)filePath completion:(void(^)(NSURLSessionTask*task , LJMeetUploadAudioModel *model , NSError *error))completion;

@end
