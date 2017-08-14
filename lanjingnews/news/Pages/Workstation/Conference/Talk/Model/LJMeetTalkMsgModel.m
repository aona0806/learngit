//
//  LJMeetTalkMsgModel.m
//  news
//
//  Created by chunhui on 15/10/8.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMeetTalkMsgModel.h"

@implementation  LJMeetTalkMsgDataUserInfoModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"company_job":@"companyJob" }];
}

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}



@end


@implementation  LJMeetTalkMsgModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"errno":@"dErrno",@"msg_id":@"msgId" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJMeetTalkMsgDataModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"audio_format":@"audioFormat",@"question_oper":@"questionOper",@"audio_duration":@"audioDuration",@"is_del":@"isDel",@"meeting_id":@"meetingId",@"user_info":@"userInfo",@"audio_text":@"audioText",@"role_name":@"roleName",@"from_chatting":@"fromChatting" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

-(NSString *)width{
    if (_width.length <= 0 && _image != nil) {
        return [NSString stringWithFormat:@"%f",_image.size.width];
    }
    return _width;
}

-(NSString *)height{
    if (_height.length <= 0 && _image != nil) {
        return [NSString stringWithFormat:@"%f",_image.size.height];
    }
    return _height;
}

@end



@implementation LJMeetTalkMsgDataModel(Role)

+(NSString *)RoleNameWithType:(LJMeetRoleType)type
{
    NSString *name = nil;
    switch (type) {
        case kMeetRoleCreator:
        case kMeetRoleManager:
            name = @"主持人";
            break;
        case kMeetRoleGuest:
            name = @"嘉宾";
            break;
//        case kMeetRoleUser:
//            name = @"记者";
//            break;
        default:
            break;
    }    
    return name;
}

@end

