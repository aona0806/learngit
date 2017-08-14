//
//  NewsImageView.m
//  news
//
//  Created by wxc on 2017/2/21.
//  Copyright © 2017年 lanjing. All rights reserved.
//

#import "NewsImageView.h"

@interface NewsImageView ()

@property (nonatomic, strong) UIImageView *holderImageView;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation NewsImageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.holderImageView];
    }
    
    return self;
}

- (UIImageView*)holderImageView
{
    if (!_holderImageView) {
        _holderImageView = [[UIImageView alloc]init];
        _holderImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _holderImageView;
}

- (UIImageView*)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
    }
    
    return _imageView;
}

- (void)setImage:(NSURL*)imageUrl holderImage:(UIImage*)holderImage
{
    _holderImageView.hidden = NO;
    _holderImageView.image = holderImage;
    
    if (holderImage != nil) {
        CGFloat imageWidth;
        CGFloat imageHeight;
        
        if (holderImage.size.width /holderImage.size.height > self.frame.size.width / self.frame.size.height) {
            imageWidth = self.frame.size.width;
            imageHeight = (self.frame.size.width * holderImage.size.height /holderImage.size.width);
        }else{
            imageHeight = self.frame.size.height;
            imageWidth = (self.frame.size.height * holderImage.size.width /holderImage.size.height);
        }
        
        _holderImageView.frame = CGRectMake(0, 0, imageWidth, imageHeight);
        _holderImageView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    }
    
    _imageView.frame = self.bounds;
    
    [_imageView sd_setImageWithURL:imageUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            _holderImageView.hidden = YES;
        }
    }];
}

@end

