//
//  AddEventTableViewController.h
//  news
//
//  Created by 奥那 on 15/12/22.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJBaseTableViewController.h"
@class LJTimeAxisDataListModel;
/**
 *  时间轴添加事件
 */
@interface LJAddEventTableViewController : LJBaseTableViewController

@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic,strong)LJTimeAxisDataListModel *model;
@property (nonatomic, copy) void(^addEvent)(LJTimeAxisDataListModel *model);
@end
