//
//  LJRedDotModel.h
//  news
//
//  Created by chunhui on 15/12/29.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface  LJRedDotDataPmsgModel  : JSONModel

@property (nonatomic, strong) NSArray<NSString *> *fromUid;

@end


@interface  LJRedDotDataModel  : JSONModel

@property (nonatomic, strong) NSNumber *zan;
@property (nonatomic, strong) LJRedDotDataPmsgModel *pmsg ;
@property (nonatomic, strong) NSNumber *rec;
@property (nonatomic, strong) NSNumber *circle;
@property (nonatomic, strong) NSNumber *cmt;
@property (nonatomic, strong) NSNumber *friendMsg;

@end


@interface  LJRedDotModel  : JSONModel

@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) NSNumber *dErrno;
@property (nonatomic, strong) LJRedDotDataModel *data ;

@end

