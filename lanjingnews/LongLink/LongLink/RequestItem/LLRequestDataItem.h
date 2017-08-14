//
//  LLRequestDataItem.h
//  LongLink
//
//  Created by chunhui on 15/9/18.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLRequestDataItem : NSObject


-(NSData *)packData;

-(uint8_t)version;

-(NSString *)name;

-(NSData *)pbData;

@end
