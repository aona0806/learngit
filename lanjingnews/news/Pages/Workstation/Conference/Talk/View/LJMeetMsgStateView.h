//
//  LJMeetMsgStateView.h
//  news
//
//  Created by chunhui on 15/10/19.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJMeetTalkMsgItem.h"

@interface LJMeetMsgStateView : UIView

@property(nonatomic , assign) LJMeetMsgSendState sendState;
@property(nonatomic , assign) LJMeetAudioDownloadState downloadState;
@property(nonatomic , copy)   void (^tapBlock)();

@end
