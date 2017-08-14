//
//  LJConfigModel.h
//  news
//
//  Created by chunhui on 16/1/15.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "JSONModel.h"

@protocol LJConfigDataNewsModel<NSObject>

@end


@interface  LJConfigDataNewsModel  : JSONModel

@property(nonatomic , copy)   NSString * name;
@property(nonatomic , strong) NSNumber * id;

@end


@interface  LJConfigDataTipsModel  : JSONModel

@property(nonatomic , copy)   NSString * relationFollow;
@property(nonatomic , copy)   NSString * agreeRelation;

@end

@interface  LJConfigDataSwitchModel  : JSONModel

@property (nonatomic, copy) NSString *dun163;

@end


@protocol LJConfigDataCurrencyModel<NSObject>

@end


@interface  LJConfigDataCurrencyModel  : JSONModel

@property(nonatomic , copy)   NSString * ruleName;
@property(nonatomic , copy)   NSString * keyid;
@property(nonatomic , copy)   NSString * ruleId;
@property(nonatomic , copy)   NSString * gold;
@property(nonatomic , copy)   NSString * ruleIntro;

@end


@interface  LJConfigDataModel  : JSONModel

@property(nonatomic , copy)   NSString * codeSign;
@property(nonatomic , strong) NSArray<LJConfigDataNewsModel> * news;
@property(nonatomic , strong) LJConfigDataTipsModel * tips ;
@property(nonatomic , strong) NSDictionary *refreshTipsRoll;
@property(nonatomic , assign) BOOL hasData;
@property(nonatomic , strong) NSArray<LJConfigDataCurrencyModel> * currency;
@property (nonatomic, strong) LJConfigDataSwitchModel *switchData;
@end


@interface  LJConfigModel  : JSONModel

@property(nonatomic , strong) NSNumber * dErrno;
@property(nonatomic , strong) LJConfigDataModel * data ;
@property(nonatomic , strong) NSNumber * time;

@end
