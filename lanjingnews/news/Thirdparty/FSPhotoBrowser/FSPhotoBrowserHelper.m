//
//  FSPhotoBrowserHelper.m
//  news
//
//  Created by chunhui on 15/4/12.
//  Copyright (c) 2015年 lanjing. All rights reserved.
//

#import "FSPhotoBrowserHelper.h"



@interface FSPhotoBrowserHelper()<PhotoBrowerScrollImageViewDataSource,PhotoBrowerScrollImageViewDelegate>

@end

@implementation FSPhotoBrowserHelper

-(void)show
{
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    FSPhotoBrowser *view = [[FSPhotoBrowser alloc] initWithFrame:frame];
    if (self.dataSource) {
        view.dataSource = self.dataSource;
    } else {
        [view setDataSource:self];
    }
    [view setDelegate:self];
    [view setNumberOfImages:[self.placeHolderImages count] andCurrentImageIndex:_currentIndex];
    view.liftImageView = self.liftImageView;
    
    
    __block typeof(FSPhotoBrowser *) __weak browser = view;
    [view setTapBlock:^() {
        [browser willRemovePhotoBrowser];
    }];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:view];
}

- (UIImage *)imagePhotoPlaceHolder:(FSPhotoBrowser *)browser
                           atIndex:(NSInteger)index
{
    UIImage *image = nil;
    if (self.placeHolderImages && self.placeHolderImages.count > index) {
        image = [self.placeHolderImages objectAtIndex:index];
    }
    return image;
}

- (NSObject *)photoBrowser:(FSPhotoBrowser *)browser
       requestDataWithType:(PhotoBrowerScrollRequestDataType)type
                   atIndex:(NSInteger)index
{
    NSObject *object = nil;
    if (self.images && self.images.count > index) {
        object = [self.images objectAtIndex:index];
    }
    return object;
}

@end
