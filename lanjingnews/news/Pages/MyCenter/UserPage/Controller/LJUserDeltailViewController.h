//
//  LJUserDeltailViewController.h
//  news
//
//  Created by 陈龙 on 15/12/11.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJBaseViewController.h"


/**
 *  用户信息主页
 */
@interface LJUserDeltailViewController : LJBaseViewController

@property (nonatomic, strong, nullable) NSString *uid;

@property (nonatomic, assign) BOOL isGetMobile;

@end
