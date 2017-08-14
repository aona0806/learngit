//
//  GuidancePageView.m
//  news
//
//  Created by wxc on 16/1/18.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "LJGuidancePageView.h"

#import <TKDefines.h>
#import "UIImage+GIF.h"

#define PageCount 2

@implementation LJGuidancePageView

-(void)drawFistActionRect
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.clipsToBounds = YES;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * PageCount , SCREEN_HEIGHT);
    [self addSubview: scrollView];
    
    for (int index = 0; index < PageCount; index ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(SCREEN_WIDTH * index, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = [UIColor clearColor];

        NSString *versionString = Is960Screen ? @"5.5": @"3.5";
        NSString *imageString = [NSString stringWithFormat:@"guidancepage_v%@_%d", versionString, index];
        
//        if (index < 2) {
//            UIImage *image = [UIImage sd_animatedGIFNamed:imageString];
//            imageView.image = image;
//        } else {
            NSString *path = [[NSBundle mainBundle] pathForResource:imageString ofType:@"jpg"];
            UIImage *image = [[UIImage alloc]initWithContentsOfFile:path];
            imageView.image = image;
//        }

        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [scrollView addSubview: imageView];
        
        if (index == PageCount - 1)
        {
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapSinger = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoRootControllerView)];
            [imageView addGestureRecognizer:tapSinger];
        }
    }
}

-(void)gotoRootControllerView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat offLength = scrollView.contentOffset.x;
    
    if (offLength >= SCREEN_WIDTH * (PageCount - 1))
    {
        [self gotoRootControllerView];
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

