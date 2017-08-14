//
//  InsetsLabel.h
//  news
//
//  Created by 陈龙 on 15/10/22.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  可调整insets的label
 */
@interface InsetsLabel : UILabel

@property(nonatomic) UIEdgeInsets edgeInsets;

-(instancetype) initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets) insets;
-(instancetype) initWithInsets: (UIEdgeInsets) insets;

@end
