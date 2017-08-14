//
//  HistoryMeetListModel.h
//  news
//
//  Created by 陈龙 on 15/10/9.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "JSONModel.h"

//"id": 60,
//"uid": 60,
//"img": "http://img.lanjinger.com/lanjingapp/meeting/20151014/164454_561e16063401e.jpg",
//"theme": "物联网时代,像智能硬件开发者致敬1444793333",
//"sponsor": "上海庆科信息有限公司1444793333",
//"start_time": 1444804980,
//"end_time": 1444812180,
//"overview": "会议介绍内容简介",
//"status": 3,
//"myaction": 0,
//"shareurl": "http://test.app.lanjinger.com/v1/share/meeting_detail?id=60",
//"scontent": "会议介绍内容简介"

@protocol LJHistoryMeetListDataModel<NSObject>

@end


@interface  LJHistoryMeetListDataModel  : JSONModel

@property(nonatomic , strong) NSNumber * status;
@property(nonatomic , strong) NSNumber * myaction;
@property(nonatomic , strong) NSNumber * uid;
@property(nonatomic , copy)   NSString * img;
@property(nonatomic , copy)   NSString * overview;
@property(nonatomic , strong) NSNumber * startTime;
@property(nonatomic , copy)   NSString * shareurl;
@property(nonatomic , copy)   NSString * scontent;
@property(nonatomic , copy)   NSString * theme;
@property(nonatomic , copy)   NSString * sponsor;
@property(nonatomic , strong) NSNumber * id;
@property(nonatomic , strong) NSNumber * endTime;

@end


@interface  LJHistoryMeetListModel  : JSONModel

@property(nonatomic , strong) NSNumber * refreshType;
@property(nonatomic , strong) NSNumber * dErrno;
@property(nonatomic , strong) NSArray<LJHistoryMeetListDataModel> * data;
@property(nonatomic , strong) NSNumber * time;
@property(nonatomic , strong) NSString * msg;

@end


