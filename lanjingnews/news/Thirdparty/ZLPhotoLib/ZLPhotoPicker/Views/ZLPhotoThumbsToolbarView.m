//
//  ZLPhotoThumbsToolbarView.m
//  CaiLianShe
//
//  Created by chunhui on 2016/10/17.
//  Copyright © 2016年 chenny. All rights reserved.
//

#import "ZLPhotoThumbsToolbarView.h"
#import "ZLPhotoAssets.h"

NSString *cellid = @"tool_cell";

@interface ZLPhotoThumbsToolbarView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic , strong) UICollectionView *toolBarThumbCollectionView;
@property (nonatomic , strong) UILabel *redDotView;
@property (nonatomic , strong) UIButton *doneBtn;
@end

@implementation ZLPhotoThumbsToolbarView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.toolBarThumbCollectionView];
        [self addSubview:self.doneBtn];
        
    }
    
    return self;
}


- (UILabel *)redDotView
{
    if (!_redDotView) {
        UILabel *redDotView = [[UILabel alloc] init];
        redDotView.textColor = [UIColor whiteColor];
        redDotView.textAlignment = NSTextAlignmentCenter;
        redDotView.font = [UIFont systemFontOfSize:13];
        redDotView.frame = CGRectMake(-5, -5, 20, 20);
        redDotView.hidden = YES;
        redDotView.layer.cornerRadius = redDotView.frame.size.height / 2.0;
        redDotView.clipsToBounds = YES;
        redDotView.backgroundColor = [UIColor redColor];
        [self addSubview:redDotView];
        self.redDotView = redDotView;
        
    }
    return _redDotView;
}

- (UIButton *)doneBtn
{
    if (!_doneBtn) {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:91/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        rightBtn.enabled = YES;
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        rightBtn.frame = CGRectMake(0, 0, 45, 45);
        [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn addSubview:self.redDotView];
        _doneBtn = rightBtn;
        
    }
    return _doneBtn;
}

-(void)doneAction
{
    if (_doneBlock) {
        _doneBlock();
    }
}

- (UICollectionView *)toolBarThumbCollectionView{
    if (!_toolBarThumbCollectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(40, 40);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 5;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        // CGRectMake(0, 22, 300, 44)
        UICollectionView *toolBarThumbCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, self.width - 100, 44) collectionViewLayout:flowLayout];
        toolBarThumbCollectionView.backgroundColor = [UIColor clearColor];
        toolBarThumbCollectionView.dataSource = self;
        toolBarThumbCollectionView.delegate = self;
        [toolBarThumbCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellid];
        
        _toolBarThumbCollectionView = toolBarThumbCollectionView;
        [self addSubview:toolBarThumbCollectionView];
        
        
    }
    return _toolBarThumbCollectionView;
}

-(UIImageView *)imageViewWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    UICollectionViewCell *cell = [self.toolBarThumbCollectionView cellForItemAtIndexPath:indexPath];
    
    UIImageView *imageView = [cell.contentView.subviews lastObject];
    
    return imageView;
    
}

-(void)reloadData
{
    [_toolBarThumbCollectionView reloadData];
}

-(void)updateReddot:(NSArray*)selectArray
{
    self.selectAssets = selectArray;
    NSInteger count = [selectArray count];
    self.redDotView.hidden = !count;
    self.redDotView.text = [NSString stringWithFormat:@"%ld",(long)count];
    self.doneBtn.enabled = (count > 0);
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.selectAssets.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellid forIndexPath:indexPath];
    
    if (self.selectAssets.count > indexPath.item) {
        UIImageView *imageView = [[cell.contentView subviews] lastObject];
        // 判断真实类型
        if (![imageView isKindOfClass:[UIImageView class]]) {
            imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.clipsToBounds = YES;
            [cell.contentView addSubview:imageView];
        }
        imageView.tag = indexPath.item;
        if ([self.selectAssets[indexPath.item] isKindOfClass:[ZLPhotoAssets class]]) {
            imageView.image = [self.selectAssets[indexPath.item] thumbImage];
        }else if ([self.selectAssets[indexPath.item] isKindOfClass:[UIImage class]]){
            imageView.image = (UIImage *)self.selectAssets[indexPath.item];
        }
    }
    
    return cell;
}

#pragma makr UICollectionViewDelegate
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectAtIndexBlock) {
        _selectAtIndexBlock(indexPath.item);
    }
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    self.doneBtn.right = self.width - 10;
    self.doneBtn.centerY = self.height/2;
    
}

@end
