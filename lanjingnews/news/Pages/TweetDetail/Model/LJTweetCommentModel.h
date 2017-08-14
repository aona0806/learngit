//
//  LJTweetCommentModel.h
//  news
//
//  Created by chunhui on 15/12/7.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "JSONModel.h"

@protocol LJTweetCommentDataContentModel<NSObject>

@end


@interface  LJTweetCommentDataContentModel  : JSONModel

@property (nonatomic, copy) NSString *replyCid;
@property (nonatomic, copy) NSString *sname;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *isDel;
@property (nonatomic, copy) NSString *replySname;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *atuids;
@property (nonatomic, copy) NSString *replyUid;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *ctime;

@end


@interface  LJTweetCommentDataModel  : JSONModel

@property (nonatomic, strong) NSArray<LJTweetCommentDataContentModel> *content;
@property (nonatomic, copy) NSString *type;

@end


@interface  LJTweetCommentModel  : JSONModel

@property (nonatomic, strong) NSNumber *dErrno;
@property (nonatomic, strong) LJTweetCommentDataModel *data ;

@end

