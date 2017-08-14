//
//  LJMeetMsgController.m
//  news
//
//  Created by chunhui on 15/10/10.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMeetMsgController.h"


@implementation LJMeetMsgController

+(GPBMessage * )messageWithName:(NSString *)name andData:(NSData *)data
{
//    NSString *builderName = [name stringByAppendingString:@"_Builder"];
//    Class clazz = NSClassFromString(builderName);
//    PBGeneratedMessage_Builder *builder = [[clazz alloc]init];
//    [builder mergeFromData:data];
//    
//    return (PBGeneratedMessage *)[builder buildPartial];
    
    Class pbClass = NSClassFromString(name);
    return (GPBMessage *)[[pbClass alloc]initWithData:data error:nil];
    
}

-(void)handleResponse:(id)obj
{
    
    if ([obj isKindOfClass:[NotifyMessageRequest class]]) {
        NotifyMessageRequest *request = (NotifyMessageRequest *)obj;
        NotifyMessage *msg = request.msg;
        GPBMessage *message = nil;
        
        NSDictionary *map = @{@(ChannelType_MeetingMain):@"IMMessage",
                              @(ChannelType_MeetingDiscuss):@"IMMessage",
                              @(ChannelType_MettingTrans):@"PlainTextMessage",
                              @(ChannelType_MettingStatus):@"StatusMessage",
                              @(ChannelType_MettingRole):@"RoleChangeMessage",
                              @(ChannelType_MeetingQuit):@"QuitMessage"};
        
        NSString *messageName = map[@(msg.channelType)];
        
        if (messageName) {
            message = [[self class] messageWithName:messageName andData:msg.data_p];
        }        
        if (message && self.receiveMessage) {
            self.receiveMessage(msg.channelType,message);
        }

    }    
}
@end
