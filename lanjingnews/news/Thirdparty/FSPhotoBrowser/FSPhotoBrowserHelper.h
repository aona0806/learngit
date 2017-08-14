//
//  FSPhotoBrowserHelper.h
//  news
//
//  Created by chunhui on 15/4/12.
//  Copyright (c) 2015年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSPhotoBrowser.h"

@interface FSPhotoBrowserHelper : NSObject

@property(nonatomic , strong) NSArray *placeHolderImages;
@property(nonatomic , assign) int currentIndex;
@property(nonatomic , weak) UIImageView *liftImageView;
@property (nonatomic, strong) NSArray *images;

@property (nonatomic) id<PhotoBrowerScrollImageViewDataSource> dataSource;

-(void)show;

@end
