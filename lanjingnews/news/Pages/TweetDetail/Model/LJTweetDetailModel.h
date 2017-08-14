//
//  LJTweetDetailModel.h
//  news
//
//  Created by chunhui on 15/12/7.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "JSONModel.h"
#import "LJTweetModel.h"

@interface  LJTweetDetailDataModel  : JSONModel

@property (nonatomic, strong) LJTweetDataContentModel *content ;

@end


@interface  LJTweetDetailModel  : JSONModel

@property (nonatomic, strong) NSNumber *dErrno;
@property (nonatomic, strong) LJTweetDetailDataModel *data ;
@property (nonatomic, strong) NSString *msg;

@end
