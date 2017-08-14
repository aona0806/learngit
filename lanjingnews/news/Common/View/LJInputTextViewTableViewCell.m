//
//  LJInputTextViewTableViewCell.m
//  news
//
//  Created by 陈龙 on 15/12/21.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJInputTextViewTableViewCell.h"
#import "UITextView+Placeholder.h"

@interface LJInputTextViewTableViewCell () <UITextViewDelegate>

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *content;

@end

@implementation LJInputTextViewTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.title = @"备注";
        
        self.contentTextView = [UITextView new];
        self.contentTextView.font = [UIFont fontWithName:@"Arial" size:14.0];
        self.contentTextView.backgroundColor = [UIColor whiteColor];
        self.contentTextView.returnKeyType = UIReturnKeyDefault;
        self.contentTextView.keyboardType = UIKeyboardTypeDefault;
        self.contentTextView.backgroundColor = [UIColor clearColor];
        self.contentTextView.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.contentTextView];
        self.contentTextView.placeholder = @"请添加个人简介及备注信息...";
        [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self.contentTextView];
    }
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - public

- (void)updateInfo:(NSString * _Nullable)content
{
    self.content = content;
    self.contentTextView.text = content;
}

#pragma mark - UITextViewDelegate

- (void)textDidChange:(NSNotification *)notification{
    
    self.content = self.contentTextView.text;
    if (self.delegate && [self.delegate respondsToSelector:@selector(LJInputTextViewUpdateWithTitle:content:)]) {
        if (self.title && self.content) {
            [self.delegate LJInputTextViewUpdateWithTitle:self.title content:self.content];
        }
    }
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    if (self.contentTextView && placeHolder) {
        self.contentTextView.placeholder = placeHolder;
    }

}
@end
