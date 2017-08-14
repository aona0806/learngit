//
//  ZLPhotoPickerBrowserCollectionViewCell.h
//  CaiLianShe
//
//  Created by chunhui on 2016/10/18.
//  Copyright © 2016年 chenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLPhotoPickerBrowserPhotoScrollView.h"


@interface ZLPhotoPickerBrowserCollectionViewCell : UICollectionViewCell

@property(nonatomic , strong ,readonly) ZLPhotoPickerBrowserPhotoScrollView *photoScrollView;

-(void)updateWithModel:(ZLPhotoPickerBrowserPhoto *)photo;

@end
