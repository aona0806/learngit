//
//  LJMeetVoiceItemView.h
//  news
//
//  Created by chunhui on 15/9/26.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJMeetVoiceItemView : UIControl

@property(nonatomic , copy)NSString *duration;
@property(nonatomic , assign) BOOL alignLeft;

-(void)playAnimate:(BOOL)play;

@end
