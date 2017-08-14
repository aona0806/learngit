//
//  LJNavigationTipStatusBar.h
//  Demo
//
//  Created by chunhui on 15/10/28.
//  Copyright © 2015年 chunhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJNavigationTipStatusBar : UIControl

-(void)updateTip:(NSString *)tip;
/**
 *  回到会议开始闪动
 */
-(void)startFlash;
/**
 *  回到会议停止闪动
 */
-(void)stopFlash;

@end
