//
//  LJAddressBookDetailViewController
//  news
//
//  Created by chenlong on 15/12/24.
//  Copyright (c) 2015年 chenlong. All rights reserved.
//

#import "LJAddressBookDetailViewController.h"
#import "news-Swift.h"
#import <NSString+TKSize.h>
#import "LJAddressBookDetailViewCell.h"
#import "LJPhoneBookFeedbackTableViewController.h"

@interface LJAddressBookDetailViewController ()<UIAlertViewDelegate,UITableViewDataSource, UITableViewDelegate, LJAddressBookDetailViewCellDelegate>
{
    UIImageView *passView;
    UIImageView *compentView;
    
    NSInteger mPage;
}
@property (nonatomic, retain) UIButton *mpButton;

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *adressLabel;
@property (nonatomic, retain) UILabel *companyLabel;
@property (nonatomic, retain) UILabel *jobLabel;

@property (nonatomic, retain) UILabel *telLabel;
@property (nonatomic, retain) NSString *telStr;
@property (nonatomic, retain) NSString *remarkStr;

@property (nonatomic, retain) UILabel *introLabel;

@property (nonatomic, retain) UIButton *chakanButton;
@property (nonatomic, retain) UIButton *callButton;

@property (nonatomic, retain) UILabel *successRateLabel;
@property (nonatomic, retain) NSMutableAttributedString *successRateStr;
@property (nonatomic, retain) NSString *rateStr;
@property (nonatomic, retain) UITableView *listTableView;
@property (nonatomic, retain) UIButton *pushNextButton;
@property (nonatomic, retain) UILabel *messgeLabel;

@property (nonatomic, retain) NSMutableArray<LJPhoneBookFeedBackDataListModel *> *commentListArray;

@end

@implementation LJAddressBookDetailViewController

#define StartY                          10


#pragma mark - lifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"电话采访";
    
    self.view.backgroundColor = RGBACOLOR(245, 245, 245, 1);
    
    UIView *topBackView = [UIView new];
    topBackView.backgroundColor = [UIColor clearColor];//RGBACOLOR(39, 138, 214, 1);//
    [self.view addSubview:topBackView];
    [topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top);
        make.height.mas_equalTo(@100);
    }];
    
    UIImage *contentBgImagebubble = [UIImage imageNamed:@"card_frame_cey"];
    UIImage * newBgImage =[contentBgImagebubble stretchableImageWithLeftCapWidth:21 topCapHeight:24] ;
    
    passView = [[UIImageView alloc] initWithImage:newBgImage];
    passView.userInteractionEnabled = YES;
    passView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:passView];
    [passView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(13);
        make.top.mas_equalTo(self.view.mas_top).offset(StartY);
        make.right.mas_equalTo(self.view.mas_right).offset(-13);
    }];
    
    UIImageView *headView = [UIImageView new];
    headView.image = [UIImage imageNamed:@"share_lanjing_cey"];
    [passView addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(passView.mas_left).offset(20);
        make.top.mas_equalTo(passView.mas_top).offset(18);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    self.mpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.mpButton addTarget:self action:@selector(showMP) forControlEvents:UIControlEventTouchUpInside];
    [self.mpButton setImage:[UIImage imageNamed:@"information_cey"] forState:UIControlStateNormal];
    [passView addSubview:self.mpButton];
    [self.mpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(passView.mas_right).offset(0);
        make.top.mas_equalTo(passView.mas_top).offset(30);
        make.size.mas_equalTo(CGSizeMake(62, 22));
    }];
    
    self.nameLabel = [UILabel new];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.textColor = RGBACOLOR(51, 51, 51, 1);
    [passView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headView.mas_right).offset(17);
        make.top.mas_equalTo(headView.mas_top);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    
    self.adressLabel = [UILabel new];
    self.adressLabel.backgroundColor = [UIColor clearColor];
    self.adressLabel.font = [UIFont systemFontOfSize:12];
    self.adressLabel.textColor = RGBACOLOR(151, 151, 151, 1);
    [passView addSubview:self.adressLabel];
    [self.adressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(passView.mas_top).offset(38);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    
    UIView *topView = headView;
    NSArray *leftArray = [NSArray arrayWithObjects:@"单位",@"职务",@"手机", @"简介", nil];
    for (NSInteger itemIndex = 0; itemIndex < leftArray.count; itemIndex ++)
    {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = RGBACOLOR(151, 151, 151, 1);
        NSString *aTitleString = leftArray[itemIndex];
        label.text = aTitleString;
        UIFont *titleFont = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = titleFont;
        [passView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topView.mas_bottom).offset(12);
            make.left.mas_equalTo(20);
            CGFloat height = [aTitleString sizeWithMaxWidth:50 font:titleFont].height;
            make.size.mas_equalTo(CGSizeMake(50, height));
        }];
        
        UILabel *rightLabel = [[UILabel alloc] init];
        rightLabel.backgroundColor = [UIColor clearColor];
        rightLabel.textColor = RGBACOLOR(51, 51, 51, 1);
        rightLabel.font = [UIFont systemFontOfSize:14];
        [passView addSubview:rightLabel];
        
        switch (itemIndex)
        {
            case 0:{
                [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(label.mas_centerY);
                    make.left.mas_equalTo(label.mas_right).offset(5);
                    make.right.mas_equalTo(passView.mas_right).offset(-5);
                    make.height.mas_equalTo(@30);
                }];

                self.companyLabel = rightLabel;
            }
                break;
            case 1:{
                [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(label.mas_centerY);
                    make.left.mas_equalTo(label.mas_right).offset(5);
                    make.right.mas_equalTo(passView.mas_right).offset(-5);
                    make.height.mas_equalTo(@30);
                }];
                self.jobLabel = rightLabel;
                break;
            }
            case 2:{
                [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(label.mas_centerY);
                    make.left.mas_equalTo(label.mas_right).offset(5);
                    make.right.mas_equalTo(passView.mas_right).offset(-80);
                    make.height.mas_equalTo(@30);
                }];

                rightLabel.textColor = RGBACOLOR(0, 158, 209, 1);
                self.telLabel = rightLabel;
                break;
            }
            case 3:{
                [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(label.mas_top);
                    make.left.mas_equalTo(label.mas_right).offset(5);
                    make.right.mas_equalTo(passView.mas_right).offset(-30);
                    make.height.mas_equalTo(@30);
                }];
                
                self.introLabel = rightLabel;
                self.introLabel.numberOfLines = 0;
                [passView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(self.introLabel.mas_bottom).offset(10);
                }];
                break;
            }
            default:
                break;
        }
        
        topView = label;
    }
    
    self.telLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(makeCall)];
    [self.telLabel addGestureRecognizer:tapGesture];
    
    self.chakanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.chakanButton.layer.cornerRadius = 2;
    self.chakanButton.layer.masksToBounds = YES;
    self.chakanButton.backgroundColor = RGBACOLOR(255, 174, 72, 1);
    [self.chakanButton addTarget:self action:@selector(chickChaKanButton) forControlEvents:UIControlEventTouchUpInside];
    [self.chakanButton setTitle:@"查看 -2 蓝鲸币" forState:UIControlStateNormal];
    [self.chakanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.chakanButton setTitleColor:RGBACOLOR(230, 230, 230, 1) forState:UIControlStateHighlighted];
    self.chakanButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.chakanButton.hidden = YES;
    [passView addSubview:self.chakanButton];
    [self.chakanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.telLabel.mas_left).offset(0);
        make.centerY.mas_equalTo(self.telLabel.mas_centerY);
        make.right.mas_equalTo(passView.mas_right).offset(-30);
        make.height.mas_equalTo(@22);
    }];
    
    self.callButton = [UIButton buttonWithType:UIButtonTypeCustom];//44 15
    [self.callButton setBackgroundImage:[UIImage imageNamed:@"new_call_cey"] forState:UIControlStateNormal];
    [self.callButton addTarget:self action:@selector(makeCall) forControlEvents:UIControlEventTouchUpInside];
    self.callButton.hidden = YES;
    [passView addSubview:self.callButton];
    [self.callButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(passView.mas_right).offset(-30);
        make.width.mas_equalTo(@44);
        make.centerY.mas_equalTo(self.telLabel.mas_centerY);
        make.height.mas_equalTo(@15);
    }];
    
    [self compentmentView];
    
    [self setTopViewData];
    
    [self getInfoData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:false animated:true];
    
    [self getCommentData:TKDataFreshTypeRefresh];
    [self getPhoneSuccessRate];
    

}


#pragma mark - private

- (void) compentmentView
{
    UIImage *contentBgImagebubble = [UIImage imageNamed:@"frame_balabala_cey"];
    UIImage * newBgImage =[contentBgImagebubble stretchableImageWithLeftCapWidth:21 topCapHeight:24] ;
    
    self.pushNextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.pushNextButton.layer.cornerRadius = 2;
    self.pushNextButton.layer.masksToBounds = YES;
    self.pushNextButton.backgroundColor = RGBACOLOR(28, 157, 214, 1);
    [self.pushNextButton addTarget: self action:@selector(feedbackButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.pushNextButton setImage:[UIImage imageNamed:@"feedback_my_interview"] forState:UIControlStateNormal];
    self.pushNextButton.hidden = YES;
    [self.view addSubview:self.pushNextButton];
    [self.pushNextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(32);
        make.bottom.mas_equalTo(self.view.bottom).offset(-20);
        make.right.mas_equalTo(self.view.mas_right).offset(-32);
        make.height.mas_equalTo(@33);
    }];
    
    compentView = [[UIImageView alloc] initWithImage:newBgImage];
//    compentView.frame = CGRectMake(13, CGRectGetMaxY(passView.frame) + 5, SCREEN_WIDTH - 26, SCREEN_HEIGHT - CGRectGetMaxY(passView.frame) - 12);
    compentView.userInteractionEnabled = YES;
    [self.view addSubview:compentView];
    [compentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(13);
        make.top.mas_equalTo(passView.mas_bottom).offset(5);
        make.right.mas_equalTo(self.view.mas_right).offset(-13);
        make.bottom.mas_equalTo(self.pushNextButton.mas_top).offset(-2);
    }];
    
    UILabel *leftTapLabel = [[UILabel alloc] init];
    leftTapLabel.backgroundColor = [UIColor clearColor];
    leftTapLabel.text = @"电话采访反馈";
    leftTapLabel.font = [UIFont systemFontOfSize:14];
    leftTapLabel.textColor = RGBACOLOR(51, 51, 51, 1);
    [compentView addSubview:leftTapLabel];
    [leftTapLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(compentView.mas_left).offset(13);
        make.top.mas_equalTo(compentView.mas_top).offset(0);
        make.size.mas_equalTo(CGSizeMake(200, 46));
    }];
    
    self.successRateLabel = [[UILabel alloc] init];
    self.successRateLabel.backgroundColor = [UIColor clearColor];
    self.successRateLabel.textAlignment = NSTextAlignmentRight;
    self.successRateLabel.font = [UIFont systemFontOfSize:12];
    self.successRateLabel.textColor = RGBACOLOR(85, 85, 85, 1);
    self.successRateLabel.hidden = YES;
    [compentView addSubview:self.successRateLabel];
    [self.successRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(compentView.mas_left);
        make.top.mas_equalTo(compentView.mas_top);
        make.right.mas_equalTo(compentView.mas_right).offset(-10);
        make.height.mas_equalTo(@44);
    }];
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = RGBACOLOR(229, 229, 229, 1);
    [compentView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(compentView.mas_left).offset(11);
        make.top.mas_equalTo(compentView.mas_top).offset(45.5);
        make.right.mas_equalTo(compentView.mas_right);
        make.height.mas_equalTo(@0.5);
    }];
    
    self.messgeLabel = [[UILabel alloc] init];
    self.messgeLabel.backgroundColor = [UIColor clearColor];
    self.messgeLabel.textColor = RGBACOLOR(169, 169, 169, 1);
    self.messgeLabel.font = [UIFont systemFontOfSize:12];
    self.messgeLabel.textAlignment = NSTextAlignmentCenter;
    self.messgeLabel.text = @"我来说两句...";
    [compentView addSubview:self.messgeLabel];
    [self.messgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(compentView);
        make.top.mas_equalTo(topLine.mas_bottom);
        make.height.mas_equalTo(@40);
    }];
    
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.backgroundColor = [UIColor clearColor];
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [compentView addSubview:self.listTableView];
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(compentView);
        make.top.mas_equalTo(compentView.mas_top).offset(46);
        make.bottom.mas_equalTo(compentView.mas_bottom).offset(0);
    }];
    
    // 添加下拉刷新，数据接口有问题，暂时屏蔽掉，日后修改
//    __weak typeof(self) weakSelf = self;
//    [self addHeaderRefreshView:self.listTableView callBack:^{
//        [weakSelf getCommentData:TKDataFreshTypeRefresh];
//    }];
//    
//    [self addFooterRefreshView:self.listTableView callBack:^{
//        [weakSelf getCommentData:TKDataFreshTypeLoadMore];
//    }];
}

- (void) setTopViewData
{
    self.rateStr = @"100";
    NSString *topStr = [NSString stringWithFormat:@"成功率%@%%",@"100"];
    self.successRateStr = [[NSMutableAttributedString alloc] initWithString:topStr];
    NSRange range = [topStr rangeOfString:self.rateStr];
    
    [self.successRateStr addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(40, 186, 137, 1) range:range];
    [self.successRateStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:range];
    
    [self refeshTopViewData];
}

- (void) showMP
{
    NSLog(@"查看名片照片");
    
    
}

- (void) makeCall
{
    if (self.telStr.length > 0){
        
//        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.telStr];
//        UIWebView * callWebview = [[UIWebView alloc] init];
//        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//        [self.view addSubview:callWebview];
        
        NSURL *url = [LJUrlHelper tryEncode:[NSString stringWithFormat:@"telprompt:%@",self.telStr]];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

/**
 *  刷新用户基本信息
 */
- (void) refeshTopViewData
{
    self.nameLabel.text = self.nameStr;
    self.adressLabel.text = self.adressStr;
    self.companyLabel.text = self.companyStr;
    self.jobLabel.text = self.jobStr;
    
    NSString *remarkStr = @"";
    if (self.remarkStr) {
        remarkStr = [self.remarkStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    self.introLabel.text = remarkStr;
    [self.introLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        float height = 30.0f;
        
        NSString *tempString = @"test";
        if (remarkStr && remarkStr.length > 0) {
            
            tempString = remarkStr;
        }
        CGFloat width = SCREEN_WIDTH - 106 - 25;
        UIFont *font = [UIFont systemFontOfSize:14];
        height = [tempString sizeWithMaxWidth:width font:font].height;
        make.height.mas_equalTo(height);
    }];
    
    self.successRateLabel.attributedText = self.successRateStr;
}

/**
 *  显示/隐藏 电话号码
 */
- (void) refeshTelPhone
{
    if (self.telStr && self.telStr.length != 0)
    {
        self.telLabel.text = self.telStr;
        self.chakanButton.hidden = YES;
        self.callButton.hidden = NO;
        
        compentView.frame = CGRectMake(13, CGRectGetMaxY(passView.frame) + 5, SCREEN_WIDTH - 26, SCREEN_HEIGHT - CGRectGetMaxY(passView.frame) - 65 - 64);
        self.listTableView.frame = CGRectMake(0, 46, compentView.frame.size.width, compentView.frame.size.height - 50);
        
        self.pushNextButton.hidden = NO;
    }
    else
    {
        self.chakanButton.hidden = NO;
        self.callButton.hidden = YES;
        self.pushNextButton.hidden = YES;
    }
    
}

- (void) tableViewRefesh
{
    [self.listTableView reloadData];
    if (self.commentListArray.count != 0)
    {
        self.messgeLabel.hidden = YES;
    }
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LJPhoneBookFeedBackDataListModel *info = self.commentListArray[indexPath.row];
    CGFloat height = [LJAddressBookDetailViewCell heightForCell:info];
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    NSString *CellIdentifile = [NSString stringWithFormat:@"CellOld%ld%ld",(long)section,(long)row];
    LJAddressBookDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifile];
    if (cell == nil)
    {
        cell = [[LJAddressBookDetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:CellIdentifile];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    LJPhoneBookFeedBackDataListModel *info = self.commentListArray[indexPath.row];
    [cell updateInfo:info];
    return cell;

}



#pragma mark - action

- (void) chickChaKanButton
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否消费蓝鲸币查看手机号码？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void)feedbackButtonClick
{
    LJPhoneBookFeedbackTableViewController *controller = [[LJPhoneBookFeedbackTableViewController alloc] init];
    controller.phoneId = self.otherUserId;
    [self.navigationController pushViewController:controller animated: YES];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self getPhoneBookMobile];
    }
}

#pragma mark - download

-(void)getCommentData:(TKDataFreshType)type
{
    if (type == TKDataFreshTypeRefresh) {
        mPage = 1;
    }
    __weak typeof(self) weakSelf = self;
    [[TKRequestHandler sharedInstance] getNoteFanKuiCommentDataWithId:self.otherUserId withPage:mPage withPerct:10 withKind:@"1" complated:^(NSURLSessionDataTask * _Nonnull sessionDataTask, LJPhoneBookFeedBackModel * _Nullable model, NSError * _Nullable error) {
        
        [weakSelf stopRefresh:weakSelf.listTableView];
        
        if (error) {
            
        } else {
            if (type == TKDataFreshTypeRefresh) {
                weakSelf.commentListArray = [NSMutableArray arrayWithArray:model.data.list];
            } else {
                if (!weakSelf.commentListArray) {
                    weakSelf.commentListArray = [NSMutableArray arrayWithArray:model.data.list];
                } else {
                    [weakSelf.commentListArray addObjectsFromArray:model.data.list];
                }
            }
            [weakSelf tableViewRefesh];
            mPage ++;
        }
    }];
}

-(void)getInfoData
{
    __weak typeof(self) weakSelf = self;

    [[TKRequestHandler sharedInstance] getPhoneBookDetailWithId:self.otherUserId complated:^(NSURLSessionDataTask * _Nonnull sessionDataTask, LJPhoneBookDetailModel * _Nullable model, NSError * _Nullable error) {
        
        if (weakSelf) {
            if (error) {
                
            } else {
                if (model.dErrno.integerValue == 0) {
                    weakSelf.nameStr = model.data.name;
                    weakSelf.companyStr = model.data.company;
                    weakSelf.adressStr = model.data.city;
                    weakSelf.jobStr = model.data.job;
                    weakSelf.telStr = model.data.mobile;
                    weakSelf.remarkStr = model.data.remark;
                    [weakSelf refeshTopViewData];
                    
                    [weakSelf.listTableView reloadData];
                    [weakSelf refeshTelPhone];
                }
            }
        }
    }];
}

/**
 *  电话采访成功率
 */
-(void)getPhoneSuccessRate
{
    __weak typeof(self) waekSelf = self;
    
    [[TKRequestHandler sharedInstance] getFeedbackRateWithPhoneId:self.otherUserId WithKind:@"1" complated:^(NSURLSessionDataTask * _Nonnull sessionDataTask, LJPhoneBookRageModel * _Nullable model, NSError * _Nullable error) {
        
        if (error) {
            
        }else{
            if (model.dErrno.integerValue == 0)
            {
                waekSelf.rateStr = model.data.stringValue;
                
                NSString *topStr = [NSString stringWithFormat:@"成功率%@%%",self.rateStr];
                waekSelf.successRateStr = [[NSMutableAttributedString alloc] initWithString:topStr];
                NSRange range = [topStr rangeOfString:self.rateStr];
                
                [waekSelf.successRateStr addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(40, 186, 137, 1) range:range];
                [waekSelf.successRateStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:range];
                [waekSelf refeshTopViewData];
            }
        }
    }];
}

- (void)getPhoneBookMobile
{
    __weak typeof(self) weakSefl = self;
    [[TKRequestHandler sharedInstance] getPhoneBookMobileByPhoneId:self.otherUserId complated:^(NSURLSessionDataTask * _Nonnull sessionDataTask, LJPhoneBookDetailModel * _Nullable model, NSError * _Nullable error) {
        if (error) {
            if (error.code == 20801) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSefl.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"您的蓝鲸币不足";
                [hud hideAnimated:YES afterDelay: 1];
            }
        }else{
            weakSefl.telStr = model.data.mobile;
            
            [weakSefl refeshTopViewData];
            [weakSefl refeshTelPhone];
        }
    }];
}

#pragma mark - LJAddressBookDetailViewCellDelegate
- (void)pushToUserDetailWithUid:(NSString * _Nonnull)uid;
{
    if (uid) {
        LJUserDeltailViewController *controller = [[LJUserDeltailViewController alloc]init];
        controller.uid = uid;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
