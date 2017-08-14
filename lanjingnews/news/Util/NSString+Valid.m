//
//  NSString+Valid.m
//  news
//
//  Created by 陈龙 on 15/12/17.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "NSString+Valid.h"

@implementation NSString (Valid)

- (NSString * _Nonnull)validStringWithDefault:(NSString * _Nonnull)defaultString
{
    NSString *rtnString = self;
    if (self.length == 0) {
        rtnString = defaultString;
    }
    return rtnString;
}

-(BOOL)isValidateEmail {
    NSString *emailRegex = @"^\\s*\\w+(?:\\.{0,1}[\\w-]+)*@[a-zA-Z0-9]+(?:[-.][a-zA-Z0-9]+)*\\.[a-zA-Z]+\\s*$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidateMobile
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd] && self.length == 0;

}
@end
