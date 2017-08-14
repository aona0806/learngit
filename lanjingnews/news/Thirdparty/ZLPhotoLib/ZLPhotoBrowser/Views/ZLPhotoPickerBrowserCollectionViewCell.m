//
//  ZLPhotoPickerBrowserCollectionViewCell.m
//  CaiLianShe
//
//  Created by chunhui on 2016/10/18.
//  Copyright © 2016年 chenny. All rights reserved.
//

#import "ZLPhotoPickerBrowserCollectionViewCell.h"
#import "ZLPhotoPickerBrowserPhotoScrollView.h"

@interface ZLPhotoPickerBrowserCollectionViewCell ()<ZLPhotoPickerPhotoScrollViewDelegate>

@property(nonatomic , strong) ZLPhotoPickerBrowserPhotoScrollView *photoScrollView;

@end

@implementation ZLPhotoPickerBrowserCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self  = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIView *scrollBoxView = [[UIView alloc] init];
        scrollBoxView.frame = [UIScreen mainScreen].bounds;
        scrollBoxView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:scrollBoxView];
        
        ZLPhotoPickerBrowserPhotoScrollView *scrollView =  [[ZLPhotoPickerBrowserPhotoScrollView alloc] init];
        scrollView.backgroundColor = [UIColor clearColor];
        // 为了监听单击photoView事件
        scrollView.frame = [UIScreen mainScreen].bounds;
        [scrollBoxView addSubview:scrollView];
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        self.photoScrollView = scrollView;
    }
    return self;
}

-(void)updateWithModel:(ZLPhotoPickerBrowserPhoto *)photo
{
    dispatch_async(dispatch_get_main_queue(), ^{        
        self.photoScrollView.photo = photo;
    });
}

@end
