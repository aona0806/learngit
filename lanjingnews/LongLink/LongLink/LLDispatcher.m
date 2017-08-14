//
//  LLDispatcher.m
//  LongLink
//
//  Created by chunhui on 15/9/18.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import "LLDispatcher.h"
#import "LLTcpClientManager.h"
#import "LLRequestDataItem.h"


@interface LLDispatcher()

@property(nonatomic , strong) NSMutableSet *listeners;
@property(nonatomic , strong) NSLock *lock;
@property(nonatomic , strong) dispatch_queue_t dispterQueue;

@end

@implementation LLDispatcher

+(LLDispatcher *)SharedInstance
{
    static LLDispatcher *dispatcher = nil;
    if (dispatcher == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dispatcher = [[LLDispatcher alloc]init];
        });
    }
    
    return dispatcher;
}

+(void)TearDown
{
    [[LLTcpClientManager SharedInstance]disconnect];
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        _listeners = [[NSMutableSet alloc]init];
        _lock = [[NSLock alloc] init];
        _dispterQueue = dispatch_queue_create("longlink.dispatcher.queue", nil);
    }
    return self;
}

-(void)registListener:(id<LLRequestProtocol>)delegate
{
    if (delegate == nil) {
        return;
    }
    dispatch_async(_dispterQueue, ^{
        [_lock lock];
        [_listeners addObject:delegate];
        [_lock unlock];
    });
}
-(void)unregistListener:(id<LLRequestProtocol>)delegate
{
    if (delegate == nil) {
        return;
    }
    dispatch_async(_dispterQueue, ^{
        [_lock lock];
        [_listeners removeObject:delegate];
        [_lock unlock];
    });
}

-(void)unregistAllListener
{
    dispatch_async(_dispterQueue, ^{
        [_lock lock];
        [_listeners removeAllObjects];
        [_lock unlock];
    });
}

-(void)sendDataItem:(LLRequestDataItem *)item
{
    dispatch_async(_dispterQueue, ^{
        NSData *data = [item packData];
        if (data.length > 0) {
            [[LLTcpClientManager SharedInstance]sendData:data];
        }
    });
}

-(void)receiveResponse:(LLProtocolHeader *)header
{
    if (header.msg && header.body) {
        [self receiveData:header.body];
    }
}

-(void)receiveData:(id)obj
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_lock lock];
        for (id<LLRequestProtocol> delegate in _listeners) {
            [delegate handleResponse:obj];
        }
        [_lock unlock];
    });
}

@end
