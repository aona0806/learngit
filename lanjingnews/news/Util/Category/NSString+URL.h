//
//  NSString+URL.h
//  news
//
//  Created by chunhui on 15/11/27.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URL)

-(NSArray *)urlMatchesForRange:(NSRange)range;

+(NSAttributedString *)urllinkAttributeString;

/**
 *  urlString 中文编码转换
 *
 *  @return <#return value description#>
 */
-(NSURL *)tryEncodeURL;

@end
