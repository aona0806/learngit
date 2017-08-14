//
//  LJPushInfoModel.h
//  news
//
//  Created by 奥那 on 15/12/28.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LJPushInfoDataConfigTelegraphModel<NSObject>

@end


@interface  LJPushInfoDataConfigTelegraphModel  : JSONModel

@property (nonatomic, copy , nullable) NSString *status;
@property (nonatomic, copy , nullable) NSString *id;
@property (nonatomic, copy , nullable) NSString *name;

@end

@interface  LJPushInfoDataConfigModel  : JSONModel

@property(nonatomic , strong , nullable) NSNumber * commentNotify;
@property(nonatomic , strong , nullable) NSNumber * friendNotify;
@property(nonatomic , strong , nullable) NSNumber * sysNotify;
@property(nonatomic , strong , nullable) NSNumber * meetNotify;
@property(nonatomic , strong , nullable) NSNumber * pmsgNotify;
@property(nonatomic , strong , nullable) NSNumber * zanNotify;
@property(nonatomic , strong , nullable) NSNumber * newsNotify;
@property (nonatomic, strong , nullable) NSArray<LJPushInfoDataConfigTelegraphModel> *telegraph;


@end


@interface  LJPushInfoDataModel  : JSONModel

@property(nonatomic , strong , nullable) LJPushInfoDataConfigModel * config ;

@end


@interface  LJPushInfoModel  : JSONModel

@property(nonatomic , strong , nullable) NSNumber * dErrno;
@property(nonatomic , strong , nullable) LJPushInfoDataModel * data ;

@end

