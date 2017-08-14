//
//  LJUserInfoModel.h
//  news
//
//  Created by chunhui on 15/12/23.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "JSONModel.h"

@protocol LJUserInfoIndustryModel<NSObject>

@end


@interface  LJUserInfoIndustryModel  : JSONModel

@property (nonatomic, copy , nullable) NSString *iid;
@property (nonatomic, copy , nullable) NSString *title;

@end


@interface  LJUserInfoRelationModel  : JSONModel

/**
 *  0: 未关注 1：已关注 2:互相关注 3:单向他/她关注我
 */
@property (nonatomic, strong , nullable) NSNumber *followType;
@property (nonatomic, strong , nullable) NSNumber *friendType;

@end


@interface  LJUserInfoModel  : JSONModel

@property (nonatomic, copy , nullable) NSString *uid;
@property (nonatomic, copy , nullable) NSString *gold;
@property (nonatomic, strong , nullable) NSNumber *friendsNum;
@property (nonatomic, copy , nullable) NSString *sex;
@property (nonatomic, strong , nullable) NSNumber *followUserNum;
@property (nonatomic, copy , nullable) NSString *companyJob;
@property (nonatomic, copy , nullable) NSString *intro;
@property (nonatomic, copy , nullable) NSString *uemail;
@property (nonatomic, copy , nullable) NSString *ukindName;
@property (nonatomic, copy , nullable) NSString *city;
@property (nonatomic, copy , nullable) NSString *privacy;
@property (nonatomic, copy , nullable) NSString *companyJionTime;
@property (nonatomic, copy , nullable) NSString *ukind;
@property (nonatomic, copy , nullable) NSString *companyLeaveTime;
@property (nonatomic, strong , nullable) NSArray<LJUserInfoIndustryModel> *followIndustry;
@property (nonatomic, copy , nullable) NSString *sname;
@property (nonatomic, copy , nullable) NSString *company;
@property (nonatomic, strong , nullable) NSNumber *tweetNum;
@property (nonatomic, strong , nullable) NSNumber *userFollowNum;
@property (nonatomic, strong , nullable) LJUserInfoRelationModel *userRelation ;
@property (nonatomic, copy , nullable) NSString *uname;
@property (nonatomic, copy , nullable) NSString *age;
@property (nonatomic, copy , nullable) NSString *avatar;
@property (nonatomic, copy , nullable) NSString *ukindVerify;
@property (nonatomic, copy , nullable) NSString *isComplete;
@property (nonatomic, copy , nullable) NSString *claim;


@property (nonatomic, copy , nullable) NSString *token;
@property (nonatomic, copy , nullable) NSString *nickname;

//认证 0-未认证 1-认证
@property (nonatomic, copy , nullable) NSString *verified;

//绑定邀请码 0-未绑定 1-绑定
@property (nonatomic, copy , nullable) NSNumber *bind_invite_code;

@end
