//
//  LJMeetTalkMsgDataModel+IMMessage.m
//  news
//
//  Created by chunhui on 15/10/11.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMeetTalkMsgDataModel+IMMessage.h"
#import "LJMeetTalkMsgModel.h"

@implementation LJMeetTalkMsgDataModel (IMMessage)

-(instancetype)initWithIMMessage:(IMMessage *)message
{
    self = [super init];
    if (self) {
        
        self.mtype = @(message.type).description;
        self.mid = @(message.messageId).description;
        self.meetingId = @(message.meetingId).description;
        
        LJMeetTalkMsgDataUserInfoModel *user = [[LJMeetTalkMsgDataUserInfoModel alloc]init];
        user.sname = message.fromUser.sname;
        user.uid   = @(message.fromUser.uid).description;
        user.avatar = message.fromUser.avatar;
        
        user.company = message.fromUser.company;
        
        self.userInfo = user;
        
        
        self.role = @(message.fromUser.role).description;

        
        self.createdt = @(message.timestamp).description;
        self.updatedt = self.createdt;
        
        switch (message.type) {
            case IMMessageType_Text:
                self.content = message.text.content;
                break;
            case IMMessageType_Audio:
                self.content = message.audio.URL;
                self.audioFormat = message.audio.format;
                self.audioDuration = @(message.audio.duration).description;
                break;
            case IMMessageType_Image:
                self.content = message.image.URL;
                self.width = @(message.image.width).description;
                self.height = @(message.image.height).description;
                //width and height
                
                break;
            default:
                break;
        }
        
        //1-创建者，2-管理员，3-嘉宾，4-普通用户
        NSInteger role = [self.role integerValue];
        self.roleName = [LJMeetTalkMsgDataModel RoleNameWithType:role];
        if (self.roleName.length == 0) {
            self.roleName = @"观众";
        }
        
        self.fromChatting = message.isQuestion? @"1": @"0";
        
    }
    return self;
}

@end
