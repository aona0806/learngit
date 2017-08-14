//
//  LJConInfoModel.h
//  news
//
//  Created by chunhui on 15/10/10.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "JSONModel.h"

@interface  LJConInfoDataModel  : JSONModel

@property(nonatomic , copy)   NSString * ip;
@property(nonatomic , copy)   NSString * token;
@property(nonatomic , strong) NSNumber * port;
@property(nonatomic , copy)   NSString * connId;

@end


@interface  LJConInfoModel  : JSONModel

@property(nonatomic , copy)   NSString * msg;
@property(nonatomic , strong) NSNumber * dErrno;
@property(nonatomic , strong) LJConInfoDataModel * data ;

@end

