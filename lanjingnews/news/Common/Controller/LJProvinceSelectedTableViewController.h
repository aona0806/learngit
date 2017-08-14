//
//  LJProvinceSelectedTableViewController.h
//  news
//
//  Created by 陈龙 on 16/1/1.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJBaseTableViewController.h"

@interface LJProvinceSelectedTableViewController : LJBaseTableViewController

- (instancetype) initWithSelectedBlock:(void(^)(NSString * province)) selectedBlock;

@end
