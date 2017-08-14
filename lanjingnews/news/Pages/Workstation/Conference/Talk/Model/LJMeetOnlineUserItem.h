//
//  LJMeetOnlineItem.h
//  news
//
//  Created by chunhui on 15/10/10.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJMeetOnlineListModel.h"

@interface LJMeetOnlineUserItem : NSObject

@property(nonatomic , strong) LJMeetOnlineListDataDataModel *model;
@property(nonatomic , assign) BOOL showDetail;
@property(nonatomic , assign) BOOL canShowDetail;

@end
