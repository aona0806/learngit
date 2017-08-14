//
//  LJzanNewsDetailModel.h
//  news
//
//  Created by wxc on 16/1/11.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "JSONModel.h"

@interface  LJzanNewsDetailDataModel  : JSONModel

@property(nonatomic , copy, nullable) NSString * num;

@end


@interface  LJzanNewsDetailModel  : JSONModel

@property(nonatomic , copy , nullable) NSString * dErrno;
@property(nonatomic , strong , nullable) LJzanNewsDetailDataModel * data ;
@property(nonatomic , copy , nullable) NSString * time;
@property(nonatomic , copy , nullable) NSString * msg;

@end
