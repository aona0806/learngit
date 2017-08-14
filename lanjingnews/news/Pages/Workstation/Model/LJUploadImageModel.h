//
//  LJUploadImageModel.h
//  news
//
//  Created by 陈龙 on 15/12/21.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJBaseJsonModel.h"

@interface  LJUploadImageDataModel  : JSONModel

@property(nonatomic , copy)   NSString *pic;

@end

@interface LJUploadImageModel : LJBaseJsonModel

@property(nonatomic , copy) LJUploadImageDataModel *data;

@end
