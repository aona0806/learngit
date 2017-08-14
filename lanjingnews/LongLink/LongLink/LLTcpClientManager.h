//
//  LLTcpClientManager.h
//  LongLink
//
//  Created by chunhui on 15/9/16.
//  Copry from team talk
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kLongLinkTokenInvalidNotification;
extern NSString *const kLongLinkCloseNotification ;
extern NSString *const kLongLinkConnectFailedNotification ;
extern NSString *const kLongLinkConnectingNotification ;
extern NSString *const kLongLinkConnectedNotification ;

typedef NS_ENUM( NSInteger , ClientStatus ){
    kClientStatusOnline = 0 ,
    kClientStatusDisconnect = 1,
};

@interface LLTcpClientManager : NSObject

@property(nonatomic , assign) ClientStatus status;
@property(nonatomic , assign , readonly) NSTimeInterval lastBeatTimestamp;//上一次发送或者接受的时间戳
@property(nonatomic , copy)  void (^sendConnBlock)();

+ (instancetype)SharedInstance;

-(void)connect:(NSString *)ipAdr port:(NSInteger)port;
-(void)disconnect;
-(void)reconnect;
-(BOOL)sendData:(NSData *)data;

@end
