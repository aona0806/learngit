//
//  LJWorkTableViewCell.h
//  news
//
//  Created by 陈龙 on 15/12/18.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJWorkStationModel.h"

@interface LJWorkTableViewCell : UITableViewCell

- (void)updateInfo:(LJWorkStationDataModel * _Nullable)info;
@end
