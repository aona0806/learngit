//
//  LYKeyBoardView.h
//  6park
//
//  Created by TI on 15/5/5.
//  Copyright (c) 2015年 6park. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

+(UIColor*)RGBAColorR:(float)r G:(float)g B:(float)b A:(float)a{
    
    return [self colorWithRed:r/255 green:g/255 blue:b/255 alpha:a];
}

+(UIColor*)RGBColorR:(float)r G:(float)g B:(float)b{
    return [self RGBAColorR:r G:g B:b A:1];
}

+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

//+ (UIColor*) colorWithHex:(NSInteger)hexValue
//{
//    return [UIColor colorWithHex:hexValue alpha:1.0];
//}
//
//+ (NSString *) hexFromUIColor: (UIColor*) color {
//    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
//        const CGFloat *components = CGColorGetComponents(color.CGColor);
//        color = [UIColor colorWithRed:components[0]
//                                green:components[0]
//                                 blue:components[0]
//                                alpha:components[1]];
//    }
//    
//    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
//        return [NSString stringWithFormat:@"#FFFFFF"];
//    }
//    
//    return [NSString stringWithFormat:@"#%x%x%x", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
//            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
//            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
//}

//lightgreen RGB:24-161-133
+(UIColor*)LightGreen{
    return [self RGBColorR:24 G:161 B:133];
}

//grey RGB:149-165-166
+(UIColor*)Grey{
    return [self RGBColorR:149 G:165 B:166];
}

//whitesmoke RGB:236-240-241
+(UIColor*)WhiteSmoke{
    return [self RGBColorR:236 G:240 B:241];
}
//darkgreen RGB:45-63-81
+(UIColor*)DarkGreen{
    return [self RGBColorR:45 G:63 B:81];
}
//lightgrey RGB:221-221-221
+(UIColor*)LightGrey{
    return [self RGBColorR:221 G:221 B:221];
}
//darkgrey RGB:169-169-169
+(UIColor*)DarkGrey{
    return [self RGBColorR:169 G:169 B:169];
}
//lightsmoke RGB:252-252-252
+(UIColor*)LightSmoke{
    return [self RGBColorR:252 G:252 B:252];
}
//greysmoke RGB:249-247-247
+(UIColor*)GreySmoke{
    return [self RGBColorR:249 G:247 B:247];
}
//deepGreen RGB:30-150-125
+(UIColor*)deepGreen{
    return [self RGBColorR:30 G:150 B:125];
}
//lightRed RGB:238-82-77
+(UIColor*)lightRed{
    return [self RGBColorR:238 G:82 B:77];
}
//tintGreen RGB:216-236-231
+(UIColor*)tintGreen{
    return [self RGBColorR:216 G:236 B:231];
}
//whiteDeep RGB:237-241-242
+(UIColor*)whiteDeep{
    return [self RGBColorR:237 G:241 B:242];
}
@end
