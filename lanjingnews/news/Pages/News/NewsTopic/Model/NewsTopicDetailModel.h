//
//  NewsTopicDetailModel.h
//  news
//
//  Created by 陈龙 on 16/1/8.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "LJNewsListModel.h"

@interface  NewsTopicDetailDataTopicInfoModel  : JSONModel

@property (nonatomic, copy , nullable) NSString *thumb;
@property (nonatomic, copy , nullable) NSString *title;
@property (nonatomic, copy , nullable) NSString *favType;
@property (nonatomic, copy , nullable) NSString *shortTitle;
@property (nonatomic, copy , nullable) NSString *ctime;
@property (nonatomic, copy , nullable) NSString *jump;
@property (nonatomic, copy , nullable) NSString *favStatus;
@property (nonatomic, copy , nullable) NSString *nid;
@property (nonatomic, copy , nullable) NSString *focusImg;
@property (nonatomic, copy , nullable) NSString *tid;
@property (nonatomic, copy , nullable) NSString *desc;

@end


@interface  NewsTopicDetailDataModel  : JSONModel

@property (nonatomic, copy , nullable) NSString *refreshType;
@property (nonatomic, strong , nullable) NSArray<LJNewsListDataListModel> *newsList;
@property (nonatomic, strong , nullable) NewsTopicDetailDataTopicInfoModel *topicInfo ;

@end


@interface  NewsTopicDetailModel  : LJBaseJsonModel

@property(nonatomic , strong , nullable) NewsTopicDetailDataModel * data ;

@end
