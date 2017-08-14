//
//  LJMeetTalkMsgDataModel+IMMessage.h
//  news
//
//  Created by chunhui on 15/10/11.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMeetTalkMsgModel.h"
#import "ClientPush.pbobjc.h"
#import "Data.pbobjc.h"

@interface LJMeetTalkMsgDataModel (IMMessage)

-(instancetype)initWithIMMessage:(IMMessage *)message;

@end
