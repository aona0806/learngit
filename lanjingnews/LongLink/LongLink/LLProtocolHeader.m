//
//  LLProtocolHeader.m
//  LongLink
//
//  Created by chunhui on 15/9/16.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import "LLProtocolHeader.h"
#import "Hi.pbobjc.h"
#import "GPBMessage.h"


@interface LLProtocolHeader ()

@property(nonatomic , strong) NSDictionary *requstMap;

@end

@implementation LLProtocolHeader

-(instancetype)init
{
    self = [super init];
    if (self) {
        _requstMap = @{@"hi":@"HiResponse",@"connect":@"ConnectResponse",@"notify_message":@"NotifyMessageRequest"};        
    }
    return self;
}

-(NSString *)bodyClassNameForName:(NSString *)name
{
    name = [name lowercaseString];    
    return _requstMap[name];
}

-(void)analyseData:(NSData *)data withRange:(NSRange)range
{
    if (data.length < range.location + range.length) {
        return;
    }
    
    NSData *pbData = [data subdataWithRange:range];
    @try {

        self.msg = [[Msg alloc]initWithData:pbData error:nil];
        
        if (self.msg) {
            NSString *className = [self bodyClassNameForName:self.msg.name];
            if (className) {
                Class pbBodyClass = NSClassFromString(className);
                NSError *error = nil;
                
                GPBMessage *message = [pbBodyClass parseFromData:self.msg.content error:&error];
                if (error == nil) {
                    self.body = message;
                }else{
#if DEBUG
                    NSLog(@"parse bp data error: %@",error);
                    exit(0);
#endif
                }
                
            }else{
                NSLog(@"class Name is null for %@\n\n----------",self.msg.name);
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@" --------analyse pb exception is: \n%@\n----------",exception);
    }
   
}

@end
