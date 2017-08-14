//
//  UIBarButtonItem+Navigation.m
//  news
//
//  Created by chunhui on 15/12/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "UIBarButtonItem+Navigation.h"

@implementation UIBarButtonItem (Navigation)

+(UIBarButtonItem *)defaultLeftItemWithTarget:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"navi_back"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateHighlighted];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    return item;
}

+(UIBarButtonItem *)createItemWithTarget:(id)target action:(SEL)action image:(NSString*)imageName
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateHighlighted];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    item.target = target;
    item.action = action;
    
    return item;
}

-(void)changeImage:(NSString*)imageName
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateHighlighted];
    [button sizeToFit];
    [button addTarget:self.target action:self.action forControlEvents:UIControlEventTouchUpInside];
    
    [self setCustomView:button];
}

@end
