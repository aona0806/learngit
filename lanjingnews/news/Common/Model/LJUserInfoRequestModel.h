//
//  LJUserInfoRequestModel.h
//  news
//
//  Created by chunhui on 15/12/23.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "JSONModel.h"
#import "LJUserInfoModel.h"

@interface  LJUserInfoRequestModel  : JSONModel

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) NSNumber *dErrno;
@property (nonatomic, strong) LJUserInfoModel *data ;

@end
