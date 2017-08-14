//
//  LJMessageTalkModel.h
//  news
//
//  Created by 陈龙 on 15/12/10.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "JSONModel.h"

@protocol LJMessageTalkDataContentModel<NSObject>

@end


@interface  LJMessageTalkDataContentModel  : JSONModel

@property(nonatomic , copy)   NSString * sname;
@property(nonatomic , copy)   NSString * ctime;
@property(nonatomic , copy)   NSString * mid;
@property(nonatomic , copy)   NSString * content;
@property(nonatomic , copy)   NSString * avatar;
@property(nonatomic , copy)   NSString * toUid;
@property(nonatomic , copy)   NSString * time;
@property(nonatomic , copy)   NSString * fromUid;

@end


@interface  LJMessageTalkDataModel  : JSONModel

@property(nonatomic , strong) NSArray<LJMessageTalkDataContentModel> * content;
@property(nonatomic , copy)   NSString * lastReadMid;
@property(nonatomic , copy)   NSString * chatting;

@end


@interface  LJMessageTalkModel  : JSONModel

@property(nonatomic , strong) NSNumber * dErrno;
@property(nonatomic , strong) LJMessageTalkDataModel * data ;
@property(nonatomic , strong) NSString * msg;

@end