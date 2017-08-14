//
//  LJTimeAxisView.m
//  news
//
//  Created by 奥那 on 15/12/22.
//  Copyright © 2015年 lanjing. All rights reserved.
//
#import "LJTimeAxisHeaderView.h"
#import "TKCommonTools.h"

@interface LJTimeAxisHeaderView ()

@end

@implementation LJTimeAxisHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self buildView];
    }
    return self;
}

- (void)setIsWeek:(BOOL)isWeek{
    _isWeek = isWeek;
        
    [self updateFrame];
}

- (void)buildView{
    
    topDateHeight = 30;
    
    self.topDateLabel = [[UILabel alloc] init];
    self.topDateLabel.backgroundColor = [UIColor whiteColor];
    self.topDateLabel.textColor = RGBACOLOR(133, 134, 136, 1);
    self.topDateLabel.font = [UIFont systemFontOfSize:14];
    self.topDateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.topDateLabel];
    
    self.calendar = [JTCalendar new];
    
    self.calendar.calendarAppearance.calendar.firstWeekday = 1; // Sunday == 1, Saturday == 7
    self.calendar.calendarAppearance.dayCircleRatio = 9. / 10.;
    self.calendar.calendarAppearance.ratioContentMenu = 1.;
    self.calendar.calendarAppearance.isWeekMode = _isWeek;
    
    self.calendarContentView = [[JTCalendarContentView alloc] init];
    self.calendarContentView.backgroundColor = [UIColor whiteColor];
    [self.calendar setContentView:self.calendarContentView];

    [self addSubview:self.calendarContentView];
    
    downLine = [[UIView alloc] init];
    downLine.backgroundColor = RGBACOLOR(186, 218, 243, 1);
    [self addSubview:downLine];
 }

- (void)updateFrame{
    
    viewHeight = 68;
    
    if (!_isWeek) {
        viewHeight = 220;
    }
    
    self.topDateLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, topDateHeight);
    self.calendarContentView.frame = CGRectMake(5, topDateHeight, SCREEN_WIDTH - 10, viewHeight);
    downLine.frame = CGRectMake(0, viewHeight + topDateHeight - 0.5, SCREEN_WIDTH, 0.5);
    self.calendar.calendarAppearance.isWeekMode = _isWeek;
    [self.calendar reloadAppearance];
    
}

@end
