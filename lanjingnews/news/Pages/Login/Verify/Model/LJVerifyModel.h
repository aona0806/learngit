//
//  LJVerifyModel.h
//  news
//
//  Created by 奥那 on 2017/6/19.
//  Copyright © 2017年 lanjing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface  LJVerifyDataModel  : JSONModel

@property (nonatomic, copy , nullable) NSString *ticket;

@end


@interface  LJVerifyModel  : JSONModel

@property (nonatomic, copy , nullable) NSString *dErrno;
@property (nonatomic, strong , nullable) LJVerifyDataModel *data ;

@end
