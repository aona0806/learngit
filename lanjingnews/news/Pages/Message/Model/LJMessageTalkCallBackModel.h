//
//  LJMessageTalkCallBackModel.h
//  news
//
//  Created by 陈龙 on 15/12/10.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "JSONModel.h"

@interface  LJMessageTalkCallBackDataModel  : JSONModel

@property(nonatomic , copy)   NSString * content;
@property(nonatomic , copy)   NSString * mid;

@end


@interface  LJMessageTalkCallBackModel  : JSONModel

@property(nonatomic , strong) LJMessageTalkCallBackDataModel * data ;
@property(nonatomic , strong) NSNumber * dErrno;

@end
