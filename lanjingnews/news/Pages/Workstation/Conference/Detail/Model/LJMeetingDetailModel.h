//
//  MeetingDetailModel.h
//  news
//
//  Created by 陈龙 on 15/10/9.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "JSONModel.h"

@interface  LJMeetingDetailDataModel  : JSONModel

//"id": 69,
//"uid": 34,
//"status": 3,
//"img": "http://img.lanjinger.com/lanjingapp/meeting/20151020/150424_5625e778b853c.png",
//"theme": "cary",
//"sponsor": "liu",
//"start_time": 1445497440,
//"end_time": 1446188640,
//"speaker": "asdfsdf",
//"meeting_info": "weqwqrweqr",
//"company_info": "zxcvxzcvxcvxc",
//"management": "asdfsadfasdf",
//"overview": "qqq",
//"meeting_notes": "asdfsdfsadfasdf",
//"shareurl": "http://test.app.lanjinger.com/v1/share/meeting_detail?id=69",
//"scontent": "qqq",
//"r_status": 0,
//"dstage": 2

@property(nonatomic , strong) NSNumber * status;
@property(nonatomic , copy)   NSString * companyInfo;
@property(nonatomic , copy)   NSString * management;
@property(nonatomic , strong) NSNumber * uid;
@property(nonatomic , copy)   NSString * img;
@property(nonatomic , copy)   NSString * overview;
@property(nonatomic , strong) NSNumber * startTime;
@property(nonatomic , copy)   NSString * shareurl;
@property(nonatomic , copy)   NSString * scontent;
@property(nonatomic , copy)   NSString * theme;
@property(nonatomic , copy)   NSString * speaker;
@property(nonatomic , copy)   NSString * sponsor;
@property(nonatomic , copy)   NSString * meetingInfo;
@property(nonatomic , strong) NSNumber * id;
@property(nonatomic , strong) NSNumber * endTime;
@property(nonatomic , strong) NSNumber * rStatus;
@property(nonatomic , strong) NSNumber * dstage;
@property(nonatomic , strong) NSString * meetingNotes;
@property(nonatomic , strong) NSString * meetingSummary;
@property(nonatomic , strong) NSString * type;

@end


@interface  LJMeetingDetailModel  : JSONModel

@property(nonatomic , strong) NSNumber * dErrno;
@property(nonatomic , strong) LJMeetingDetailDataModel * data ;
@property(nonatomic , strong) NSNumber * time;
@property(nonatomic , strong) NSString * msg;

@end
