//
//  TKRequestHandler+NewsRollList.m
//  news
//
//  Created by 奥那 on 2017/1/3.
//  Copyright © 2017年 lanjing. All rights reserved.
//

#import "TKRequestHandler+NewsRollList.h"
#import "news-Swift.h"

@implementation TKRequestHandler (NewsRollList)
- (NSURLSessionDataTask *)getNewsRollListWith:(NSString *)type lastTime:(NSString *)lastCtime refreshType:(TKDataFreshType)refreshType complated:(void (^ )(NSURLSessionDataTask * sessionDataTask, LJNewsRollListModel *model , NSError *error))finish{
    
    NSString *path = [NSString stringWithFormat:@"%@/v1/roll/get_list",[NetworkManager apiHost]];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"type":type, @"last_time":lastCtime, @"rn":@"20"}];
    NSString *refreshTypeString = (refreshType == TKDataFreshTypeRefresh ? @"0" : @"1");
    [param setObject:refreshTypeString forKey:@"refresh_type"];
    
    return [[TKRequestHandler sharedInstance] getRequestForPath:path param:param jsonName:@"LJNewsRollListModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {

            finish(sessionDataTask, (LJNewsRollListModel *)model, error);
        }
    }];
}
@end
