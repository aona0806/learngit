//
//  LJCodeSignHelper.h
//  news
//
//  Created by chunhui on 15/12/1.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJCodeSignHelper : NSObject

+(NSString *_Nonnull)signWithDictionary:(NSDictionary<NSString * , NSObject *> * _Nullable)dic;

@end
