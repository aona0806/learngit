//
//  LJEventStyleViewController.h
//  news
//
//  Created by 奥那 on 15/12/22.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJBaseViewController.h"

@interface LJEventStyleViewController : LJBaseViewController
@property (nonatomic, retain) NSString *eventsType;

@property (nonatomic, copy) void (^chooseType)(NSString *typeStr);
@end
