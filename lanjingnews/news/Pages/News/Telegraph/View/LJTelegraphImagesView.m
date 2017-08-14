//
//  CSArgueImagesView.m
//  CaiLianShe
//
//  Created by chunhui on 16/7/7.
//  Copyright © 2016年 chenny. All rights reserved.
//

#import "LJTelegraphImagesView.h"
#import "UIImageView+WebCache.h"
#import "LJNewsRollListModel.h"
#import "ImageHelper.h"
#import "UIView+Utils.h"
#import "LJTelegraphCollectionViewLayout.h"

#define kLongImageFont   [UIFont themeLevel3Font]

@interface LJTelegraphImageCell : UICollectionViewCell

@property(nonatomic , strong) UIImageView *imageView;


@end


@interface LJTelegraphImagesView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic , strong) NSArray<LJNewsRollListDataListRollImgsModel *> *images;
@property(nonatomic , strong) UIImageView *bigImageView;
@property(nonatomic , strong) UICollectionView *collectionView;

@property (nonatomic , strong) UIImageView *tagImageView;//长图

@end

@implementation LJTelegraphImagesView

#define kItemPadding 4
#define kSingleImageMaxHeight(width) (width*2.50)
#define kTooLongImageHeight   (SCREEN_HEIGHT/3)
#define kMaxImagesWidth       (SCREEN_WIDTH-30)

+(CGFloat)heightForModel:(NSArray *)images width:(CGFloat)width
{
    if (images.count == 1) {
        LJNewsRollListDataListRollImgsModel *imgModel = (LJNewsRollListDataListRollImgsModel *)[images firstObject];
        
        if (imgModel.thumb.w > 0) {
            
            CGFloat height = [self getImageHeightWithModel:imgModel width:width].height;
            CGFloat maxHeight = kSingleImageMaxHeight(width);
            if (height > maxHeight && height > kTooLongImageHeight*2) {
                //超长图 宽度变成原来的一半，否则太长
                height = kTooLongImageHeight;
            }
            return  height;
            
        }else{
            return 0;
        }
    }
    
    CGFloat itemWidth = (width - 2*kItemPadding)/3;
    NSInteger count = images.count > 9 ? 9 : images.count;
    return (count+2)/3*itemWidth + kItemPadding*((count+2)/3-1);

}

+(CGSize)getImageHeightWithModel:(LJNewsRollListDataListRollImgsModel *)imgModel width:(CGFloat)width
{
    
    CGFloat h = imgModel.thumb.h.floatValue/2.0;
    CGFloat w = imgModel.thumb.w.floatValue/2.0;

    if (h < 1 || w < 1) {
        //没有获得图片大小，先不显示
        h = 0;
        w = width;

    }
    
    CGFloat height = h;
    CGFloat showWidth = w;
    if (w > width) {
        height = ceil((width)*(h/w));
        showWidth = width;
    }
    
    //非长图 但长度超过屏幕的2/3 
    if (h/w < 2.5 && height > SCREEN_HEIGHT/3.0*2) {
        height = SCREEN_HEIGHT/3.0*2;
        showWidth = ceil((height)*(w/h));
    }

    CGSize imgSize = CGSizeMake(showWidth, height);
    
    return imgSize;

}

-(UIImageView *)tagImageView{
    if (!_tagImageView) {
        _tagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 48, 23)];
        _tagImageView.image = [UIImage imageNamed:@"tag_icon"];
        _tagImageView.hidden = YES;
    }
    return _tagImageView;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        _bigImageView = [[UIImageView alloc]init];
        _bigImageView.userInteractionEnabled = true;
        _bigImageView.clipsToBounds = true;
        _bigImageView.backgroundColor = RGB(0xf5,0xf5,0xf5);
        _bigImageView.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [_bigImageView addGestureRecognizer:gesture];
        [_bigImageView addSubview:self.tagImageView];
        
        
        CGFloat itemWidth = (kMaxImagesWidth - 2*kItemPadding)/3;
        LJTelegraphCollectionViewLayout *layout = [[LJTelegraphCollectionViewLayout alloc] init];
        layout.itemWidth = itemWidth;
        layout.itemPadding = kItemPadding;
//        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
//        layout.minimumLineSpacing = kItemPadding;
//        layout.minimumInteritemSpacing = kItemPadding;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = false;
        [_collectionView registerClass:[LJTelegraphImageCell class] forCellWithReuseIdentifier:@"cellid"];
        
        [self addSubview:_bigImageView];
        [self addSubview:_collectionView];
        
    }
    return self;
}


-(void)updateWithImages:(NSArray *)images width:(CGFloat)width
{
    
    self.images = images;

    _bigImageView.hidden = (images.count > 1);
    _collectionView.hidden = !_bigImageView.hidden;
    [_collectionView reloadData];
    
    if (!_bigImageView.hidden) {
        //适配单图
        LJNewsRollListDataListRollImgsModel *img = [images firstObject];

         _bigImageView.size = [[self class] getImageHeightWithModel:img width:width];
        _tagImageView.hidden = YES;
        if (_bigImageView.height > kSingleImageMaxHeight(width) && _bigImageView.height > kTooLongImageHeight*2) {
            
            _bigImageView.height = kTooLongImageHeight;
            _bigImageView.width = width;
            self.tagImageView.right = _bigImageView.right;
            self.tagImageView.top = _bigImageView.bottom - _tagImageView.height;
            self.tagImageView.hidden = NO;
            
            CGFloat height = img.thumb.w.floatValue*_bigImageView.height/_bigImageView.width;
            if (height < img.thumb.h.floatValue) {
                [_bigImageView sd_setImageWithURL:[NSURL URLWithString:img.thumb.url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    _bigImageView.highlightedImage = image;

                    image = [ImageHelper subImageFor:image inRegion:CGRectMake(0, 0, image.size.width,height )];
                    _bigImageView.image = image;
                }];
            }
        }else{
            [_bigImageView sd_setImageWithURL:[NSURL URLWithString:img.thumb.url]];
        }
    }
    

}


-(UIImageView *)imageAtIndex:(NSInteger)index
{
    if (self.images.count == 1) {
        return _bigImageView;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    if (self.images.count == 4) {
        indexPath = [NSIndexPath indexPathForRow:index%2 inSection:index/2];
    }
    LJTelegraphImageCell *cell = (LJTelegraphImageCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.imageView ;
}


#pragma mark -
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if ([_images count] == 4) {
        return 2;
    }
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([_images count] > 1) {
        
        if ([_images count] == 4) {
            return 2;
        }else{
            return [_images count] > 9 ? 9 : [_images count];
        }
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LJTelegraphImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    NSInteger count = indexPath.section*2 + indexPath.item;

    LJNewsRollListDataListRollImgsModel *img = [_images objectAtIndex:count];
    NSString *imgUrl = img.thumb.url?:img.org.url;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(_tapBlock){
        LJTelegraphImageCell *cell =  (LJTelegraphImageCell *)[collectionView cellForItemAtIndexPath:indexPath];
        _tapBlock(indexPath.item,indexPath.section , cell.imageView );
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 1) {
        return UIEdgeInsetsMake(kItemPadding, 0, 0, 0);//分别为上、左、下、右
    }
    return UIEdgeInsetsZero;
}

-(void)tapAction:(UITapGestureRecognizer *)gesture
{
    if(_tapBlock){
        _tapBlock(0,0 , _bigImageView);
    }
}


@end


@implementation LJTelegraphImageCell


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.backgroundColor = HexColor(0xf5f5f5);
        [self.contentView addSubview:_imageView];
        
        self.contentView.clipsToBounds = true;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
}


@end
