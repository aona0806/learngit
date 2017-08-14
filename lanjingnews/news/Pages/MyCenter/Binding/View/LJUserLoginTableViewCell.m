//
//  UserLoginTableViewCell.m
//  news
//
//  Created by Vison_Cui on 15/4/17.
//  Copyright (c) 2015年 lanjing. All rights reserved.
//

#import "LJUserLoginTableViewCell.h"
//#import "VendorMacro.h"
@implementation LJUserLoginTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return  self;
}

-(void)createPhoneNumber
{
    UIView *phoneView = [[UIView alloc] initWithFrame: CGRectMake(-1, 0, SCREEN_WIDTH + 2, 44)];
    phoneView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview: phoneView];
    
    _iTextField = [[UITextField alloc] initWithFrame: CGRectMake(10, 0, SCREEN_WIDTH - 20, 44)];
    _iTextField.backgroundColor = [UIColor clearColor];
    _iTextField.delegate = self;
    _iTextField.placeholder = @"手机号码";
    _iTextField.textColor = [UIColor colorWithRed:112/255.0f green:112/255.0f blue:112/255.0f alpha:1];
    _iTextField.textColor = [UIColor blackColor];
    _iTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _iTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _iTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _iTextField.returnKeyType = UIReturnKeyDone;
    _iTextField.keyboardType = UIKeyboardTypePhonePad;
    _iTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _iTextField.font = [UIFont systemFontOfSize: 17];
    [phoneView addSubview: _iTextField];
}

-(void)createMailView
{
    UIView *phoneView = [[UIView alloc] initWithFrame: CGRectMake(-1, 0, SCREEN_WIDTH + 2, 44)];
    phoneView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview: phoneView];
    
    _iTextField = [[UITextField alloc] initWithFrame: CGRectMake(10, 0, SCREEN_WIDTH - 20, 44)];
    _iTextField.backgroundColor = [UIColor clearColor];
    _iTextField.delegate = self;
    _iTextField.placeholder = @"邮箱";
    _iTextField.textColor = [UIColor colorWithRed:112/255.0f green:112/255.0f blue:112/255.0f alpha:1];
    _iTextField.textColor = [UIColor blackColor];
    _iTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _iTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _iTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _iTextField.returnKeyType = UIReturnKeyDone;
    _iTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _iTextField.font = [UIFont systemFontOfSize: 17];
    [phoneView addSubview: _iTextField];
}

-(void)createPassWord
{
    UIView *phoneView = [[UIView alloc] initWithFrame: CGRectMake(-1, 0, SCREEN_WIDTH + 2, 44)];
    phoneView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview: phoneView];
    
    _iTextField = [[UITextField alloc] initWithFrame: CGRectMake(10, 0, SCREEN_WIDTH - 20, 44)];
    _iTextField.backgroundColor = [UIColor clearColor];
    _iTextField.delegate = self;
    _iTextField.placeholder = @"密码";
    [_iTextField setSecureTextEntry:YES];
    _iTextField.textColor = [UIColor colorWithRed:112/255.0f green:112/255.0f blue:112/255.0f alpha:1];
    _iTextField.textColor = [UIColor blackColor];
    _iTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _iTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _iTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _iTextField.returnKeyType = UIReturnKeyDone;
    _iTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _iTextField.font = [UIFont systemFontOfSize: 17];
    [phoneView addSubview: _iTextField];
}

-(void)createLoginRow
{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [self.contentView addSubview: _loginButton];
    }
    
    _loginButton.frame = CGRectMake(20, 20, SCREEN_WIDTH - 40, 40);
    _loginButton.backgroundColor = [UIColor colorWithRed:0/255.0f green:158/255.0f blue:209/255.0f alpha:1];
    _loginButton.layer.masksToBounds = YES;
    _loginButton.layer.cornerRadius = 5;
    _loginButton.layer.borderWidth = 1;
    _loginButton.layer.borderColor = [UIColor colorWithRed:0/255.0f green:158/255.0f blue:209/255.0f alpha:1].CGColor;
    [_loginButton setTitle: @"登录" forState: UIControlStateNormal];
}

-(void)createForgetButton
{
    if (!_forgetButton) {
        _forgetButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [self.contentView addSubview: _forgetButton];
    }
    
    _forgetButton.frame = CGRectMake(SCREEN_WIDTH - 100, 0, 100, 40);
    _forgetButton.backgroundColor = [UIColor clearColor];
    [_forgetButton setTitleColor:[UIColor lightGrayColor] forState: UIControlStateNormal];
    _forgetButton.titleLabel.font = [UIFont systemFontOfSize: 15];
    _forgetButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_forgetButton setTitle: @"忘记密码?" forState: UIControlStateNormal];
}

- (void)createTip
{
    if (!self.tipLabel) {
        self.tipLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_tipLabel];
    }
    _tipLabel.frame = CGRectMake(20, 0, SCREEN_WIDTH - 40, 100);
    _tipLabel.backgroundColor = [UIColor clearColor];
    _tipLabel.text = @"您可以在此输入蓝鲸财经内网账号，系统将会一次性导入您之前积累的蓝鲸财经币，同时会导入您收藏的通讯录条目，该操作只可进行一次，请您注意。";
    _tipLabel.textColor = [UIColor colorWithRed:200/256.0f green:200/256.0f blue:200/256.0f alpha:1];
    _tipLabel.numberOfLines = 0;
    _tipLabel.font = [UIFont systemFontOfSize:15];
}

- (void)createNameTipLabel
{
    if (!self.tipLabel) {
        self.tipLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.tipLabel];
    }
    
    self.tipLabel.frame = CGRectMake(20, 0, SCREEN_HEIGHT - 40, 40);
    self.tipLabel.backgroundColor = [UIColor clearColor];
    self.tipLabel.text = @"注册须实名，且填写后无法变更";
    self.tipLabel.textColor = [UIColor redColor];
    self.tipLabel.numberOfLines = 0;
    self.tipLabel.font = [UIFont systemFontOfSize:15];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_iTextField resignFirstResponder];
    
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
