//
//  LLSendBuffer.m
//  LongLink
//
//  Created by chunhui on 15/9/16.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import "LLSendBuffer.h"

@implementation LLSendBuffer

+ (id)dataWithNSData:(NSData *)newData;
{
    return [[LLSendBuffer alloc] initWithData:newData];
}

- (id)initWithData:(NSData *)newData
{
    self = [super init];
    if (self) {
        embeddedData = [NSMutableData dataWithData:newData];
        _sendPos = 0;
    }
    
    return self;
}

- (void)consumeData:(NSInteger)length {
    _sendPos += length;
}


- (const void *)bytes
{
    return [embeddedData bytes];
}

- (NSUInteger)length
{
    return [embeddedData length];
}

- (void *)mutableBytes
{
    return [embeddedData mutableBytes];
}

- (void)setLength:(NSUInteger)length
{
    [embeddedData setLength:length];
}


@end
