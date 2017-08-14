//
//  LJMeetAudioContentView.h
//  news
//
//  Created by chunhui on 15/10/11.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJMeetAudioContentView : UIView

+(CGFloat)HeightForContent:(NSString *)content andWidth:(CGFloat)width;

-(void)setContent:(NSString *)content;

@end
