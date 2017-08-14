//
//  NSString+Attribute.m
//  news
//
//  Created by chunhui on 15/11/27.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "NSString+Attribute.h"
#import "KILabel.h"
#import "NSString+URL.h"

@implementation NSString (Attribute)

- (NSMutableAttributedString *)showWithFont:(UIFont *) textFont
                                imageOffSet:(UIOffset) offset
                                  lineSpace:(CGFloat) lineSpace
{
    return [self showWithFont:textFont imageOffSet:offset lineSpace:lineSpace imageWidthRatio:1.0];
}

- (NSMutableAttributedString *)showWithFont:(UIFont *) textFont
                                imageOffSet:(UIOffset) offset
                                  lineSpace:(CGFloat) lineSpace
                            imageWidthRatio:(CGFloat) imageRaite
{
    if (self.length == 0) {
        return [[NSMutableAttributedString alloc]initWithString:@""];
    }
    //创建一个可变的属性字符串
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    
    [attributeString addAttribute:NSFontAttributeName
                            value:textFont
                            range:NSMakeRange(0, self.length)];
    
    NSError *error = nil;
    //正则匹配要替换的文字的范围
    //正则表达式
    NSString * pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSError *faceError = nil;
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&faceError];
    
    if (!re) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    //通过正则表达式来匹配字符串
    NSArray *resultArray = [re matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    if (resultArray.count == 0) {
        return attributeString;
    }
    static NSArray *face = nil;
    if (face == nil) {
            //加载plist文件中的数据
        NSBundle *bundle = [NSBundle mainBundle];
        //寻找资源的路径
        NSString *path = [bundle pathForResource:@"emoticons" ofType:@"json"];
        //获取plist中的数据
        NSData *faceData = [NSData dataWithContentsOfFile:path];
        
        face = [NSJSONSerialization JSONObjectWithData:faceData options:kNilOptions error:&error];
    }
    
    //用来存放字典，字典中存储的是图片和图片对应的位置
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    
    //根据匹配范围来用图片进行相应的替换
    for(NSTextCheckingResult *match in resultArray) {
        //获取数组元素中得到range
        NSRange range = [match range];
        
        //获取原字符串中对应的值
        NSString *subStr = [self substringWithRange:range];
        
        for (int i = 0; i < face.count; i ++)
        {
            if ([face[i][@"chs"] isEqualToString:subStr])
            {
                
                //face[i][@"gif"]就是我们要加载的图片
                //新建文字附件来存放我们的图片
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                
                //给附件添加图片
                textAttachment.image = [UIImage imageNamed:face[i][@"png"]];
                textAttachment.bounds = CGRectMake(offset.horizontal, offset.vertical, textFont.pointSize * imageRaite, textFont.pointSize * imageRaite);
                
                //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
                NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                
                //把图片和图片对应的位置存入字典中
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                [imageDic setObject:imageStr forKey:@"image"];
                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                
                //把字典存入数组中
                [imageArray addObject:imageDic];
            }
        }
    }
    
    if (imageArray.count == 0) {
        return attributeString;
    }
    
    //从后往前替换
    for (int i = (int)imageArray.count -1; i >= 0; i--)
    {
        NSRange range;
        [imageArray[i][@"range"] getValue:&range];
        //进行替换
        [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
        
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributeString.length)];
    
    [attributeString addAttribute:NSKernAttributeName value:@(0.0) range:NSMakeRange(0, attributeString.length)];
    return  attributeString;
    
    return nil;
}

- (NSMutableAttributedString *)translateToUrlAttributedStringFrom:(NSMutableAttributedString *)attributedString
{
    NSMutableString *plainText = [NSMutableString stringWithString:self];
    NSArray *matches = [KILabel urlMatchesForText:plainText range:NSMakeRange(0, plainText.length)];
    
    NSMutableAttributedString *tempAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
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
