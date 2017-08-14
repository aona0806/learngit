//
//  TKRequestHandler+Ad.m
//  news
//
//  Created by chunhui on 16/3/15.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "TKRequestHandler+Ad.h"
#import "news-Swift.h"


@implementation TKRequestHandler (Ad)

-(NSURLSessionDataTask *)getAdPos:(LJAdPostion)postion count:(NSInteger)count completion:(void(^)(NSURLSessionDataTask *task , LJAdModel *model , NSError * error))completion
{
    NSString *path = [NSString stringWithFormat:@"%@/1/ad/get",[NetworkManager apiHost]];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    param[@"pos"] = [NSString stringWithFormat:@"%d",(int)postion];
    param[@"perct"] = [NSString stringWithFormat:@"%d",(int)count];
    NSString *screensize = [NSString stringWithFormat:@"%d_%d", (int)SCREEN_WIDTH, (int)SCREEN_HEIGHT];
    param[@"screensize"] = screensize;
    
    return [[TKRequestHandler sharedInstance] getRequestForPath:path param:param jsonName:@"LJAdModel" finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        
        if (completion) {
            completion(sessionDataTask, (LJAdModel *)model,error);
        }
    }];
}

@end
