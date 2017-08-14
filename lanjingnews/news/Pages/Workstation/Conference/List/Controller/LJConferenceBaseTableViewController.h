//
//  LJConferenceBaseTableViewController.h
//  news
//
//  Created by 陈龙 on 15/12/22.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "LJConferenceTableViewCell.h"
#import "news-Swift.h"
#import "UIViewController+Refresh.h"

//#import "ConferenceDetailViewController.h"

@interface LJConferenceBaseTableViewController : UIViewController<LJConferenceTableViewCellDelegate,ShareViewProtocol,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain,nonnull) UITableView *tableView;

/**
 *  资源数据 NSArray
 */
@property (nonatomic,retain,nonnull) NSMutableArray *dataSource;
@property (nonatomic,copy,nonnull) NSString *XBParam;

@property (nonatomic) NSInteger pageNum;
@property (nonatomic , weak, nullable) UIViewController *superNavController;

@property (nonatomic,retain,nonnull) UIView *tableFooterView;

@property (nonatomic, assign) BOOL isFirstLoading;

- (void)downloadRefresh;
- (void)downloadLoadMore;
- (void)refreshData:(NSNotification  * _Nonnull )notification;

/**
 *  显示网络错误
 */
- (void)showNetError:(void (^ _Nullable)(id _Nonnull sender))handler;
/**
 *  显示网络正常，没有数据情况
 *
 *  @param handler <#handler description#>
 */
- (void)showNoDataWithTitle:(NSString * _Nonnull)title Error:(void (^ _Nullable)(id _Nullable sender))handler;
- (void)hidenNoDataView;
- (void)hidenNetError;

/**
 *  显示loading视图
 *
 *  @param view 将要添加到得view
 *
 *  @return <#return value description#>
 */
- (MBProgressHUD * _Nullable)showLoadingHudInView:(UIView * _Nullable)view;


@end

