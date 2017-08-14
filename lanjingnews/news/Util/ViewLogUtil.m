//
//  ViewLogUtil.m
//  news
//
//  Created by 徐凯伦 on 15/3/12.
//  Copyright (c) 2015年 lanjing. All rights reserved.
//

#import "ViewLogUtil.h"
#import <UIKit/UIKit.h>

@implementation ViewLogUtil


//+(void)load
//{
//    [self ShowFonts];
//}

+(void)LogView:(UIView *)v
{
#if DEBUG
    
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    SEL sel = NSSelectorFromString(@"recursiveDescription");
    
    @try {
        NSLog(@"%@",[v performSelector:sel]);
    }
    @catch (NSException *exception) {
        
    }
    @finally {
    }
#pragma clang diagnostic pop
    
#endif
}

#if TARGET_IPHONE_SIMULATOR

+(void)ShowFonts
{
    NSArray *installFonts = [UIFont familyNames];
    NSLog(@"installed fonts are:\n\n%@\n\n",installFonts);
}

#endif

@end
