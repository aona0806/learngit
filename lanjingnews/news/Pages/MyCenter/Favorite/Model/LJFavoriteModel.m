//
//  LJFavoriteModel.m
//  news
//
//  Created by wxc on 16/1/6.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "LJFavoriteModel.h"

@implementation  LJFavoriteModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"errno":@"dErrno" }];
}


+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJFavoriteDataModel



+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

- (instancetype)initWithInfo:(LJNewsListDataListModel*)info
{
    self = [super init];
    if (self) {
        self.info = info;
    }
    
    return self;
}

@end
