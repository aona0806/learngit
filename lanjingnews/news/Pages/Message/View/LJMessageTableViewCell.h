//
//  LJMessageTableViewCell.h
//  news
//
//  Created by 陈龙 on 15/12/20.
//  Copyright (c) 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageData.h"

@interface LJMessageTableViewCell : UITableViewCell

-(instancetype _Nonnull)initWithMessageStyle:(UITableViewCellStyle)style
                             reuseIdentifier:(NSString * _Nonnull)reuseIdentifier;

- (void)updateInfo:(MessageData * _Nullable)info;
@end
