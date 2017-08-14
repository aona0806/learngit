//
//  LJWorkStationModel.h
//  news
//
//  Created by 陈龙 on 15/12/18.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "JSONModel.h"

@protocol LJWorkStationDataModel<NSObject>

@end


@interface  LJWorkStationDataModel  : JSONModel

@property(nonatomic , copy)   NSString * img;
@property(nonatomic , copy)   NSString * title;
@property(nonatomic , copy)   NSString * url;
@property(nonatomic , copy)   NSString * item;
@property(nonatomic , copy)   NSString * intro;
@property(nonatomic , copy)   NSString * scheme;
@property(nonatomic , strong) NSArray<NSString *> * params;

@end


@interface  LJWorkStationModel  : JSONModel

@property(nonatomic , strong) NSNumber * dErrno;
@property(nonatomic , strong) NSArray<LJWorkStationDataModel> * data;
@property(nonatomic , strong) NSNumber * time;
@property(nonatomic , strong) NSString * msg;

@end