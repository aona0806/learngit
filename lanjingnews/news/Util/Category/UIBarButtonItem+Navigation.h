//
//  UIBarButtonItem+Navigation.h
//  news
//
//  Created by chunhui on 15/12/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Navigation)

+(UIBarButtonItem *)defaultLeftItemWithTarget:(id)target action:(SEL)action;

+(UIBarButtonItem *)createItemWithTarget:(id)target action:(SEL)action image:(NSString*)imageName;

-(void)changeImage:(NSString*)imageName;

@end
