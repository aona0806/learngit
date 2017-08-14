//
//  LJNewsDetailModel.h
//  news
//
//  Created by wxc on 16/1/6.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "JSONModel.h"

@protocol LJNewsDetailDataArticleRecModel<NSObject>

@end


@interface  LJNewsDetailDataArticleRecModel  : JSONModel

@property (nonatomic, copy , nullable) NSString *newsId;
@property (nonatomic, copy , nullable) NSString *ctime;
@property (nonatomic, copy , nullable) NSString *title;
@property (nonatomic, copy , nullable) NSString *author;
@property (nonatomic, copy , nullable) NSString *jump;
@property (nonatomic, copy , nullable) NSString *source;

@end

@interface  LJNewsDetailDataModel  : JSONModel

@property (nonatomic, copy , nullable) NSString *content;
@property (nonatomic, copy , nullable) NSString *authorInfo;
@property (nonatomic, copy , nullable) NSString *thumb;
@property (nonatomic, copy , nullable) NSString *title;
@property (nonatomic, copy , nullable) NSString *commentNum;
@property (nonatomic, copy , nullable) NSString *favType;
@property (nonatomic, copy , nullable) NSString *isZan;
@property (nonatomic, copy , nullable) NSString *favTime;
@property (nonatomic, copy , nullable) NSString *nid;
@property (nonatomic, copy , nullable) NSString *ctime;
@property (nonatomic, copy , nullable) NSString *templateType;
@property (nonatomic, copy , nullable) NSString *favStatus;
@property (nonatomic, copy , nullable) NSString *shareUrl;
@property (nonatomic, strong , nullable) NSArray<LJNewsDetailDataArticleRecModel> *articleRec;
@property (nonatomic, copy , nullable) NSString *zanNum;
@property (nonatomic, copy , nullable) NSString *topImage;
@property (nonatomic, copy , nullable) NSString *update;
@property (nonatomic, copy , nullable) NSString *shareContent;
@property (nonatomic, copy , nullable) NSString *appReadNum;
@property (nonatomic, copy , nullable) NSString *shareImg;

// 是否是feed流广告
@property (nonatomic, copy , nullable) NSString *isAd;

@end


@interface  LJNewsDetailModel  : JSONModel

@property (nonatomic, copy , nullable) NSString *dErrno;
@property (nonatomic, strong , nullable) LJNewsDetailDataModel *data ;
@property (nonatomic, copy , nullable) NSString *time;
@property(nonatomic , copy , nullable) NSString * msg;

@end
