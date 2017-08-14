//
//  LJPushInfoModel+ModifyInfo.m
//  news
//
//  Created by 奥那 on 15/12/28.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJPushInfoModel+ModifyInfo.h"

@implementation LJPushInfoDataConfigModel (ModifyInfo)
- (NSString *)toMidifyString{
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    
    [tempDic setObject:self.commentNotify?:@"1" forKey:@"comment_notify"];
    [tempDic setObject:self.zanNotify?:@"1" forKey:@"zan_notify"];
    [tempDic setObject:self.pmsgNotify?:@"1" forKey:@"pmsg_notify"];
    [tempDic setObject:self.friendNotify?:@"1" forKey:@"friend_notify"];
    [tempDic setObject:self.meetNotify?:@"1" forKey:@"meet_notify"];
        
    [tempDic setObject:self.newsNotify?:@"1" forKey:@"news_notify"];
    
    NSMutableDictionary *telegraph = [NSMutableDictionary dictionary];
    for (LJPushInfoDataConfigTelegraphModel *teleModel in self.telegraph) {
        if (teleModel.id) {
            [telegraph setObject:teleModel.status forKey:teleModel.id];
        }

    }
    [tempDic setObject:telegraph forKey:@"telegraph"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:tempDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    
    return string;
}


@end
