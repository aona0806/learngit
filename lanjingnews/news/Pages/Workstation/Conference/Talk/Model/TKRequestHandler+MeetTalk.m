//
//  TKRequestHandler+MeetTalk.m
//  news
//
//  Created by chunhui on 15/12/25.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler+MeetTalk.h"
#import "news-Swift.h"


@implementation TKRequestHandler (MeetTalk)


/**
 *  获取会议在线列表西西呢
 *
 *  @param meetId 会议id
 *  @param finish 完成会滴
 *
 *  @return 请求对象
 */
-(NSURLSessionTask *)getMeetOnlineListWithMeetingId:(NSString *)meetId
                                      finish:(void (^)(NSURLSessionTask *task , LJMeetOnlineListModel *model, NSError* error))finish
{
    if (meetId.length == 0) {
        return nil;
    }

    NSDictionary *param = @{@"meeting_id":meetId};

    
    NSString *path = [NSString stringWithFormat: @"%@/v1/meeting_member/get_online",[NetworkManager apiHost]];
    
    return [self getRequestForPath:path param:param jsonName:@"LJMeetOnlineListModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        
        if(finish)
        {
            finish(sessionDataTask,(LJMeetOnlineListModel *)model, error);
        }
    }];
}


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
-(NSURLSessionTask *)getMeetMsgWithMeetId:(NSString *)mid msgId:(NSString *)msgId uid:(NSString *)uid isHost:(BOOL)isHost finish:(void (^)(NSURLSessionTask *task , LJMeetTalkMsgModel *model, NSError* error))finish
{
    if (mid.length == 0 || uid.length == 0) {
        return nil;
    }
    NSDictionary *param = @{@"meeting_id":mid , @"msg_id":msgId.length==0?@"0":msgId,@"uid": uid.length == 0 ?@"0":uid,@"type":isHost?@"msg":@"chatting"};
    
    NSString *path = [NSString stringWithFormat:@"%@/v1/meeting_message/get",[NetworkManager apiHost]];
    
    return [self getRequestForPath:path param:param jsonName:@"LJMeetTalkMsgModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        
        if (finish) {
            finish( sessionDataTask,(LJMeetTalkMsgModel *)model,error);
        }
    }];
}


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
-(NSURLSessionTask *)postMeetMsgWithMeetId:(NSString *)mid uid:(NSString *)uid msgUUID:(NSString *)uuid content:(NSString *)content type:(LJMeetMsgType)type duration:(NSInteger)duration format:(NSString *)format finish:(void(^)(NSURLSessionTask *task ,LJMeetSendModel *model , NSError *error))finish
{
    if (mid.length == 0 || uid.length == 0 || uuid.length == 0) {
        return nil;
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:mid forKey:@"meeting_id"];
    [param setObject:uid forKey:@"uid"];
    [param setObject:uuid forKey:@"uuid"];
    if (content.length > 0) {
        [param setObject:content forKey:@"content"];
    }
    [param setObject:@(type).description forKey:@"mtype"];
    if (duration > 0) {
        [param setObject:@(duration).description forKey:@"duration"];
    }
    if (format.length > 0) {
        [param setObject:format?:@"" forKey:@"format"];
    }
    
    
    NSString *path = [NSString stringWithFormat:@"%@/v1/meeting_message/send",[NetworkManager  apiHost]];
    
    return [self postRequestForPath:path param:param jsonName:@"LJMeetSendModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask,(LJMeetSendModel *)model,error);
        }
    }];
    
}

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
-(NSURLSessionTask *)meetChangeRoleWithMeetId:(NSString *)meetId changeUid:(NSString *)uid role:(NSString *)role finish:(void (^)(NSURLSessionTask *task , LJMeetChangeRoleModel *model, NSError* error))finish
{
    if (meetId.length == 0 || uid.length == 0 || role.length == 0) {
        return nil;
    }
    NSString *path = [NSString stringWithFormat:@"%@/v1/meeting_member/change_role",[NetworkManager apiHost]];
    
    NSDictionary *param = @{@"meeting_id":meetId,@"change_uid":uid,@"role":role};
    
    return [self postRequestForPath:path param:param jsonName:@"LJMeetChangeRoleModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask,(LJMeetChangeRoleModel *)model,error);
        }
    }];
    
    
}


/**
 *  进入会议
 *
 *  @param meetId     会议id
 *  @param completion 请求完成回调
 *
 *  @return 请求实例
 */
-(NSURLSessionTask *)meetJoinMeetWithMeetId:(NSString *)meetId finish:(void (^)(NSURLSessionTask *task , LJMeetJoinMeetInfoModel *model , NSError *error))finish
{
    if (meetId.length == 0) {
        return nil;
    }
    NSString *path = [NSString stringWithFormat:@"%@/v1/meeting_operation/join",[NetworkManager apiHost]];
    NSDictionary *param = @{@"meeting_id":meetId};
    
    return [self postRequestForPath:path param:param jsonName:@"LJMeetJoinMeetInfoModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask,(LJMeetJoinMeetInfoModel *)model,error);
        }
    }];
}


/**
 *  退出会议
 *
 *  @param meetId     会议id
 *  @param completion 请求完成回调
 *
 *  @return 请求request实例
 */
-(NSURLSessionTask *)meetQuitMeetWithMeetId:(NSString *)meetId completion:(void(^)( NSError *error))completion
{
    if (meetId.length == 0) {
        return nil;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/v1/meeting_operation/quit",[NetworkManager apiHost]];
    NSDictionary *param = @{@"meeting_id":meetId};
    
    return [self postRequestForPath:path param:param finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {
        if (error == nil && [response isKindOfClass:[NSDictionary class]]) {
            NSInteger errNo = [[(NSDictionary *)response objectForKey:@"errno"] integerValue];
            if (errNo != 0) {
                error = [NSError errorWithDomain:@"meet" code:errNo userInfo:nil];
            }
        }
        if (completion) {
            completion(error);
        }
        
    }];
    
}


/**
 *  管理员收集问题
 *
 *  @param meetId     会议id
 *  @param chatId     消息id
 *  @param completion 请求返回的回调
 *
 *  @return 请求的实例
 */
-(NSURLSessionTask *)meetCollectProblemWithMeetId:(NSString *)meetId chatId:(NSString *)chatId completion:(void (^)(NSError *error,NSString *errMsg , NSString *msgId , NSString *chatId ))completion
{
    if (meetId.length == 0 || chatId.length == 0) {
        return nil;
    }
    NSString *path = [NSString stringWithFormat:@"%@/v1/meeting_message/collect",[NetworkManager apiHost]];
    NSDictionary *param = @{@"meeting_id":meetId,@"chatting_id":chatId};
    
    return [self postRequestForPath:path param:param finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {
        
        NSString *msgId = nil;
        NSString *chattingId = nil;
        NSString *errMsg = nil;
        if (error == nil && [response isKindOfClass:[NSDictionary class]]) {
            
            NSInteger errNo = [response[@"errno"] integerValue];
            if (errNo != 0) {
                errMsg = response[@"msg"];
                
                if (errMsg.length == 0 ) {
                    if (errNo == 21222) {
                        errMsg = @"您已选择过这个问题";
                    }else{
                        errMsg = @"设置问题失败";
                    }
                }
                
            } else{
                
                NSDictionary *data  = [(NSDictionary *)response objectForKey:@"data"];
                
                msgId = data[@"msg_id"];
                if (![msgId isKindOfClass:[NSString class]]) {
                    msgId = msgId.description;
                }
                chattingId = data[@"chatting_id"];
                if (![chattingId isKindOfClass:[NSString class]]) {
                    chattingId = chattingId.description;
                }
                
            }
            
        }
        if (completion) {
            completion(error,errMsg,msgId,chattingId);
        }
    }];
}


/**
 *  上传音频请求
 *
 *  @param filePath   音频文件路径
 *  @param completion 请求完成回调
 *
 *  @return 请求的request
 */
-(NSURLSessionTask *)meetUploadAudio:(NSString *)filePath completion:(void(^)(NSURLSessionTask*task , LJMeetUploadAudioModel *model , NSError *error))completion
{

    NSString *path = [NSString stringWithFormat:@"%@/v1/meeting_message/upload_audio",[NetworkManager apiHost]];
    
    return [[TKRequestHandler sharedInstance]postRequestForPath:path param:nil formData:^(id<AFMultipartFormData> formData) {
        if (filePath) {
            NSURL *url = [NSURL fileURLWithPath:filePath];
            [formData appendPartWithFileURL:url name:@"auido" fileName:@"audio.spx" mimeType:@"audio/basic" error:nil];
        }
    } finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {
        
        LJMeetUploadAudioModel *model = nil;
        if ([response isKindOfClass:[NSDictionary class]]) {
            
            model = [[LJMeetUploadAudioModel alloc] initWithDictionary:response error:nil];
        }
        if (completion) {
            completion(sessionDataTask, model , error);
        }
    } ];
    
    
}



@end
