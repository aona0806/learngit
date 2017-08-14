//
//  LJSegmentView.m
//  news
//
//  Created by chunhui on 15/9/30.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJSegmentView.h"
#import "UIColor+Util.h"
#import "UIView+Utils.h"

@interface LJSegmentItemView : UIControl

@property(nonatomic , strong) UILabel *label;

-(void)setHighlight:(BOOL)highlight;

@end

@interface LJSegmentView ()

@property(nonatomic , strong) NSMutableArray *items;
@property(nonatomic , strong) UIView *selectLineView;
@property(nonatomic , strong) NSMutableArray *splitLines;
@property(nonatomic , strong) UIView *topLine;
@property(nonatomic , strong) UIView *bottomLine;

@end

@implementation LJSegmentView


-(instancetype)initWithFrame:(CGRect)frame andItems:(NSArray *)itemNames
{
    self = [super initWithFrame:frame];
    if (self) {
        _items = [NSMutableArray new];
        _splitLines = [NSMutableArray new];
        _selectLineView = [[UIView alloc]init];
        _selectLineView.backgroundColor = HexColor(0x2a7ad9);
        
        _topLine = [[UIView alloc]init];
        _bottomLine = [[UIView alloc]init];
        _topLine.backgroundColor = HexColor(0xdddddd);
        _bottomLine.backgroundColor = _topLine.backgroundColor;
        
        
        [self updateWithNames:itemNames];
        
        _selectedIndex = -1;
        self.selectedIndex = 0;
        
        [self addSubview:_topLine];
        [self addSubview:_bottomLine];
        [self addSubview:_selectLineView];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
/*
 * 中间分隔线
 */
-(UIView *)makeDefaultLine
{
    UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
    line.backgroundColor = HexColor(0xdddddd);
    
    return  line;
}

-(void)updateWithNames:(NSArray *)names
{
    for (LJSegmentItemView *itemView in _items) {
        [itemView removeFromSuperview];
    }
    [_items removeAllObjects];
    for ( UIView *line in _splitLines) {
        [line removeFromSuperview];
    }
    [_splitLines removeAllObjects];
    
    LJSegmentItemView *itemView;
    NSInteger tag = 0;
    for (NSString *name in names) {
        itemView = [[LJSegmentItemView alloc]initWithFrame:CGRectZero];
        itemView.label.text = name;
        [itemView addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
        itemView.tag = tag++;
        
        [self addSubview:itemView];
        [_items addObject:itemView];
    }
    UIView *line = nil;
    for(int i = 1 ; i < [names count] ; i++){
        line = [self makeDefaultLine];
        [self addSubview:line];
        [_splitLines addObject:line];
    }
    
}

-(void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (selectedIndex < 0 || selectedIndex > [_items count]) {
        return;
    }
    if (_selectedIndex == selectedIndex) {
        return;
    }
    _selectedIndex = selectedIndex;
    if ([_items count] > 0) {
        _selectLineView.left = self.width/[_items count]*selectedIndex;
    }
    for (LJSegmentItemView *item in self.items) {
        
        [item setHighlight:NO];
    }
    [(LJSegmentItemView *)self.items[selectedIndex] setHighlight:YES];
}

-(void)updateAtIndext:(NSInteger)index withName:(NSString *)name
{
    if (index < 0 || index > [_items count]) {
        return;
    }
    
    LJSegmentItemView *itemView = _items[index];
    itemView.label.text = name;
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([_items count] == 0) {
        return;
    }
    
    CGRect frame = self.bounds;
    
    if (self.frame.size.height <= 0.1) {
        self.hidden = YES;
        return;
    }
    self.hidden = NO;
    
    frame.size.width /= [_items count];
    
    for (LJSegmentItemView *itemView in _items) {
        itemView.frame = frame;
        frame.origin.x += frame.size.width;
    }
    
    CGFloat padding = frame.size.width;
    frame.origin.x = frame.size.width;
    frame.size.width = 1;
    UIView *line;
    for (line in _splitLines) {
        line.frame = frame;
        frame.origin.x += padding;
    }
    
    _selectLineView.frame = CGRectMake(padding*_selectedIndex, self.height - 2, padding, 2);
    [self bringSubviewToFront:_selectLineView];
    
    frame = self.bounds;
    frame.size.height = 0.5;
    self.topLine.frame = frame;

    frame.origin.y = CGRectGetHeight(self.bounds) - 0.5;
    self.bottomLine.frame = frame;
}


-(void)touchAction:(LJSegmentItemView *)itemView
{
    self.selectedIndex = itemView.tag;
    
    if ([self.delegate respondsToSelector:@selector(selecteAtIndex:)]) {
        [self.delegate selecteAtIndex:itemView.tag];
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


@implementation LJSegmentItemView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _label = [[UILabel alloc]initWithFrame:self.bounds];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = HexColor(0x333333);
//        _label.highlightedTextColor = HexColor(0x3691e1);
        _label.highlightedTextColor = [UIColor redColor];
        _label.font = [UIFont fontWithName:@"Hiragino Sans" size:14];
        [self addSubview:_label];
    }
    return self;
}

-(void)setHighlight:(BOOL)highlight
{
    if(highlight){
        _label.textColor = HexColor(0x3691e1);
    }else{
        _label.textColor = HexColor(0x333333);
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _label.frame = self.bounds;
}

@end