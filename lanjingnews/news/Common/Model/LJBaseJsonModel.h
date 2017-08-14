//
//  LJBaseJsonModel.h
//  news
//
//  Created by 陈龙 on 15/12/8.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "JSONModel.h"

@interface LJBaseJsonModel : JSONModel

@property(nonatomic , copy , nullable) NSString * msg;
@property(nonatomic , copy , nullable) NSString * dErrno;
@property(nonatomic , copy , nullable) NSString * dtime;

@end
