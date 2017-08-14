//
//  LJCodeSignHelper.m
//  news
//
//  Created by chunhui on 15/12/1.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJCodeSignHelper.h"
#import "NSString+MD5.h"


@implementation LJCodeSignHelper

+(NSString *)signWithDictionary:(NSDictionary<NSString * , NSObject *> *)dic
{
    NSMutableArray *realKeys = [[NSMutableArray alloc]initWithCapacity:[dic count]];
    // 删除这里的key是由于签名的时候，文件类型不用签名
    for (NSString *key in [dic allKeys]) {
        id value = [dic objectForKey:key];
        if (![value isKindOfClass:[NSData class]]) {
            [realKeys addObject:key];
        }
    }
    NSArray *myary = [realKeys sortedArrayUsingComparator:^(NSString * obj1, NSString * obj2){
        return (NSComparisonResult)[obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableString *keyValue = [[NSMutableString alloc]init];
    
    for (NSString *key in myary)
    {
        [keyValue appendString: key];
        [keyValue appendString: @"="];
        [keyValue appendString: [NSString stringWithFormat:@"%@",dic[key]]];
        [keyValue appendString: @"&"];
    }
    
    if (keyValue.length != 0)
    {
        [keyValue deleteCharactersInRange:NSMakeRange(keyValue.length -1 , 1)];
    }
    NSString *sha1 = [keyValue sha1String];
    NSString *sign = [sha1 md5String];
    
    return sign;
}

@end
