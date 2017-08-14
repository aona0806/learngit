//
//  LJLongLinkManager.m
//  news
//
//  Created by chunhui on 15/10/10.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJLongLinkManager.h"
#import "TKRequestHandler+LongLink.h"
#import "LLConnectRequestDataItem.h"
#import "NSString+MD5.h"
#import "LLDispatcher.h"
#import "Reconnect.pbobjc.h"
#import "ErrCode.pbobjc.h"


#define kAutoConnectDuration 2 // 自动重连延迟

@interface LJLongLinkManager ()<LLRequestProtocol>

@property(nonatomic , assign) BOOL loadingConfig;

@end

@implementation LJLongLinkManager

+(LJLongLinkManager *)SharedInstance
{
    static LJLongLinkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LJLongLinkManager alloc]init];
    });
    return manager;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        __weak typeof(self) weakSelf = self;
        [LLTcpClientManager SharedInstance].sendConnBlock = ^(){
            [weakSelf sendConnectRequest];
        };
        [[LLDispatcher SharedInstance]registListener:self];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
        });
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(longLinkCloseNotification:) name:kLongLinkCloseNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(longLinkConnectFailedNotification:) name:kLongLinkConnectFailedNotification object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[LLDispatcher SharedInstance]unregistListener:self];
    [[LLTcpClientManager SharedInstance]disconnect];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)autoConnect:(float)delay
{

    if (delay < 0 ) {
        //不连接
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        __weak typeof(self) weakSelf = self;
        [self loadConfigInfo:^(BOOL ok) {
            if (ok) {
                [weakSelf connect];
            }else{
                //failed
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf autoConnect:kAutoConnectDuration];
                });
            }
        }];
    });
}

-(void)loadConfigInfo:(void(^)(BOOL ok))doneBlock
{
    if (self.loadingConfig) {
        return;
    }
    self.loadingConfig = YES;
    
    NSString *cuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    __weak typeof(self) weakSelf = self;
    [[TKRequestHandler sharedInstance] getLongLinkConfigWithCuid:cuid completion:^(LJConInfoModel *model, NSError *error) {
        
        weakSelf.loadingConfig = NO;
        BOOL ok = NO;
        if (model) {
            self.configModel = model.data;
            ok = YES;
        }
        if (doneBlock) {
            doneBlock(ok);
        }
        
    }];
}

-(BOOL)connect
{
    if (self.configModel) {
        [[LLTcpClientManager SharedInstance]disconnect];
        [[LLTcpClientManager SharedInstance]connect:self.configModel.ip port:[self.configModel.port integerValue]];
        
#if 0
        //测试连接代码
        /*
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self longLinkCloseNotification:nil];
            });
        });
         */
        
#endif
        return YES;
    }
    return NO;
}

-(void)disconnect
{
    [[LLDispatcher SharedInstance]unregistAllListener];
    
    [[LLTcpClientManager SharedInstance]disconnect];
}

-(void)registListener:(id<LLRequestProtocol>)delegate
{
    [[LLDispatcher SharedInstance]registListener:delegate];
}
-(void)unregistListener:(id<LLRequestProtocol>)delegate
{
    [[LLDispatcher SharedInstance]unregistListener:delegate];
}

-(void)sendConnectRequest
{
    if (self.configModel){
//        NSLog(@"----send connect id: %@--------\n\n",self.configModel.connId);
        LLConnectRequestDataItem *item = [[LLConnectRequestDataItem alloc]init];
        ConnectRequest *connect = [[ConnectRequest alloc]init];
        connect.connId = self.configModel.connId;
        connect.token = self.configModel.token;
        
//        ConnectRequest_Builder *builder = [[ConnectRequest_Builder alloc]init];
//        [builder setConnId:self.configModel.connId];
//        [builder setToken:self.configModel.token];
        //MD5(SHA1(conn_id=xxxx&token=xxxx))
        NSString *sign = [NSString stringWithFormat:@"conn_id=%@&token=%@",self.configModel.connId,self.configModel.token];
        sign = [sign sha1String];
        sign = [sign md5String];
//        [builder setSign:sign];
        connect.sign = sign;
        
        item.request = connect;
        
        [[LLDispatcher SharedInstance]sendDataItem:item];
    }
}

#pragma mark - check network
-(void)handleResponse:(id)obj
{
    if ([obj isKindOfClass:[ConnectResponse class]]) {
        //连接response
        ConnectResponse *res = (ConnectResponse *)obj;
        switch (res.errCode) {
            case ErrCode_IllegalRequest:
            case ErrCode_InvalidConnection:
            {
                //token过期等错误，重新获取token
                [[LLTcpClientManager SharedInstance]disconnect];
                [self autoConnect:1];
            }
                break;
            case ErrCode_InternalErr:
            case ErrCode_ServerTooBusy:
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self sendConnectRequest];
                });
            }
                break;
            default:
                break;
        }
    }else if ([obj isKindOfClass:[ReConnectRequest class]]){
        //需要重连
        ReConnectRequest *request = (ReConnectRequest *)obj;
        if([request.connId isEqualToString:self.configModel.connId]){
            self.configModel = nil;
            [self autoConnect:0.5];
        }
    }
}

-(void)applicationBecomeActiveNotification:(NSNotification *)notification
{
    [self autoConnect:0.5];
}

-(void)longLinkCloseNotification:(NSNotification *)notification
{
    [self autoConnect:1.5];
}

-(void)longLinkConnectFailedNotification:(NSNotification *)notification
{
    [self autoConnect:1];
}

@end
