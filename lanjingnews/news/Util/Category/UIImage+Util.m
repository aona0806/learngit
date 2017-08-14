//
//  UIImage+Util.m
//  news
//
//  Created by 陈龙 on 16/1/14.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "UIImage+Util.h"

@implementation UIImage (Util)

- (UIImage *)translateToSquareImage {
    
    CGSize originalsize = [self size];
    
    if ( originalsize.width - originalsize.height > -1 && originalsize.width - originalsize.height < 1) {
        return self;
    }
    @autoreleasepool {
        
        CGImageRef imageRef = nil;
        
        CGFloat minWidth = MIN(originalsize.width, originalsize.height);
        CGSize size = CGSizeMake(minWidth, minWidth);
        
        
        CGFloat scale = self.scale;
        
        imageRef = CGImageCreateWithImageInRect([self CGImage], CGRectMake((originalsize.width - size.width)/2*scale, (originalsize.height - size.height)/2*scale, size.width*scale, size.height*scale));
        
        UIImage *image =  [UIImage imageWithCGImage:imageRef];
        
        CGImageRelease(imageRef);
        
        return image;
    }
    
}

@end
