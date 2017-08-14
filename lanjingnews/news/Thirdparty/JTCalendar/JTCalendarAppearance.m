//
//  JTCalendarAppearance.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarAppearance.h"

@implementation JTCalendarAppearance

- (instancetype)init
{
    self = [super init];
    if(!self){
        return nil;
    }
        
    [self setDefaultValues];
    
    return self;
}

- (void)setDefaultValues
{
    self.isWeekMode = NO;
    
    self.weekDayFormat = JTCalendarWeekDayFormatShort;
    
    self.ratioContentMenu = 2.;
    self.dayCircleRatio = 1.;
    self.dayDotRatio = 1. / 9.;
    
    self.menuMonthTextFont = [UIFont systemFontOfSize:17.];
    self.weekDayTextFont = [UIFont systemFontOfSize:14];
    self.dayTextFont = [UIFont systemFontOfSize:14];
    
    self.menuMonthTextColor = [UIColor blackColor];
    self.weekDayTextColor = RGBACOLOR(12, 89, 159, 1);
    
    [self setDayDotColorForAll:RGBACOLOR(255, 255, 255, 0)];
    [self setDayTextColorForAll:RGBACOLOR(12, 89, 159, 1)];
    
    self.dayTextColorOtherMonth = RGBACOLOR(178, 191, 208, 1);

    self.dayCircleColorSelected = RGBACOLOR(28, 136, 208, 1);
    self.dayTextColorSelected = RGBACOLOR(12, 89, 159, 1);
    
    self.dayDotColorSelected = RGBACOLOR(255, 255, 255, 0);///////////
    
    self.dayCircleColorSelectedOtherMonth = self.dayCircleColorSelected;
    self.dayTextColorSelectedOtherMonth = self.dayTextColorSelected;
    self.dayDotColorSelectedOtherMonth = self.dayDotColorSelected;
    
    self.dayCircleColorToday = RGBACOLOR(251, 126, 135, 1.0);
//    self.dayCircleColorToday = [UIColor clearColor];
    
    self.dayTextColorToday = RGBACOLOR(12, 89, 159, 1);
    self.dayDotColorToday = RGBACOLOR(255, 255, 255, 0);/////////////
    
    self.dayCircleColorTodayOtherMonth = self.dayCircleColorToday;
    self.dayTextColorTodayOtherMonth = self.dayTextColorToday;
    self.dayDotColorTodayOtherMonth = self.dayDotColorToday;
}

- (NSCalendar *)calendar
{
    static NSCalendar *calendar;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        calendar.timeZone = [NSTimeZone localTimeZone];
    });
    
    return calendar;
}

- (void)setDayDotColorForAll:(UIColor *)dotColor
{
    self.dayDotColor = dotColor;
    self.dayDotColorSelected = dotColor;
    
    self.dayDotColorOtherMonth = dotColor;
    self.dayDotColorSelectedOtherMonth = dotColor;
    
    self.dayDotColorToday = dotColor;
    self.dayDotColorTodayOtherMonth = dotColor;
}

- (void)setDayTextColorForAll:(UIColor *)textColor
{
    self.dayTextColor = textColor;
    self.dayTextColorSelected = textColor;
    
    self.dayTextColorOtherMonth = textColor;
    self.dayTextColorSelectedOtherMonth = textColor;
    
    self.dayTextColorToday = textColor;
    self.dayTextColorTodayOtherMonth = textColor;
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
