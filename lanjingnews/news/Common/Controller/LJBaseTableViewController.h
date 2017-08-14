//
//  LJBaseTableViewController.h
//  news
//
//  Created by chunhui on 15/11/25.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJBaseTableViewController : UITableViewController

/**
 *  是否定制导航栏返回返回 
 *  默认是yes
 */
@property(nonatomic , assign) BOOL customBackItem;

@property(nonatomic , assign) BOOL customUserInfoItem;

/**
 *  更新导航栏右侧
 */
-(void)updateNaviUserInfoItem;
/**
 *  统计事件
 *
 *  @param name 统计事件的名称
 *  @param attr 参数
 */
-(void)eventForName:(NSString *_Nonnull)name attr:(NSDictionary *_Nullable)attr;

@end
