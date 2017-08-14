//
//  TKRequestHandler+NewsSorted.m
//  news
//
//  Created by 奥那 on 2017/5/10.
//  Copyright © 2017年 lanjing. All rights reserved.
//

#import "TKRequestHandler+NewsSorted.h"
#import "news-Swift.h"

@implementation TKRequestHandler (NewsSorted)

- (NSURLSessionDataTask *)getNewsSortedListFinish:(void (^ )(NSURLSessionDataTask * sessionDataTask, id response, NSError *error))finish{
    NSString *path = [NSString stringWithFormat:@"%@/v1/label/get",[NetworkManager apiHost]];
    return [[TKRequestHandler sharedInstance] getRequestForPath:path param:nil jsonName:@"LJNewsSortModel" finish:^(NSURLSessionDataTask * _Nonnull sessionDataTask, JSONModel * _Nullable model, NSError * _Nullable error) {
        if (finish) {
            finish(sessionDataTask,(LJNewsSortModel *)model,error);
        }
    }];
}


- (NSURLSessionDataTask *)syncNewsSortedWithContent:(NSMutableArray *)content complated:(void (^ )(NSURLSessionDataTask * sessionDataTask, NSError *error))finish{
    NSString *path = [NSString stringWithFormat:@"%@/v1/label/set",[NetworkManager apiHost]];
    NSData *data = [NSJSONSerialization dataWithJSONObject:content options:0 error:NULL];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    NSDictionary *param = @{@"content":string};
    
    return [[TKRequestHandler sharedInstance] getRequestForPath:path param:param finish:^(NSURLSessionDataTask *sessionDataTask, id response, NSError *error) {
        if (finish) {
            finish(sessionDataTask,error);
        }
    }];
}
@end
