//
//  OldUserLogViewController.m
//  news
//
//  Created by Vison_Cui on 15/4/18.
//  Copyright (c) 2015年 lanjing. All rights reserved.
//

#import "LJOldUserLogViewController.h"
#import "TKRequestHandler+Binding.h"
#import "news-Swift.h"

#define kPhoneNumberTag   215412
#define kPasswordTag     2678654
@interface LJOldUserLogViewController ()

@end

@implementation LJOldUserLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"绑定用户";
    self.view.backgroundColor = [UIColor colorWithRed:233/256.0f green:234/256.0f blue:239/256.0f alpha:1];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithRed:233/256.0f green:234/256.0f blue:239/256.0f alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:false animated:animated];
}

-(void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    switch (row) {
        case 0:
            return 20;
            break;
        case 1:
            return 45;
        case 2:
            return 45;
        case 3:
            return 60;
        case 4:
            return 110;
        default:
            return 40;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    long section = indexPath.section;
    
    NSString *CellIdentifile = [NSString stringWithFormat:@"CellOld%ld%ld",section,(long)row];
    LJUserLoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifile];
    if (cell == nil)
    {
        cell = [[LJUserLoginTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifile];
        switch (row) {
            case 1:
                [cell createMailView];
                cell.iTextField.tag = kPhoneNumberTag;
                break;
            case 2:
                [cell createPassWord];
                cell.iTextField.tag = kPasswordTag;
                break;
            case 3:
                [cell createLoginRow];
                [cell.loginButton setTitle:@"绑定用户" forState: UIControlStateNormal];
                [cell.loginButton addTarget: self action:@selector(nextButtonClick) forControlEvents: UIControlEventTouchUpInside];
                break;
            case 4:
                [cell createTip];
                break;
            default:
                break;
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return  self.navigationController.navigationBar.bottom - NAVBAR_HEIGHT;
        
    }
    
    return CGFLOAT_MIN;
}


-(void)nextButtonClick
{
    NSString *mailNumberString = ((UITextField *)[self.view viewWithTag: kPhoneNumberTag]).text;
    NSString *passWordString = ((UITextField *)[self.view viewWithTag: kPasswordTag]).text;
    
    NSString *errorString;
    if (mailNumberString.length == 0) {
        errorString = @"请填写账号";
    }else if (passWordString.length == 0)
    {
        errorString = @"请填写密码";
    }
    if (errorString) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = errorString;
        [hud hideAnimated:YES afterDelay: 1];
        return;
    }

    __weak typeof(self) weakself = self;
    [[TKRequestHandler sharedInstance] bindeingOldUserWithMail:mailNumberString withPassword:passWordString finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {
        if (error) {
            if (error.code == 0) {
            } else if (error.code == 20107){
                
                [weakself showToastHidenDefault:@"该账户已绑定"];
            }  else {
                
                [weakself showToastHidenDefault:@"账号密码错误"];
            }
        }else{
            NSString *errnoString = [NSString stringWithFormat:@"%@",response[@"errno"]];
            if ([errnoString isEqualToString: @"0"])
            {
                [weakself showPopHud:@"绑定成功" hideDelay:0.5];

                [[AccountManager sharedInstance] getUserInfo].claim = @"1";
                [weakself performSelector:@selector(successBack) withObject:nil afterDelay:1];
            } else if ([ errnoString isEqualToString:@"20107"]){
                
                [weakself showToastHidenDefault:@"该账户已绑定"];
            }  else {
                
                [weakself showToastHidenDefault:@"账号密码错误"];
            }
        }
    }];
}

-(void)successBack
{
    [self.navigationController popViewControllerAnimated: YES];
}
@end
