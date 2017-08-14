//
//  LJTimeAxisModel.m
//  news
//
//  Created by 奥那 on 15/12/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJTimeAxisModel.h"

@implementation  LJTimeAxisModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"errno":@"dErrno" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJTimeAxisDataModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"next_cursor":@"nextCursor",@"previous_cursor":@"previousCursor",@"total_cursor":@"totalCursor",@"share_url":@"shareUrl",@"total_number":@"totalNumber" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJTimeAxisDataListModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"time_show":@"timeShow",@"sign_show":@"signShow", @"time_end":@"timeEnd" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"time_show"]) {
        self.timeShow = value;
    }
}

@end
