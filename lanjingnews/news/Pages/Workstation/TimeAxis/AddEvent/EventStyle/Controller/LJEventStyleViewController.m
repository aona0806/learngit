//
//  LJEventStyleViewController.m
//  news
//
//  Created by 奥那 on 15/12/22.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJEventStyleViewController.h"
#define kTypeSeclectedButtonTag           38273
#define kTypeSeclectedLabelTag            39292
@interface LJEventStyleViewController ()

@end

@implementation LJEventStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBACOLOR(233, 234, 239, 1);
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44 * 3)];
    backView.backgroundColor = [UIColor whiteColor];
    
    for (NSInteger itemIndex = 0; itemIndex < 2; itemIndex ++)
    {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5 + itemIndex * 44, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGBACOLOR(233, 233, 233, 1);
        [backView addSubview:line];
    }
    
    [self.view addSubview:backView];
    
    NSArray *leftLogoArray = [NSArray arrayWithObjects:@"workstation_blue",@"workstation_orange",@"workstation_red", nil];
    NSArray *leftLogoSeclectedArray = [NSArray arrayWithObjects:@"workstation_blueCenter",@"workstation_orangeCenter",@"workstation_redCenter", nil];
    NSArray *labelStrArray = [NSArray arrayWithObjects:@"重要节点",@"发布会",@"个人专用（此类目仅本人可见）", nil];
    
    NSMutableAttributedString *attriString0 = [[NSMutableAttributedString alloc] initWithString:labelStrArray[0]];
    NSRange range0 = [labelStrArray[0] rangeOfString:@"重要节点"];
    [attriString0 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:range0];
    
    NSMutableAttributedString *attriString1 = [[NSMutableAttributedString alloc] initWithString:labelStrArray[1]];
//    NSRange range1 = [labelStrArray[1] rangeOfString:@"发布会"];
//    NSRange elseRange1 = [labelStrArray[1] rangeOfString:@"（添加 +2；查看 -2 蓝鲸币）"];
//    [attriString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:range1];
//    [attriString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:elseRange1];
    
    NSMutableAttributedString *attriString2 = [[NSMutableAttributedString alloc] initWithString:labelStrArray[2]];
    NSRange range2 = [labelStrArray[2] rangeOfString:@"个人专用"];
    NSRange elseRange2 = [labelStrArray[2] rangeOfString:@"（此类目仅本人可见）"];
    [attriString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:range2];
    [attriString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:elseRange2];
    
    NSArray *labeLAttriStrArray = [NSArray arrayWithObjects:attriString0,attriString1,attriString2, nil];
    
    for (NSInteger itemIndex = 0; itemIndex < 3; itemIndex ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(20, 20 + 44 * itemIndex, SCREEN_WIDTH - 20, 44);
        [button setImage:[UIImage imageNamed:leftLogoArray[itemIndex]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:leftLogoSeclectedArray[itemIndex]] forState:UIControlStateSelected];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, button.frame.size.width - 12);
        [button addTarget:self action:@selector(typeSeclected:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = itemIndex + kTypeSeclectedButtonTag;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, button.frame.size.width - 20, 44)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = RGBACOLOR(144, 168, 201, 1);
        label.attributedText = labeLAttriStrArray[itemIndex];
        label.tag = itemIndex + kTypeSeclectedLabelTag;
        [button addSubview:label];
        
        [self.view addSubview:button];
    }
    
    if (self.eventsType.length != 0)
    {
        NSInteger currentIndex = [self.eventsType integerValue];
        switch (currentIndex)
        {
            case 0:
            {
                UIButton *thrButton = (UIButton *)[self.view viewWithTag:kTypeSeclectedButtonTag + 2];
                [self showTypeSeclected:thrButton];
            }
                break;
            case 1:
            {
                UIButton *firstButton = (UIButton *)[self.view viewWithTag:kTypeSeclectedButtonTag];
                [self showTypeSeclected:firstButton];
            }
                break;
            case 2:
            {
                UIButton *secButton = (UIButton *)[self.view viewWithTag:kTypeSeclectedButtonTag + 1];
                [self showTypeSeclected:secButton];
            }
                break;
            default:
                break;
        }
    }
    
}

#pragma mark---UIButtonAction

- (void) typeSeclected:(UIButton *)button
{
    UIButton *firstButton = (UIButton *)[self.view viewWithTag:kTypeSeclectedButtonTag];
    UIButton *secButton = (UIButton *)[self.view viewWithTag:kTypeSeclectedButtonTag + 1];
    UIButton *thrButton = (UIButton *)[self.view viewWithTag:kTypeSeclectedButtonTag + 2];
    
    UILabel *firstLabel = (UILabel *)[self.view viewWithTag:kTypeSeclectedLabelTag];
    UILabel *secLabel = (UILabel *)[self.view viewWithTag:kTypeSeclectedLabelTag + 1];
    UILabel *thrLabel = (UILabel *)[self.view viewWithTag:kTypeSeclectedLabelTag + 2];
    
    
    if (button.selected)
    {
        return;
    }
    else
    {
        if (button == firstButton)
        {
            firstButton.selected = YES;
            secButton.selected = NO;
            thrButton.selected = NO;
            
            firstLabel.textColor = RGBACOLOR(89, 89, 89, 1);
            secLabel.textColor = RGBACOLOR(144, 168, 201, 1);
            thrLabel.textColor = RGBACOLOR(144, 168, 201, 1);
            
            self.eventsType = @"1";
        }
        else if (button == secButton)
        {
            firstButton.selected = NO;
            secButton.selected = YES;
            thrButton.selected = NO;
            
            firstLabel.textColor = RGBACOLOR(144, 168, 201, 1);
            secLabel.textColor = RGBACOLOR(89, 89, 89, 1);
            thrLabel.textColor = RGBACOLOR(144, 168, 201, 1);
            
            self.eventsType = @"2";
        }
        else if (button == thrButton)
        {
            firstButton.selected = NO;
            secButton.selected = NO;
            thrButton.selected = YES;
            
            firstLabel.textColor = RGBACOLOR(144, 168, 201, 1);
            secLabel.textColor = RGBACOLOR(144, 168, 201, 1);
            thrLabel.textColor = RGBACOLOR(89, 89, 89, 1);
            
            self.eventsType = @"0";
        }
        
        if (_chooseType) {
            _chooseType(self.eventsType);
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}

- (void) showTypeSeclected:(UIButton *)button
{
    UIButton *firstButton = (UIButton *)[self.view viewWithTag:kTypeSeclectedButtonTag];
    UIButton *secButton = (UIButton *)[self.view viewWithTag:kTypeSeclectedButtonTag + 1];
    UIButton *thrButton = (UIButton *)[self.view viewWithTag:kTypeSeclectedButtonTag + 2];
    
    UILabel *firstLabel = (UILabel *)[self.view viewWithTag:kTypeSeclectedLabelTag];
    UILabel *secLabel = (UILabel *)[self.view viewWithTag:kTypeSeclectedLabelTag + 1];
    UILabel *thrLabel = (UILabel *)[self.view viewWithTag:kTypeSeclectedLabelTag + 2];
    
    
    if (button.selected)
    {
        return;
    }
    else
    {
        if (button == firstButton)
        {
            firstButton.selected = YES;
            secButton.selected = NO;
            thrButton.selected = NO;
            
            firstLabel.textColor = RGBACOLOR(89, 89, 89, 1);
            secLabel.textColor = RGBACOLOR(144, 168, 201, 1);
            thrLabel.textColor = RGBACOLOR(144, 168, 201, 1);
            
            self.eventsType = @"1";
        }
        else if (button == secButton)
        {
            firstButton.selected = NO;
            secButton.selected = YES;
            thrButton.selected = NO;
            
            firstLabel.textColor = RGBACOLOR(144, 168, 201, 1);
            secLabel.textColor = RGBACOLOR(89, 89, 89, 1);
            thrLabel.textColor = RGBACOLOR(144, 168, 201, 1);
            
            self.eventsType = @"2";
        }
        else if (button == thrButton)
        {
            firstButton.selected = NO;
            secButton.selected = NO;
            thrButton.selected = YES;
            
            firstLabel.textColor = RGBACOLOR(144, 168, 201, 1);
            secLabel.textColor = RGBACOLOR(144, 168, 201, 1);
            thrLabel.textColor = RGBACOLOR(89, 89, 89, 1);
            
            self.eventsType = @"0";
        }
        
    }
}

@end
