//
//  NSString+Version.h
//  news
//
//  Created by chunhui on 15/12/7.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Version)

/**
 *  版本号比对
 *
 *  @param anotherVersion 另一个版本号
 *
 *  @return 1 自己的版本号大于anotherVersion 
 *          0 两个版本号相等
 *         -1 自己的版本号小于anotherVersion
 */
-(NSInteger)compareVersion:(NSString *)anotherVersion;

@end
