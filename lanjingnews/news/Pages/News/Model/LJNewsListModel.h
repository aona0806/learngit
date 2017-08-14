//
//  LJNewsListModel.h
//  news
//
//  Created by 陈龙 on 16/1/5.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "LJBaseJsonModel.h"

@interface  LJNewsListDataListTipModel  : JSONModel

@property (nonatomic, copy , nullable) NSString *name;
@property (nonatomic, copy , nullable) NSString *bgcolor;
@property (nonatomic, copy , nullable) NSString *forecolor;

@end


@protocol LJNewsListDataListModel<NSObject>

@end


@protocol LJNewsListDataListBannerModel<NSObject>

@end


@interface  LJNewsListDataListBannerModel  : JSONModel

@property (nonatomic, copy , nullable) NSString *jump;
@property (nonatomic, copy , nullable) NSString *img;
@property (nonatomic, copy , nullable) NSString *title;

@end

@protocol LJNewsListDataListRollListModel<NSObject>

@end


@interface  LJNewsListDataListRollListModel  : JSONModel

@property (nonatomic, copy , nullable) NSString *jump;
@property (nonatomic, copy , nullable) NSString *content;
@property (nonatomic, copy , nullable) NSString *marked; //1标红、0不标红

@end


@interface  LJNewsListDataListModel  : JSONModel

@property (nonatomic, copy , nullable) NSString *jump;
@property (nonatomic, strong , nullable) NSArray<LJNewsListDataListBannerModel> *bannerContent;
@property (nonatomic, strong , nullable) NSArray<LJNewsListDataListRollListModel> *rollList;
@property (nonatomic, copy , nullable) NSString *authorInfo;
@property (nonatomic, copy , nullable) NSString *ctime;
@property (nonatomic, copy , nullable) NSString *title;
@property (nonatomic, copy , nullable) NSString *favType;
@property (nonatomic, copy , nullable) NSString *favTime;
@property (nonatomic, copy , nullable) NSString *nid;
@property (nonatomic, copy , nullable) NSString *brief;
@property (nonatomic, copy , nullable) NSString *templateType;
@property (nonatomic, copy , nullable) NSString *favStatus;
@property (nonatomic, copy , nullable) NSString *appReadNum;
@property (nonatomic, strong , nullable) NSArray<NSString *> *imgs;
@property (nonatomic, copy , nullable) NSString *lastTime;
@property (nonatomic, copy , nullable) LJNewsListDataListTipModel *tip;
@property (nonatomic, strong , nullable) NSNumber * isDel;
@property (nonatomic, copy , nullable) NSString *sponsor;
@property (nonatomic, copy , nullable) NSString *timeStart;

@property (nonatomic, copy , nullable) NSString *tshow;
@property (nonatomic, copy , nullable) NSString *tview;

@end


@interface  LJNewsListDataModel  : JSONModel

@property (nonatomic, copy , nullable) NSString *refreshType;
@property (nonatomic, copy , nullable) NSString *catType;
@property (nonatomic, strong , nullable) NSArray<LJNewsListDataListModel> *list;
@property (nonatomic, copy , nullable) NSString *catName;

@end


@interface  LJNewsListModel  : JSONModel

@property (nonatomic, copy , nullable) NSString *dErrno;
@property (nonatomic, strong , nullable) LJNewsListDataModel *data ;
@property (nonatomic, copy , nullable) NSString *time;
@property(nonatomic , copy , nullable)  NSString * msg;

@end
