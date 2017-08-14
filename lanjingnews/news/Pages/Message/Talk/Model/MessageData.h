//
//  MessageData.h
//  news
//
//  Created by chenny on 15/5/21.
//  Copyright (c) 2015年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJMessageListModel.h"

/**
 *  该model使用是为了保证旧版本数据存储不会丢失
 */
@interface MessageData : NSObject <NSCoding>

@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSURL *headUrl;
@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, strong) NSString *contentStr;
@property (nonatomic, strong) NSString *has_new_msg;
@property (nonatomic, strong) NSString *from_uid;
@property (nonatomic, strong) NSString *to_uid;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype) initWithModel:(LJMessageListDataContentModel *)model;

@end
