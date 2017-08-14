//
//  MeetListModel.h
//  news
//
//  Created by 陈龙 on 15/10/8.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "JSONModel.h"

@protocol LJMeetListDataModel<NSObject>

@end


@interface  LJMeetListDataModel  : JSONModel

// 所有会议列表
//errno	int	错误编号
//msg	string	错误信息
//id	int	会议id
//img	string	会议图片
//theme	string	会议主题
//sponsor	string	主办方
//start_time	string	会议开始时间
//end_time	string	会议结束时间
//online	int	在线人数
//stage	int	会议阶段 0：其他状态 / 1:即将开始 2:正在直播
//r_status	int	预约状态 0：未预约 / 1:已预约

// 我的会议列表
//errno	int	错误编号
//msg	string	错误信息
//id	int	会议id
//img	string	会议图片
//theme	string	会议主题
//sponsor	string	主办方
//start_time	string	会议开始时间
//end_time	string	会议结束时间
//online	int	在线人数
//stage	int	会议阶段 0：其他状态 / 1:即将开始 2:正在直播
//
//rtime	string	预约会议时间

// 历史会议
//errno	int	错误编号
//msg	string	错误信息
//id	int	会议id
//img	string	会议图片
//theme	string	会议主题
//sponsor	string	主办方
//start_time	string	会议开始时间
//end_time	string	会议结束时间
//
//myaction	int	我的动作 0：未参加 / 1:已参加 / 2：已主办

//"id": 42,
//"img": "http://news.xinhuanet.com/photo/2015-10/08/128296135_14442735331791n.jpg",
//"theme": "18物联网时代,像智能硬件开发者致敬1444287364",
//"sponsor": "18上海庆科信息有限公司1444287364",
//"start_time": 1444264320,
//"end_time": 1444271520,
//"stage": 2,
//"r_status": 1,
//"online": 10,
//"shareurl": "http://test.app.lanjinger.com/v1/share/meeting_detail?id=42"

@property(nonatomic , copy)   NSString * img;
@property(nonatomic , copy)   NSString * startTime;
@property(nonatomic , strong) NSNumber * rStatus;
@property(nonatomic , copy)   NSString * theme;
@property(nonatomic , copy)   NSString * endTime;
@property(nonatomic , strong) NSNumber * online;
@property(nonatomic , strong) NSNumber * stage;
@property(nonatomic , strong) NSNumber * id;
@property(nonatomic , strong) NSNumber * uid;
@property(nonatomic , copy)   NSString * sponsor;
@property(nonatomic , copy)   NSString * shareurl;


@end


@interface LJMeetListModel  : JSONModel

@property(nonatomic , strong) NSNumber * dErrno;
@property(nonatomic , strong) NSArray<LJMeetListDataModel> * data;
@property(nonatomic , strong) NSString * msg;

@end