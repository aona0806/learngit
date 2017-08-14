//
//  LYKeyBoardView.h
//  6park
//
//  Created by TI on 15/5/5.
//  Copyright (c) 2015年 6park. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "LYTextView.h"
#import "UIView+Extensions.h"
#import "ChatEmojiView.h"
#import "KeyBoardAnimationV.h"
#import "ChatOtherIconsView.h"
#import "EmoTaxtAttachment.h"
#import "EmojiObj.h"
#import "NSString+Attribute.h"

typedef NS_ENUM( NSInteger , LYKeyBoardType)
{
    kLYKeyBoardNormal = 0 ,
    kLYKeyBoardEmojiOnlyRight = 1, //右侧显示表情
    kLYKeyBoardEmojiOnlyLeft = 2,  //左侧显示表情
    kLYKeyBoardAudioAndEmojiLeft = 3,//左侧显示表情和语音
};

@class LYKeyBoardView;
@protocol LYKeyBoardViewDelegate <NSObject>
@optional
-(void)keyBoardView:(LYKeyBoardView*)keyBoard ChangeDuration:(CGFloat)durtaion;

-(void)keyBoardView:(LYKeyBoardView*)keyBoard sendMessage:(NSString*)message;

-(void)keyBoardView:(LYKeyBoardView*)keyBoard imgPicType:(UIImagePickerControllerSourceType)sourceType;

-(void)keyBoardViewClickImgPic:(LYKeyBoardView*)keyBoard;

-(void)keyBoardView:(LYKeyBoardView*)keyBoard audioRuning:(UILongPressGestureRecognizer*)longPress;

- (void)keyBoardView:(LYKeyBoardView *)keyBoard changeKeyBoardHeight:(CGFloat)height;

- (void)keyBoardView:(LYKeyBoardView *)keyBoard allSpace:(NSString*)spaceStr;

@end

@interface LYKeyBoardView : UIView
@property (nonatomic,strong) UIView * topView;
@property (nonatomic,strong) LYTextView * inputText;
@property (nonatomic,weak) id<LYKeyBoardViewDelegate> delegate;
@property (nonatomic,assign) NSUInteger maxInputCount;//能输入的最大字数
@property (nonatomic,assign) NSInteger  maxValidCount;//最大有效输入，当超过时会触发Maxcount block
@property(nonatomic, copy) void (^maxCountBlock)(NSInteger count);//输入超出后block

//-(instancetype)initDelegate:(id)delegate superView:(UIView*)superView;

/**
 *  初始化
 *
 *  @param delegate  <#delegate description#>
 *  @param superView <#superView description#>
 *  @param isShowPic 是否显示照片功能
 *
 *  @return <#return value description#>
 */
-(instancetype)initDelegate:(id)delegate superView:(UIView *)superView andIsShowPic:(BOOL) isShowPic;

-(instancetype)initDelegate:(id)delegate superView:(UIView *)superView type:(LYKeyBoardType)type;

-(void)textViewChangeText;
-(void)tapAction;

-(void)updateType:(LYKeyBoardType)type;

@end
