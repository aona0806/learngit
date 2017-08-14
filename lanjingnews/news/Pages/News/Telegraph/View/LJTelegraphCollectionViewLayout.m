//
//  LJTelegraphCollectionViewLayou.m
//  news
//
//  Created by 奥那 on 2017/1/3.
//  Copyright © 2017年 lanjing. All rights reserved.
//

#import "LJTelegraphCollectionViewLayout.h"

@interface LJTelegraphCollectionViewLayout ()



@end

@implementation LJTelegraphCollectionViewLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    if (CGSizeEqualToSize(self.collectionView.bounds.size, newBounds.size)) {
        return NO;
    }else{
        return YES;
    }
}

- (CGSize)collectionViewContentSize
{
    return [self collectionView].frame.size;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat x = _itemPadding*(indexPath.row%3+1)+_itemWidth*(indexPath.row%3);
    CGFloat y = (_itemPadding+_itemWidth)*(indexPath.row/3);
    if (indexPath.section == 1) {
        y += _itemPadding+_itemWidth;
    }
    
    
    CGRect frame = CGRectMake(x, y, _itemWidth, _itemWidth);
    attributes.frame = frame;
    return attributes;
}


- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray* attributes = [NSMutableArray array];
    for(NSInteger i=0 ; i < self.collectionView.numberOfSections; i++) {
        for (NSInteger j=0 ; j < [self.collectionView numberOfItemsInSection:i]; j++) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
    return attributes;
}



@end
