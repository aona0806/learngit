//
//  LYTextView.m
//  chatUI
//
//  Created by TI on 15/4/21.
//  Copyright (c) 2015年 YccTime. All rights reserved.
//

#import "LYTextView.h"
@interface LYTextView()

@end

@implementation LYTextView

-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(UIResponder *)nextResponder
{
    if (_customNextResponder) {
        return _customNextResponder;
    }
    return [super nextResponder];
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (_customNextResponder) {
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.textStorage.delegate = self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.textStorage.delegate = self;
        self.dataDetectorTypes = UIDataDetectorTypeAll;
    }
    return self;
}

-(NSString *)plainText{
    
    NSRange range = NSMakeRange(0, self.attributedText.length);
    NSMutableAttributedString *result = [self.attributedText mutableCopy];
    
    [result enumerateAttribute:NSAttachmentAttributeName inRange:range options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value && [value isKindOfClass:[EmoTaxtAttachment class]]) {
            EmoTaxtAttachment *attach = (EmoTaxtAttachment *)value;
            [result deleteCharactersInRange:range];
            [result insertAttributedString:[[NSAttributedString alloc] initWithString:attach.emoName] atIndex:range.location];
        }
    }];
    return result.string;
}

//显示表情,用属性字符串显示表情
+ (NSMutableAttributedString *)showFace:(NSString *)str
                               WithFont:(UIFont *) textFont
                            imageOffSet:(UIOffset) offset
                              lineSpace:(CGFloat) lineSpace
{
    if (str != nil) {
        //加载plist文件中的数据
        NSBundle *bundle = [NSBundle mainBundle];
        //寻找资源的路径
        NSString *path = [bundle pathForResource:@"emoticons" ofType:@"json"];
        //获取plist中的数据
        NSData *faceData = [NSData dataWithContentsOfFile:path];
        NSError *error;
        NSArray *face = [NSJSONSerialization JSONObjectWithData:faceData options:kNilOptions error:&error];
        
        //创建一个可变的属性字符串
        
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:str];
        
        [attributeString addAttribute:NSFontAttributeName
                                value:textFont
                                range:NSMakeRange(0, str.length)];
        
        //        var body = NSMutableAttributedString(string: info.body)
        //        var para = NSMutableParagraphStyle()
        //        para.lineSpacing = Consts.ForwardLineSpacing
        
        //正则匹配要替换的文字的范围
        //正则表达式
        NSString * pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        NSError *faceError = nil;
        NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&faceError];
        
        if (!re) {
            NSLog(@"%@", [error localizedDescription]);
        }
        
        //通过正则表达式来匹配字符串
        NSArray *resultArray = [re matchesInString:str options:0 range:NSMakeRange(0, str.length)];
        
        
        //用来存放字典，字典中存储的是图片和图片对应的位置
        NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
        
        //根据匹配范围来用图片进行相应的替换
        for(NSTextCheckingResult *match in resultArray) {
            //获取数组元素中得到range
            NSRange range = [match range];
            
            //获取原字符串中对应的值
            NSString *subStr = [str substringWithRange:range];
            
            for (int i = 0; i < face.count; i ++)
            {
                if ([face[i][@"chs"] isEqualToString:subStr])
                {
                    
                    //face[i][@"gif"]就是我们要加载的图片
                    //新建文字附件来存放我们的图片
                    EmoTaxtAttachment *textAttachment = [[EmoTaxtAttachment alloc] initWithData:nil ofType:nil];
                    
                    textAttachment.emoName = subStr;
                    textAttachment.Top = -3.5;
                    
                    //给附件添加图片
                    textAttachment.image = [UIImage imageNamed:face[i][@"png"]];
                    CGFloat lineHeight = textFont.pointSize;
                    textAttachment.bounds = CGRectMake(offset.horizontal, offset.vertical, lineHeight, lineHeight);
                    
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
        
    }
    
    return nil;
    
}

@end
