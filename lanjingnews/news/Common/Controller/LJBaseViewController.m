//
//  LJBaseViewController.m
//  news
//
//  Created by chunhui on 15/11/25.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJBaseViewController.h"
#import <UMMobClick/MobClick.h>
#import "UIViewController+LJNavigationbar.h"
#import "news-Swift.h"

@interface LJBaseViewController ()


@end

@implementation LJBaseViewController

+(instancetype)instace
{
    return [[[self class]alloc] init];
}

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
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];

    [self customRightItem];
    
    if (_customBackItem) {
        [self initBackItem];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(customRightItem) name:[GlobalConsts kUserAvatarDidChanged] object:nil];
}

- (void)customRightItem
{
    if (_customUserInfoItem) {
        [self initNaviUserInfoItem];
    }
}

-(void)updateNaviUserInfoItem
{
    [self customRightItem];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    //首页手指从最左侧滑动不处理
    if (self.navigationController &&  [[self.navigationController viewControllers] count] == 1) {
        return NO;
    }
    return YES;
}

@end
