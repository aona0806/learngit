//
//  LJUIInitManagerExtend.m
//  news
//
//  Created by chunhui on 2017/1/6.
//  Copyright © 2017年 lanjing. All rights reserved.
//

#import "LJUIInitManagerExtend.h"
@import UIKit;


@implementation LJUIInitManagerExtend

+(void)navbariOS8Init
{

    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:[UIImagePickerController class], nil];
    bar.tintColor = [UIColor blackColor];
    
    UIBarButtonItem *item = [UIBarButtonItem appearanceWhenContainedIn:[UIViewController class], nil];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    
}

@end
