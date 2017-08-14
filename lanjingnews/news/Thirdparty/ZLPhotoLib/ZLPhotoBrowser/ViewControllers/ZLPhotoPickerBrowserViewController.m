//
//  ZLPhotoPickerBrowserViewController.m
//  ZLAssetsPickerDemo
//
//  Created by 张磊 on 14-11-14.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <objc/runtime.h>
#import "ZLPhotoPickerBrowserViewController.h"
#import "ZLPhotoPickerBrowserPhoto.h"
#import "ZLPhotoPickerDatas.h"
#import "UIView+Extension.h"
#import "ZLPhotoPickerBrowserPhotoScrollView.h"
#import "ZLPhotoPickerCommon.h"
#import "ZLPhotoPickerBrowserCollectionViewCell.h"


#define kBottomBarHeight 46

static NSString *_cellIdentifier = @"collectionViewCell";

@interface ZLPhotoPickerBrowserViewController () <UIScrollViewDelegate,ZLPhotoPickerPhotoScrollViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>

// 控件
@property (weak,nonatomic) UILabel   *pageLabel;
@property (weak,nonatomic) UIButton  *deleleBtn;
@property (weak,nonatomic) UIButton  *backBtn;

@property (nonatomic , strong) UIView *fakeNavbar;
@property (nonatomic , strong) UILabel *titleLabel;
@property (nonatomic , strong) UIButton *rightButton;
@property (nonatomic , strong) UIView *bottomBar;
@property (nonatomic , strong) UIButton *bottomDoneButton;

@property (weak,nonatomic) UICollectionView *collectionView;

// 数据相关
// 单击时执行销毁的block
@property (nonatomic , copy) ZLPickerBrowserViewControllerTapDisMissBlock disMissBlock;
// 装着所有的图片模型
//@property (nonatomic , strong) NSMutableArray *photos;
// 当前提供的分页数
@property (nonatomic , assign) NSInteger currentPage;

@end


@implementation ZLPhotoPickerBrowserViewController

#pragma mark collectionView
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        CGFloat height = self.view.height;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = ZLPickerColletionViewPadding;
        flowLayout.itemSize = self.view.size;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
//        if (_browserMode != ZLPhotoPickerBrowserModeDefault) {
//            height -= _fakeNavbar.bottom;
//            if (_browserMode == ZLPhotoPickerBrowserModePushCheckable) {
//                height -= kBottomBarHeight;
//            }
//        }
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width + ZLPickerColletionViewPadding ,height) collectionViewLayout:flowLayout];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.pagingEnabled = YES;
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.bounces = YES;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[ZLPhotoPickerBrowserCollectionViewCell class] forCellWithReuseIdentifier:_cellIdentifier];
        
        [self.view addSubview:collectionView];
        self.collectionView = collectionView;
        
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        
//        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-x-|" options:0 metrics:@{@"x":@(-20)} views:@{@"_collectionView":_collectionView}]];
//        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_collectionView]-0-|" options:0 metrics:nil views:@{@"_collectionView":_collectionView}]];
        
        if (_pushIn){
            [self.view sendSubviewToBack:collectionView];
        }
        self.pageLabel.hidden = _pushIn;
        self.deleleBtn.hidden = _pushIn ? true :  !self.isEditing;
        
        
    }
    return _collectionView;
}

-(UIView *)bottomBar
{
    if (!_bottomBar) {
        _bottomBar = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height - 46, self.view.width, 46)];
        _bottomBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"完成" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.layer.cornerRadius = 4;
        button.layer.masksToBounds  = true;
        button.backgroundColor = RGB(0xff, 0x38, 0x24);
        
        [button addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
        
        button.bounds = CGRectMake(0, 0, 85, 24);
        button.right = _bottomBar.width - 15;
        button.centerY = _bottomBar.height/2;
        button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        self.bottomDoneButton = button;
        
        _bottomBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.55];
        [_bottomBar addSubview:button];
        
    }
    return _bottomBar;
}

#pragma mark deleleBtn
- (UIButton *)deleleBtn
{
    if (!_deleleBtn) {
        UIButton *deleleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleleBtn.translatesAutoresizingMaskIntoConstraints = NO;
        deleleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [deleleBtn setImage:[UIImage imageNamed:@"photo_picker_delete"] forState:UIControlStateNormal];
        // 设置阴影
        deleleBtn.layer.shadowColor = [UIColor blackColor].CGColor;
        deleleBtn.layer.shadowOffset = CGSizeMake(0, 0);
        deleleBtn.layer.shadowRadius = 3;
        deleleBtn.layer.shadowOpacity = 1.0;
        
        [deleleBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        deleleBtn.hidden = YES;
        [self.view addSubview:deleleBtn];
        self.deleleBtn = deleleBtn;
        
        NSString *widthVfl = @"H:[deleleBtn(deleteBtnWH)]-margin-|";
        NSString *heightVfl = @"V:|-margin-[deleleBtn(deleteBtnWH)]";
        NSDictionary *metrics = @{@"deleteBtnWH":@(50),@"margin":@(10)};
        NSDictionary *views = NSDictionaryOfVariableBindings(deleleBtn);
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:metrics views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:metrics views:views]];
        
    }
    return _deleleBtn;
}

//-(UIButton *)backBtn
//{
//    if (!_backBtn) {
//        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    }
//    return _backBtn;
//}

#pragma mark pageLabel
- (UILabel *)pageLabel
{
    if (!_pageLabel) {
        UILabel *pageLabel = [[UILabel alloc] init];
        pageLabel.font = [UIFont systemFontOfSize:18];
        pageLabel.textAlignment = NSTextAlignmentCenter;
        pageLabel.userInteractionEnabled = NO;
        pageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        pageLabel.backgroundColor = [UIColor clearColor];
        pageLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:pageLabel];
        self.pageLabel = pageLabel;
        
        NSString *widthVfl = @"H:|-0-[pageLabel]-0-|";
        NSString *heightVfl = @"V:[pageLabel(ZLPickerPageCtrlH)]-20-|";
        NSDictionary *views = NSDictionaryOfVariableBindings(pageLabel);
        NSDictionary *metrics = @{@"ZLPickerPageCtrlH":@(ZLPickerPageCtrlH)};
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:metrics views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:metrics views:views]];
        
    }
    return _pageLabel;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:true];
}
/*
 * 点击完成
 */
-(void)doneAction
{
    if ([self.delegate respondsToSelector:@selector(photoBrowserClickDone:)]) {
        [self.delegate photoBrowserClickDone:self];
    }else{
        [self backAction];
    }
}

-(void)checkAction
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:changeCheckPhotoAtIndexPath:photo:)]) {
        
        NSInteger index = (NSInteger)(self.collectionView.contentOffset.x / self.collectionView.width);
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        
        ZLPhotoPickerBrowserPhoto *photo = [self.dataSource photoBrowser:self photoAtIndexPath:indexPath];
        
        BOOL updated = [self.delegate photoBrowser:self changeCheckPhotoAtIndexPath:indexPath photo:photo];
        if (updated) {
            photo.checked = !photo.checked;
            self.rightButton.selected = !self.rightButton.selected;
        }
        [self updateBottomBar];
    }
}


-(void)initNavbar
{
    _fakeNavbar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    _fakeNavbar.backgroundColor = [UIColor blackColor];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIImage *img = [UIImage imageNamed:@"photo_picker_back_white"];
    [backButton setImage:img forState:UIControlStateNormal];
    [backButton sizeToFit];
    backButton.left = 0;
    backButton.width += 20;
    backButton.backgroundColor = [UIColor clearColor];
    backButton.bottom = _fakeNavbar.height - 10;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (_browserMode == ZLPhotoPickerBrowserModePushDeleteable) {
        
        self.navigationItem.titleView = self.titleLabel;
        img = [UIImage imageNamed:@"photo_picker_delete"];
        [rightButton setImage:img forState:UIControlStateNormal];
        
        [rightButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        
        [rightButton sizeToFit];
    }else{
        
        img = [UIImage imageNamed:@"photo_browser_check"];
        [rightButton setImage:img forState:UIControlStateNormal];
        img = [UIImage imageNamed:@"photo_picker_checked"];
        [rightButton setImage:img forState:UIControlStateSelected];
        
        [rightButton addTarget:self action:@selector(checkAction) forControlEvents:UIControlEventTouchUpInside];
        
        [rightButton sizeToFit];
        rightButton.bounds = CGRectMake(0, 0, rightButton.width + 15, rightButton.height + 15);
    }

    rightButton.right = _fakeNavbar.width - 10;
    rightButton.centerY = backButton.centerY;
    
    self.rightButton = rightButton;
    

    [_fakeNavbar addSubview:backButton];
    [_fakeNavbar addSubview:rightButton];
    [_fakeNavbar addSubview:self.titleLabel];
    _titleLabel.center = CGPointMake(_fakeNavbar.width/2, _fakeNavbar.height/2 + 10 );
    
    [self.view addSubview:_fakeNavbar];
}

#pragma mark - Life cycle
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = [UIColor blackColor];
    
    if (_pushIn) {
        [self initNavbar];
        if (_browserMode == ZLPhotoPickerBrowserModePushCheckable) {
            [self.view addSubview:self.bottomBar];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_pushIn) {
        [self.navigationController setNavigationBarHidden:true animated:true];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSAssert(self.dataSource, @"你没成为数据源代理");
    // 初始化动画
    [self showToView];
}

- (void)showToView
{
    if (_browserMode == ZLPhotoPickerBrowserModeDefault) {
        
        UIView *mainView = [[UIView alloc] init];
        mainView.backgroundColor = [UIColor blackColor];
        mainView.frame = [UIScreen mainScreen].bounds;
        [[UIApplication sharedApplication].keyWindow addSubview:mainView];
        
        UIImageView *toImageView = nil;
        
        if(self.status == UIViewAnimationAnimationStatusZoom){
            toImageView = (UIImageView *)[[self.dataSource photoBrowser:self photoAtIndexPath:self.currentIndexPath] toView];
        }
        
        if (![toImageView isKindOfClass:[UIImageView class]] && self.status != UIViewAnimationAnimationStatusFade) {
            assert(@"error: need toView `UIImageView` class.");
            return;
        }
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [mainView addSubview:imageView];
        mainView.clipsToBounds = YES;
        
        UIImage *thumbImage = [[self.dataSource photoBrowser:self photoAtIndexPath:self.currentIndexPath] thumbImage];
        
        if (self.status == UIViewAnimationAnimationStatusFade){
            imageView.image = thumbImage;
        }else{
            if (thumbImage == nil) {
                imageView.image = toImageView.image;
            }else{
                imageView.image = thumbImage;
            }
        }
        
        if (self.status == UIViewAnimationAnimationStatusFade){
            imageView.alpha = 0.0;
            imageView.frame = [self setMaxMinZoomScalesForCurrentBounds:imageView.image];
        }else if(self.status == UIViewAnimationAnimationStatusZoom){
            CGRect tempF = [toImageView.superview convertRect:toImageView.frame toView:[self getParsentView:toImageView]];
            if (self.navigationHeight) {
                tempF.origin.y += self.navigationHeight;
            }
            imageView.frame = tempF;
        }
        
        __weak typeof(self)weakSelf = self;
        self.disMissBlock = ^(NSInteger page){
            mainView.hidden = NO;
            mainView.alpha = 1.0;
            CGRect originalFrame = CGRectZero;
            BOOL animated = false;
            if (weakSelf.transitioningDelegate) {
                animated = true;
            }
            
            [weakSelf dismissViewControllerAnimated:animated completion:nil];
            
            // 不是淡入淡出
            if(weakSelf.status == UIViewAnimationAnimationStatusZoom){
                
                UIImage *thumbImage = [[weakSelf.dataSource photoBrowser:weakSelf photoAtIndexPath:[NSIndexPath indexPathForItem:page inSection:weakSelf.currentIndexPath.section]] thumbImage];
                
                if (thumbImage == nil) {
                    thumbImage = [(UIImageView *)[[weakSelf.dataSource photoBrowser:weakSelf photoAtIndexPath:[NSIndexPath indexPathForItem:page inSection:weakSelf.currentIndexPath.section]] toView] image];
                }
                
                imageView.image = thumbImage;
                imageView.frame = [weakSelf setMaxMinZoomScalesForCurrentBounds:imageView.image];
                imageView.clipsToBounds = true;
                
                UIImageView *toImageView2 = (UIImageView *)[[weakSelf.dataSource photoBrowser:weakSelf photoAtIndexPath:[NSIndexPath indexPathForItem:page inSection:weakSelf.currentIndexPath.section]] toView];
                originalFrame = [toImageView2.superview convertRect:toImageView2.frame toView:[weakSelf getParsentView:toImageView2]];
            }
            
            if (weakSelf.navigationHeight) {
                originalFrame.origin.y += weakSelf.navigationHeight;
            }
            
            [UIView animateWithDuration:0.35 animations:^{
                if (weakSelf.status == UIViewAnimationAnimationStatusFade){
                    imageView.alpha = 0.0;
                    mainView.alpha = 0.0;
                }else if(weakSelf.status == UIViewAnimationAnimationStatusZoom){
                    mainView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
                    imageView.frame = originalFrame;
                }
            } completion:^(BOOL finished) {
                [mainView removeFromSuperview];
                [imageView removeFromSuperview];
                imageView.alpha = 1.0;
                mainView.alpha = 1.0;
            }];
        };
        
        [weakSelf reloadData];
        [UIView animateWithDuration:0.35 animations:^{
            if (self.status == UIViewAnimationAnimationStatusFade){
                // 淡入淡出
                imageView.alpha = 1.0;
            }else if(self.status == UIViewAnimationAnimationStatusZoom){
                imageView.frame = [self setMaxMinZoomScalesForCurrentBounds:imageView.image];
            }
        } completion:^(BOOL finished) {
            mainView.hidden = YES;
        }];
        
    }else{
        [self reloadData];
    }
}

- (CGRect)setMaxMinZoomScalesForCurrentBounds:(UIImage *)image
{
    if (!([image isKindOfClass:[UIImage class]]) || image == nil) {
        if (!([image isKindOfClass:[UIImage class]])) {
            return CGRectZero;
        }
    }
    
    // Sizes
    CGSize boundsSize = [UIScreen mainScreen].bounds.size;
    CGSize imageSize = image.size;
    if (imageSize.width == 0 && imageSize.height == 0) {
        return CGRectZero;
    }
    
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
    // Image is smaller than screen so no zooming!
    if (xScale >= 1 && yScale >= 1) {
        minScale = MIN(xScale, yScale);
    }
    
    if (minScale >= 3) {
        minScale = 3;
    }
    
    CGRect frameToCenter = CGRectMake(0, 0, imageSize.width * minScale, imageSize.height * minScale);
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    
    return frameToCenter;
}


#pragma mark - Get
#pragma mark getPhotos
- (NSArray *) getPhotos
{
    NSMutableArray *photos = [NSMutableArray array];
    NSInteger section = self.currentIndexPath.section;
    NSInteger rows = [self.dataSource photoBrowser:self numberOfItemsInSection:section];
    for (NSInteger i = 0; i < rows; i++) {
        [photos addObject:[self.dataSource photoBrowser:self photoAtIndexPath:[NSIndexPath indexPathForItem:i inSection:section]]];
    }
    return photos;
}

#pragma mark get Controller.view
- (UIView *)getParsentView:(UIView *)view{
    
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];    
    if (window) {
        return window;
    }
    
    if ([[view nextResponder] isKindOfClass:[UIViewController class]] || view == nil) {
        return view;
    }
    return [self getParsentView:view.superview];
}

- (id)getParsentViewController:(UIView *)view{
    if ([[view nextResponder] isKindOfClass:[UIViewController class]] || view == nil) {
        return [view nextResponder];
    }
    return [self getParsentViewController:view.superview];
}

#pragma mark - reloadData
- (void)reloadData{
    if (self.currentPage <= 0){
        self.currentPage = self.currentIndexPath.item;
    }else{
        --self.currentPage;
    }
    
    NSInteger count = [self.dataSource photoBrowser:self numberOfItemsInSection:0];
    
    if (self.currentPage >= count) {
        self.currentPage = count - 1;
    }
    
    [self.collectionView reloadData];
    
    // 添加自定义View
    if ([self.delegate respondsToSelector:@selector(photoBrowserShowToolBarViewWithphotoBrowser:)]) {
        UIView *toolBarView = [self.delegate photoBrowserShowToolBarViewWithphotoBrowser:self];
        toolBarView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        CGFloat width = self.view.width;
        CGFloat x = self.view.x;
        if (toolBarView.width) {
            width = toolBarView.width;
        }
        if (toolBarView.x) {
            x = toolBarView.x;
        }
        toolBarView.frame = CGRectMake(x, self.view.height - 44, width, 44);
        [self.view addSubview:toolBarView];
    }
    
    [self setPageLabelPage:self.currentPage];
    if (self.currentPage >= 0) {
        CGFloat attachVal = 0;
        self.collectionView.x = -attachVal;
        self.collectionView.contentOffset = CGPointMake(self.currentPage * self.collectionView.width, 0);
        
        NSInteger count = [self.dataSource photoBrowser:self numberOfItemsInSection:0];
        if (self.currentPage == count - 1 && count > 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(00.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.collectionView.contentOffset = CGPointMake(self.currentPage * self.collectionView.width, 0);
            });
        }
    }
    
    [self updateBottomBar];
}

-(void)updateBottomBar
{
    NSString *title = nil;
    if ([self.dataSource respondsToSelector:@selector(numberOfChoosedInphotoBrowser:)]) {
        NSInteger count = [self.dataSource numberOfChoosedInphotoBrowser:self];
        if (count > 0) {
            title = [NSString stringWithFormat:@"完成(%d)",(int)count];
        }
    }
    
    if (title == nil) {
        title = @"完成";
    }
    
    [_bottomDoneButton setTitle:title forState:UIControlStateNormal];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource photoBrowser:self numberOfItemsInSection:self.currentIndexPath.section];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZLPhotoPickerBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    
    if (cell.photoScrollView.photoScrollViewDelegate == nil) {
        //config cell
        cell.photoScrollView.photoScrollViewDelegate = self;
        cell.photoScrollView.sheet = self.sheet;
        cell.photoScrollView.disableSave = self.disableSave;
        
        UIView *scrollBoxView = cell.photoScrollView.superview;
        
        __weak typeof(scrollBoxView) weakScrollBoxView = scrollBoxView;
        __weak typeof(self)weakSelf = self;
        if ([self.delegate respondsToSelector:@selector(photoBrowser:photoDidSelectView:atIndexPath:)]) {
            [[scrollBoxView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            cell.photoScrollView.callback = ^(id obj){
                [weakSelf.delegate photoBrowser:weakSelf photoDidSelectView:weakScrollBoxView atIndexPath:indexPath];
            };
        }
        
    }
    
    NSInteger count = [self.dataSource photoBrowser:self numberOfItemsInSection:0];
    
    if (count > 0) {
                
        ZLPhotoPickerBrowserPhoto *photo = [self.dataSource photoBrowser:self photoAtIndexPath:indexPath];
        [cell updateWithModel:photo];
        
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_pushIn && _browserMode == ZLPhotoPickerBrowserModePushCheckable) {
        
        ZLPhotoPickerBrowserPhoto *photo = [self.dataSource photoBrowser:self photoAtIndexPath:indexPath];
        self.rightButton.selected = photo.checked;
    }
}

#pragma mark - 获取CollectionView
- (UIView *) getScrollViewBaseViewWithCell:(UIView *)view{
    for (int i = 0; i < view.subviews.count; i++) {
        UICollectionViewCell *cell = view.subviews[i];
        if ([cell isKindOfClass:[UICollectionView class]] || [cell isKindOfClass:[UITableView class]]  || [cell isKindOfClass:[UIScrollView class]] || view == nil) {
            return cell;
        }
    }
    return [self getScrollViewBaseViewWithCell:view.superview];
}

#pragma mark - <UIScrollViewDelegate>
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    
//    
////    CGRect tempF = self.collectionView.frame;
////    NSInteger currentPage = (NSInteger)((scrollView.contentOffset.x / scrollView.frame.size.width) + 0.5);
////    if (tempF.size.width < [UIScreen mainScreen].bounds.size.width){
////        tempF.size.width = [UIScreen mainScreen].bounds.size.width;
////    }
////    
////    NSLog(@"current page is: %ld  -",currentPage);
////    
////    if (!scrollView.isDragging) {
//////        NSLog(@"content view is: %@",scrollView);
////        
////        NSInteger count = [self.dataSource photoBrowser:self numberOfItemsInSection:self.currentIndexPath.section] ;
////        if (currentPage < count - 1) {
////            tempF.origin.x = 0;
////        }else{
////            tempF.origin.x = -ZLPickerColletionViewPadding;
////        }
////        
////        self.collectionView.frame = tempF;
////    }
//    
//}

-(void)setPageLabelPage:(NSInteger)page
{
    NSInteger count = [self.dataSource photoBrowser:self numberOfItemsInSection:0] ;
    NSString *pageText =  [NSString stringWithFormat:@"%ld / %ld",page + 1, (long)count];
    if (_pushIn) {
        self.titleLabel.text = pageText;
        [self.titleLabel sizeToFit];
        _titleLabel.center = CGPointMake(_fakeNavbar.width/2, _fakeNavbar.height/2 + 10);
    }else{
        self.pageLabel.text = pageText;
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentPage = (NSInteger)(scrollView.contentOffset.x / (scrollView.frame.size.width));
    
    NSInteger count = [self.dataSource photoBrowser:self numberOfItemsInSection:0] ;
    if (currentPage == count - 2) {
        currentPage = roundf((scrollView.contentOffset.x) / (scrollView.frame.size.width));
    }
    
    if (currentPage == count - 1) {
        self.collectionView.contentOffset = CGPointMake(currentPage*scrollView.width, 0);
    }
    
    self.currentPage = currentPage;
    [self setPageLabelPage:currentPage];
    
    if ([self.delegate respondsToSelector:@selector(photoBrowser:didCurrentPage:)]) {
        [self.delegate photoBrowser:self didCurrentPage:self.currentPage];
    }
    
}

#pragma mark - 展示控制器
- (void)show{
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:self animated:NO completion:nil];
}

#pragma mark - 删除照片
- (void) deleteAction
{
    // 准备删除
    if ([self.delegate respondsToSelector:@selector(photoBrowser:willRemovePhotoAtIndexPath:)]) {
        if(![self.delegate photoBrowser:self willRemovePhotoAtIndexPath:[NSIndexPath indexPathForItem:self.currentPage inSection:self.currentIndexPath.section]]){
            return ;
        }
    }
    
    UIAlertView *removeAlert = [[UIAlertView alloc]
                                initWithTitle:@"确定要删除此图片？"
                                message:nil
                                delegate:self
                                cancelButtonTitle:@"取消"
                                otherButtonTitles:@"确定", nil];
    [removeAlert show];
}

#pragma mark - <UIAlertViewDelegate>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSInteger page = self.currentPage;
        if ([self.delegate respondsToSelector:@selector(photoBrowser:removePhotoAtIndexPath:)]) {
            [self.delegate photoBrowser:self removePhotoAtIndexPath:[NSIndexPath indexPathForItem:page inSection:self.currentIndexPath.section]];
        }
        
        NSInteger count = [self.dataSource photoBrowser:self numberOfItemsInSection:0] ;
        if (page >= count) {
            self.currentPage--;
        }
        
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:page inSection:self.currentIndexPath.section]];
        if (cell) {
            if([[[cell.contentView subviews] lastObject] isKindOfClass:[UIView class]]){
                
                [UIView animateWithDuration:.35 animations:^{
                    [[[cell.contentView subviews] lastObject] setAlpha:0.0];
                } completion:^(BOOL finished) {
                    [[[cell.contentView subviews] lastObject] setAlpha:1.0];
                    [self reloadData];
                }];
            }
        }
        
        if (count < 1){
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            [self dismissViewControllerAnimated:YES completion:nil];
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
        }
    }
}

#pragma mark - <PickerPhotoScrollViewDelegate>
- (void)pickerPhotoScrollViewDidSingleClick:(ZLPhotoPickerBrowserPhotoScrollView *)photoScrollView{
    if (self.disMissBlock) {
        
        NSInteger count = [self.dataSource photoBrowser:self numberOfItemsInSection:0] ;
        if (count == 1) {
            self.currentPage = 0;
        }
        self.disMissBlock(self.currentPage);
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - showHeadPortrait 放大缩小一张图片的情况下（查看头像）
- (void)showHeadPortrait:(UIImageView *)toImageView{
    [self showHeadPortrait:toImageView originUrl:nil];
}

- (void)showHeadPortrait:(UIImageView *)toImageView originUrl:(NSString *)originUrl{
    UIView *mainView = [[UIView alloc] init];
    mainView.backgroundColor = [UIColor blackColor];
    mainView.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:mainView];
    
    CGRect tempF = [toImageView.superview convertRect:toImageView.frame toView:[self getParsentView:toImageView]];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    imageView.frame = tempF;
    imageView.image = toImageView.image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [mainView addSubview:imageView];
    mainView.clipsToBounds = YES;
    
    [UIView animateWithDuration:.25 animations:^{
        imageView.frame = [UIScreen mainScreen].bounds;
    } completion:^(BOOL finished) {
        imageView.hidden = YES;
        
        ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
        photo.photoURL = [NSURL URLWithString:originUrl];
        photo.photoImage = toImageView.image;
        photo.thumbImage = toImageView.image;
        
        ZLPhotoPickerBrowserPhotoScrollView *scrollView = [[ZLPhotoPickerBrowserPhotoScrollView alloc] init];
        
        __weak typeof(ZLPhotoPickerBrowserPhotoScrollView *)weakScrollView = scrollView;
        scrollView.callback = ^(id obj){
            [weakScrollView removeFromSuperview];
            mainView.backgroundColor = [UIColor clearColor];
            imageView.hidden = NO;
            [UIView animateWithDuration:.25 animations:^{
                imageView.frame = tempF;
            } completion:^(BOOL finished) {
                [mainView removeFromSuperview];
            }];
        };
        scrollView.frame = [UIScreen mainScreen].bounds;
        scrollView.photo = photo;
        [mainView addSubview:scrollView];
    }];
}


#pragma mark - rotate
-(BOOL)shouldAutorotate
{
    return true;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
