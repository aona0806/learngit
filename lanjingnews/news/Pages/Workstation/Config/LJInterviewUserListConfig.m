//
//  LJInterviewUserListConfig.m
//  news
//
//  Created by 陈龙 on 16/5/11.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "LJInterviewUserListConfig.h"
#import "news-Swift.h"

@implementation LJInterviewUserListConfig

- (instancetype)init
{
    
    self = [super init];
    if (self) {
        
        BOOL is320WidthScreen = [GlobalConsts Is320WidthScreen];
        _titleHorizontalSpace = is320WidthScreen ? 17.0 : 20.0;
        _titleTopSpace = is320WidthScreen ? 12.0 : 14.0;
        _titleFont = [UIFont boldSystemFontOfSize:14];
        _titleColor = HexColor(0x222222);
        _detailTopSpace = is320WidthScreen ? 6.0 : 8.0;
        _detailButtomSpace = is320WidthScreen ? 11.0 : 13.0;
        _detailFont = [UIFont systemFontOfSize:10];
        _detailColor = HexColor(0xa5aaae);
        _seperateLineColor = HexColor(0xdddddd);
    }
    return self;
}

+ (nonnull instancetype)sharedInstance
{
    static LJInterviewUserListConfig *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LJInterviewUserListConfig alloc] init];
    });
    return manager;
}

@end
