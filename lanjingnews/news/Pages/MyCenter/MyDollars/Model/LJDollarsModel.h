//
//  LJDollarsModel.h
//  news
//
//  Created by 奥那 on 15/12/21.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LJDollarsDataListModel<NSObject>

@end


@interface  LJDollarsDataListModel  : JSONModel

@property(nonatomic , copy , nullable)   NSString * keyid;
@property(nonatomic , copy , nullable)   NSString * uid;
@property(nonatomic , copy , nullable)   NSString * timeCreate;
@property(nonatomic , copy , nullable)   NSString * intro;
@property(nonatomic , copy , nullable)   NSString * action;
@property(nonatomic , copy , nullable)   NSString * affect;
@property(nonatomic , copy , nullable)   NSString * timeYday;
@property(nonatomic , copy , nullable)   NSString * timeYear;
@property(nonatomic , copy , nullable)   NSString * id;

@end


@interface  LJDollarsDataModel  : JSONModel

@property(nonatomic , strong , nullable) NSNumber * nums;
@property(nonatomic , strong , nullable) NSArray<LJDollarsDataListModel> * list;
@property(nonatomic , copy , nullable)   NSString * minId;
@property(nonatomic , copy , nullable)   NSString * sql;
@property(nonatomic , copy , nullable)   NSString * type;
@property(nonatomic , strong , nullable) NSNumber * perct;

@end


@interface  LJDollarsModel  : JSONModel

@property(nonatomic , copy , nullable)   NSString * msg;
@property(nonatomic , strong , nullable) NSNumber * dErrno;
@property(nonatomic , strong , nullable) LJDollarsDataModel * data ;

@end

