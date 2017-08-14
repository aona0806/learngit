//
//  LJMeetCollectionViewCell.m
//  news
//
//  Created by chunhui on 15/11/18.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMeetCollectionViewCell.h"

@implementation LJMeetCollectionViewCell

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    /*
     The default value of this property is CGSizeZero. Setting it to any other value causes the collection view to query each cell for its actual size using the cell’s preferredLayoutAttributesFittingAttributes: method. If all of your cells are the same height, use the itemSize property, instead of this property, to specify the cell size instead.
     
     */
//    NSLog(@"-----%@-------\n layout attributes are:\n%@\n\n\n",NSStringFromSelector(_cmd),layoutAttributes);
    return layoutAttributes;
}

//-(BOOL)respondsToSelector:(SEL)aSelector
//{
//    NSLog(@"-----%@-------\n\n\n\n",NSStringFromSelector(aSelector));
//    return [super respondsToSelector:aSelector];
//}

@end
