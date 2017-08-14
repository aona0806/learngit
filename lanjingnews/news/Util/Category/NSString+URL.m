//
//  NSString+URL.m
//  news
//
//  Created by chunhui on 15/11/27.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "NSString+URL.h"
#import "NSString+Encode.h"
@import UIKit;

@implementation NSString (URL)

-(NSArray *)urlMatchesForRange:(NSRange)range
{
    NSError *error = nil;
    NSDataDetector *detector = [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:&error];
    
    NSArray *matches = [detector matchesInString:self options:kNilOptions range:NSMakeRange(0, self.length)];
    if ([matches count] == 0) {
        return nil;
    }
    
    NSString *pattern = @"((http|https)://)?([a-zA-Z0-9]([a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])?\\.)+(com|net|org|edu|gov|int|mil|cn|tel|biz|cc|tv|info|name|hk|mobi|asia|cd|travel|pro|museum|me|coop|aero|ad|ae|af|ag|ai|al|am|an|ao|aq|ar|as|at|au|aw|az|ba|bb|bd|be|bf|bg|bh|bi|bj|bm|bn|bo|br|bs|bt|bv|bw|by|bz|ca|cc|cf|cg|ch|ci|ck|cl|cm|co|cq|cr|cu|cv|cx|cy|cz|de|dj|dk|dm|do|dz|ec|ee|eg|eh|es|et|ev|fi|fj|fk|fm|fo|fr|ga|gb|gd|ge|gf|gh|gi|gl|gm|gn|gp|gr|gt|gu|gw|gy|hk|hm|hn|hr|ht|hu|id|ie|il|in|io|iq|ir|is|it|jm|jo|jp|ke|kg|kh|ki|km|kn|kp|kr|kw|ky|kz|la|lb|lc|li|lk|lr|ls|lt|lu|lv|ly|ma|mc|md|mg|mh|ml|mm|mn|mo|mp|mq|mr|ms|mt|mv|mw|mx|my|mz|na|nc|ne|nf|ng|ni|nl|no|np|nr|nt|nu|nz|om|qa|pa|pe|pf|pg|ph|pk|pl|pm|pn|pr|pt|pw|py|re|ro|ru|rw|sa|sb|sc|sd|se|sg|sh|si|sj|sk|sl|sm|sn|so|sr|st|su|sy|sz|tc|td|tf|tg|th|tj|tk|tm|tn|to|tp|tr|tt|tv|tw|tz|ua|ug|uk|us|uy|va|vc|ve|vg|vn|vu|wf|ws|ye|yu|za|zm|zr|zw)(/[a-zA-Z0-9_\\.]+)*(\\?([a-zA-Z0-9_+%\\.]+=[a-zA-Z0-9_+%\\.]+&)*([a-zA-Z0-9_+%\\.]+=[a-zA-Z0-9_+%\\.]+))?";
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:&error];
    
    NSMutableArray *urlMatches = [[NSMutableArray alloc]init];
    
    for (NSTextCheckingResult *match in matches) {
        
        matches = [expression matchesInString:self options:kNilOptions range:match.range];
        [urlMatches addObjectsFromArray:matches];
    }
    
    return urlMatches;
}


+(NSAttributedString *)urllinkAttributeString
{
    UIImage *image = [UIImage imageNamed:@"urllink_attach"];
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = image;
    
    UIFont *font = [UIFont systemFontOfSize:14];
    CGFloat size = 15;
    attach.bounds = CGRectMake(0, -2, size, size);
    
    NSAttributedString *attachString  = [NSAttributedString attributedStringWithAttachment:attach];
    NSMutableAttributedString *urlLink = [[NSMutableAttributedString alloc]init];
    [urlLink appendAttributedString:attachString];
    
    NSAttributedString *link = [[NSAttributedString alloc]initWithString:@"网页链接" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor colorWithRed:33/255.0 green:117/255.0 blue:204/255.0 alpha:1.0]}];
    [urlLink appendAttributedString:link];
    
    return urlLink;
}

-(NSURL *)tryEncodeURL {
    
    NSURL *url = [NSURL URLWithString:self];
    if (!url) {
        url = [self encodeURL];
    }
    return url;
}
@end
