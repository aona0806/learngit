//
//  LJUserDetailSendTableViewCell.m
//  news
//
//  Created by 陈龙 on 15/12/16.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJUserDetailSendTableViewCell.h"
#import "LJUserInfoModel.h"
#import "news-Swift.h"

@interface LJUserDetailSendTableViewCell (){
    NSString *typeString;
}

@property (nonatomic, strong, nonnull) UIButton *sendMessbutton;

@end

#define KSendMessageButtonBG [UIColor colorWithRed:0/255.0f green:158/255.0f blue:209/255.0f alpha:1]

@implementation LJUserDetailSendTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        typeString = @"2";
        self.backgroundColor = [UIColor clearColor];
        self.sendMessbutton = [UIButton buttonWithType: UIButtonTypeCustom];
        self.sendMessbutton.backgroundColor = KSendMessageButtonBG;
        [self.sendMessbutton addTarget: self action:@selector(buttonoAction:) forControlEvents:UIControlEventTouchUpInside];
        self.sendMessbutton.layer.masksToBounds = YES;
        self.sendMessbutton.layer.cornerRadius = 5;
        [self.sendMessbutton setTitle:@"发消息" forState:UIControlStateNormal];
        self.sendMessbutton.hidden = YES;
        [self.contentView addSubview:self.sendMessbutton];
        [self.sendMessbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo(self.contentView).with.insets(UIEdgeInsetsMake(10, 20, 10, 20));
        }];
    }
    return self;
}

#pragma mark - public

- (void)updateWithType:(NSString *)type uid:(NSString *)uid
{
    typeString = type;

    NSString *userIdString = [AccountManager.sharedInstance uid];
    
    if ([userIdString isEqualToString:uid]) {
        self.sendMessbutton.hidden = YES;
    } else {
        self.sendMessbutton.hidden = NO;
        self.sendMessbutton.backgroundColor = KSendMessageButtonBG;
        if ([typeString isEqualToString: @"0"]) //未关注
        {
            [self.sendMessbutton setTitle:@"添加好友" forState: UIControlStateNormal];
            self.sendMessbutton.enabled = YES;
        }else if ([typeString isEqualToString: @"1"]) //已关注
        {
            self.sendMessbutton.backgroundColor = [UIColor lightGrayColor];
            [self.sendMessbutton setTitle:@"等待验证" forState: UIControlStateNormal];
            self.sendMessbutton.enabled = NO;
        }else if ([typeString isEqualToString: @"2"]) //互相关注
        {
            [self.sendMessbutton setTitle:@"发消息" forState: UIControlStateNormal];
            
        }else //  3 单向他关注我
        {
            [self.sendMessbutton setTitle:@"接受" forState: UIControlStateNormal];
            self.sendMessbutton.enabled = true;
        }
        
        NSString *myId = [AccountManager.sharedInstance uid];
        
        if ([uid isEqualToString: myId]) {
            [self.sendMessbutton removeFromSuperview];
        }
    }

}

#pragma mark - action

- (void)buttonoAction:(UIButton *)button
{
    if ([typeString isEqualToString:@"0"]) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"等待对方验证通过，对方更新将出现在你首页" delegate:self.delegate cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 10001;
        
        [alertView show];
    } else if ([typeString isEqualToString:@"3"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(LJUserDetailSendTableViewCellSendFocusMe)]) {
            [self.delegate LJUserDetailSendTableViewCellSendFocusMe];
        }
    } else if ([typeString isEqualToString:@"2"]) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(LJUserDetailSendTableViewCellSendMessage)]) {
            [self.delegate LJUserDetailSendTableViewCellSendMessage];
        }
    }
}

@end
