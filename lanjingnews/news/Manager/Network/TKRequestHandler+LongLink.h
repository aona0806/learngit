//
//  TKRequestHandler+LongLink.h
//  news
//
//  Created by chunhui on 15/12/25.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"
#import "LJConInfoModel.h"


@interface TKRequestHandler (LongLink)

/**
 *  获取长连接配置信息
 *
 *  @param cuid       用户的cuid
 *  @param completion 完成回调
 *
 *  @return 请求的实例
 */
-(NSURLSessionTask *)getLongLinkConfigWithCuid:(NSString *)cuid completion:(void (^)(LJConInfoModel *model , NSError *error) )completion;

@end
