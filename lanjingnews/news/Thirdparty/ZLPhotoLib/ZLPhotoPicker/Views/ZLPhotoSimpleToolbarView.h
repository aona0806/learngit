//
//  ZLPhotoSimpleToolbarView.h
//  CaiLianShe
//
//  Created by chunhui on 2016/10/17.
//  Copyright © 2016年 chenny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLPhotoSimpleToolbarView : UIView

@property(nonatomic , copy) void (^doneBlock)();

-(void)updateChooseImage:(NSInteger)choosed total:(NSInteger)total;

@end
