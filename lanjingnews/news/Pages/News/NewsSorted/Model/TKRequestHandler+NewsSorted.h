//
//  TKRequestHandler+NewsSorted.h
//  news
//
//  Created by 奥那 on 2017/5/10.
//  Copyright © 2017年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"
#import "LJNewsSortModel.h"

@interface TKRequestHandler (NewsSorted)

- (NSURLSessionDataTask *)syncNewsSortedWithContent:(NSMutableArray *)content complated:(void (^ )(NSURLSessionDataTask * sessionDataTask, NSError *error))finish;

- (NSURLSessionDataTask *)getNewsSortedListFinish:(void (^)(NSURLSessionDataTask *sessionDataTask,id response,NSError *error))finish;

@end
