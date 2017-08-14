//
//  LJMyDiscussModel.h
//  news
//
//  Created by 奥那 on 15/12/12.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJTweetModel.h"

@protocol LJMyDiscussDataContentTopicModel<NSObject>

@end


@protocol LJMyDiscussDataContentTopicCommentListModel<NSObject>

@end


@interface  LJMyDiscussDataContentTopicCommentListModel  : JSONModel

@property(nonatomic , copy , nullable)   NSString * replyCid;
@property(nonatomic , copy , nullable)   NSString * uid;
@property(nonatomic , copy , nullable)   NSString * cid;
@property(nonatomic , copy , nullable)   NSString * isDel;
@property(nonatomic , copy , nullable)   NSString * replySname;
@property(nonatomic , copy , nullable)   NSString * content;
@property(nonatomic , copy , nullable)   NSString * atuids;
@property(nonatomic , copy , nullable)   NSString * replyUid;
@property(nonatomic , copy , nullable)   NSString * avatar;
@property(nonatomic , copy , nullable)   NSString * tid;
@property(nonatomic , copy , nullable)   NSString * ctime;

@end


@interface  LJMyDiscussDataContentTopicCommentModel  : JSONModel

@property(nonatomic , copy , nullable)   NSString * num;
@property(nonatomic , strong , nullable) NSArray<LJMyDiscussDataContentTopicCommentListModel> * list;

@end


@protocol LJMyDiscussDataContentTopicForwardUserModel<NSObject>

@end


@interface  LJMyDiscussDataContentTopicForwardUserModel  : JSONModel

@property(nonatomic , copy , nullable)   NSString * sname;
@property(nonatomic , copy , nullable)   NSString * uid;

@end


@interface  LJMyDiscussDataContentTopicForwardModel  : JSONModel

@property(nonatomic , copy , nullable)   NSString * url;
@property(nonatomic , copy , nullable)   NSString * num;
@property(nonatomic , strong , nullable) NSArray<LJMyDiscussDataContentTopicForwardUserModel> * user;

@end


@interface  LJMyDiscussDataContentTopicOriginTopicModel  : JSONModel

@property(nonatomic , copy , nullable)   NSString * body;
@property(nonatomic , copy , nullable)   NSString * sname;
@property(nonatomic , copy , nullable)   NSString * uid;
@property(nonatomic , copy , nullable)   NSString * uname;
@property(nonatomic , copy , nullable)   NSString * title;
@property(nonatomic , copy , nullable)   NSString * atuids;
@property(nonatomic , copy , nullable)   NSString * tid;
@property(nonatomic , copy , nullable)   NSString * ctime;

@end


@protocol LJMyDiscussDataContentTopicPraiseUserModel<NSObject>

@end


@interface  LJMyDiscussDataContentTopicPraiseUserModel  : JSONModel

@property(nonatomic , copy , nullable)   NSString * sname;
@property(nonatomic , copy , nullable)   NSString * uid;

@end


@interface  LJMyDiscussDataContentTopicPraiseModel  : JSONModel

@property(nonatomic , copy , nullable)   NSString * num;
@property(nonatomic , strong , nullable) NSArray<LJMyDiscussDataContentTopicPraiseUserModel> * user;

@end



@interface  LJMyDiscussDataContentUserInfoModel  : JSONModel

@property(nonatomic , copy , nullable)   NSString * ukind;
@property(nonatomic , copy , nullable)   NSString * sname;
@property(nonatomic , copy , nullable)   NSString * uid;
@property(nonatomic , copy , nullable)   NSString * companyJob;
@property(nonatomic , copy , nullable)   NSString * avatar;

@end


@interface  LJMyDiscussDataContentModel  : JSONModel

@property(nonatomic , strong , nullable) NSArray<LJTweetDataContentModel> * topic;
@property(nonatomic , strong , nullable) LJMyDiscussDataContentUserInfoModel * userInfo ;

@end


@interface  LJMyDiscussDataModel  : JSONModel

@property(nonatomic , strong , nullable) LJMyDiscussDataContentModel * content ;

@end


@interface  LJMyDiscussModel  : JSONModel

@property(nonatomic , strong , nullable) NSNumber * dErrno;
@property(nonatomic , strong , nullable) LJMyDiscussDataModel * data ;

@end
