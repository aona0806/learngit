//
//  LLSendBuffer.h
//  LongLink
//
//  Created by chunhui on 15/9/16.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLSendBuffer : NSMutableData
{
@private
    NSMutableData *embeddedData;
    NSInteger _sendPos;
}

@property (readonly) NSInteger sendPos;

+ (id)dataWithNSData:(NSData *)newdata;

- (id)initWithData:(NSData *)newdata;
- (void)consumeData:(NSInteger)length;

- (const void *)bytes;
- (NSUInteger)length;

- (void *)mutableBytes;
- (void)setLength:(NSUInteger)length;

@end
