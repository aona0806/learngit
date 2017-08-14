//
//  VersionHelp.h
//  news
//
//  Created by 陈龙 on 15/5/29.
//  Copyright (c) 2015年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sys/utsname.h"

@interface LJVersionManager : NSObject

/**
 *  查看版本更新信息
 */
+ (void)checkUpdateIfNeeded:(void (^)(NSString *url))block;


@end
