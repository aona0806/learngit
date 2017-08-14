//
//  HotEventDetailModel.h
//  news
//
//  Created by 陈龙 on 16/6/7.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "JSONModel.h"
#import "HotEventModel.h"

@protocol HotEventDetailDataModel<NSObject>

@end


@interface  HotEventDetailDataModel  : JSONModel

@property(nonatomic , copy)   NSString * status;
@property(nonatomic , copy)   NSString * ctime;
@property(nonatomic , copy)   NSString * title;
@property(nonatomic , strong) NSArray<HotEventDataAtricleRecListModel> * atricleRecList;
@property(nonatomic , copy)   NSString * recArticle;
@property(nonatomic , strong) NSString * isZan;
@property(nonatomic , copy)   NSString * brief;
@property(nonatomic , strong) NSArray<HotEventDataExpertRecListModel> * expertRecList;
@property(nonatomic , copy)   NSString * content;
@property(nonatomic , copy)   NSString * recExpert;
@property(nonatomic , strong) NSString * zanNum;
@property(nonatomic , copy)   NSString * id;
@property(nonatomic , copy)   NSString * shareUrl;

@end


@interface  HotEventDetailModel  : JSONModel

@property(nonatomic , strong) NSNumber * dErrno;
@property(nonatomic , strong) HotEventDetailDataModel * data;
@property(nonatomic , strong) NSNumber * time;

@end