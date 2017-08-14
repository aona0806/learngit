//
//  LLProtocolHeader.h
//  LongLink
//
//  Created by chunhui on 15/9/16.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <ProtocolBuffers/ProtocolBuffers.h>
#import "Msg.pbobjc.h"

typedef struct{
    int version;
    
}LLHeader;

@interface LLProtocolHeader : NSObject

@property(nonatomic , strong) Msg *msg;
@property(nonatomic , strong) GPBMessage *body;

-(void)analyseData:(NSData *)data withRange:(NSRange)range;

@end
