//
//  LJMeetUploadAudioModel.m
//  news
//
//  Created by chunhui on 15/10/15.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMeetUploadAudioModel.h"

@implementation  LJMeetUploadAudioDataModel

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation  LJMeetUploadAudioModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"errno":@"dErrno" }];
}

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
