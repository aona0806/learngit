//
//  LJMyInfoHeaderCell.h
//  news
//
//  Created by 奥那 on 15/12/7.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJUserInfoModel.h"

@protocol LJMyInfoHeaderCellDelegate <NSObject>

- (void)clickHeaderImage;
- (void)clickNumOfFans;
- (void)clickNumOfDollars;
- (void)clickBack;

@end

@interface LJMyInfoHeaderCell : UITableViewCell
@property (nonatomic,assign)id<LJMyInfoHeaderCellDelegate>delegate;
@property (nonatomic,strong)UIImage *headerImage;

@property (nonatomic,strong) LJUserInfoModel *userInfo;

@end
