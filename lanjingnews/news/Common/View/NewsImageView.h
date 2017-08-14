//
//  NewsImageView.h
//  news
//
//  Created by wxc on 2017/2/21.
//  Copyright © 2017年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>

//placeHolderImage随imageView变化居中
@interface NewsImageView : UIView

@property (nonatomic, strong, readonly) UIImageView *imageView;

@property (nonatomic, strong, readonly) UIImageView *holderImageView;

- (void)setImage:(NSURL*)imageUrl holderImage:(UIImage*)holderImage;

@end
