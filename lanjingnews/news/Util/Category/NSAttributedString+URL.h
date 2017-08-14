//
//  NSAttributedString+URL.h
//  news
//
//  Created by chunhui on 15/11/27.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (URL)

/**
 *  更改url连接
 *
 *  @return 将连接改为 网页连接富文本
 */
- (NSMutableAttributedString *)translateToUrlAttributedString;

@end
