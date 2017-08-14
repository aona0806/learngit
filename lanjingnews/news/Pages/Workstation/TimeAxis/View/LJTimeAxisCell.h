//
//  LJTimeAxisCell.h
//  news
//
//  Created by 奥那 on 15/12/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJTimeAxisModel.h"

@interface LJTimeAxisCell : UITableViewCell
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *addressLabel;

@property (nonatomic, retain) UIImageView *dateBackView;

@property (nonatomic, retain) UILabel *weekLabel;
@property (nonatomic, retain) UILabel *timeLabel;

@property (nonatomic, retain) UIImageView *typeLogo;

@property (nonatomic, strong) LJTimeAxisDataListModel *model;
@end
