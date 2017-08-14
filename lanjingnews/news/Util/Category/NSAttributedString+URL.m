//
//  NSAttributedString+URL.m
//  news
//
//  Created by chunhui on 15/11/27.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "NSAttributedString+URL.h"
#import "NSString+URL.h"

@implementation NSAttributedString (URL)

- (NSMutableAttributedString *) addTapClick:(NSMutableAttributedString *) attributeString
{
    return attributeString;
}

- (NSMutableAttributedString *)translateToUrlAttributedString
{
    NSMutableString *plainText = [NSMutableString stringWithString:self.string];
    NSArray *matches = [plainText urlMatchesForRange:NSMakeRange(0, plainText.length)];
    
    NSMutableAttributedString *tempAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self];
    for (NSInteger i = [matches count] - 1; i >= 0; --i)
    {
        NSTextCheckingResult *match = matches[i];
        NSRange range = NSMakeRange([match range].location , [match range].length);
        
        NSAttributedString *urlString = [NSString urllinkAttributeString];
        [tempAttributedString replaceCharactersInRange:range withAttributedString:urlString];
        
    }
    return tempAttributedString;
}


@end
