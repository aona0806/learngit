//
//  LJPhoneBookFeedBackModel.h
//  news
//
//  Created by 陈龙 on 15/12/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "JSONModel.h"

@protocol LJPhoneBookFeedBackDataListModel<NSObject>

@end

@interface  LJPhoneBookFeedBackDataListUserinfoUserRelationModel  : JSONModel

@property(nonatomic , strong) NSNumber * followType;
@property(nonatomic , strong) NSNumber * friendType;

@end


@interface  LJPhoneBookFeedBackDataListUserinfoModel  : JSONModel

@property(nonatomic , copy)   NSString * claim;
@property(nonatomic , copy)   NSString * oauthName;
@property(nonatomic , copy)   NSString * ufrom;
@property(nonatomic , copy)   NSString * uid;
@property(nonatomic , copy)   NSString * gold;
@property(nonatomic , strong) NSNumber * followIndustryNum;
@property(nonatomic , copy)   NSString * integral;
@property(nonatomic , copy)   NSString * friendsNum;
@property(nonatomic , copy)   NSString * sex;
@property(nonatomic , copy)   NSString * uname;
@property(nonatomic , copy)   NSString * companyJob;
@property(nonatomic , copy)   NSString * createTime;
@property(nonatomic , copy)   NSString * uemail;
@property(nonatomic , copy)   NSString * oauthKey;
@property(nonatomic , copy)   NSString * id;
@property(nonatomic , copy)   NSString * ukindName;
@property(nonatomic , copy)   NSString * city;
@property(nonatomic , copy)   NSString * province;
@property(nonatomic , copy)   NSString * privacy;
@property(nonatomic , copy)   NSString * companyJionTime;
@property(nonatomic , copy)   NSString * ukind;
@property(nonatomic , copy)   NSString * tname;
@property(nonatomic , copy)   NSString * companyLeaveTime;
@property(nonatomic , strong) NSDictionary * followIndustry ;
@property(nonatomic , copy)   NSString * status;
@property(nonatomic , copy)   NSString * updateTime;
@property(nonatomic , copy)   NSString * sname;
@property(nonatomic , copy)   NSString * followerNum;
@property(nonatomic , copy)   NSString * umobile;
@property(nonatomic , copy)   NSString * company;
@property(nonatomic , copy)   NSString * school;
@property(nonatomic , copy)   NSString * lockNum;
@property(nonatomic , copy)   NSString * tweetNum;
@property(nonatomic , copy)   NSString * followeeNum;
@property(nonatomic , copy)   NSString * address;
@property(nonatomic , strong) LJPhoneBookFeedBackDataListUserinfoUserRelationModel * userRelation ;
@property(nonatomic , copy)   NSString * dummy;
@property(nonatomic , copy)   NSString * lockTime;
@property(nonatomic , copy)   NSString * inital;
@property(nonatomic , copy)   NSString * locked;
@property(nonatomic , strong) NSNumber * followUserNum;
@property(nonatomic , copy)   NSString * industry;
@property(nonatomic , copy)   NSString * age;
@property(nonatomic , copy)   NSString * intro;
@property(nonatomic , copy)   NSString * avatar;
@property(nonatomic , copy)   NSString * ukindVerify;
@property(nonatomic , copy)   NSString * isComplete;

@end


@interface  LJPhoneBookFeedBackDataListModel  : JSONModel

@property(nonatomic , copy)   NSString * comment;
@property(nonatomic , copy)   NSString * status;
@property(nonatomic , copy)   NSString * kind;
@property(nonatomic , copy)   NSString * uid;
@property(nonatomic , copy)   NSString * contactStatus;
@property(nonatomic , copy)   NSString * timeCreate;
@property(nonatomic , copy)   NSString * phoneId;
@property(nonatomic , copy)   NSString * timeAgo;
@property(nonatomic , copy)   NSString * contact;
@property(nonatomic , strong) LJPhoneBookFeedBackDataListUserinfoModel * userinfo ;
@property(nonatomic , copy)   NSString * type;
@property(nonatomic , copy)   NSString * id;

@end


@interface  LJPhoneBookFeedBackDataModel  : JSONModel

@property(nonatomic , strong) NSNumber * nextPage;
@property(nonatomic , strong) NSNumber * totalNumber;
@property(nonatomic , strong) NSNumber * prevPage;
@property(nonatomic , strong) NSArray<LJPhoneBookFeedBackDataListModel> * list;
@property(nonatomic , strong) NSNumber * totalPage;
@property(nonatomic , strong) NSNumber * perct;

@end


@interface  LJPhoneBookFeedBackModel  : JSONModel

@property(nonatomic , copy)   NSString * msg;
@property(nonatomic , strong) NSNumber * dErrno;
@property(nonatomic , strong) LJPhoneBookFeedBackDataModel * data ;

@end
