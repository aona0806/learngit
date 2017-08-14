//
//  ConferenceCreateViewController.m
//  news
//
//  Created by 陈龙 on 15/11/4.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJConferenceCreateViewController.h"
#import <CoreText/CoreText.h>
#import "news-Swift.h"
#import "TCCopyableLabel.h"
#import "UIColor+Extension.h"
#import "UIBarButtonItem+Navigation.h"
#import <TKModuleWebViewController.h>

@interface LJConferenceCreateViewController ()

@end

@implementation LJConferenceCreateViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加会议";
    [self buildNavigationbar];
    [self buildView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

- (void)buildNavigationbar
{    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem defaultLeftItemWithTarget:self action:@selector(onBack:)];

}

- (void)buildView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *backImageView = [UIImageView new];
    backImageView.image = [UIImage imageNamed:@"conference_create_bg"];
    [self.view addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"欢迎使用会议系统";
    titleLabel.textColor = [UIColor colorWithHex:0x333333];
    titleLabel.font = [UIFont boldSystemFontOfSize:25];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_centerY).offset(-110);
        make.height.mas_equalTo(@20);
        make.right.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
    }];
    
    UILabel *topLabel = [UILabel new];
    topLabel.textColor = [UIColor colorWithHex:0x333333];
    topLabel.numberOfLines = 1;
    topLabel.text = @"请使用电脑登录到";
    topLabel.font = [UIFont systemFontOfSize:20];
    topLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(45);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_greaterThanOrEqualTo(@0);
    }];
    
    TCCopyableLabel *urlLabel = [TCCopyableLabel new];
    urlLabel.textColor = [UIColor colorWithHex:0x333333];
    urlLabel.numberOfLines = 1;
    NSString *urlString = @"huiyi.lanjinger.com";
    UIColor *ljColor = [UIColor colorWithHex:0x316994];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:urlString];
    NSDictionary *linkDic = @{ NSForegroundColorAttributeName : ljColor,
                               NSFontAttributeName:[UIFont systemFontOfSize:20],
                               NSUnderlineColorAttributeName:ljColor,
                               NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:1]};
    [attributedString setAttributes:linkDic range:[urlString rangeOfString:urlString]];
    
    //设置行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:0];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, urlString.length)];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    urlLabel.attributedText = attributedString;
    
    urlLabel.font = [UIFont systemFontOfSize:20];
    urlLabel.backgroundColor = [UIColor clearColor];
    urlLabel.userInteractionEnabled = YES;
    [self.view addSubview:urlLabel];
    [urlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topLabel.mas_bottom).offset(15);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_greaterThanOrEqualTo(@0);
    }];
    
    [urlLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(tapUrlAction:)]];
    
    UILabel *bottomLabel = [UILabel new];
    bottomLabel.textColor = [UIColor colorWithHex:0x333333];
    bottomLabel.numberOfLines = 1;
    bottomLabel.text = @"填写会议申请更方便！";
    bottomLabel.font = [UIFont systemFontOfSize:20];
    bottomLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(urlLabel.mas_bottom).offset(15);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_greaterThanOrEqualTo(@0);
    }];
    
    
    UIButton *cancelButton = [UIButton new];
    [cancelButton setBackgroundColor:[UIColor colorWithHex:0x2c8ffe]];
    [cancelButton setTitle:@"我知道了" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    cancelButton.layer.borderWidth = 0;
    cancelButton.layer.borderColor = [[UIColor colorWithHex:0xe2e2e2] CGColor];
    cancelButton.layer.cornerRadius = 6;
    [cancelButton addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_centerX).offset(-13);
        make.top.mas_equalTo(bottomLabel.mas_bottom).offset(40);
        make.size.mas_equalTo(CGSizeMake(91, 32));
    }];
    
    UIButton *okButton = [UIButton new];
    [okButton setBackgroundColor:[UIColor colorWithHex:0x2c8ffe]];
    [okButton setTitle:@"联系小秘书" forState:UIControlStateNormal];
    okButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    okButton.layer.borderWidth = 0;
    okButton.layer.borderColor = [[UIColor colorWithHex:0xe2e2e2] CGColor];
    okButton.layer.cornerRadius = 6;
    [okButton addTarget:self action:@selector(onOK:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okButton];
    [okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_centerX).offset(13);
        make.top.mas_equalTo(bottomLabel.mas_bottom).offset(40);
        make.size.mas_equalTo(CGSizeMake(91, 32));
    }];
}

- (void)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onOK:(id)sender
{
    LJTalkTableViewController *viewController = [LJTalkTableViewController new];
    viewController.talkingUserId = 2;//2代表后台小秘书
    viewController.talkUserName = @"蓝鲸财经小秘书";
    viewController.isPopToRoot = YES;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController: viewController animated: YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)tapUrlAction:(UIGestureRecognizer *)gesture
{
    TKModuleWebViewController *webController = [self moduleWebViewWithUrl:@"https://huiyi.lanjinger.com"];
    
    [self.navigationController pushViewController:webController animated:YES];
}


@end
