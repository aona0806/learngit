//
//  LJAdModel.h
//  news
//
//  Created by chunhui on 15/11/28.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "JSONModel.h"

@protocol LJAdDataModel<NSObject>

@end


@interface  LJAdDataModel  : JSONModel

@property(nonatomic , copy)   NSString * remark;
@property(nonatomic , copy)   NSString * title;
@property(nonatomic , copy)   NSString * goUrl;
@property(nonatomic , copy)   NSString * postion;
@property(nonatomic , copy)   NSString * relId;
@property(nonatomic , copy)   NSString * imgUrl;
@property(nonatomic , copy)   NSString * adId;

@end


@interface  LJAdModel  : JSONModel

@property(nonatomic , copy)   NSString * msg;
@property(nonatomic , strong) NSNumber * dErrno;
@property(nonatomic , strong) NSArray<LJAdDataModel> * data;

@end
