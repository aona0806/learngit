//
//  UserLoginTableViewCell.h
//  news
//
//  Created by Vison_Cui on 15/4/17.
//  Copyright (c) 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJUserLoginTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, retain) UITextField *iTextField;

@property (nonatomic, retain) UIButton *loginButton;

@property (nonatomic, retain) UIButton *forgetButton;

@property (nonatomic, retain) UILabel *tipLabel;

-(void)createPhoneNumber;
-(void)createPassWord;
-(void)createLoginRow;
-(void)createForgetButton;
-(void)createMailView;
-(void)createTip;
- (void)createNameTipLabel;

@end
