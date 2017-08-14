//
//  LJSystemNofiticaationModel.h
//  news
//
//  Created by chunhui on 16/1/11.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "LJBaseJsonModel.h"

typedef NS_ENUM(NSInteger , LJSystemNotificationType) {
    LJSystemNotificationTypeNormal,
    LJSystemNotificationTypeComment,
    LJSystemNotificationTypePraise,
};


@protocol LJSystemNofiticationDataMsgListModel<NSObject>

@end


@interface  LJSystemNofiticationDataMsgListFromUserModel  : JSONModel

@property (nonatomic, copy , nullable) NSString *sname;
@property (nonatomic, copy , nullable) NSString *avatar;
@property (nonatomic, copy , nullable) NSString *uid;

@end


@interface  LJSystemNofiticationDataMsgListModel  : JSONModel

@property (nonatomic, copy , nullable) NSString *jump;
@property (nonatomic, copy , nullable) NSString *ctime;
@property (nonatomic, strong , nullable) NSNumber *timestamp;
@property (nonatomic, strong , nullable) NSNumber *sysMsgId;
@property (nonatomic, strong , nullable) NSNumber *isRead;
@property (nonatomic, strong , nullable) NSNumber *actionType;
@property (nonatomic, strong , nullable) LJSystemNofiticationDataMsgListFromUserModel *fromUser ;
@property (nonatomic, strong , nullable) NSNumber *tid;
@property (nonatomic, copy , nullable) NSString *actionContent;
@property (nonatomic, copy , nullable) NSString *digest;

@end


@interface  LJSystemNofiticationDataModel  : JSONModel

@property (nonatomic, strong , nullable) NSNumber *hasMore;
@property (nonatomic, strong , nullable) NSArray<LJSystemNofiticationDataMsgListModel> *msgList;
@property (nonatomic, copy , nullable) NSString *type;

@end


@interface  LJSystemNofiticationModel  : LJBaseJsonModel

@property (nonatomic, strong , nullable) LJSystemNofiticationDataModel *data ;

@end

