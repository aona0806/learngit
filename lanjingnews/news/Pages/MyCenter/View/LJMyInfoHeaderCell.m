//
//  LJMyInfoHeaderCell.m
//  news
//
//  Created by 奥那 on 15/12/7.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMyInfoHeaderCell.h"
#import "news-Swift.h"

@interface LJMyInfoHeaderCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *numOfFans;
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;
@property (weak, nonatomic) IBOutlet UILabel *dollarLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfDollars;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *isBigv;
@property (weak, nonatomic) IBOutlet UILabel *company;

@property (weak, nonatomic) IBOutlet UILabel *dollarAnimotaLabel;
@property (weak, nonatomic) IBOutlet UIImageView *setVImage;

@end

@implementation LJMyInfoHeaderCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self initHeaderImage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initHeaderImage{
    
    self.headerImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headerImageView.layer.borderWidth = 1.5;
    self.headerImageView.layer.cornerRadius = CGRectGetWidth(self.headerImageView.frame) / 2;
    self.headerImageView.layer.masksToBounds = YES;

}

- (void)setHeaderImage:(UIImage *)headerImage{
    if (_headerImage != headerImage) {
        _headerImage = nil;
        _headerImage = headerImage;
        
        self.headerImageView.image = _headerImage;
    }
}

-(void)setUserInfo:(LJUserInfoModel *)userInfo{
    if (_userInfo != userInfo) {
        _userInfo = nil;
        _userInfo = userInfo;
        
        [self setValueForSubViews:_userInfo];
    }
}

- (void)setValueForSubViews:(LJUserInfoModel *)userInfo{

    [self.headerImageView sd_setImageWithURL:[LJUrlHelper tryEncode:userInfo.avatar] placeholderImage:[UIImage imageNamed:@"myInfo_default_headerImage"]];
    self.userName.text = userInfo.sname;
    self.company.text = [NSString stringWithFormat:@"%@ - %@",userInfo.company,userInfo.companyJob];
    self.numOfFans.text = [NSString stringWithFormat:@"%@",userInfo.friendsNum];
    
    [self setBigvType:userInfo.ukind];
    [self setDollars:userInfo.gold];
}

- (void)setBigvType:(NSString *)ukind{
    if (ukind.integerValue == 0){
        self.isBigv.image = nil;
    }else if (ukind.integerValue == 1) {
        self.isBigv.image = [UIImage imageNamed:@"tag_v"];
    }else if (ukind.integerValue == 2) {
        self.isBigv.image = [UIImage imageNamed:@"tag_v2"];
    }

}

- (void)setDollars:(NSString *)gold{
    
    LJUserInfoModel *model = [[AccountManager sharedInstance] getUserInfo];
    NSString *oldGold = model.gold;
    
    _userInfo.token = [[AccountManager sharedInstance]token];
    [[AccountManager sharedInstance] updateAccountInfo:_userInfo];

    if (oldGold.integerValue >= 0 && oldGold.integerValue != gold.integerValue) {
        self.dollarAnimotaLabel.hidden = NO;
        NSInteger increaseGold = gold.integerValue - oldGold.integerValue;
        NSString *increaseGoldString = [NSString stringWithFormat:@"%ld",(long)increaseGold];
        if (increaseGold > 0) {
            increaseGoldString = [NSString stringWithFormat:@"+%ld",(long)increaseGold];
        }
        self.dollarAnimotaLabel.text = increaseGoldString;
        [UIView animateWithDuration:1.0 animations:^{
            self.dollarAnimotaLabel.transform = CGAffineTransformMake(1.3, 0, 0, 1.3, 0, -2);
            self.dollarAnimotaLabel.alpha = 1.0;
        }];
        
        [UIView animateWithDuration:1.0 animations:^{
            self.dollarAnimotaLabel.transform = CGAffineTransformMake(1.3, 0, 0, 1.3, 0, -2);
            self.dollarAnimotaLabel.alpha = 1.0;

        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                self.dollarAnimotaLabel.transform = CGAffineTransformMake(1.7, 0, 0, 1.7, 0, -5);
                self.dollarAnimotaLabel.alpha = 0.6;
            } completion:^(BOOL finished) {
                if (finished) {
                    
                    self.dollarAnimotaLabel.alpha = 0;
                    self.dollarAnimotaLabel.hidden = YES;
                    self.dollarAnimotaLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    self.numOfDollars.text = gold;
                }
            }];
        }];
    }else {
        self.dollarAnimotaLabel.hidden = YES;
        self.numOfDollars.text = gold;
    }
}

/**
 *  点击用户头像
 */
- (IBAction)tapHeader:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickHeaderImage)]) {
        
        [self.delegate clickHeaderImage];
    }
}

/**
 *  点击好友
 */
- (IBAction)tapFans:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickNumOfFans)]) {
        [self.delegate clickNumOfFans];
    }
}

/**
 *  点击蓝鲸币
 */
- (IBAction)taoDollars:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickNumOfDollars)]) {
        [self.delegate clickNumOfDollars];
    }
}
- (IBAction)backAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickBack)]) {
        [self.delegate clickBack];
    }
}

@end
