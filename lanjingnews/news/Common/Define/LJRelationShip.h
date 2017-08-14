//
//  LJRelationShip.h
//  news
//
//  Created by chunhui on 15/12/25.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#ifndef LJRelationShip_h
#define LJRelationShip_h


typedef NS_ENUM(NSInteger , LJRelationFollowType ) {
    LJRelationFollowTypeInvalid = -1 , //无效
    LJRelationFollowTypeNoFollow = 0 ,  //无关注关系
    LJRelationFollowTypeMeFollowOther = 1, //我单向关注他人
    LJRelationFollowTypeEacher = 2 ,       //互相关注
    LJRelationFollowTypeOtherFollowMe = 3  //其他人关注我
};

#endif /* LJRelationShip_h */
