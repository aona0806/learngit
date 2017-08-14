//
//  LongLink.h
//  LongLink
//
//  Created by chunhui on 15/9/16.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const LLLongLinkDisconnectNotification ;
extern NSString *const LLLinkConnectCompleteNotification;


#define POSTNOTIFICATION(name)  dispatch_async(dispatch_get_main_queue(), ^{ \
        [[NSNotificationCenter defaultCenter]postNotificationName:name object:nil]; \
})

@interface LongLink : NSObject

@end
