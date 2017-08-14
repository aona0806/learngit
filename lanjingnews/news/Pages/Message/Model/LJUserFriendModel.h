//
//  LJUserFriendModel.h
//  news
//
//  Created by 陈龙 on 15/12/8.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "JSONModel.h"

@protocol LJUserFriendDataListModel<NSObject>

@end


@interface  LJUserFriendDataListUserRelationModel  : JSONModel

@property(nonatomic , copy)   NSString * followType;
@property(nonatomic , copy)   NSString * friendType;

@end


@interface  LJUserFriendDataListModel  : JSONModel

@property(nonatomic , copy)   NSString * inital;
@property(nonatomic , copy)   NSString * company;
@property(nonatomic , copy)   NSString * companyJob;
@property(nonatomic , strong) LJUserFriendDataListUserRelationModel * userRelation ;
@property(nonatomic , copy)   NSString * ukind;
@property(nonatomic , copy)   NSString * sname;
@property(nonatomic , copy)   NSString * avatar;
@property(nonatomic , copy)   NSString * ukindVerify;
@property(nonatomic , copy)   NSString * id;

@end


@interface  LJUserFriendDataModel  : JSONModel

@property(nonatomic , strong) NSNumber * previousCursor;
@property(nonatomic , strong) NSNumber * totalCursor;
@property(nonatomic , strong) NSArray<LJUserFriendDataListModel> * list;
@property(nonatomic , copy)   NSString * nextCursor;
@property(nonatomic , copy)   NSString * totalNumber;

@end


@interface  LJUserFriendModel  : JSONModel

@property(nonatomic , strong) NSNumber * dErrno;
@property(nonatomic , strong) LJUserFriendDataModel * data ;
@property(nonatomic , copy)   NSString * uid;
@property(nonatomic , strong) NSNumber * time;
@property(nonatomic , copy)   NSString * msg;

@end