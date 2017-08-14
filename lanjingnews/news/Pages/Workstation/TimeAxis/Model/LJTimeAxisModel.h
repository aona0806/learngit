//
//  LJTimeAxisModel.h
//  news
//
//  Created by 奥那 on 15/12/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LJTimeAxisDataListModel<NSObject>

@end


@interface  LJTimeAxisDataListModel  : JSONModel

@property(nonatomic , copy)   NSString * status;
@property(nonatomic , copy)   NSString * uid;
@property(nonatomic , copy)   NSString * title;
@property(nonatomic , copy)   NSString * signShow;
@property(nonatomic , copy)   NSString * content;
@property(nonatomic , copy)   NSString * timeShow;
@property(nonatomic , copy)   NSString * timeEnd;
@property(nonatomic , copy)   NSString * sponsor;
@property(nonatomic , copy)   NSString * address;
@property(nonatomic , copy)   NSString * type;
@property(nonatomic , copy)   NSString * id;

@end


@interface  LJTimeAxisDataModel  : JSONModel

@property(nonatomic , strong) NSNumber * totalCursor;
@property(nonatomic , copy)   NSString * totalNumber;
@property(nonatomic , strong) NSNumber * previousCursor;
@property(nonatomic , strong) NSArray<LJTimeAxisDataListModel> * list;
@property(nonatomic , copy)   NSString * shareUrl;
@property(nonatomic , strong) NSNumber * nextCursor;

@end


@interface  LJTimeAxisModel  : JSONModel

@property(nonatomic , strong) NSNumber * dErrno;
@property(nonatomic , strong) LJTimeAxisDataModel * data ;
@property(nonatomic , strong) NSNumber * time;
@property(nonatomic , strong) NSString * msg;

@end
