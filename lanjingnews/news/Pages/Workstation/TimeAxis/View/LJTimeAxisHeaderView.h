//
//  LJTimeAxisView.h
//  news
//
//  Created by 奥那 on 15/12/22.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"

@interface LJTimeAxisHeaderView : UIView
{
    CGFloat topDateHeight;
    CGFloat viewHeight;
    UIView *downLine;
}

@property (nonatomic, retain) UILabel *topDateLabel;

@property (nonatomic, strong) JTCalendarContentView *calendarContentView;
@property (nonatomic, strong) JTCalendar *calendar;

@property (nonatomic, assign)BOOL isWeek;
@end
