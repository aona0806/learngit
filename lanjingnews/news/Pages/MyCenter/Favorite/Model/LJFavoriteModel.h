//
//  LJCollectionModel.h
//  news
//
//  Created by wxc on 16/1/6.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "JSONModel.h"
#import "LJNewsListModel.h"

@protocol LJFavoriteDataModel<NSObject>

@end

@interface  LJFavoriteDataModel  : JSONModel

@property(nonatomic , strong , nullable) LJNewsListDataListModel * info ;
@property(nonatomic , strong , nullable) NSNumber * ctime;

- (instancetype _Nullable)initWithInfo:(LJNewsListDataListModel* _Nullable)info;

@end


@interface  LJFavoriteModel  : JSONModel

@property(nonatomic , strong , nullable) NSNumber * dErrno;
@property(nonatomic , strong , nullable) NSArray<LJFavoriteDataModel > * data;
@property(nonatomic , strong , nullable) NSNumber * time;
@property(nonatomic , copy , nullable) NSString * msg;

@end
