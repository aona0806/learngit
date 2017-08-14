//
//  LJAddressBookSearchTableViewCell.h
//  news
//
//  Created by 陈龙 on 15/12/19.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJPhoneBookModel.h"

@interface LJAddressBookSearchTableViewCell : UITableViewCell

- (void)updateInfo:(LJPhoneBookDataDataModel * _Nullable)info;
+ (CGFloat)heightForInfo;

@end
