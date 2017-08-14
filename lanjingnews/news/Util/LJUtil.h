//
//  LJUtil.h
//  news
//
//  Created by chunhui on 15/11/3.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJUtil : NSObject

+ (NSString * _Nonnull)UUID;

+ (NSString * _Nonnull)UUIDShort;

/**
 *  计算toast弹出时间
 *
 *  @param toastString 显示错误的字段
 *
 *  @return <#return value description#>
 */
+ (double)toastInterval:(NSString * _Nonnull)toastString;

@end