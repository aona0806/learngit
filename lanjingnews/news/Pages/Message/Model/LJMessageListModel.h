//
//  LJMessageListModel.h
//  news
//
//  Created by 陈龙 on 15/12/8.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "JSONModel.h"

@protocol LJMessageListDataContentModel<NSObject>

@end


@interface  LJMessageListDataContentModel  : JSONModel

@property(nonatomic , copy)   NSString * sname;
@property(nonatomic , copy)   NSString * ctime;
@property(nonatomic , copy)   NSString * content;
@property(nonatomic , copy)   NSString * avatar;
@property(nonatomic , copy)   NSString * toUid;
@property(nonatomic , strong) NSNumber * hasNewMsg;
@property(nonatomic , copy)   NSString * fromUid;

@end


@interface  LJMessageListDataModel  : JSONModel

@property(nonatomic , strong) NSArray<LJMessageListDataContentModel> * content;

@end


@interface  LJMessageListModel  : JSONModel

@property(nonatomic , copy)   NSString * msg;
@property(nonatomic , strong) NSNumber * dErrno;
@property(nonatomic , strong) LJMessageListDataModel * data ;

@end


