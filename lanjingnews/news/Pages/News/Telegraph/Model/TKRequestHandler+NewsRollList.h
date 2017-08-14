//
//  TKRequestHandler+NewsRollList.h
//  news
//
//  Created by 奥那 on 2017/1/3.
//  Copyright © 2017年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"
#import "LJNewsRollListModel.h"

@interface TKRequestHandler (NewsRollList)

- (NSURLSessionDataTask *)getNewsRollListWith:(NSString *)type lastTime:(NSString *)lastCtime refreshType:(TKDataFreshType)refreshType complated:(void (^ )(NSURLSessionDataTask * sessionDataTask, LJNewsRollListModel *model , NSError *error))finish;

@end
