//
//  TKTapCharLabel.m
//  ToolKitDemo
//
//  Created by chunhui on 2016/10/11.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import "TKTapCharLabel.h"
#import "NSAttributedString+TKSize.h"

@interface TKTapCharLabel ()<NSLayoutManagerDelegate>

// Used to control layout of glyphs and rendering
@property (nonatomic, retain) NSLayoutManager *layoutManager;

// Specifies the space in which to render text
@property (nonatomic, retain) NSTextContainer *textContainer;

// Backing storage for text that is rendered by the layout manager
@property (nonatomic, retain) NSTextStorage *textStorage;

@end

@implementation TKTapCharLabel

+(NSInteger)charIndexWithAttrString:(NSAttributedString *)attrStr widthWidth:(CGFloat)width lineNum:(NSInteger)lineNum lastLinePadding:(CGFloat)padding lineBreakMode:(NSLineBreakMode)breakMode
{
    CGSize size = [attrStr sizeWithMaxWidth:width font:nil maxLineNum:lineNum];
    
    NSTextContainer *container = [[NSTextContainer alloc]init];
    
    container = [[NSTextContainer alloc] init];
    container.lineFragmentPadding = 0;
    container.maximumNumberOfLines = lineNum;
    container.lineBreakMode = breakMode;
    container.size = CGSizeMake(size.width, size.height + 100);
    
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc]init];
    [layoutManager addTextContainer:container];
    
    [container setLayoutManager:layoutManager];
    
    NSTextStorage *storage = [[NSTextStorage alloc]initWithAttributedString:attrStr];
    [storage addLayoutManager:layoutManager];
    [layoutManager setTextStorage:storage];
    
    NSUInteger charIndex = [layoutManager glyphIndexForPoint:CGPointMake(width - padding, size.height - 3) inTextContainer:container];
    
    return charIndex;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupTextSystem];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setupTextSystem];
    }
    
    return self;
}

// Common initialisation. Must be done once during construction.
- (void)setupTextSystem
{
    // Create a text container and set it up to match our label properties
    _textContainer = [[NSTextContainer alloc] init];
    _textContainer.lineFragmentPadding = 0;
    _textContainer.maximumNumberOfLines = self.numberOfLines;
    _textContainer.lineBreakMode = self.lineBreakMode;
    _textContainer.size = self.frame.size;
    
    // Create a layout manager for rendering
    _layoutManager = [[NSLayoutManager alloc] init];
    _layoutManager.delegate = self;
    [_layoutManager addTextContainer:_textContainer];
    
    // Attach the layou manager to the container and storage
    [_textContainer setLayoutManager:_layoutManager];
    
    // Make sure user interaction is enabled so we can accept touches
    self.userInteractionEnabled = YES;
    
}


- (void)setNumberOfLines:(NSInteger)numberOfLines
{
    [super setNumberOfLines:numberOfLines];
    
    _textContainer.maximumNumberOfLines = numberOfLines;
}

-(void)setLineBreakMode:(NSLineBreakMode)lineBreakMode
{
    [super setLineBreakMode:lineBreakMode];
    _textContainer.lineBreakMode = lineBreakMode;
}


-(void)setText:(NSString *)text
{
    NSMutableDictionary *attrDict = [[NSMutableDictionary alloc]initWithCapacity:2];
    if (self.font) {
        [attrDict setObject:self.font forKey:NSFontAttributeName];
    }
    if (self.textColor) {
        [attrDict setObject:self.textColor forKey:NSForegroundColorAttributeName];
    }
    NSAttributedString *attrText = [[NSAttributedString alloc]initWithString:text attributes:attrDict];
    [self setAttributedText:attrText];
}

-(void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self updateTextStoreWithAttributedString:attributedText];
}

- (void)updateTextStoreWithAttributedString:(NSAttributedString *)attributedString
{
    if (_textStorage)
    {
        // Set the string on the storage
        [_textStorage setAttributedString:attributedString];
    } else {
        // Create a new text storage and attach it correctly to the layout manager
        _textStorage = [[NSTextStorage alloc] initWithAttributedString:attributedString];
        [_textStorage addLayoutManager:_layoutManager];
        [_layoutManager setTextStorage:_textStorage];
    }
}


// Returns the XY offset of the range of glyphs from the view's origin
- (CGPoint)calcGlyphsPositionInView
{
    CGPoint textOffset = CGPointZero;
    
    CGRect textBounds = [_layoutManager usedRectForTextContainer:_textContainer];
    textBounds.size.width = ceil(textBounds.size.width);
    textBounds.size.height = ceil(textBounds.size.height);
    
    if (textBounds.size.height < self.bounds.size.height)
    {
        CGFloat paddingHeight = (self.bounds.size.height - textBounds.size.height) / 2.0;
        textOffset.y = paddingHeight;
    }
    
    return textOffset;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _textContainer.size = self.bounds.size;
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    _textContainer.size = self.bounds.size;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Update our container size when the view frame changes
    _textContainer.size = self.bounds.size;
}


#pragma mark - Interactions

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Do nothing if we have no text
    if (_textStorage.string.length == 0)
    {
        [super touchesBegan:touches withEvent:event];
        return ;
    }
    
    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    
    [self.textStorage setAttributedString:self.attributedText];
    self.textContainer.lineFragmentPadding = 0;
    self.textContainer.maximumNumberOfLines = self.numberOfLines;
    self.textContainer.lineBreakMode = self.lineBreakMode;
    self.textContainer.size = CGSizeMake(self.bounds.size.width, self.bounds.size.height+100);
    
    NSUInteger touchedChar = [_layoutManager glyphIndexForPoint:touchLocation inTextContainer:_textContainer];
    
    BOOL handle = false;
    if (_handleTapCharAtIndex) {
        handle = _handleTapCharAtIndex(touchedChar);
    }
    if (!handle) {
        [super touchesBegan:touches withEvent:event];
    }
    
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
