//
//  LJPhoneBookDetailModel.h
//  news
//
//  Created by 陈龙 on 15/12/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "JSONModel.h"

@interface  LJPhoneBookDetailDataModel  : JSONModel

@property(nonatomic , copy)   NSString * province;
@property(nonatomic , copy)   NSString * city;
@property(nonatomic , copy)   NSString * name;
@property(nonatomic , copy)   NSString * timeCreate;
@property(nonatomic , copy)   NSString * industry;
@property(nonatomic , copy)   NSString * work;
@property(nonatomic , copy)   NSString * id;
@property(nonatomic , copy)   NSString * job;
@property(nonatomic , copy)   NSString * eqUid;
@property(nonatomic , copy)   NSString * company;
@property(nonatomic , copy)   NSString * email;
@property(nonatomic , copy)   NSString * identity;
@property(nonatomic , copy)   NSString * uid;
@property(nonatomic , copy)   NSString * mobile;
@property(nonatomic , copy)   NSString * remark;

@end


@interface  LJPhoneBookDetailModel  : JSONModel

@property(nonatomic , copy)   NSString * msg;
@property(nonatomic , strong) NSNumber * dErrno;
@property(nonatomic , strong) LJPhoneBookDetailDataModel * data ;

@end


