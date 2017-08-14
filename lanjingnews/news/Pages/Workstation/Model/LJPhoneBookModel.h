//
//  LJPhoneBookModel.h
//  news
//
//  Created by 陈龙 on 15/12/18.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "JSONModel.h"

@protocol LJPhoneBookDataDataModel<NSObject>

@end

//???: Field needs to be perfect(需要跟东哥确认字段，特别是 identity 字段问题）

@interface  LJPhoneBookDataDataModel  : JSONModel

@property(nonatomic , copy)   NSString * city;
@property(nonatomic , copy)   NSString * name;
@property(nonatomic , copy)   NSString * mobile;
@property(nonatomic , copy)   NSString * timeCreate;
@property(nonatomic , copy)   NSString * industry;
@property(nonatomic , copy)   NSString * work;
@property(nonatomic , copy)   NSString * id;
@property(nonatomic , copy)   NSString * job;
@property(nonatomic , copy)   NSString * company;
@property(nonatomic , copy)   NSString * email;
@property(nonatomic , copy)   NSString * identity;

@end


@interface  LJPhoneBookDataModel  : JSONModel

@property(nonatomic , strong) NSArray<LJPhoneBookDataDataModel> * data;
@property(nonatomic , strong) NSArray<LJPhoneBookDataDataModel> * list;
@property(nonatomic , copy)   NSNumber * totalNumber;
@property(nonatomic , copy)   NSNumber * totalPage;
@property(nonatomic , copy)   NSNumber * prevPage;
@property(nonatomic , copy)   NSNumber * nextPage;
@property(nonatomic , copy)   NSNumber * perct;

@end


@interface  LJPhoneBookModel  : JSONModel

@property(nonatomic , copy)   NSString * msg;
@property(nonatomic , strong) NSNumber * dErrno;
@property(nonatomic , strong) LJPhoneBookDataModel * data ;

@end
