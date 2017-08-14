//
//  JTCalendarDayView.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarDayView.h"

#import "JTCircleView.h"

@interface JTCalendarDayView (){
    JTCircleView *circleView;
    UILabel *textLabel;
    UIImageView *dotView;
    
    BOOL isSelected;
    
    int cacheIsToday;
    NSString *cacheCurrentDateText;
}
@end

static NSString *kJTCalendarDaySelected = @"kJTCalendarDaySelected";

@implementation JTCalendarDayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}

- (void)commonInit
{
    isSelected = NO;
    self.isOtherMonth = NO;
    {
        circleView = [JTCircleView new];
//        self.clipsToBounds = NO;
        [self addSubview:circleView];
    }
    
    {
        textLabel = [UILabel new];
        textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:textLabel];
    }
    
    {
        dotView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4, 14, 8)];
        [self addSubview:dotView];
        dotView.hidden = YES;
    }
    
    {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouch)];

        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:gesture];
    }
    
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDaySelected:) name:kJTCalendarDaySelected object:nil];
    }
    
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comeBackToday:) name:@"comeBackToday" object:nil];
    }
}

- (void)layoutSubviews
{
    [self configureConstraintsForSubviews];
    
    // No need to call [super layoutSubviews]
}

// Avoid to calcul constraints (very expensive)
- (void)configureConstraintsForSubviews
{
    textLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    CGFloat sizeCircle = MIN(self.frame.size.width, self.frame.size.height);
//    CGFloat sizeDot = sizeCircle;
    
    sizeCircle = sizeCircle * self.calendarManager.calendarAppearance.dayCircleRatio;
//    sizeDot = sizeDot * self.calendarManager.calendarAppearance.dayDotRatio;
    
    sizeCircle = roundf(sizeCircle);
//    sizeDot = roundf(sizeDot);
    
    circleView.frame = CGRectMake(0, 0, sizeCircle, sizeCircle);
    circleView.center = CGPointMake(self.frame.size.width / 2., self.frame.size.height / 2.);
    circleView.layer.cornerRadius = sizeCircle / 2.;
    
//    dotView.frame = CGRectMake(0, 0, sizeDot + 2, sizeDot + 2);
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:textLabel.font forKey:NSFontAttributeName];
    CGSize strSize = [textLabel.text boundingRectWithSize:CGSizeMake(1000, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                     attributes:stringAttributes context:nil].size;
    CGFloat textHeight = strSize.height;
    dotView.center = CGPointMake(self.frame.size.width / 2. , (self.frame.size.height / 2.) + textHeight / 2 + 3);
    
//    dotView.layer.cornerRadius = sizeDot / 2.;
}

- (void)setDate:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = self.calendarManager.calendarAppearance.calendar.timeZone;
        [dateFormatter setDateFormat:@"dd"];
    }
    
    self->_date = date;
    
    textLabel.text = [dateFormatter stringFromDate:date];
    
    cacheIsToday = -1;
    cacheCurrentDateText = nil;
}

- (void) comeBackToday:(NSNotification *)notification
{
    NSDate *dateSelected = [notification object];
    
    [self.calendarManager setCurrentDateSelected:dateSelected];

    
    [[NSNotificationCenter defaultCenter] postNotificationName:kJTCalendarDaySelected object:dateSelected];
    
}

- (void)didTouch
{
    [self setSelected:YES animated:YES];
    [self.calendarManager setCurrentDateSelected:self.date];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kJTCalendarDaySelected object:self.date];
    
    [self.calendarManager.dataSource calendarDidDateSelected:self.calendarManager date:self.date];
    
    [self.calendarManager.dataSource otherCalendarSeclect:self.calendarManager date:self.date];
    
    if(!self.isOtherMonth){
        return;
    }
    
    NSInteger currentMonthIndex = [self monthIndexForDate:self.date];
    NSInteger calendarMonthIndex = [self monthIndexForDate:self.calendarManager.currentDate];
        
    currentMonthIndex = currentMonthIndex % 12;
    
    if(currentMonthIndex == (calendarMonthIndex + 1) % 12){
        [self.calendarManager loadNextMonth];
    }
    else if(currentMonthIndex == (calendarMonthIndex + 12 - 1) % 12){
        [self.calendarManager loadPreviousMonth];
    }
}

- (void)didDaySelected:(NSNotification *)notification
{
    
    NSDate *dateSelected = [notification object];
    
    if([self isSameDate:dateSelected]){
        if(!isSelected){
            [self setSelected:YES animated:YES];
        }
    }
    else if(isSelected){
        [self setSelected:NO animated:YES];
        
        if (dotView.hidden)
        {
            dotView.hidden = NO;
            dotView.alpha = 0;
            [UIView animateWithDuration:0.3 animations:^{
                dotView.alpha = 1;
            } completion:^(BOOL finished) {
                dotView.hidden = NO;
            }];
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if(isSelected == selected){
        animated = NO;
    }
    
    isSelected = selected;
    
    circleView.transform = CGAffineTransformIdentity;
    CGAffineTransform tr = CGAffineTransformIdentity;
    CGFloat opacity = 1.;
    
    if(selected)
    {
        if(!self.isOtherMonth)
        {
            circleView.color = [self.calendarManager.calendarAppearance dayCircleColorSelected];
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorSelected];
            dotView.backgroundColor = [self.calendarManager.calendarAppearance dayDotColorSelected];

            dotView.hidden = YES;
            
        }
        else
        {
            circleView.color = [self.calendarManager.calendarAppearance dayCircleColorSelectedOtherMonth];
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorSelectedOtherMonth];
            dotView.backgroundColor = [self.calendarManager.calendarAppearance dayDotColorSelectedOtherMonth];
        }
        
        circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
        tr = CGAffineTransformIdentity;
    }
    else if([self isToday])
    {
        if(!self.isOtherMonth)
        {
            circleView.color = [self.calendarManager.calendarAppearance dayCircleColorToday];
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorToday];
            dotView.backgroundColor = [self.calendarManager.calendarAppearance dayDotColorToday];
        }
        else
        {
            circleView.color = [self.calendarManager.calendarAppearance dayCircleColorTodayOtherMonth];
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorTodayOtherMonth];
            dotView.backgroundColor = [self.calendarManager.calendarAppearance dayDotColorTodayOtherMonth];
        }
    }
    else
    {
        if(!self.isOtherMonth)
        {
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColor];
            dotView.backgroundColor = [self.calendarManager.calendarAppearance dayDotColor];
        }
        else
        {
            textLabel.textColor = [self.calendarManager.calendarAppearance dayTextColorOtherMonth];
            dotView.backgroundColor = [self.calendarManager.calendarAppearance dayDotColorOtherMonth];
        }
        
        opacity = 0.;
    }
    
    if(animated){
        [UIView animateWithDuration:.3 animations:^{
            circleView.layer.opacity = opacity;
            circleView.transform = tr;
        }];
    }
    else{
        circleView.layer.opacity = opacity;
        circleView.transform = tr;
    }
}

- (void)setIsOtherMonth:(BOOL)isOtherMonth
{
    self->_isOtherMonth = isOtherMonth;
    [self setSelected:isSelected animated:NO];
}

- (void)reloadData
{
    NSString *typeStr = [self.calendarManager.dataSource calendarHaveEvent:self.calendarManager date:self.date];
    if ([typeStr isEqualToString:@"0"])
    {
        dotView.image = [[UIImage alloc] init];
        dotView.hidden = YES;
    }
    else if ([typeStr isEqualToString:@"2"])
    {
        dotView.image = [UIImage imageNamed:@"timeAxis_mark3"];
        dotView.hidden = NO;
    }
    else if ([typeStr isEqualToString:@"4"])
    {
        dotView.image = [UIImage imageNamed:@"timeAxis_mark1"];
        dotView.hidden = NO;
    }
    else if ([typeStr isEqualToString:@"8"])
    {
        dotView.image = [UIImage imageNamed:@"timeAxis_mark2"];
        dotView.hidden = NO;
    }
    else if ([typeStr isEqualToString:@"6"])
    {
        dotView.image = [UIImage imageNamed:@"timeAxis_mark5"];
        dotView.hidden = NO;
    }
    else if ([typeStr isEqualToString:@"10"])
    {
        dotView.image = [UIImage imageNamed:@"timeAxis_mark6"];
        dotView.hidden = NO;
    }
    else if ([typeStr isEqualToString:@"12"])
    {
        dotView.image = [UIImage imageNamed:@"timeAxis_mark4"];
        dotView.hidden = NO;
    }
    else if ([typeStr isEqualToString:@"14"])
    {
        dotView.image = [UIImage imageNamed:@"timeAxis_mark7"];
        dotView.hidden = NO;
    }
    
    BOOL selected = [self isSameDate:[self.calendarManager currentDateSelected]];
    [self setSelected:selected animated:NO];
}

- (BOOL)isToday
{
    if(cacheIsToday == 0){
        return NO;
    }
    else if(cacheIsToday == 1){
        return YES;
    }
    else{
        if([self isSameDate:[NSDate date]]){
            cacheIsToday = 1;
            return YES;
        }
        else{
            cacheIsToday = 0;
            return NO;
        }
    }
}

- (BOOL)isSameDate:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = self.calendarManager.calendarAppearance.calendar.timeZone;
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    }
    
    if(!cacheCurrentDateText){
        cacheCurrentDateText = [dateFormatter stringFromDate:self.date];
    }
    
    NSString *dateText2 = [dateFormatter stringFromDate:date];
    
    if ([cacheCurrentDateText isEqualToString:dateText2]) {
        return YES;
    }
    
    return NO;
}

- (NSInteger)monthIndexForDate:(NSDate *)date
{
    NSCalendar *calendar = self.calendarManager.calendarAppearance.calendar;
    NSDateComponents *comps = [calendar components:NSCalendarUnitMonth fromDate:date];
    return comps.month;
}

- (void)reloadAppearance
{
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = self.calendarManager.calendarAppearance.dayTextFont;
    
    [self configureConstraintsForSubviews];
    [self setSelected:isSelected animated:NO];
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
