//
//  LJNewsSortModel.h
//  news
//
//  Created by 奥那 on 2017/5/10.
//  Copyright © 2017年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJConfigModel.h"


@interface  LJNewsSortModel  : JSONModel

@property (nonatomic, copy , nullable) NSString *dErrno;
@property (nonatomic, strong , nullable) NSArray<LJConfigDataNewsModel> *data;
@property (nonatomic, copy , nullable) NSString *time;

@end
