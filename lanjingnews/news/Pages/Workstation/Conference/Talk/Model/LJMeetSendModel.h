//
//  LJMeetSendModel.h
//  news
//
//  Created by chunhui on 15/9/29.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "JSONModel.h"

@interface  LJMeetSendDataModel  : JSONModel

@property(nonatomic , strong) NSNumber * msgId;
@property(nonatomic , copy)   NSString * type;

@end


@interface  LJMeetSendModel  : JSONModel

@property(nonatomic , copy)   NSString * msg;
@property(nonatomic , strong) NSNumber * dErrno;
@property(nonatomic , strong) LJMeetSendDataModel * data ;

@end

