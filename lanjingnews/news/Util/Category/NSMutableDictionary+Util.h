//
//  NSMutableDictionary+Util.h
//  news
//
//  Created by 陈龙 on 15/12/21.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Util)

- (void)lj_setObject:(id)anObject forKey:(id<NSCopying>)aKey;

@end
