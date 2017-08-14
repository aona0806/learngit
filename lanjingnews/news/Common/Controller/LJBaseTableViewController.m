//
//  LJBaseTableViewController.m
//  news
//
//  Created by chunhui on 15/11/25.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJBaseTableViewController.h"
#import "UIViewController+LJNavigationbar.h"
#import "news-Swift.h"

@interface LJBaseTableViewController ()

@end

@implementation LJBaseTableViewController

-(instancetype)init
{
    self = [super init];
    if (self) {
        _customBackItem = YES;
        _customUserInfoItem = NO;
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil  bundle:nibBundleOrNil];
    if (self) {
        _customBackItem = YES;
        _customUserInfoItem = NO;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _customBackItem = YES;
        _customUserInfoItem = NO;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self customRightItem];
    if (self.customBackItem) {
        [self initBackItem];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(customRightItem) name:[GlobalConsts kUserAvatarDidChanged] object:nil];
}

- (void)customRightItem{
    if (_customUserInfoItem) {
        [self initNaviUserInfoItem];
    }
}

-(void)updateNaviUserInfoItem
{
    [self customRightItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    //首页手指从最左侧滑动不处理
    if (self.navigationController &&  [[self.navigationController viewControllers] count] == 1) {
        return NO;
    }
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


/**
 *  统计事件
 *
 *  @param name 统计事件的名称
 *  @param attr 参数
 */
-(void)eventForName:(NSString *)name attr:(NSDictionary *)attr
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (attr) {
            [MobClick event:name attributes:attr];
        }else{
            [MobClick event:name];
        }
        
    });
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
