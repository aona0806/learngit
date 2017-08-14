//
//  TKRequestHandler+HotEventDetail.m
//  news
//
//  Created by 陈龙 on 16/6/3.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "TKRequestHandler+HotEventDetail.h"
#import "news-Swift.h"

@implementation TKRequestHandler (HotEventDetail)

-(NSURLSessionDataTask * _Nonnull)getHotEventDetailWithId:(NSString * _Nonnull)idString finish:(void (^ _Nonnull)(NSURLSessionDataTask * _Nonnull sessionDataTask, HotEventDetailModel * _Nullable model , NSError * _Nullable error))finish
{
    
    NSString *path = [NSString stringWithFormat:@"%@/v2/event/get_info",[NetworkManager apiHost]];
    NSDictionary *param = @{@"id":idString};
    
    return [self getRequestForPath:path param:param jsonName:@"HotEventDetailModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish){
            finish(sessionDataTask, (HotEventDetailModel *)model, error);
        }
    }];
}

@end
