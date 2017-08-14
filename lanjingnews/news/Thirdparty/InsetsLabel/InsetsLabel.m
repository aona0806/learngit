//
//  InsetsLabel.m
//  news
//
//  Created by 陈龙 on 15/10/22.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "InsetsLabel.h"

@implementation InsetsLabel

-(instancetype)initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets {
    
    self = [super initWithFrame:frame];
    if(self){
        self.edgeInsets = insets;
    }
    return self;
}

-(instancetype)initWithInsets:(UIEdgeInsets)insets {
    self = [super init];
    if(self){
        self.edgeInsets = insets;
    }
    return self;
}

-(void) drawTextInRect:(CGRect)rect {
    
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

@end
