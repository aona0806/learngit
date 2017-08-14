//
//  LJTimeAxisHelpView.h
//  news
//
//  Created by 奥那 on 15/12/22.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJTimeAxisHelpView : UIView
@property (nonatomic,copy)void (^dismissHelperView)(LJTimeAxisHelpView *helpView);
@end
