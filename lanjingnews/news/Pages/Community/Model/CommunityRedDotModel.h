//
//  CommunityRedDotModel.h
//  news
//
//  Created by chunhui on 15/12/23.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "JSONModel.h"

@interface  CommunityRedDotDataModel  : JSONModel

@property (nonatomic, strong) NSNumber *zan;
@property (nonatomic, strong) NSNumber *comment;

@end


@interface  CommunityRedDotModel  : JSONModel

@property (nonatomic, strong) NSNumber *dErrno;
@property (nonatomic, strong) CommunityRedDotDataModel *data ;
@end
