//
//  TCCopyableLabel.m
//  TCLabel
//
//  Created by Thibault Charbonnier on 12/04/14.
//  Copyright (c) 2014 Thibault Charbonnier. All rights reserved.
//

#import "TCCopyableLabel.h"

@interface TCCopyableLabel ()
@property (nonatomic, strong) UILongPressGestureRecognizer* longPressGestureRecognizer;
@property (nonatomic, strong) UIColor *defaultColor;
@property (nonatomic) BOOL isOnLongPress;
@property (nonatomic) BOOL isActivit;

- (void)onLongGesture:(UILongPressGestureRecognizer *)gestureRecognizer;

@end

@implementation TCCopyableLabel

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<TCCopyableLabelDelegate>)delegate
{
    self = [self initWithFrame:frame];
    [self setDelegate:delegate];

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame copiedBlock:(void (^)(NSString *copiedString))copiedBlock
{
    self = [self initWithFrame:frame];
    [self setLabelCopied:copiedBlock];
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

#pragma mark - Internal Methods

- (void)setup
{
    self.isOnLongPress = NO;
    self.isActivit = NO;
    
    [self setCopyingEnabled:YES];
    
    if (!self.longPressGestureRecognizer) {
        self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(onLongGesture:)];
        [self addGestureRecognizer:self.longPressGestureRecognizer];
    }
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(UIMenuControllerWillHide:)
                               name:UIMenuControllerWillHideMenuNotification
                             object:nil];
    [notificationCenter addObserver:self
                           selector:@selector(UIMenuControllerWillShow:)
                               name:UIMenuControllerWillShowMenuNotification
                             object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onLongGesture:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        self.isOnLongPress = YES;
    
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        [menuController setTargetRect:self.bounds inView:self];
        [menuController setMenuVisible:YES animated:YES];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
        self.isOnLongPress = NO;
    }
}

#pragma mark - Custom Setters

- (void)setCopyingEnabled:(BOOL)enableCopying
{
    _copyingEnabled = enableCopying;
    
    [self setUserInteractionEnabled:enableCopying];
}

- (void)setMinimumPressDuration:(CFTimeInterval)minimumPressDuration
{
    _minimumPressDuration = minimumPressDuration;
    
    [self.longPressGestureRecognizer setMinimumPressDuration:minimumPressDuration];
}

#pragma mark - UIResponder

- (BOOL)canBecomeFirstResponder
{
    return self.copyingEnabled;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copy:)) {
        return YES;
    } else {
        return [super canPerformAction:action withSender:sender];
    }
}

- (void)copy:(id)sender
{
    NSString *copiedStr = (self.customString != nil) ? self.customString : self.text;
    
    if ([copiedStr isKindOfClass:[NSString class]]) {
        [[UIPasteboard generalPasteboard] setString:copiedStr];
    }
    
    if ([self.delegate respondsToSelector:@selector(label:didCopyText:)]) {
        [self.delegate label:self didCopyText:copiedStr];
    }
    if (self.labelCopied != nil) {
        self.labelCopied(copiedStr);
    }
}

#pragma mark - UIMenuController Notification

- (void)UIMenuControllerWillHide:(NSNotification *)notification
{
    if (self.isActivit) {
        self.backgroundColor = self.defaultColor;
        self.isActivit = NO;
    }

}

- (void)UIMenuControllerWillShow:(NSNotification *)notification
{
    if (self.isOnLongPress && !self.isActivit) {
        self.isActivit = !self.isActivit;
        self.defaultColor = self.backgroundColor;
        
        self.backgroundColor = [UIColor lightGrayColor];
        

    }
}

@end
