//
//  LJRecommendModel.h
//  news
//
//  Created by 奥那 on 16/1/8.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LJRecommendDataRecommendListModel<NSObject>

@end


@interface  LJRecommendDataRecommendListModel  : JSONModel

@property(nonatomic , copy , nullable)   NSString * sname;
@property(nonatomic , copy , nullable)   NSString * uid;
@property(nonatomic , copy , nullable)   NSString * company;
@property(nonatomic , copy , nullable)   NSString * companyJob;
@property(nonatomic , strong , nullable) NSNumber * ukind;
@property(nonatomic , copy , nullable)   NSString * avatar;
@property(nonatomic , strong , nullable) NSNumber * isVerify;

@end


@interface  LJRecommendDataModel  : JSONModel

@property(nonatomic , strong , nullable) NSArray<LJRecommendDataRecommendListModel> * recommendList;

@end


@interface  LJRecommendModel  : JSONModel

@property(nonatomic , strong , nullable) NSNumber * dErrno;
@property(nonatomic , strong , nullable) LJRecommendDataModel * data ;

@end
