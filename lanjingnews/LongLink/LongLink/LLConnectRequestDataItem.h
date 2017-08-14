//
//  LLConnectRequestDataItem.h
//  LongLink
//
//  Created by chunhui on 15/9/25.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import "LLRequestDataItem.h"
#import "Connect.pbobjc.h"

@interface LLConnectRequestDataItem : LLRequestDataItem

@property(nonatomic , strong) ConnectRequest *request;

@end
