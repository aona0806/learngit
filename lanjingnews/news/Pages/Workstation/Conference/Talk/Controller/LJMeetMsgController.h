//
//  LJMeetMsgController.h
//  news
//
//  Created by chunhui on 15/10/10.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJLongLinkManager.h"
#import "ClientPush.pbobjc.h"
#import "Data.pbobjc.h"


@interface LJMeetMsgController : NSObject<LLRequestProtocol>

@property(nonatomic , copy) void (^receiveMessage)(ChannelType type , GPBMessage *message);

+(GPBMessage * )messageWithName:(NSString *)name andData:(NSData *)data;

@end
