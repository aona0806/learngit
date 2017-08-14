//
//  VersionHelp.m
//  news
//
//  Created by 陈龙 on 15/5/29.
//  Copyright (c) 2015年 lanjing. All rights reserved.
//

#import "LJVersionManager.h"
#import <UIKit/UIKit.h>
#import "NSString+Version.h"
#import "news-Swift.h"


@interface LJVersionManager()


@end

@implementation LJVersionManager

+ (void)checkUpdateIfNeeded:(void (^)(NSString *url))block
{

    [[TKRequestHandler sharedInstance] getAppVersionFinish:^(NSURLSessionDataTask *sessionDataTask, id responses, NSError *error) {
        if (error)
        {
            return;
        }
        else
        {
            if (responses)
            {
                NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
                NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"]; //系统版本
                NSString *lastVersionStr = responses[@"data"][@"version"];   //appstore 获取版本
                NSString *trackViewUrlStr = responses[@"data"][@"url"];
                
                
                if ([appVersion compareVersion:lastVersionStr] < 0)
                {
                    block(trackViewUrlStr);
                }
                else
                {
                }
            }
        }

    }];
}

@end
