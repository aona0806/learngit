//
//  LJCommentModel.h
//  news
//
//  Created by wxc on 16/1/6.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "JSONModel.h"


@protocol LJCommentDataListModel<NSObject>

@end


@interface  LJCommentDataListModel  : JSONModel

@property (nonatomic, copy , nullable) NSString *replyCid;
@property (nonatomic, copy , nullable) NSString *verified;
@property (nonatomic, copy , nullable) NSString *uid;
@property (nonatomic, copy , nullable) NSString *name;
@property (nonatomic, copy , nullable) NSString *cid;
@property (nonatomic, copy , nullable) NSString *isDel;
@property (nonatomic, copy , nullable) NSString *timeCreate;
@property (nonatomic, copy , nullable) NSString *company;
@property (nonatomic, copy , nullable) NSString *isTop;
@property (nonatomic, copy , nullable) NSString *infoid;
@property (nonatomic, copy , nullable) NSString *content;
@property (nonatomic, copy , nullable) NSString *ukind;
@property (nonatomic, copy , nullable) NSString *avatar;
@property (nonatomic, copy , nullable) NSString *replyUid;
@property (nonatomic, copy , nullable) NSString *ukindVerify;
@property (nonatomic, copy , nullable) NSString *isHidden;
@property (nonatomic, copy , nullable) NSString *timeTop;
@property (nonatomic, copy , nullable) NSString *ukindName;

@end


@interface  LJCommentDataModel  : JSONModel

@property (nonatomic, copy , nullable) NSString *commentNum;
@property (nonatomic, strong , nullable) NSArray<LJCommentDataListModel> *list;

@end


@interface  LJCommentModel  : JSONModel

@property (nonatomic, copy , nullable) NSString *dErrno;
@property (nonatomic, strong , nullable) LJCommentDataModel *data ;
@property (nonatomic, copy , nullable) NSString *time;
@property(nonatomic , copy , nullable)   NSString * msg;

@end

@interface  LJSubmitCommentModel  : JSONModel

@property(nonatomic , strong , nullable) NSString * dErrno;
@property(nonatomic , strong , nullable) LJCommentDataListModel * data ;
@property(nonatomic , strong , nullable) NSString * time;
@property(nonatomic , copy , nullable)   NSString * msg;

@end
