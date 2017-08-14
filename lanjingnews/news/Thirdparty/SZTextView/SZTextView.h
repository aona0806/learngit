//
//  SZTextView.h
//  SZTextView
//
//  Created by glaszig on 14.03.13.
//  Copyright (c) 2013 glaszig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+Attribute.h"

//! Project version number for SZTextView.
FOUNDATION_EXPORT double SZTextViewVersionNumber;

//! Project version string for SZTextView.
FOUNDATION_EXPORT const unsigned char SZTextViewVersionString[];


IB_DESIGNABLE

/**
 *  TextView with placeholder
 */

@protocol PasteDelegate

- (void)VSPaste:(NSString *)string;

@end

@interface SZTextView : UITextView

@property (copy, nonatomic) IBInspectable NSString *placeholder;
@property (nonatomic) IBInspectable double fadeTime;
@property (copy, nonatomic) NSAttributedString *attributedPlaceholder;
@property (retain, nonatomic) UIColor *placeholderTextColor UI_APPEARANCE_SELECTOR;
@property id<PasteDelegate> pasteDelegate;

@property (retain, nonatomic) NSString *originalText;
-(NSString *)plainText;

@end
