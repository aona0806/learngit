//
//  ZLPhotoThumbsToolbarView.h
//  CaiLianShe
//
//  Created by chunhui on 2016/10/17.
//  Copyright © 2016年 chenny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLPhotoThumbsToolbarView : UIView

@property(nonatomic , strong) NSArray *selectAssets;

@property(nonatomic , copy) void (^selectAtIndexBlock)(NSInteger index);

@property(nonatomic , copy) void (^doneBlock)();

-(UIImageView *)imageViewWithIndex:(NSInteger)index;

-(void)reloadData;

-(void)updateReddot:(NSArray*)selectArray;


@end
