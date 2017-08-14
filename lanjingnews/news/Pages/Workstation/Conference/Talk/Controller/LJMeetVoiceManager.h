//
//  LJMeetVoiceManager.h
//  news
//
//  Created by chunhui on 15/10/12.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LJMeetVoiceManagerDelegate;

@interface LJMeetVoiceManager : NSObject

@property(nonatomic , weak) id<LJMeetVoiceManagerDelegate> playDelegate;

-(void)speechForUrl:(NSString *)url completion:(void(^)(NSData *data , NSError *error))completion;

-(void)downloadVoiceForUrl:(NSString *)url completion:(void(^)(NSData *data, NSError *error))completion;

/**
 *  播放音频
 *
 *  @param url 音频对应的url
 */
-(void)playAudioWithUrl:(NSString *)url ;
/**
 *  播放音频
 *
 *  @param path 音频所在的目录
 */
-(void)playAudioWithPath:(NSString *)path;

-(void)stopPlay;

@end


@protocol LJMeetVoiceManagerDelegate <NSObject>

- (void)playingStoped;

@end