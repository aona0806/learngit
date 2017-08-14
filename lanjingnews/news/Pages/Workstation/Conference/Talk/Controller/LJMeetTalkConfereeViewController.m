//
//  LJMeetTalkConfereeViewController.m
//  news
//
//  Created by chunhui on 15/9/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMeetTalkConfereeViewController.h"
#import "LJSegmentView.h"
#import "Masonry.h"
#import "LJMeetConfereeOnlineViewModel.h"
#import "LJMeetHostViewModel.h"
#import "UIView+Utils.h"
#import "news-Swift.h"
#import "LJMeetOnlineUserItem.h"
#import "LJMeetCollectionViewCell.h"
#import "LJMeetTalkFlowLayout.h"


#define kExpandWidth  32

extern NSString *const SetToQuestionNotification;

@interface LJMeetTalkConfereeViewController ()<UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,LJSegmentViewDelegate>
@property(nonatomic , strong) UIView *talkBgView;
@property(nonatomic , strong) UIImageView *bgImageView;
@property(nonatomic , strong) LJSegmentView *segmentView;
@property(nonatomic , strong) UICollectionView *collectionView;
@property(nonatomic , strong) UITableView *talkTableView;
@property(nonatomic , strong) UITableView *onlineTableView;
@property(nonatomic , strong) LJMeetConfereeOnlineViewModel *onlineViewModel;
@property(nonatomic , strong) LJMeetHostViewModel *talkViewModel;
@property(nonatomic , strong) UIButton *expandButton;
@property(nonatomic , assign) LJMeetShowDegree showDegree;

@end

@implementation LJMeetTalkConfereeViewController

-(void)dealloc
{
    _collectionView.delegate = nil;
    _onlineTableView.delegate = nil;
    _talkTableView.delegate = nil;
    [_collectionView removeObserver:self forKeyPath:@"bounds"];
    if ([[[UIDevice currentDevice]systemVersion] floatValue] <= 7.9) {
        //适配ios7
        [_talkTableView removeObserver:self forKeyPath:@"bounds"];
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


-(LJMeetConfereeOnlineViewModel*)onlineViewModel
{
    if (_onlineViewModel == nil) {
        _onlineViewModel = [[LJMeetConfereeOnlineViewModel alloc]init];
        _onlineViewModel.meetUserInfo = self.meetUserInfo;
        
        __weak typeof(self) weakSelf = self;
        _onlineViewModel.loadDoneBlock = ^{
            [weakSelf onlineUpdated];
        };
        _onlineViewModel.showUserInfoBlock = ^(LJMeetOnlineUserItem *model){
            weakSelf.showOtherUserInfoBlock(model.model.uid);
        };
    }
    return _onlineViewModel;
}


-(LJMeetHostViewModel *)talkViewModel
{
    if (_talkViewModel == nil) {
        _talkViewModel =  [[LJMeetHostViewModel alloc]init];
        _talkViewModel.meetUserInfo = self.meetUserInfo;        
        _talkViewModel.showOtherUserInfoBlock = self.showOtherUserInfoBlock;
        _talkViewModel.isHost = NO;
    }
    return _talkViewModel;
}

-(UIView *)talkBgView
{
    if (_talkBgView == nil) {
        _talkBgView = [[UIView alloc]initWithFrame:self.view.bounds];
        _talkBgView.autoresizingMask = UIViewAutoresizingNone;
        _talkBgView.backgroundColor = [UIColor yellowColor];
    }
    return _talkBgView;
}

-(UIImageView *)bgImageView
{
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.image = [UIImage imageNamed:@"xiaomishu_background.jpg"];
        _bgImageView.autoresizingMask = UIViewAutoresizingNone;

        _bgImageView.backgroundColor = [UIColor whiteColor];
        
    }
    return _bgImageView;
}

-(LJSegmentView *)segmentView
{
    if (_segmentView == nil) {
        CGRect bounds = [[UIScreen mainScreen]bounds];
        bounds.size.height = 40;
        
        _segmentView = [[LJSegmentView alloc]initWithFrame:bounds andItems:@[@"讨论",@"在线(0)"]];
        _segmentView.delegate = self;
    }
    
    return _segmentView;
}

-(UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        CGRect frame = CGRectMake(0, self.segmentView.height, self.view.width, self.view.height - self.segmentView.height);
        UICollectionViewFlowLayout *layout = [[LJMeetTalkFlowLayout alloc]init];
        
        layout.sectionInset = UIEdgeInsetsZero;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.allowsSelection = false;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        [_collectionView registerClass:[LJMeetCollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
        
        [_collectionView addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return _collectionView;
}

-(UITableView *)onlineTableView
{
    if (_onlineTableView == nil) {
        _onlineTableView = [[UITableView alloc]initWithFrame:self.collectionView.bounds style:UITableViewStyleGrouped];
        _onlineTableView.delegate = self;
        _onlineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _onlineTableView.autoresizingMask = UIViewAutoresizingNone;
        self.onlineViewModel.onlineTableView = _onlineTableView;
        
        _onlineTableView.backgroundColor = [UIColor whiteColor];
    }
    return _onlineTableView;
}

-(UITableView *)talkTableView
{
    if (_talkTableView == nil) {
        _talkTableView = [[UITableView alloc]initWithFrame:self.collectionView.bounds style:UITableViewStyleGrouped];
        _talkTableView.delegate = self;
        _talkTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _talkTableView.allowsSelection = NO;
        __weak typeof(self) weakSelf = self;
        
        MJRefreshStateHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf.talkViewModel loadData];
        }];
        _talkTableView.header = header;
        _talkTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _talkTableView.autoresizingMask = UIViewAutoresizingNone;
                        
        _talkTableView.backgroundColor = [UIColor clearColor];
        
        if ([[[UIDevice currentDevice]systemVersion] floatValue] <= 7.9) {
            //适配 ios7
            [_talkTableView addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:(void *)_talkTableView];
        }
        
    }
    return _talkTableView;
}

-(UIButton *)expandButton
{
    if (_expandButton == nil) {
        _expandButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_expandButton addTarget:self action:@selector(expandAction:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *image = [UIImage imageNamed:@"meet_talk_fullscreen"];        
        [_expandButton setBackgroundImage:image forState:UIControlStateNormal];
        [_expandButton setBackgroundImage:image forState:UIControlStateHighlighted];
        
    }
    return _expandButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.expandButton];
    
    self.showDegree = kMeetShowHalf;
    self.talkViewModel.tableView = self.talkTableView;
    self.talkTableView.dataSource = self.talkViewModel;
    
    self.talkTableView.backgroundView = self.bgImageView;
    [self.talkBgView addSubview:_talkTableView];
    
    self.onlineViewModel.onlineTableView = self.onlineTableView;
    self.onlineTableView.dataSource = self.onlineViewModel;
    
    [self.talkTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_talkTableView.superview);
    }];
    
}

-(void)loadData
{
    [self.talkViewModel loadData];
    [self.onlineViewModel loadData];
}

-(void)fullScreen:(LJMeetShowDegree)degree
{
    self.showDegree = degree;
    [self.view setNeedsUpdateConstraints];
    UIImage *image = nil;
    if (degree  == kMeetShowFull) {
        image = [UIImage imageNamed:@"meet_talk_shrink"];
    }else{
        image = [UIImage imageNamed:@"meet_talk_fullscreen"];
    }
    [_expandButton setBackgroundImage:image forState:UIControlStateNormal];
    [_expandButton setBackgroundImage:image forState:UIControlStateHighlighted];
    
    if (degree != KMeetShowMinimum) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.talkViewModel scrollToBottom];
        });
    }
}

-(void)scrollToTalk:(BOOL)toTalk
{
    [self selecteAtIndex:toTalk?0:1];
}

-(void)updateBgImage:(UIImage *)image
{
    self.bgImageView.image = image;
}

-(void)stopPlayAudio
{
    [self.talkViewModel stopPlayAudio];
}

-(void)updateViewConstraints
{
    [self.view layoutIfNeeded];
    [super updateViewConstraints];    
    [self.segmentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(30)).priorityLow();
    }];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self.expandButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentView.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.width.equalTo(@(kExpandWidth));
        make.height.equalTo(@(kExpandWidth));
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)expandAction:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(expand:)]) {
        [_delegate expand:self];
    }
}

-(void)onlineUpdated
{
    NSString *online = [NSString stringWithFormat:@"在线(%d)",(int)[self.onlineViewModel.userList count]];
    [self.segmentView updateAtIndext:1 withName:online];
}

#pragma mark - scrollview delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        CGPoint offset = scrollView.contentOffset;
        if (offset.x > self.collectionView.width - 5) {
            self.segmentView.selectedIndex = 1;
        }else{
            self.segmentView.selectedIndex = 0;
        }   
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - table view delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.talkTableView) {
        return [self.talkViewModel CellHeightFromIndexPath:indexPath];
    }else{
        return [self.onlineViewModel CellHeightFromIndexPath:indexPath];
    }
    return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.talkTableView) {
        return 30;
    }
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}


- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    // required
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LJMeetOnlineUserItem *item = [self.onlineViewModel.userList objectAtIndex:indexPath.row];
    if(item.canShowDetail){
        item.showDetail = !item.showDetail;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        //show detail
        self.showOtherUserInfoBlock(item.model.uid);
    }
}

#pragma mark - seg ment delegate
-(void)selecteAtIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

#pragma mark - uicolloection view data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellid";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    CGRect frame = self.collectionView.bounds;
    frame.origin = CGPointZero;
    if (indexPath.row == 0) {
        self.talkBgView.frame = frame;
        [cell addSubview:_talkBgView];
    }else{
        self.onlineTableView.frame = frame;
        [cell addSubview:self.onlineTableView];
    }
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = self.collectionView.frame;
    return frame.size;
}


#pragma mark  - observer
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"bounds"]) {
        NSValue * newValue = change[NSKeyValueChangeNewKey];
        CGRect bounds ;
        [newValue getValue:&bounds];
        
        [self.collectionView reloadData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
            if ([[[UIDevice currentDevice]systemVersion]floatValue] > 7.9) {
                layout.itemSize = bounds.size;                
                layout.estimatedItemSize = bounds.size;
            }
            
        });
        
    }
}

#pragma mark -long link
-(void)receiveTalkMessage:(IMMessage *)message
{
    [self.talkViewModel receiveTalkMessage:message];
}

-(void)roleChangeMessage:(RoleChangeMessage *)message
{
    [self.onlineViewModel roleChangeMessage:message];
    [self.talkViewModel userRoleChanagedWithMessage:message];
    
}

-(void)onlineStatusChangeMessage:(StatusMessage *)message
{
    [self.onlineViewModel onlineStatusChangeMessage:message];
}

-(void)sendMessage:(NSString *)message
{
    [self.talkViewModel sendMessage:message];
}

-(void)sendAudioMessage:(NSString *)filePath duration:(NSTimeInterval)duration
{
    [self.talkViewModel sendAudioMessage:filePath duration:duration];
}

@end
