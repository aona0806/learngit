//
//  LLDispatcher.h
//  LongLink
//
//  Created by chunhui on 15/9/18.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLProtocolHeader.h"

@class LLRequestDataItem;
@protocol LLRequestProtocol;
@interface LLDispatcher : NSObject

+(LLDispatcher *)SharedInstance;

-(void)registListener:(id<LLRequestProtocol>)delegate;
-(void)unregistListener:(id<LLRequestProtocol>)delegate;
-(void)unregistAllListener;

-(void)sendDataItem:(LLRequestDataItem *)item;
-(void)receiveResponse:(LLProtocolHeader *)header;

@end


@protocol LLRequestProtocol <NSObject>

-(void)handleResponse:(id)obj;

@end