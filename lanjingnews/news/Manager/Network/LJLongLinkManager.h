//
//  LJLongLinkManager.h
//  news
//
//  Created by chunhui on 15/10/10.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLTcpClientManager.h"
#import "LJConInfoModel.h"
#import "LLDispatcher.h"


@interface LJLongLinkManager : NSObject

@property(nonatomic , strong) LJConInfoDataModel *configModel;

+(LJLongLinkManager *)SharedInstance;

-(void)autoConnect:(float)delay;

-(void)loadConfigInfo:(void(^)(BOOL ok))doneBlock;

-(BOOL)connect;

-(void)disconnect;

-(void)registListener:(id<LLRequestProtocol>)delegate;

-(void)unregistListener:(id<LLRequestProtocol>)delegate;

@end
