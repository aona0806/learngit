//
//  ZLPhotoLayout.h
//  CaiLianShe
//
//  Created by chunhui on 2016/10/17.
//  Copyright © 2016年 chenny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLPhotoDefine.h"

@interface ZLPhotoLayout : NSObject

@property(nonatomic , assign) NSInteger countPerRow;//每行显示数目

@property(nonatomic , assign) CGFloat horPadding;//两边的间距
@property(nonatomic , assign) CGFloat topPadding;//顶部间距
@property(nonatomic , assign) CGFloat itemHorPadding;//图片之间的水平间距
@property(nonatomic , assign) CGFloat itemVerPadding;//图片之间的垂直间距

@property(nonatomic , assign) ZLPhotoBottomBarType bottomBarType;

@end
