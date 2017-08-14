//
//  LJTimeAxisDetailCell.h
//  news
//
//  Created by 奥那 on 15/12/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KILabel.h"

@interface LJTimeAxisDetailCell : UITableViewCell
{
    CGRect titleFrame;
    CGRect contentFrame;
}
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) KILabel *contentLabel;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detailString;

+ (CGFloat)cellHeightForTitle:(NSString *)title Content:(NSString *)content;

@end
