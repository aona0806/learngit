//
//  TimeAxisDetailTableViewController.h
//  news
//
//  Created by 奥那 on 15/12/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJBaseTableViewController.h"
#import "LJTimeAxisModel.h"

@interface LJTimeAxisDetailTableViewController : LJBaseTableViewController

@property (nonatomic , copy) NSString *eventId;
@property (nonatomic , strong)LJTimeAxisDataListModel *model;


@end
