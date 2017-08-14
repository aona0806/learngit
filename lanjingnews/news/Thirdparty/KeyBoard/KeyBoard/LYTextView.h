//
//  LYTextView.h
//  chatUI
//
//  Created by TI on 15/4/21.
//  Copyright (c) 2015年 YccTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmoTaxtAttachment.h"
#import "SZTextView.h"

@interface LYTextView : SZTextView<NSTextStorageDelegate,UITextViewDelegate>

@property (nonatomic, strong)NSString * plainText;
@property (nonatomic, strong)UIResponder *customNextResponder;

/**
 *  将字符串str改为键盘输入表情
 *
 *  @param str       <#str description#>
 *  @param textFont  <#textFont description#>
 *  @param offset    <#offset description#>
 *  @param lineSpace <#lineSpace description#>
 *
 *  @return <#return value description#>
 */
+ (NSMutableAttributedString *)showFace:(NSString *)str
                               WithFont:(UIFont *) textFont
                            imageOffSet:(UIOffset) offset
                              lineSpace:(CGFloat) lineSpace;
@end
