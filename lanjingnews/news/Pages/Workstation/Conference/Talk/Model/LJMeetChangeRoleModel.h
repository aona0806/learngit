//
//  LJMeetChangeRoleModel.h
//  news
//
//  Created by chunhui on 15/10/8.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "JSONModel.h"
#import "LJMeetCommon.h"

@interface  LJMeetChangeRoleDataModel  : JSONModel

@property(nonatomic , strong) NSNumber * role;
@property(nonatomic , strong) NSNumber * changeUid;

@end


@interface  LJMeetChangeRoleModel  : JSONModel

@property(nonatomic , copy)   NSString * msg;
@property(nonatomic , strong) NSNumber * dErrno;
@property(nonatomic , strong) LJMeetChangeRoleDataModel * data ;

@end
