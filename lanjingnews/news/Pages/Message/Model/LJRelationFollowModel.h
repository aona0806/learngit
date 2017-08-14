//
//  LJRelationFollowModel.h
//  news
//
//  Created by 陈龙 on 15/12/8.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJBaseJsonModel.h"

@protocol LJRelationFollowDataModel<NSObject>

@end


@interface  LJRelationFollowDataModel  : JSONModel

@property(nonatomic , strong) NSNumber * type;
@property(nonatomic , copy)   NSString * followUid;

@end


@interface  LJRelationFollowModel  :  LJBaseJsonModel

@property(nonatomic , strong) NSArray<LJRelationFollowDataModel> * data;

@end