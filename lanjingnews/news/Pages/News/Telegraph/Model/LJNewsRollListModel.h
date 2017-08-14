//
//  LJNewsRollListModel.h
//  news
//
//  Created by 奥那 on 2017/1/3.
//  Copyright © 2017年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface  LJNewsRollListDataListRollImgsOrgModel  : JSONModel

@property (nonatomic, copy , nullable) NSString *url;
@property (nonatomic, copy , nullable) NSString *h;
@property (nonatomic, copy , nullable) NSString *w;

@end

@protocol LJNewsRollListDataListRollImgsModel<NSObject>

@end

@interface  LJNewsRollListDataListRollImgsModel  : JSONModel

@property (nonatomic, strong , nullable) LJNewsRollListDataListRollImgsOrgModel *org ;
@property (nonatomic, strong , nullable) LJNewsRollListDataListRollImgsOrgModel *thumb ;

@end

@protocol LJNewsRollListDataListModel<NSObject>

@end


@interface  LJNewsRollListDataListModel  : JSONModel

@property (nonatomic, copy , nullable) NSString *jump;
@property (nonatomic, copy , nullable) NSString *ctime;
@property (nonatomic, copy , nullable) NSString *title;
@property (nonatomic, copy , nullable) NSString *commentNum;
@property (nonatomic, copy , nullable) NSString *nid;
@property (nonatomic, copy , nullable) NSString *content;
@property (nonatomic, copy , nullable) NSString *readingNum;
@property (nonatomic, copy , nullable) NSString *templateType;
@property (nonatomic, copy , nullable) NSString *lastTime;
@property (nonatomic, copy , nullable) NSString *marked; //1标红、0不标红
@property (nonatomic, copy , nullable) NSString *hasImg;//1-是，0-否
@property (nonatomic, strong , nullable) NSArray<LJNewsRollListDataListRollImgsModel> *rollImgs;
@property (nonatomic, copy , nullable) NSString *shareImg;
@property (nonatomic, copy , nullable) NSString *shareUrl;


@property (nonatomic, assign) BOOL isShowAll;
@property (nonatomic, assign) BOOL isRead;

@end


@interface  LJNewsRollListDataModel  : JSONModel

@property (nonatomic, copy , nullable) NSString *refreshType;
@property (nonatomic, copy , nullable) NSString *catType;
@property (nonatomic, strong , nullable) NSArray<LJNewsRollListDataListModel> *list;
@property (nonatomic, copy , nullable) NSString *catName;

@end


@interface  LJNewsRollListModel  : JSONModel

@property (nonatomic, copy , nullable) NSString *dErrno;
@property (nonatomic, strong , nullable) LJNewsRollListDataModel *data ;
@property (nonatomic, copy , nullable) NSString *time;

@end
