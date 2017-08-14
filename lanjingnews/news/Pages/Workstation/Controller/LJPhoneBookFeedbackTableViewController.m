//
//  LJPhoneBookFeedbackViewController.m
//  news
//
//  Created by 陈龙 on 15/12/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJPhoneBookFeedbackTableViewController.h"
#import <objc/runtime.h>
#import "LJInputTextViewTableViewCell.h"
#import "MBProgressHUD.h"
#import "TKRequestHandler+Workstation.h"

@interface LJPhoneBookFeedbackTableViewController ()<LJInputTextViewTableViewCellDelegate, UIActionSheetDelegate>{
    
    UIView *pickBackground;
    
    NSArray *pickerNameArray;
    NSInteger caifangType;
}

@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) NSString *feedbackString;

@end

@implementation LJPhoneBookFeedbackTableViewController

#pragma mark - lefeCycle
- (void)viewDidLoad {
    

    [super viewDidLoad];
    
    self.title = @"采访反馈";
    self.tableView.backgroundColor = [UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0f alpha:1];
    pickerNameArray = @[@"采访：电话号码采访错误",@"采访：电话号码正确",@"采访：拒绝号码采访",@"采访：号码无人接听"];
    caifangType = 1;
    self.feedbackString = @"";
}

#pragma mark - private

-(void)goBackController
{
    [self.navigationController popViewControllerAnimated: YES];
}

#pragma mark - action

-(void)submitButtonClick:(UIButton *)senderButton
{
    
    if (self.feedbackString.length == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.text = @"请填写反馈内容";
        [hud hideAnimated:YES afterDelay: 1];
        
        return;
    }
    
    NSString *numberString = self.phoneTextField.text;
    if (numberString != nil && numberString.length == 0)
    {

    } else if (numberString.length != 11){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.text = @"手机号码尾数不正确";
        [hud hideAnimated:YES afterDelay: 1];
        return;
    } else {
        numberString = self.phoneTextField.text;
    }
    
    NSString *typeString;
    typeString = [NSString stringWithFormat:@"%ld",(long)caifangType + 1];
    
    //采访反馈
    senderButton.enabled = NO;
    __weak typeof(self) weakSelf = self;
    [[TKRequestHandler sharedInstance] postPhoneBookFeedBackAddWithPhone_id:self.phoneId withType:typeString withContact:numberString withComment:self.feedbackString withKind:@"1" complated:^(NSURLSessionDataTask * _Nonnull sessionDataTask, LJPhoneBookRageModel * _Nullable model, NSError * _Nullable error) {
        senderButton.enabled = YES;
        NSString *textTagString;
        if (error) {
            textTagString = @"提交内容失败";
        }else{
            if (model.dErrno.integerValue == 0)
            {
                [self performSelector:@selector(goBackController) withObject:weakSelf afterDelay:1.0];
                textTagString = @"提交数据成功";
            }else{
                textTagString =model.data.stringValue;
            }
        }
        
        if (textTagString) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabel.text = textTagString;
            [hud hideAnimated:YES afterDelay: 1];
        }
    }];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
            break;
        case 4:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section)
    {
        case 0:
            return 50;
            break;
        case 1:
            return 150;
            break;
        case 2:
            return 50;
            break;
        case 3:
            return 50;
            break;
        default:
            return 50;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 10;
            break;
        case 2:
            return 10;
            break;
        default:
            return 0;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4)
    {
        return 5;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0:
        {
            NSString *reuseIdentifier = [NSString stringWithCString:class_getName([UITableViewCell class]) encoding:NSUTF8StringEncoding];
            cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
                cell.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = pickerNameArray[caifangType];
            break;
        }
        case 1:
        {
            NSString *reuseIdentifier = [NSString stringWithCString:class_getName([LJInputTextViewTableViewCell class]) encoding:NSUTF8StringEncoding];
            LJInputTextViewTableViewCell *inputTextcell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if (!inputTextcell) {
                inputTextcell = [[LJInputTextViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
                inputTextcell.placeHolder = @"请填写反馈";
            }
            inputTextcell.delegate = self;
            
            cell = inputTextcell;
        }
            break;
        case 2:
        {
            NSString *reuseIdentifier = [NSString stringWithCString:class_getName([UITableViewCell class]) encoding:NSUTF8StringEncoding];
            cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
                cell.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"若你从其他渠道获取了正确号码";
            break;
        }
        case 3:
        {
            NSString *reuseIdentifier = @"cellTextField";
            cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
                cell.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                self.phoneTextField = [UITextField new];
                self.phoneTextField.backgroundColor = [UIColor clearColor];
                self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
                self.phoneTextField.placeholder = @"请填写正确的手机号(可获得蓝鲸币)";
                self.phoneTextField.font = [UIFont systemFontOfSize: 13];
                [cell.contentView addSubview:self.phoneTextField];
                [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell.contentView.mas_left).offset(15);
                    make.top.mas_equalTo(cell.contentView.mas_top).offset(5);
                    make.size.mas_equalTo(CGSizeMake(250, 40));
                }];
            }
            break;
        }
        case 4:
        {
            NSString *reuseIdentifier = @"cellButon";
            cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
                UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
                button.backgroundColor = [UIColor colorWithRed:0/255.0f green:158/255.0f blue:209/255.0f alpha:1];
                button.layer.cornerRadius = 3;
                button.layer.masksToBounds = YES;
                button.titleLabel.font = [UIFont systemFontOfSize: 17];
                button.frame = CGRectMake((SCREEN_WIDTH - 200) / 2, 10, 200, 35);
                [button setTitle:@"提交我的交流反馈结果" forState:UIControlStateNormal];
                [cell.contentView addSubview: button];
                [button addTarget: self
                           action: @selector(submitButtonClick:)
                 forControlEvents: UIControlEventTouchUpInside];
            }
            break;
        }
        default:
            break;
    }
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self.view endEditing:YES];

}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    long section = indexPath.section;
    
    switch (section) {
        case 0:
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: @"采访反馈"
                                                                     delegate: self
                                                            cancelButtonTitle: @"取消"
                                                       destructiveButtonTitle: nil
                                                            otherButtonTitles: pickerNameArray[0],pickerNameArray[1],pickerNameArray[2],pickerNameArray[3], nil];
            [actionSheet showInView: self.view];
            [self.view endEditing:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex < 4)
    {
        caifangType = buttonIndex;
        [self.tableView reloadData];
    }
}

#pragma mark - LJInputTextViewTableViewCellDelegate

- (void)LJInputTextViewUpdateWithTitle:(NSString * _Nonnull)title content:(NSString * _Nonnull)content;
{
    if (content) {
        self.feedbackString = content;
    }
}
@end
