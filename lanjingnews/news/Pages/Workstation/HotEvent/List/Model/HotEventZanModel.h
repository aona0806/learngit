//
//  HotEventZanModel.h
//  news
//
//  Created by 陈龙 on 16/6/6.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "JSONModel.h"

@protocol HotEventZanDataModel<NSObject>

@end


@interface  HotEventZanDataModel  : JSONModel

@property(nonatomic , copy)   NSString * action;
@property(nonatomic , copy)   NSString * num;

@end


@interface  HotEventZanModel  : JSONModel

@property(nonatomic , strong) NSNumber * dErrno;
@property(nonatomic , strong) HotEventZanDataModel * data;
@property(nonatomic , strong) NSNumber * time;

@end