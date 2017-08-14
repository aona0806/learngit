//
//  NSString+Attribute.h
//  news
//
//  Created by chunhui on 15/11/27.
//  Copyright © 2015年 lanjing. All rights reserved.
//  Copy from chenlong
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Attribute)

- (NSMutableAttributedString *)showWithFont:(UIFont *) textFont
                            imageOffSet:(UIOffset) offset
                              lineSpace:(CGFloat) lineSpace;

- (NSMutableAttributedString *)showWithFont:(UIFont *) textFont
                                imageOffSet:(UIOffset) offset
                                  lineSpace:(CGFloat) lineSpace
                            imageWidthRatio:(CGFloat) imageRaite;

- (NSMutableAttributedString *)translateToUrlAttributedStringFrom:(NSMutableAttributedString *)attributedString;

@end
