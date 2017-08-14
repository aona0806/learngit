//
//  CSArgueImagesView.h
//  CaiLianShe
//
//  Created by chunhui on 16/7/7.
//  Copyright © 2016年 chenny. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LJNewsRollListDataListRollImgsModel;

@interface LJTelegraphImagesView : UIView

@property(nonatomic , copy) void (^tapBlock)(NSInteger index,NSInteger section , UIImageView *imageView);

@property(nonatomic , copy) void (^singleThumbLoaddoneBlock)(UIImage *image);

+(CGFloat)heightForModel:(NSArray *)images width:(CGFloat)width;

-(void)updateWithImages:(NSArray<LJNewsRollListDataListRollImgsModel *> *)images width:(CGFloat)width;

-(UIImageView *)imageAtIndex:(NSInteger)index;

@end
