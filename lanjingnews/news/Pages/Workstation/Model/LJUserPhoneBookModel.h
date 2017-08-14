//
//  LJUserPhoneBookModel.h
//  news
//
//  Created by 陈龙 on 15/12/22.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "JSONModel.h"

@protocol LJUserPhoneBookDataListModel<NSObject>

@end


@interface  LJUserPhoneBookDataListUserRelationModel  : JSONModel

@property(nonatomic , strong) NSNumber * followType;
@property(nonatomic , strong) NSNumber * friendType;

@end


@interface  LJUserPhoneBookDataListModel  : JSONModel

@property(nonatomic , copy)   NSString * sname;
@property(nonatomic , copy)   NSString * company;
@property(nonatomic , copy)   NSString * companyJob;
@property(nonatomic , strong) LJUserPhoneBookDataListUserRelationModel * userRelation ;
@property(nonatomic , copy)   NSString * ukind;
@property(nonatomic , copy)   NSString * avatar;
@property(nonatomic , copy)   NSString * ukindVerify;
@property(nonatomic , copy)   NSString * id;

@end


@interface  LJUserPhoneBookDataModel  : JSONModel

@property(nonatomic , strong) NSNumber * previousCursor;
@property(nonatomic , strong) NSNumber * totalCursor;
@property(nonatomic , strong) NSArray<LJUserPhoneBookDataListModel> * list;
@property(nonatomic , copy)   NSString * nextCursor;
@property(nonatomic , copy)   NSString * totalNumber;

@end


@interface  LJUserPhoneBookModel  : JSONModel

@property(nonatomic , strong) NSNumber * dErrno;
@property(nonatomic , strong) LJUserPhoneBookDataModel * data ;
@property(nonatomic , strong) NSNumber * time;
@property(nonatomic , strong) NSString * msg;

@end
