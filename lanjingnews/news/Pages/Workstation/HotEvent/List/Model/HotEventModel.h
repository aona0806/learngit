//
//  HotEventModel.h
//  news
//
//  Created by 陈龙 on 16/6/3.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "JSONModel.h"

@protocol HotEventDataModel<NSObject>

@end


@protocol HotEventDataAtricleRecListModel<NSObject>

@end


@interface  HotEventDataAtricleRecListModel  : JSONModel

@property(nonatomic , copy)   NSString * id;
@property(nonatomic , copy)   NSString * title;
@property(nonatomic , copy)   NSString * schema;

@end


@protocol HotEventDataExpertRecListModel<NSObject>

@end


@interface  HotEventDataExpertRecListModel  : JSONModel

@property(nonatomic , copy)   NSString * job;
@property(nonatomic , copy)   NSString * company;
@property(nonatomic , copy)   NSString * id;
@property(nonatomic , copy)   NSString * name;

@end


@interface  HotEventDataModel  : JSONModel

@property(nonatomic , copy)   NSString * status;
@property(nonatomic , copy)   NSString * ctime;
@property(nonatomic , copy)   NSString * title;
@property(nonatomic , strong) NSArray<HotEventDataAtricleRecListModel> * atricleRecList;
@property(nonatomic , strong) NSString * isZan;
@property(nonatomic , copy)   NSString * brief;
@property(nonatomic , strong) NSArray<HotEventDataExpertRecListModel> * expertRecList;
@property(nonatomic , strong) NSString * zanNum;
@property(nonatomic , copy)   NSString * id;

@end


@interface  HotEventModel  : JSONModel

@property(nonatomic , strong) NSNumber * dErrno;
@property(nonatomic , strong) NSArray<HotEventDataModel> * data;
@property(nonatomic , strong) NSNumber * time;

@end

