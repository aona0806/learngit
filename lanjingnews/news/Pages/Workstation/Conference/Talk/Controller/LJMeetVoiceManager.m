//
//  LJMeetVoiceManager.m
//  news
//
//  Created by chunhui on 15/10/12.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMeetVoiceManager.h"
#import "ISDiskCache.h"
#import "AFNetworking.h"
#import "NSString+MD5.h"
#import "PlayerManager.h"
@interface LJMeetVoiceManager ()<PlayingDelegate>

@property(nonatomic , strong) NSMutableArray *downloadList;

@end

@implementation LJMeetVoiceManager

-(instancetype)init
{
    self = [super init];
    if (self) {
        
        _downloadList = [[NSMutableArray alloc]init];
        
    }
    return self;
}

-(BOOL)isDownloadingUrl:(NSString *)url
{
    for (NSString *u in _downloadList) {
        if ([u isEqualToString:url]) {
            return YES;
        }
    }
    return NO;
}

-(void)speechForUrl:(NSString *)url completion:(void(^)(NSData *data , NSError *error))completion
{
    if (url.length == 0) {
        return;
    }
    NSString *key = url; //[HashHelper md5:url];
    NSData *data = [[ISDiskCache sharedCache] dataForKey:key];
    if (data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(data,nil);
        });
    }else{
        
        //后续优化判断重复下载
//        if ([self isDownloadingUrl:url]) {
//            
//            return;
//        }
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            if ([responseObject isKindOfClass:[NSData class]]) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[ISDiskCache sharedCache]setData:responseObject forKey:key];
                });
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(responseObject,nil);
                    }
                });
            }
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(nil,error);
                }
            });
        }];
        
    }
}

-(void)downloadVoiceForUrl:(NSString *)url completion:(void(^)(NSData *data, NSError *error))completion
{
    [self speechForUrl:url completion:^(NSData *data, NSError *error) {
        if (completion) {
            completion(data,error);
        }
    }];
}

-(void)playAudioWithUrl:(NSString *)url
{

    if (url.length == 0) {
        return;
    }
        
    NSString *path =  [[ISDiskCache sharedCache] filePathForKey:url];
    
    [self playAudioWithPath:path];
}

-(void)playAudioWithPath:(NSString *)path
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path isDirectory:nil]) {
        [[PlayerManager sharedManager] playAudioWithFileName:path audioType:kAudioTypeSpx delegate:self];
    }
}

-(void)stopPlay
{
    [[PlayerManager sharedManager]stopPlaying];
}

#pragma mark - play delegate
- (void)playingStoped
{
    if ([self.playDelegate respondsToSelector:@selector(playingStoped)]) {
        [self.playDelegate playingStoped];
    }
}

@end
