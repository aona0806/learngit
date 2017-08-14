//
//  NSString+Valid.h
//  news
//
//  Created by 陈龙 on 15/12/17.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Valid)

/**
 *  获取有效字符串
 *
 *  @param defaultString 默认字符串
 *
 *  @return return value description
 */
- (NSString * _Nonnull)validStringWithDefault:(NSString * _Nonnull)defaultString;

/**
 *  验证邮箱有效性
 *
 *  @return <#return value description#>
 */
-(BOOL)isValidateEmail;

- (BOOL)isValidateMobile;

@end
