//
//  LJInputFieldTableViewCell.m
//  news
//
//  Created by 陈龙 on 15/12/19.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJInputFieldTableViewCell.h"
#import "NSString+TKSize.h"

@interface LJInputFieldTableViewCell () {
    UILabel *placeHodeLabel;
    UIView *seperateLineView;
}

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UITextField *contentTField;
@property (nonatomic, retain) UILabel *animoteLabel;

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *content;

@end

#pragma mark - lifecycle

@implementation LJInputFieldTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize: 14];
        [self.contentView addSubview: _titleLabel];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(20);
            make.size.mas_equalTo(CGSizeMake(50, 40));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(50);
        }];
        
        _contentTField = [[UITextField alloc] initWithFrame: CGRectMake(70, 5, 200, 40)];
        _contentTField.backgroundColor = [UIColor clearColor];
        _contentTField.textColor = [UIColor colorWithRed:112/255.0f green:112/255.0f blue:112/255.0f alpha:1];
        _contentTField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _contentTField.autocorrectionType = UITextAutocorrectionTypeNo;
        _contentTField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _contentTField.returnKeyType = UIReturnKeyDone;
        _contentTField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _contentTField.font = [UIFont systemFontOfSize: 14];
        [self.contentView addSubview:self.contentTField];
        
        [self.contentTField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_right).offset(0);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
            make.height.mas_equalTo(@40);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        seperateLineView = [[UIView alloc] init];
        seperateLineView.backgroundColor = [UIColor lightGrayColor];
        seperateLineView.hidden = YES;
        [self.contentView addSubview:seperateLineView];
        [seperateLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_left);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(0.3);
            make.right.mas_equalTo(self.contentView.mas_right);
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(TextFieldDidChange:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:self.contentTField];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (instancetype _Nonnull)initWithTitle:(NSString * _Nonnull)title
                            placeholder:(NSString * _Nullable)placreholder
                        reuseIdentifier:(NSString * _Nonnull)reuseIdentifier
{
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.title = title;
        self.titleLabel.text = title;
        self.contentTField.placeholder = placreholder;
    }
    return self;
}

- (instancetype _Nonnull)initWithTitle:(NSString * _Nonnull)title
                  placeholder:(NSString * _Nullable)placreholder
                  animoteText:(NSString * _Nonnull)animoteString
              reuseIdentifier:(NSString * _Nonnull)reuseIdentifier
{
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.title = title;
        self.titleLabel.text = title;
        self.contentTField.placeholder = placreholder;
        
        self.animoteLabel = [UILabel new];
        self.animoteLabel.text = animoteString;
        self.animoteLabel.hidden = true;
        self.animoteLabel.backgroundColor = [UIColor redColor];
        UIColor *origenC = RGBA(249, 163, 127, 1);
        _animoteLabel.textColor = origenC;
        CGRect animoteRect = CGRectMake(140, 5, 80, 40);
        self.animoteLabel.frame = animoteRect;
        [self.contentView addSubview:self.animoteLabel];
        [self.animoteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentTField.mas_left).offset(10);
            make.centerY.mas_equalTo(self.contentView);
            CGFloat width = [animoteString sizeWithMaxWidth:200 font:self.animoteLabel.font].width;
            make.width.mas_equalTo(width);
        }];
        

    }
    return self;
}

- (void)setDelegate:(id<LJInputFieldTableViewCellDelegate>)delegate
{
    _delegate = delegate;
    _contentTField.delegate = (id)delegate;
}

#pragma mark - public 

- (void)setIsShowSeperateLine:(BOOL)isShowSeperateLine {
    if (isShowSeperateLine) {
        seperateLineView.hidden = NO;
    } else {
        seperateLineView.hidden = YES;
    }
}

- (void)updateInfo:(NSString * _Nullable)content
{
    if (content) {
        self.content = content;
        self.contentTField.text = content;
    }
}

- (void)animation:(void (^ __nullable)(BOOL finished))completion
{
    if (!self.animoteLabel) {
        return;
    }
    
    self.animoteLabel.hidden = NO;
//    self.alpha = 1;
    [UIView animateWithDuration:0.7 animations:^{
        self.animoteLabel.transform = CGAffineTransformMake(1.3, 0, 0, 1.3, 0, -20);
        self.animoteLabel.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            
            self.animoteLabel.transform = CGAffineTransformMake(1.0, 0, 0, 1.0, 0, 0);
            self.animoteLabel.hidden = YES;
            if (completion) {
                completion(finished);
            }
        }
    }];
}

- (void)setKeytboardType:(UIKeyboardType)kytboardType {
    if (self.contentTField) {
        self.contentTField.keyboardType = kytboardType;
    }
}

#pragma mark - UITextFieldDelegate

- (void)TextFieldDidChange:(NSNotification *)notification
{    
    self.content = self.contentTField.text;
    if (self.delegate && [self.delegate respondsToSelector:@selector(LJInputFieldUpdateWithTitle:content:)]) {
        if (self.title && self.content) {
            [self.delegate LJInputFieldUpdateWithTitle:self.title content:self.content];
        }
    }
}

@end
