//
//  JTCircleView.h
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCircleView.h"

// http://stackoverflow.com/questions/17038017/ios-draw-filled-circles

@implementation JTCircleView

- (instancetype)init
{
    self = [super init];
    if(!self){
        return nil;
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.color = [UIColor whiteColor];
    
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
//    CGContextSetFillColorWithColor(ctx, [self.backgroundColor CGColor]);
//    CGContextFillRect(ctx, rect);
//
//    
//    rect = CGRectInset(rect, .5, .5);
//    
//    CGContextSetStrokeColorWithColor(ctx, [self.color CGColor]);
//    CGContextSetFillColorWithColor(ctx, [self.color CGColor]);
//    
//    CGContextAddEllipseInRect(ctx, rect);
//    CGContextFillEllipseInRect(ctx, rect);
//    
//    CGContextFillPath(ctx);
    
    

    
    
    rect = CGRectInset(rect, .5, .5);
    
    const CGFloat *components = CGColorGetComponents(self.color.CGColor);
    
    CGFloat alpheLine = 1.0;
    if (components[0] == 0 || components[1] == 0 || components[2] == 0)
    {
        alpheLine = 0.0;
    }
    
    CGContextSetRGBStrokeColor(ctx,components[0],components[1],components[2],alpheLine);//画笔线的颜色

    CGContextSetLineWidth(ctx, 1.0);//线的宽度
    //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
    CGContextAddArc(ctx, rect.origin.x + 13.5, rect.origin.y + 13.5, 13.5, 0, 2*M_PI, 0); //添加一个圆
    CGContextDrawPath(ctx, kCGPathStroke);
    
}

- (void)setColor:(UIColor *)color
{
    self->_color = color;
    
    [self setNeedsDisplay];
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
