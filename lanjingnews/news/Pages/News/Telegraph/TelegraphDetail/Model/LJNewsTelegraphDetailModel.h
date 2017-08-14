//
//  LJNewsTelegraphDetailModel.h
//  news
//
//  Created by wxc on 2017/1/4.
//  Copyright © 2017年 lanjing. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol LJNewsTelegraphDetailDataImgsModel<NSObject>

@end

@interface  LJNewsTelegraphDetailDataImgsDetailModel  : JSONModel

@property(nonatomic , copy)   NSString * url;
@property(nonatomic , strong) NSNumber * h;
@property(nonatomic , strong) NSNumber * w;

@end

@interface  LJNewsTelegraphDetailDataImgsModel  : JSONModel

@property(nonatomic , strong) LJNewsTelegraphDetailDataImgsDetailModel * org ;
@property(nonatomic , strong) LJNewsTelegraphDetailDataImgsDetailModel * thumb ;

@end

@interface  LJNewsTelegraphDetailDataModel  : JSONModel

@property (nonatomic, copy) NSString *ctime;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *commentNum;
@property (nonatomic, copy) NSString *isZan;
@property (nonatomic, copy) NSString *readingNum;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *nid;
@property (nonatomic, copy) NSString *zanNum;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *shareImg;
@property (nonatomic, copy) NSString *marked;
@property (nonatomic, copy) NSArray<LJNewsTelegraphDetailDataImgsModel> *rollImgs;

@end


@interface  LJNewsTelegraphDetailModel  : JSONModel

@property (nonatomic, copy) NSString *dErrno;
@property (nonatomic, strong) LJNewsTelegraphDetailDataModel *data ;
@property (nonatomic, copy) NSString *time;

@end
