//
//  LJMeetTalkFlowLayout.m
//  news
//
//  Created by chunhui on 15/10/29.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMeetTalkFlowLayout.h"

@implementation LJMeetTalkFlowLayout
/*
-(CGSize)collectionViewContentSize
{
    CGSize size = self.collectionView.bounds.size;
    size.width *= 2;
    return size;
}

- (NSArray*) layoutAttributesForElementsInRect:(CGRect)rect {
        
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    NSInteger width = 2;//self.collectionView.frame.size.width;
    NSInteger height = 1;
    
    for (UICollectionViewLayoutAttributes* attributes in array) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            // see which section this is in
            CGRect configurableRect = UIEdgeInsetsInsetRect(visibleRect, self.sectionInset);
            int horizontalIndex = attributes.indexPath.row % width;
            int verticalIndex = attributes.indexPath.row / width;
            double xspace = (configurableRect.size.width - width * self.itemSize.width) / width;
            double yspace = (configurableRect.size.height - height * self.itemSize.height) / height;
            attributes.center = CGPointMake(attributes.indexPath.section * visibleRect.size.width + self.sectionInset.left + (self.itemSize.width + xspace) * horizontalIndex + self.itemSize.width / 2, self.sectionInset.top + (self.itemSize.height + yspace) * verticalIndex + self.itemSize.height / 2);
        }
    }
    return array;
}
 */


//- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    NSLog(@"++++++++++++++---------------rect is:\n%@\n\n",NSStringFromCGRect(rect));
////    UICollectionViewLayoutAttributes *la = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
////    NSLog(@"la is:\n%@\n\n",la);
////    
////    UICollectionViewLayoutAttributes *l0 = [[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]] copy];
////    
////    UICollectionViewLayoutAttributes *l1 = [[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]] copy];
////    
//////    NSLog(@"l0 is:\n%@\n\n l1 is:\n\n%@\n\n",l0,l1);
//////    NSLog(@"l0 info is:>>>");
//////    [self attrinfo:l0];
//////    NSLog(@"l1 info is:>>>");
//////    [self attrinfo:l1];
//////    
//////    NSLog(@"item size is:%@\n\n",NSStringFromCGSize(self.itemSize));
////    
////    CGRect frame = l0.frame;
////    frame.size = self.itemSize;
////    l0.frame = frame;
////    l0.size  = frame.size;
////
////    frame = l1.frame;
////    frame.size = self.itemSize;
////    l1.frame = frame;
////    l1.size = frame.size;
//    
//    return [super layoutAttributesForElementsInRect:rect];
//    
//}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10) {
        return true;
    }
    return false;
}



@end
