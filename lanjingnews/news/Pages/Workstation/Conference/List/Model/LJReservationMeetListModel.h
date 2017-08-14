//
//  ReservationMeetListModel.h
//  news
//
//  Created by 陈龙 on 15/10/9.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "JSONModel.h"

@protocol LJReservationMeetListDataModel<NSObject>

@end

@interface  LJReservationMeetListDataModel  : JSONModel

//"id": 47,
//"img": "0",
//"theme": "物联网时代,像智能硬件开发者致敬1444294807",
//"sponsor": "上海庆科信息有限公司1444294807",
//"start_time": 0,
//"end_time": 0,
//"shareurl": "http://test.app.lanjinger.com/v1/share/meeting_detail?id=47",
//"rtime": 1238214300,
//"stage": 2,
//"online": 200

//errno	int	错误编号
//msg	string	错误信息
//id	int	会议id
//img	string	会议图片
//theme	string	会议主题
//sponsor	string	主办方
//start_time	string	会议开始时间
//end_time	string	会议结束时间
//rtime	string	预约会议时间
//online	int	在线人数
//stage	int	会议阶段 0：其他状态 / 1:即将开始 / 2:正在直播 / 3：已主办 / 4：已取消
//shareurl	string	分享链接
//scontent	string	分享内容

@property(nonatomic , strong) NSNumber * rtime;
@property(nonatomic , copy)   NSString * img;
@property(nonatomic , strong) NSNumber * startTime;
@property(nonatomic , copy)   NSString * shareurl;
@property(nonatomic , copy)   NSString * theme;
@property(nonatomic , strong) NSNumber * endTime;
@property(nonatomic , strong) NSNumber * online;
@property(nonatomic , strong) NSNumber * stage;
@property(nonatomic , strong) NSNumber * id;
@property(nonatomic , copy)   NSString * sponsor;

@end


@interface  LJReservationMeetListModel  : JSONModel

@property(nonatomic , strong) NSNumber * dErrno;
@property(nonatomic , strong) NSArray<LJReservationMeetListDataModel> * data;
@property(nonatomic , strong) NSNumber * time;
@property(nonatomic , strong) NSString * msg;

@end
