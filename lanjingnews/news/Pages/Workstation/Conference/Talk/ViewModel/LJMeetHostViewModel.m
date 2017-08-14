//
//  LJMeetHostViewModel.m
//  news
//
//  Created by chunhui on 15/9/28.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMeetHostViewModel.h"
#import "LJMeetTalkTableViewCell.h"
#import "TKRequestHandler+MeetTalk.h"
#import "LJMeetTalkMsgItem.h"
#import "LJMeetTalkMsgDataModel+IMMessage.h"
#import "PlayerManager.h"
#import "LJMeetUploadAudioModel.h"
#import "LJMeetSendModel.h"
#import "news-Swift.h"
#import "ISDiskCache.h"
#import "MJRefresh.h"
#import "UIScrollView+MJRefresh.h"
#import "LJUtil.h"
#import "LLTcpClientManager.h"

#define kShowDuration 60 // 5分钟 两个会话之间的间隔
#define kShowCatDuration 5*60 //30分钟 每隔30分钟显示一次时间

#define kMaxMsgCount  40 //每次最多显示的数据数目，多余的会删除

@interface LJMeetHostViewModel ()<LJMeetVoiceManagerDelegate>

@property(nonatomic , assign) CGFloat systemVersion;
@property(nonatomic , strong) NSMutableArray *itemsArray;
@property(nonatomic , strong) LJMeetTalkMsgItem *playingItem;//正在播放的语音item
@property(nonatomic , assign) NSTimeInterval lastShowDate;//显示时间的时间戳
/*
 *是否收取到长连接的消息，当长连接异常时使用轮询
 */
@property(nonatomic , assign) BOOL receiveLongLinkData;

@end

@implementation LJMeetHostViewModel

-(instancetype)init
{
    self = [super init];
    if (self) {
        _itemsArray  = [NSMutableArray new];
        _speechManager = [[LJMeetVoiceManager alloc]init];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(longLinkErrorNotification:) name:kLongLinkCloseNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(longLinkErrorNotification:) name:kLongLinkConnectFailedNotification object:nil];
        _receiveLongLinkData = YES;
        
        self.systemVersion = [[[UIDevice currentDevice]systemVersion]floatValue];
        
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(BOOL)containThisDialogWithId:(NSString *)msgId andUUID:(NSString *)uuid
{
    LJMeetTalkMsgItem *item;
    NSInteger count = [self.itemsArray count] -1;
    for (NSInteger i = count ; i >= 0 ; i--) {
        item = self.itemsArray[i];
        if ( [item.data.mid isEqualToString:msgId] || (uuid.length > 0 && [item.data.uuid isEqualToString:uuid])) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)cansetQeustion
{
    if (!self.isHost && (self.meetUserInfo.role != kMeetRoleUser )) {
        return YES;
    }
    return NO;
}
/**
 *  添加新的消息 并且检查是否超过阈值
 *
 *  @param item 要添加的消息
 *
 *  @return YES 超过阈值并删除了超过部分
 */
-(BOOL)addItemAndResize:(LJMeetTalkMsgItem *)item
{
    [self.itemsArray addObject:item];
    
    if ([self.itemsArray count] > kMaxMsgCount) {
        [self.itemsArray removeObjectsInRange:NSMakeRange(0, [self.itemsArray count] - kMaxMsgCount)];
        return YES;
    }
    return NO;
}

-(NSIndexPath *)indexPathForItem:(LJMeetTalkMsgItem *)model
{
    NSInteger index = [self.itemsArray indexOfObject:model];
    if(index < 0 || index == NSNotFound){
        return nil;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    return indexPath;
}

-(void)reloadForItem:(LJMeetTalkMsgItem *)item
{
    void(^reload)() = ^{
        NSIndexPath *indexPath = [self indexPathForItem:item];
        LJMeetTalkTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell) {
            [cell updateWithModel:item];
        }else{
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    };
    if ([NSThread currentThread] == [NSThread mainThread]) {
        reload();
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            reload();
        });
    }
}

-(void)downloadAudio:(LJMeetTalkMsgItem *)item
{
    LJMeetTalkMsgDataModel *model = item.data;
    
    if ([model.mtype integerValue] == kMeetMsgTypeAudio && model.content.length > 0) {
        //model.content 为音频的url
        item.audioDownloadState = kMeetAudioDownloading;
        __weak typeof(self) weakSelf = self;
        [self.speechManager downloadVoiceForUrl:model.content completion:^(NSData *data, NSError *error) {
            
            if (error == nil) {
                item.audioDownloadState = kMeetAudioDownloadDone;
            }else{
                item.audioDownloadState = kMeetAudioDownloadFailed;
            }
            [weakSelf reloadForItem:item];
        }];
    }
}

-(void)appendMsgModels:(NSArray *)models
{
    NSMutableArray *msgs = [[NSMutableArray alloc]initWithCapacity:[models count]+[self.itemsArray count]];
    
    [msgs addObjectsFromArray:self.itemsArray];
    
    LJMeetTalkMsgItem *item = [self.itemsArray lastObject];
    LJMeetTalkMsgDataModel *lastModel = item.data;
    
    for (NSInteger i = [models count] - 1 ; i >= 0 ; --i) {
        LJMeetTalkMsgDataModel *model = models[i];
        
        if ([self containThisDialogWithId:model.mid andUUID:model.uuid]) {
            continue;
        }
        
        item = [[LJMeetTalkMsgItem alloc]init];
        item.data = model;
        if (lastModel) {
            
            if ([model.createdt integerValue] - [lastModel.createdt integerValue] > kShowDuration) {
                item.showDate = YES;
            }else if ([model.createdt integerValue] - _lastShowDate > kShowCatDuration){
                item.showDate = YES;
                _lastShowDate = [model.createdt doubleValue];
            }
        }
        
        [self downloadAudio:item];
        item.canSetProblem = [self cansetQeustion];
        item.isHost        = self.isHost;
        
        [msgs addObject:item];
        
        lastModel = model;
    }
    
    self.itemsArray = msgs;
}

-(void)insertMsgModels:(NSArray *)models
{
    NSMutableArray *msgs = [[NSMutableArray alloc]initWithCapacity:[models count]+[self.itemsArray count]];
    
    LJMeetTalkMsgItem *item;
    LJMeetTalkMsgDataModel *lastModel = nil;
    
    for (LJMeetTalkMsgDataModel *model in models) {
        
        if ([self containThisDialogWithId:model.mid andUUID:model.uuid]) {
            continue;
        }
        
        item = [[LJMeetTalkMsgItem alloc]init];
        item.data = model;
        if (lastModel) {
            
            if ([model.createdt integerValue] - [lastModel.createdt integerValue] > kShowDuration) {
                item.showDate = YES;
            }else if ([model.createdt integerValue] - _lastShowDate > kShowCatDuration){
                item.showDate = YES;
                _lastShowDate = [model.createdt doubleValue];
            }
        }

        [self downloadAudio:item];
        
        item.canSetProblem = [self cansetQeustion];
        item.isHost        = self.isHost;
        
        [msgs insertObject:item atIndex:0];
        lastModel = model;
    }
    
    if ([self.itemsArray count] > 0) {
        item = [self.itemsArray firstObject];
        if ([item.data.createdt integerValue] - [lastModel.createdt integerValue] > kShowDuration) {
            item.showDate = YES;
        }
        [msgs addObjectsFromArray:self.itemsArray];
    }
    
    self.itemsArray = msgs;
}

-(void)loadData
{
    [self loadData:NO];
}

-(void)loadData:(BOOL)isRefresh
{
    NSString *lastId = isRefresh?@"": _lastMsgId;
    
    __weak typeof(self) weakSelf = self;
    [[TKRequestHandler sharedInstance]getMeetMsgWithMeetId:self.meetUserInfo.meetInfo.meetingId msgId:lastId uid:self.meetUserInfo.uid isHost:_isHost finish:^(NSURLSessionTask *task, LJMeetTalkMsgModel *model, NSError *error) {
        [self.tableView.header endRefreshing];
        if ([model.data count] > 0) {
            BOOL scrollToBottom = _lastMsgId.length == 0;
            
            if (isRefresh) {
                [self appendMsgModels:model.data];
//                if (!self.receiveLongLinkData) {
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        if (!self.receiveLongLinkData) {
//                            //没有数据，进行轮询
//                            [self loadData:YES];
//                        }
//                    });
//                }
            }else{
                [weakSelf insertMsgModels:model.data];
            }
            weakSelf.lastMsgId = [NSString stringWithFormat:@"%ld",(long)([model.msgId integerValue])];
            
            [weakSelf.tableView reloadData];

            if (scrollToBottom) {
                [weakSelf scrollToBottom];
            }
        }
    }];
}

-(void)scrollToBottom
{
    if([self.itemsArray count] > 0){
        dispatch_async(dispatch_get_main_queue(), ^{                        
            NSIndexPath *path = [NSIndexPath indexPathForRow:[_itemsArray count]-1 inSection:0];
            if ( !self.isHost && self.systemVersion < 7.9) {
                //下部适配 7.x
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    CGFloat gap = self.tableView.contentOffset.y + CGRectGetHeight(self.tableView.frame)  - self.tableView.contentSize.height;
                    if ( gap > 5 || gap < -5) {
                        CGPoint offset = self.tableView.contentOffset;
                        offset.y = self.tableView.contentSize.height - CGRectGetHeight(self.tableView.frame);
                        self.tableView.contentOffset = offset;
                    }
                });
            }else{
                [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        });
    }
}

-(void)setToQuestion:(LJMeetTalkMsgDataModel *)model state:(BOOL)isOK
{
    if (self.isHost) {
        if (isOK) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([self containThisDialogWithId:model.mid andUUID:model.uuid]) {
                    return ;
                }
                LJMeetTalkMsgItem *item = [[LJMeetTalkMsgItem alloc]init];
                item.isHost = YES;
                item.canSetProblem = NO;
                item.data = model;
                [self addItemAndResize:item];
                [self.tableView reloadData];
                [self scrollToBottom];
            });
        }else{
            LJMeetTalkMsgItem *insertItem = nil;
            for (LJMeetTalkMsgItem *it in self.itemsArray) {
                if ([model.mid isEqualToString: it.data.mid] || [model.uuid isEqualToString:it.data.uuid]) {
                    insertItem = it;
                    break;
                }
            }
            if (insertItem) {
                [self.itemsArray removeObject:insertItem];
                [self.tableView reloadData];
            }
        }
    }
}


-(void)receiveTalkMessage:(IMMessage *)message
{
    self.receiveLongLinkData = YES;

    if ([self containThisDialogWithId:@(message.messageId).description andUUID:message.uuid]) {
        return;
    }
    
    LJMeetTalkMsgDataModel *model = [[LJMeetTalkMsgDataModel alloc]initWithIMMessage:message];
    LJMeetTalkMsgItem *item = [[LJMeetTalkMsgItem alloc]init];
    item.data = model;
    item.isHost = self.isHost;
    item.canSetProblem = [self cansetQeustion];

    
    [self addItemAndResize:item];
    [self.tableView reloadData];
    
    CGFloat ratio = 2.5;
    if (SCREEN_HEIGHT <= 480) {
        //4 设备上屏幕太小设置倍率大些
        ratio = 3;
    }
    CGFloat cellHeight = [LJMeetTalkTableViewCell CellHeightForModel:item];//刚才收到的消息
    if (self.tableView.contentOffset.y + self.tableView.height*ratio + cellHeight > self.tableView.contentSize.height) {
        //不算刚才收到的消息 不超过一屏半，需要滑动到最后
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //延迟滑动到最后，不然会抖动
            NSIndexPath *path = [NSIndexPath indexPathForRow:[_itemsArray count] - 1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:YES];
        });
    }
    
    if ([model.mtype integerValue] == kMeetMsgTypeAudio && model.content.length > 0) {
        item.audioDownloadState = kMeetAudioDownloading;
        __weak typeof(self) weakSelf = self;
        [self.speechManager downloadVoiceForUrl:model.content completion:^(NSData *data, NSError *error) {
            if (data && error == nil) {
                item.audioDownloadState = kMeetMsgSendDone;
            }else{
                item.audioDownloadState = kMeetMsgSendFailed;
            }
            [weakSelf reloadForItem:item];
        }];
    }
    
}

-(void)receiveAudioConvertMessage:(PlainTextMessage *)message
{
    self.receiveLongLinkData = YES;
    NSInteger index = 0;
    for (LJMeetTalkMsgItem *item in self.itemsArray) {
        if ([item.data.mid longLongValue] == message.relationMessageId) {
            
            item.data.audioText = message.text.content;
            item.data.updatedt = @(message.timestamp).description;
            
            [self reloadForItem:item];
            break;
        }
        index++;
    }
}

-(void)sendMessage:(NSString *)message
{
    [self sendTalkMessage:message type:kMeetMsgTypeText duration:0 format:nil completion:nil];
}

-(NSURLSessionTask *)sendPic:(UIImage *)pic index:(NSString *)index finish:(void (^)(NSString *result , NSString *error))finish{
    
   return [ImageUploadManager uploadImage:pic fileName:index completion:^(NSURLSessionDataTask * task, NSString * url, NSString * error) {
        if (url && url.length > 0) {

            LJMeetTalkMsgItem *item = [self itemWithMessage:url type:kMeetMsgTypeImage duration:0 format:nil];
            item.data.image = pic;
            [self addItemAndResize:item];
            [self.tableView reloadData];
            
            [self scrollToBottom];
            
            [self sendMessage:item scrollToBottom:YES completion:nil];
        }else{
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabel.text = @"上传图片失败";
            [hud hideAnimated:YES afterDelay: 1];
        }
       
       if (finish) {
           finish(url , error);
       }
    }];
    
}

-(void)sendAudioMessage:(NSString *)filePath duration:(NSTimeInterval)duration
{
    LJMeetTalkMsgItem *item = [self itemWithMessage:nil type:kMeetMsgTypeAudio duration:duration format:@"spx"];
    item.nativeAudioPath = filePath;
    item.audioDownloadState = kMeetAudioDownloading;
    [self addItemAndResize:item];
    [self.tableView reloadData];
    
    [self scrollToBottom];
    
    __weak typeof(self) weakSelf = self;
    [self sendMessage:item scrollToBottom:YES completion:^(BOOL ok, LJMeetTalkMsgItem *item) {
        
        if (ok) {
            item.sendState = kMeetMsgSendDone;
        }else{
            item.sendState = kMeetMsgSendFailed;
        }
        NSIndexPath *path = [weakSelf indexPathForItem:item];
        if (path) {
            dispatch_async(dispatch_get_main_queue(), ^{
                LJMeetTalkTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:path];
                if (cell) {
                    [cell updateWithModel:item];
                }
            });
        }
    }];
    
}

/**
 *  重发消息
 *
 *  @param item       消息内容
 *  @param completion 完成回调
 */
-(void)resendMessage:(LJMeetTalkMsgItem *)item completion:(void (^)(BOOL ok , LJMeetTalkMsgItem *item))completion
{    
    item.sendState = kMeetMsgSending;
    
    __weak typeof(self) weakSelf = self;
    [self sendMessage:item scrollToBottom:NO completion:^(BOOL ok, LJMeetTalkMsgItem *item) {
        if (completion) {
            completion(ok,item);
        }else{
            if (ok) {
                item.sendState = kMeetMsgSendDone;
            }else{
                item.sendState = kMeetMsgSendFailed;
            }
            [weakSelf reloadForItem:item];
        }
        
    }];
    
}

-(void)sendMessage:(LJMeetTalkMsgItem *)item scrollToBottom:(BOOL)scroll completion:(void (^)(BOOL ok , LJMeetTalkMsgItem *item))completion
{
    LJMeetTalkMsgDataModel *msg = item.data;
    if ([msg.mtype integerValue] == kMeetMsgTypeAudio && msg.content.length == 0) {
        //音频，需要上传文件
        __weak typeof(self) weakSelf = self;
        [[TKRequestHandler sharedInstance]meetUploadAudio:item.nativeAudioPath completion:^(NSURLSessionTask *task, LJMeetUploadAudioModel *model, NSError *error) {
            
            if (error) {
                item.sendState = kMeetMsgSendFailed;
                item.audioDownloadState = kMeetAudioDownloadFailed;
                [weakSelf reloadForItem:item];
                [weakSelf showFailToast];
            } else {
                if (model.data.audio.length > 0) {
                    //发送音频成功
                    msg.content = model.data.audio;
                    [[ISDiskCache sharedCache] saveWithFilePath:item.nativeAudioPath forKey:msg.content];
                    item.nativeAudioPath = nil;
                    item.audioDownloadState = kMeetAudioDownloadDone;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf sendMessage:item scrollToBottom:scroll completion:^(BOOL ok, LJMeetTalkMsgItem *item) {
                            if (completion) {
                                completion(ok,item);
                            }
                        }];
                    });
                }else{
                    //send failed
                    item.sendState = kMeetMsgSendFailed;
                    item.audioDownloadState = kMeetAudioDownloadFailed;
                    [weakSelf reloadForItem:item];
                    [weakSelf showFailToast];
                }
            }
        }];
        
        return;
    }
    
    //发送消息
    [[TKRequestHandler sharedInstance]postMeetMsgWithMeetId:self.meetUserInfo.meetId uid:self.meetUserInfo.uid msgUUID:msg.uuid content:msg.content type:[msg.mtype integerValue] duration:[msg.audioDuration integerValue] format:msg.audioFormat finish:^(NSURLSessionTask *task, LJMeetSendModel *model, NSError *error) {
        //make msg item
        LJMeetSendModel *sendModel = (LJMeetSendModel *)model;
        
        //通过长连接收到了刚才发的消息时，会自动去掉
        if (error == nil && sendModel ) {
            if (sendModel.dErrno.integerValue == 0) {
                item.sendState = kMeetMsgSendDone;
                item.audioDownloadState = kMeetAudioDownloadDone;
                msg.mid = sendModel.data.msgId.description;
                msg.roleName = [LJMeetTalkMsgDataModel RoleNameWithType:[msg.role integerValue]];
            } else {
                item.sendState = kMeetMsgSendFailed;
                NSString *errMsg = sendModel.msg;
                if (errMsg.length == 0) {
                    errMsg = @"发送失败";
                }
                [self showToastWithTitle:errMsg];
            }
        }else{
            item.sendState = kMeetMsgSendFailed;
            [self showFailToast];
        }
        
        [self.tableView reloadData];
        if (scroll) {
            [self scrollToBottom];
        }
        if(completion){
            completion(!error,item);
        }
    }];
}

-(void)sendTalkMessage:(NSString *)message type:(LJMeetMsgType)type duration:(NSTimeInterval)duration format:(NSString *)format completion:(void (^)(BOOL ok , LJMeetTalkMsgItem *item))completion
{
    LJMeetTalkMsgItem *item = [self itemWithMessage:message type:type duration:duration format:format];
    
    [self addItemAndResize:item];
    [self.tableView reloadData];

    [self scrollToBottom];
    
    [self sendMessage:item scrollToBottom:YES completion:^(BOOL ok, LJMeetTalkMsgItem *item) {
        if (completion) {
            completion(ok,item);
        }
    }];
    
}

-(void)showFailToast
{
    [self showToastWithTitle:@"发送失败"];
}

-(void)showToastWithTitle:(NSString *)title
{
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.offset = CGPointMake(0, -100);//向上偏移
//    hud.yOffset = -100;//向上偏移
    hud.detailsLabel.text = title;
    hud.mode = MBProgressHUDModeText;
    [hud hideAnimated:YES afterDelay:.5];
}

-(LJMeetTalkMsgItem *)itemWithMessage:(NSString *)message type:(LJMeetMsgType)type duration:(NSTimeInterval)duration format:(NSString *)format
{
    LJMeetTalkMsgItem *item = [[LJMeetTalkMsgItem alloc]init];
    LJMeetTalkMsgDataModel *msg = [self emptyMessageModel];
    msg.content = message;
    item.data = msg;
    item.sendState = kMeetMsgSending;
    msg.mtype = @(type).description;
    if (type == kMeetMsgTypeAudio) {
        //音频
        msg.audioFormat = format;
        msg.audioDuration = [NSString stringWithFormat:@"%d",(int)floor(duration+0.5)];
    }
    msg.content = message;
    msg.roleName = [LJMeetTalkMsgDataModel RoleNameWithType:[msg.role integerValue]];
    item.isHost = self.isHost;
    msg.uuid = [LJUtil UUIDShort];
    if ([self.itemsArray count] > 0) {
        LJMeetTalkMsgItem *lastItem = [self.itemsArray lastObject];
        if ([msg.createdt longLongValue] - [lastItem.data.createdt longLongValue] > kShowDuration) {
            item.showDate = YES;
        }
    }
    
    return item;
}

-(void)managerSetQuestion:(LJMeetTalkMsgItem *)item
{
    LJMeetTalkMsgDataModel *model = item.data;
    
    LJMeetTalkMsgDataModel *copyModel = [model copy];
    copyModel.fromChatting = model.mid;

    //不假写数据，因为消息id变了
    
//    NSDictionary *userInfo = @{SetToQuestionState:@"1",SetTOQuestionItem:copyModel};
//    [[NSNotificationCenter defaultCenter]postNotificationName:SetToQuestionNotification object:nil userInfo:userInfo];
    
    [[TKRequestHandler sharedInstance]meetCollectProblemWithMeetId:model.meetingId chatId:model.mid  completion:^(NSError *error, NSString *errMsg, NSString *msgId, NSString *chatId) {
        
        if (error || msgId.length == 0) {
            //set question failed
            copyModel.mid = msgId;
            copyModel.fromChatting = chatId;
            
//            NSDictionary *userInfo = @{SetToQuestionState:@"0",SetTOQuestionItem:copyModel};
//            [[NSNotificationCenter defaultCenter]postNotificationName:SetToQuestionNotification object:nil userInfo:userInfo];
            
            //tip
            if (errMsg.length == 0) {
                errMsg = @"设置问题失败";
            }
            UIWindow *window = [[UIApplication sharedApplication]keyWindow];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
            hud.detailsLabel.text = errMsg;
            hud.mode = MBProgressHUDModeText;
            [hud hideAnimated:YES afterDelay:.3];
        }
    }];
    
}

-(void)msgOperation:(LJMeetMsgOperate)operate withItem:(LJMeetTalkMsgItem *)item
{
    if (operate == kMeetMsgSetToQuestion) {
        [self managerSetQuestion:item];
    }
}

-(void)userRoleChanagedWithMessage:(RoleChangeMessage*)message
{
    NSString*uid  = @(message.user.uid).description;
    
    LJMeetTalkMsgDataModel *model ;
    for (LJMeetTalkMsgItem *item in self.itemsArray) {
        model = item.data;
        if ([model.userInfo.uid isEqualToString:uid]) {
            model.role = @(message.user.role).description;
        }
        item.canSetProblem = [self cansetQeustion];
    }
    [self.tableView reloadData];
    
}

-(LJMeetTalkMsgDataModel *)emptyMessageModel
{
    LJMeetTalkMsgDataModel *msg = [[LJMeetTalkMsgDataModel alloc]init];
    msg.meetingId = self.meetUserInfo.meetId;
    msg.createdt = @([[NSDate date]timeIntervalSince1970]).description;
    msg.updatedt = msg.createdt;

    LJMeetTalkMsgDataUserInfoModel *user = [[LJMeetTalkMsgDataUserInfoModel alloc]init];
    AccountManager *manager = [AccountManager sharedInstance];
    LJUserInfoModel *userInfo = [manager getUserInfo];
    user.sname = userInfo.sname;
    user.uid   = userInfo.uid;
    user.avatar = userInfo.avatar;
    user.company = self.meetUserInfo.meetInfo.company;
    msg.userInfo = user;
    
    msg.role = @(self.meetUserInfo.role).description;
    
    return msg;
}


-(CGFloat)CellHeightFromIndexPath:(NSIndexPath *)indexPath
{
     LJMeetTalkMsgItem *item = self.itemsArray[indexPath.row];
    return [LJMeetTalkTableViewCell CellHeightForModel:item];
}

-(void)stopPlayAudio
{
    [self.speechManager stopPlay];
    [self playingStoped];
    
}

#pragma mark - play speech
-(void)playSpeech:(LJMeetTalkMsgItem *)item
{
    if (item.isPlayingAudio) {
        
        self.playingItem = nil;
        item.isPlayingAudio = NO;
        [self.speechManager stopPlay];
        self.speechManager.playDelegate = nil;

        [self reloadForItem:item];
        
    }else{
        self.playingItem = item;
        [self playingStoped];
        self.speechManager.playDelegate = self;
        if(item.nativeAudioPath.length > 0){
            [self.speechManager playAudioWithPath:item.nativeAudioPath];
        }else{
            [self.speechManager playAudioWithUrl:item.data.content ];
        }
        item.isPlayingAudio = YES;
        [self.tableView reloadData];
    }

}

- (void)playingStoped
{
    BOOL shouldReload = NO;
    for (LJMeetTalkMsgItem *item in self.itemsArray) {
        if(!shouldReload && item.isPlayingAudio){
            shouldReload = YES;
        }
        item.isPlayingAudio = NO;
    }
    if (shouldReload) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

-(void)tapUserHead:(LJMeetTalkMsgItem *)item
{
    if (![[AccountManager sharedInstance] isVerified]) {
        //未登录不能点击
        return;
    }
    
    if (self.showOtherUserInfoBlock) {
        _showOtherUserInfoBlock(item.data.userInfo.uid);
    }
}

#pragma mark - tableview data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_itemsArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellid";
    LJMeetTalkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[LJMeetTalkTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        __weak typeof(self) weakSelf = self;
        cell.playSpeech = ^(LJMeetTalkMsgItem *model){
            [weakSelf playSpeech:model];
        };
        cell.tapHeadBlock = ^(LJMeetTalkMsgItem *model){
            [weakSelf tapUserHead:model];
        };
        cell.msgOperateBlock = ^(LJMeetTalkMsgItem *model , LJMeetMsgOperate operate){
            [weakSelf msgOperation:operate withItem:model];
        };
        
        cell.reloadBlock = ^(LJMeetTalkMsgItem *model){
            model.sendState = kMeetMsgSending;
            model.audioDownloadState = kMeetAudioDownloading;
            NSIndexPath *indexPath = [weakSelf indexPathForItem:model];
            if (indexPath) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    LJMeetTalkTableViewCell *talkCell =  [weakSelf.tableView cellForRowAtIndexPath:indexPath];
                    [talkCell updateWithModel:model];
                });
            }
            
            if([model.data.mtype integerValue] == kMeetMsgTypeText){
                //重新
                [weakSelf resendMessage:model completion:^(BOOL ok, LJMeetTalkMsgItem *item) {
                    
                }];
            }else if ([model.data.mtype integerValue] == kMeetMsgTypeAudio){
                if (model.nativeAudioPath.length > 0) {
                    //重新上传
                    [weakSelf resendMessage:model completion:^(BOOL ok, LJMeetTalkMsgItem *item) {
                        
                    }];
                }else{
                    //重新下载
                    [weakSelf downloadAudio:model];
                }
            }
        };
        
        cell.showOrHideAudioWordBlock = ^(LJMeetTalkMsgItem *model , LJMeetTalkTableViewCell *cell){
            if ([weakSelf.itemsArray lastObject] == model) {
                [weakSelf.tableView reloadData];
                [weakSelf scrollToBottom];
            }else{
                NSIndexPath *indexPath = [weakSelf indexPathForItem:model];
                if (indexPath) {
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        UITableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
                        CGFloat maxY = cell.bottom;
                        if (maxY > weakSelf.tableView.contentOffset.y+weakSelf.tableView.height) {
                            //遮挡了翻译的文字，向上滑动
                            [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                        }
                    });
                }
            }
        };
    }
    
    LJMeetTalkMsgItem *item = self.itemsArray[indexPath.row];
    [cell updateWithModel:item];
    
    return cell;
}

#pragma mark - long link event
-(void)longLinkErrorNotification:(NSNotification *)notification
{
    //重新拉取最新数据
    self.receiveLongLinkData = NO;
    [self loadData:YES];
}

@end


NSString *const SetToQuestionNotification = @"_SetToQuestionNotification";
NSString *const SetToQuestionState        = @"_state";
NSString *const SetTOQuestionItem         = @"_item";
