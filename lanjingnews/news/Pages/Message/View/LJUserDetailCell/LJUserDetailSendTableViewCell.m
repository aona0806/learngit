//
//  LJUserDetailSendTableViewCell.m
//  news
//
//  Created by 陈龙 on 15/12/16.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJUserDetailSendTableViewCell.h"
#import "LJUserNoteDataModel.h"
#import "news-swift.h"

@interface LJUserDetailSendTableViewCell (){
    NSString *typeString;
}

@property (nonatomic, strong, nonnull) UIButton *sendMessbutton;

@end

@implementation LJUserDetailSendTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        typeString = @"2";
        self.backgroundColor = [UIColor clearColor];
        self.sendMessbutton = [UIButton buttonWithType: UIButtonTypeCustom];
        self.sendMessbutton.backgroundColor = [UIColor colorWithRed:0/255.0f green:158/255.0f blue:209/255.0f alpha:1];
        [self.sendMessbutton addTarget: self action:@selector(buttonoAction:) forControlEvents:UIControlEventTouchUpInside];
        self.sendMessbutton.layer.masksToBounds = YES;
        self.sendMessbutton.layer.cornerRadius = 5;
        [self.sendMessbutton setTitle:@"发消息" forState:UIControlStateNormal];
        self.sendMessbutton.hidden = YES;
        [self.contentView addSubview:self.sendMessbutton];
        [self.sendMessbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView).width.insets(UIEdgeInsetsMake(10, 20, 10, 20));
        }];
    }
    return self;
}

#pragma mark - public
- (void)updateWithType:(NSString *)type uid:(NSString *)uid
{
    typeString = type;

    NSString *userIdString = [AccountManager.sharedInstace uid];
    
    if ([userIdString isEqualToString:uid]) {
        self.sendMessbutton.hidden = YES;
    } else {
        self.sendMessbutton.hidden = NO;
        if ([typeString isEqualToString: @"0"]) //未关注
        {
            [self.sendMessbutton setTitle:@"添加好友" forState: UIControlStateNormal];
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
        }
        
        NSString *myId = [AccountManager.sharedInstace uid];
        
        if ([uid isEqualToString: myId]) {
            [self.sendMessbutton removeFromSuperview];
        }
    }

}

#pragma mark - action

- (void)buttonoAction:(UIButton *)button
{
    if ([typeString isEqualToString:@"0"] || [typeString isEqualToString:@"3"]) {
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
