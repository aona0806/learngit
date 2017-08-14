//
//  TKRequestHandler+Ad.h
//  news
//
//  Created by chunhui on 16/3/15.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"
#import "LJAdModel.h"


typedef NS_ENUM(NSInteger , LJAdPostion) {
    LJAdPostionHotNewsBanner = 1 , //推荐banner
    LJAdPostionSplash = 2, //闪屏
    LJAdPostionNewsBanner = 4, //新闻top轮播
};

@interface TKRequestHandler (Ad)
/**
 *  拉取广告
 *
 *  @param postion    拉取广告的页面
 *  @param count      广告数目
 *
 */
-(NSURLSessionDataTask *)getAdPos:(LJAdPostion)postion count:(NSInteger)count completion:(void(^)(NSURLSessionDataTask *task , LJAdModel *model , NSError * error))completion;

@end
