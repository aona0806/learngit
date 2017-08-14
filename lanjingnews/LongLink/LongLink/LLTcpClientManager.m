//
//  LLTcpClientManager.m
//  LongLink
//
//  Created by chunhui on 15/9/16.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import "LLTcpClientManager.h"
#import "LongLink.h"
#import "LLSendBuffer.h"
#import "DDDataInputStream.h"
#import "LLProtocolHeader.h"
#import "LLDispatcher.h"
#import "AFNetworkReachabilityManager.h"

#import "LLHeartbeatDataItem.h"


#define kHeartBeatDuration   100
#define kMaxReconnectCount   5 //连接失败时最大重连次数
#define kReconnetInterval    5  //重连的时间间隔


extern NSString *kReachabilityChangedNotification;

@interface LLTcpClientManager ()<NSStreamDelegate>
{
    
@private
    NSInputStream *_inStream;
    NSOutputStream *_outStream;
    NSLock *_receiveLock;
    NSMutableData *_receiveBuffer;
    NSInteger _receiveLength;
    NSLock *_sendLock;
    NSMutableArray *_sendBuffers;
    LLSendBuffer *_lastSendBuffer;
    BOOL _noDataSent;
    int32_t cDataLen;
    BOOL _shouldReconnect;
    
}

@property(nonatomic , copy) NSString *ipAddr;
@property(nonatomic , assign) NSInteger port;
@property(nonatomic , strong) AFNetworkReachabilityManager *reachability;
@property(nonatomic , assign) NSInteger reconnectTryCount;

//@property(nonatomic , assign) NSTimeInterval lastBeatTimestamp;
@property(nonatomic , strong) NSTimer *heatBeatTimer;
@property(nonatomic , assign) NSInteger reconnectGap;//网络重连间隔


- (void)handleConntectOpenCompletedStream:(NSStream *)aStream;
- (void)handleEventErrorOccurredStream:(NSStream *)aStream;
- (void)handleEventEndEncounteredStream:(NSStream *)aStream;
- (void)handleEventHasBytesAvailableStream:(NSStream *)aStream;
- (void)handleEventHasSpaceAvailableStream:(NSStream *)aStream;


@end

@implementation LLTcpClientManager

+ (instancetype)SharedInstance
{
    static LLTcpClientManager* g_tcpClientManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_tcpClientManager = [[LLTcpClientManager alloc] init];
    });
    return g_tcpClientManager;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reachabilityChangeNotification:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
        
        self.reachability = [AFNetworkReachabilityManager sharedManager];
        
        [self.reachability startMonitoring];
        
    }
    return self;
}

-(void)dealloc
{
    [self.reachability stopMonitoring];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - PublicAPI
-(void)connect:(NSString *)ipAdr port:(NSInteger)port
{
    self.ipAddr = ipAdr;
    self.port   = port;
    
    cDataLen = 0;
    
    _shouldReconnect = YES;
    _receiveBuffer = [NSMutableData data];
    _sendBuffers = [NSMutableArray array];
    _noDataSent = NO;
    
    _receiveLock = [[NSLock alloc] init];
    _sendLock = [[NSLock alloc] init];
    
    NSInputStream  *tempInput  = nil;
    NSOutputStream *tempOutput = nil;
    
    [self streamsToHostNamed:ipAdr port:port inputStream:&tempInput outputStream:&tempOutput];
    _inStream  = tempInput;
    _outStream = tempOutput;
    
    [_inStream setDelegate:self];
    [_outStream setDelegate:self];
    
    [_inStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [_inStream open];
    [_outStream open];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kLongLinkConnectingNotification object:nil];
    
}
/**
 *  强制断开，不再重连
 */
-(void)disconnect
{
    [self disconnect:YES];
}
/**
 *  断开连接
 *
 *  @param tearDown 是否还要重连
 */
-(void)disconnect:(BOOL)tearDown
{
    cDataLen = 0;
    
    if(tearDown){
        _shouldReconnect = NO;
    }
    _receiveLock = nil;
    _sendLock = nil;
    
    if(_inStream)
    {
        [_inStream close];
        [_inStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    _inStream = nil;
    
    if (_outStream) {
        [_outStream close];
        [_outStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    
    _outStream = nil;
    
    _receiveBuffer = nil;
    _sendBuffers = nil;
    _lastSendBuffer = nil;
    
    POSTNOTIFICATION(LLLongLinkDisconnectNotification);
    
    if (self.heatBeatTimer) {
        [self.heatBeatTimer invalidate];
        self.heatBeatTimer = nil;
    }
    
}

-(void)reconnect
{
    if (self.ipAddr.length > 0) {
        
        self.reconnectTryCount++;
        if (self.reconnectTryCount < kMaxReconnectCount) {
            [self disconnect:NO];
            [self connect:self.ipAddr port:self.port];
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:kLongLinkConnectFailedNotification object:nil];
        }
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:kLongLinkConnectFailedNotification object:nil];
    }
}

-(void)tryReconnect
{
    if ([self.reachability isReachable] ) {
        [self reconnect];
    }
}

-(BOOL)sendData:(NSData *)data
{
    [_sendLock lock];
    @try {
        if (_outStream == nil) {
            return NO;
        }
        
        if (_noDataSent ==YES) {
            
            NSInteger len;
            len = [_outStream write:[data bytes] maxLength:[data length]];
            _noDataSent = NO;
            if (len < [data length]) {
                LLLog(@"WRITE - Creating a new buffer for remaining data len:%u", [data length] - len);
                _lastSendBuffer = [LLSendBuffer dataWithNSData:[data subdataWithRange:NSMakeRange([data length]-len, [data length])]];
                [_sendBuffers addObject:_lastSendBuffer];
            }
            return YES;
        }
        
        if (_lastSendBuffer) {
            NSInteger lastSendBufferLength;
            NSInteger newDataLength;
            lastSendBufferLength = [_lastSendBuffer length];
            newDataLength = [data length];
            if (lastSendBufferLength<1024) {
                LLLog(@"WRITE - Have a buffer with enough space, appending data to it");
                [_lastSendBuffer appendData:data];
                return YES;
            }
        }
        LLLog(@"WRITE - Creating a new buffer");
        _lastSendBuffer = [LLSendBuffer dataWithNSData:data];
        [_sendBuffers addObject:_lastSendBuffer];
        
    }
    @catch (NSException *exception) {
        LLLog(@" ***** NSException:%@ in writeToSocket of MGJMTalkClient *****",exception);
    }
    @finally {
        [_sendLock unlock];
    }
}

/*
-(NSString *)nameForEventCode:(NSStreamEvent)code
{
    switch (code) {
        case NSStreamEventNone:
            return @"NSStreamEventNone";
        case NSStreamEventOpenCompleted:
            return @"NSStreamEventOpenCompleted";
        case NSStreamEventHasBytesAvailable:
            return @"NSStreamEventHasBytesAvailable";
        case NSStreamEventHasSpaceAvailable:
            return @"NSStreamEventHasSpaceAvailable";
        case NSStreamEventErrorOccurred:
            return @"NSStreamEventErrorOccurred";
        case NSStreamEventEndEncountered:
            return @"NSStreamEventEndEncountered";
        default:
            break;
    }
    return nil;
}
//*/

#pragma mark - NSStream Delegate
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    
//    NSLog(@"-------%@---------: %@ \n\n",NSStringFromSelector(_cmd),[self nameForEventCode:eventCode]);
    
    switch(eventCode) {
        case NSStreamEventNone:
            LLLog(@"Event type: EventNone");
            break;
        case NSStreamEventOpenCompleted:
            [self handleConntectOpenCompletedStream:aStream];
            break;
        case NSStreamEventHasSpaceAvailable:          //发送数据
            [self handleEventHasSpaceAvailableStream:aStream];
            break;
        case NSStreamEventErrorOccurred:
            [self handleEventErrorOccurredStream:aStream];
            break;
        case NSStreamEventEndEncountered:
            [self handleEventEndEncounteredStream:aStream];
            break;
        case NSStreamEventHasBytesAvailable:
            [self handleEventHasBytesAvailableStream:aStream];
            break;
    }
}

#pragma mark - PrivateAPI
- (void)handleConntectOpenCompletedStream:(NSStream *)aStream
{
    if (aStream == _outStream) {

        self.reconnectTryCount = 0;
        POSTNOTIFICATION(LLLinkConnectCompleteNotification);
        self.status = kClientStatusOnline;
        
        //发送连接请求
        if (self.sendConnBlock) {
            self.sendConnBlock();
        }
        
        if (self.heatBeatTimer) {
            [self.heatBeatTimer invalidate];
        }
        self.heatBeatTimer = [NSTimer scheduledTimerWithTimeInterval:kHeartBeatDuration target:self selector:@selector(onHeartBeatTimer:) userInfo:nil repeats:YES];
        
        self.reconnectGap = 1;
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kLongLinkConnectedNotification object:nil];
    }
}

- (void)handleEventHasSpaceAvailableStream:(NSStream *)aStream
{
    [_sendLock lock];
    
    @try {
        
        if (![_sendBuffers count]) {
            _noDataSent = YES;
            
            return;
        }
        
        LLSendBuffer *sendBuffer = [_sendBuffers objectAtIndex:0];
        
        NSInteger sendBufferLength = [sendBuffer length];
        
        if (!sendBufferLength) {
            if (sendBuffer == _lastSendBuffer) {
                _lastSendBuffer = nil;
            }
            
            [_sendBuffers removeObjectAtIndex:0];
            _noDataSent = YES;
            return;
        }
        
        NSInteger len = ((sendBufferLength - [sendBuffer sendPos] >= 1024) ? 1024 : (sendBufferLength - [sendBuffer sendPos]));
        if (!len) {
            if (sendBuffer == _lastSendBuffer) {
                _lastSendBuffer = nil;
            }
            
            [_sendBuffers removeObjectAtIndex:0];
            _noDataSent = YES;
            
            return;
        }
        
        //			LLLog(@"write %ld bytes", len);
        len = [_outStream write:((const uint8_t *)[sendBuffer mutableBytes] + [sendBuffer sendPos]) maxLength:len];
        LLLog(@"WRITE - Written directly to outStream len:%lid", (long)len);
        [sendBuffer consumeData:len];

        if (![sendBuffer length]) {
            if (sendBuffer == _lastSendBuffer) {
                _lastSendBuffer = nil;
            }
            
            [_sendBuffers removeObjectAtIndex:0];
        }
        _noDataSent = NO;
        return;
    }
    @catch (NSException *exception) {
        LLLog(@" ***** NSException in MGJMTalkCleint :%@  ******* ",exception);
    }
    @finally {
        [_sendLock unlock];
    }
}

- (void)handleEventErrorOccurredStream:(NSStream *)aStream
{
    LLLog(@"handle eventErrorOccurred");
    [self disconnect:NO];
    
    self.status = kClientStatusDisconnect;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_reconnectGap * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self tryReconnect];
        if (_reconnectGap < 60) {
            //最长1分钟重试一次
            _reconnectGap+=2;
        }
    });
    
}

- (void)handleEventEndEncounteredStream:(NSStream *)aStream
{
    LLLog(@"handle eventEndEncountered");
    
    cDataLen = 0;
    //断开连接，释放资源
    [self disconnect];

    [[NSNotificationCenter defaultCenter]postNotificationName:kLongLinkCloseNotification object:nil];
    
}

- (void)handleEventHasBytesAvailableStream:(NSStream *)aStream
{
    // LLLog(@"handle eventHasBytesAvailable");
    if (aStream) {
        uint8_t buf[1024];
        NSInteger len = 0;
        len = [(NSInputStream *)aStream read:buf maxLength:1024];
        
#if 0
        printf("\n-----------%ld-------\n",len);
        for (int i = 0 ; i < len; i++) {
            printf("0x%02x,",buf[i]);
        }
        printf("\n\n\n\n");        
#endif
     
        
//#if kUseMagicNum
#define kMsgHeadLength 9
//#else
//#define kMsgHeadLength 5
//#endif
        
        if (len > 0) {
            
            [_receiveLock lock];
            
            [_receiveBuffer appendBytes:(const void *)buf length:len];
            while ([_receiveBuffer length] >= kMsgHeadLength) {
                NSRange range = NSMakeRange(0, kMsgHeadLength);
                
                NSData *headerData = [_receiveBuffer subdataWithRange:range];
                
                DDDataInputStream *inputData = [DDDataInputStream dataInputStreamWithData:headerData];
                
                //目前没有使用version
                uint8_t version = [inputData readChar];
                
//#if kUseMagicNum
                uint32_t magicnum = [inputData readInt];
//                printf("magic num is:%d\n\n",magicnum);
                if (magicnum != kMagicNum || version != 1) {
                    [_receiveBuffer setData:[NSData data]];
                    break;
                }
//#endif
                uint32_t pduLen = [inputData readInt];//读取前4个字节,已经将大端转成小端
                
                if (pduLen + kMsgHeadLength > (uint32_t)[_receiveBuffer length]) {
                    break;
                }
                if (version == kLongLinkVersion) { //是否是当前版本
                    //handle receive data
                    LLProtocolHeader *header = [[LLProtocolHeader alloc]init];
                    [header analyseData:_receiveBuffer withRange:NSMakeRange(kMsgHeadLength, pduLen)];
                    if (header.msg && header.body) {
                       
//                         NSLog(@"msg is: \n%@\nbody is: %@\n",header.msg,header.body);
                        
                        [[LLDispatcher SharedInstance]receiveResponse:header];
                        
                       
                    }
                    
                }else{
                    
                    LLLog(@"longlink verion is: %d",version);
                    
                }
                //后续内容
                if (kMsgHeadLength + pduLen >= _receiveBuffer.length) {
                    [_receiveBuffer setData:[NSData data]];
                }else{
                    NSInteger loc = range.location + range.length + pduLen;
                    [_receiveBuffer setData:[_receiveBuffer subdataWithRange:NSMakeRange(loc, _receiveBuffer.length -  loc)]];
                }
                
//                NSLog(@"after check receive buffer length is: %ld",[_receiveBuffer length]);
//                if([_receiveBuffer length] > 0){
//                    NSLog(@"has data\n");
//                }
            }
            
            [_receiveLock unlock];
        }
    }
    
}


#pragma mark - 
- (void)streamsToHostNamed:(NSString *)hostName port:(NSInteger)port inputStream:(NSInputStream **)inputStream outputStream:(NSOutputStream **)outputStream
{
    CFHostRef           host;
    CFReadStreamRef     readStream;
    CFWriteStreamRef    writeStream;
    
    readStream = NULL;
    writeStream = NULL;
    
    host = CFHostCreateWithName(NULL, (__bridge CFStringRef) hostName);
    if (host != NULL) {
        (void) CFStreamCreatePairWithSocketToCFHost(NULL, host, (SInt32)port, &readStream, &writeStream);
        CFRelease(host);
    }
    
    if (inputStream == NULL) {
        if (readStream != NULL) {
            CFRelease(readStream);
        }
    } else {
        *inputStream = (__bridge NSInputStream *) readStream;
    }
    if (outputStream == NULL) {
        if (writeStream != NULL) {
            CFRelease(writeStream);
        }
    } else {
        *outputStream =(__bridge NSOutputStream *) writeStream;
    }
}


#pragma mark - network status notification
-(void)reachabilityChangeNotification:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_shouldReconnect && [_reachability isReachable] > 0) {
            //需要重新获取connection的token
            [self reconnect];
        }else{
            //没有网络不发心跳
            if (self.heatBeatTimer) {
                [self.heatBeatTimer invalidate];
                self.heatBeatTimer = nil;
            }
        }
    });
}

#pragma mark - heart beat timer
-(void)onHeartBeatTimer:(NSTimer *)timer
{
    if (self.status == kClientStatusOnline) {
        //在线
        LLHeartbeatDataItem *item = [[LLHeartbeatDataItem alloc]init];
        HiRequest *request = [[HiRequest alloc]init];
        request.msg = @"hi";
        item.request = request;
//        HiRequest_Builder *builder = [[HiRequest_Builder alloc]init];
//        builder.msg = @"hi";
//        item.request = [builder build];
        
        [[LLDispatcher SharedInstance] sendDataItem:item];
    }
}

@end


NSString *const kLongLinkCloseNotification = @"kLongLinkCloseNotification";
NSString *const kLongLinkConnectFailedNotification = @"kLongLinkConnectFailedNotification";
NSString *const kLongLinkConnectingNotification = @"kLongLinkConnectingNotification";
NSString *const kLongLinkConnectedNotification = @"kLongLinkConnectedNotification" ;
