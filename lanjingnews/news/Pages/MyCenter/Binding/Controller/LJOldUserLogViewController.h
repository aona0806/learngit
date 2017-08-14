//
//  OldUserLogViewController.h
//  news
//
//  Created by Vison_Cui on 15/4/18.
//  Copyright (c) 2015年 lanjing. All rights reserved.
//

#import "LJBaseViewController.h"
#import "LJUserLoginTableViewCell.h"

@interface LJOldUserLogViewController : LJBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;

@end
