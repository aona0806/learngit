//
//  LLRequestDataItem.m
//  LongLink
//
//  Created by chunhui on 15/9/18.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import "LLRequestDataItem.h"
#import "DDDataOutputStream.h"
#import "Msg.pb.h"

@implementation LLRequestDataItem

-(uint8_t)version
{
    return 1;
}

-(NSData *)pbData
{
    return nil;
}

-(NSString *)name
{
    return nil;
}

-(NSData *)packData
{
    NSData *pbData = [self pbData];
    
    if ([pbData length] > 0) {
    
        NSLog(@"pb data is: %@",pbData);
        const char *bytes = [pbData bytes];
        for (int i = 0 ; i < [pbData length]; i++) {
            printf("%02x",(uint8_t)bytes[i]);
        }
        printf("\n\n");
        
        Msg_Builder *builder = [[Msg_Builder alloc]init];
        [builder setMid:2];
        NSString *name = [self name];
        if (name) {
            [builder setName:name];
        }
        [builder setContent:pbData];
        Msg *msg = [builder buildPartial];
        NSData *msgData = [msg data];
                
        uint8_t version = [self version];
        DDDataOutputStream *ostream = [[DDDataOutputStream alloc]init];
        [ostream writeChar:version];
        
        int length = (int)[msgData length];
        [ostream writeInt:length];
        
        [ostream writeBytes:msgData];
        
        return [ostream toByteArray];
    }
    
    return nil;
}

@end
