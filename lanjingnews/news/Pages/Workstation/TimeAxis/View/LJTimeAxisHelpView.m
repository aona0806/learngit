//
//  LJTimeAxisHelpView.m
//  news
//
//  Created by 奥那 on 15/12/22.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJTimeAxisHelpView.h"

@implementation LJTimeAxisHelpView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutMySubViews];
    }
    return self;
}

- (void)layoutMySubViews{

    self.backgroundColor = RGBA(102, 102, 102, 0.5);
    UITapGestureRecognizer *tapGestureGecongnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissHelperView:)];
    [self addGestureRecognizer:tapGestureGecongnizer];
    
    UIImage *tipBackImage = [UIImage imageNamed:@"workstation_sharetip"];
    tipBackImage = [tipBackImage resizableImageWithCapInsets:UIEdgeInsetsMake(20, 10, 10, 30) resizingMode:UIImageResizingModeTile];
    UIImageView *tipBackImageView = [[UIImageView alloc] initWithImage:tipBackImage];
    [self addSubview:tipBackImageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"每日分享即可获得2个蓝鲸币"];
    [attributeString addAttribute:NSForegroundColorAttributeName
                            value:[UIColor whiteColor]
                            range:NSMakeRange(0, attributeString.length)];
    [attributeString addAttribute:NSFontAttributeName
                            value:[UIFont boldSystemFontOfSize:12]
                            range:NSMakeRange(0, attributeString.length)];
    
    label.attributedText = attributeString;
    [tipBackImageView addSubview:label];
    
    [tipBackImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(105, 41));
        make.top.equalTo(self.mas_top).offset(55);
        make.right.equalTo(self.mas_right).offset(-11);
    }];
    
    [label mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(tipBackImageView).with.insets(UIEdgeInsetsMake(10,10,0,10));
        
    }];

}

- (void)dismissHelperView:(UITapGestureRecognizer *)tap{
    if (_dismissHelperView) {
        self.dismissHelperView(self);
    }
}

@end
