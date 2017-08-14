//
//  LJTimeAxisDataListModel+ModifyInfo.m
//  news
//
//  Created by 奥那 on 15/12/25.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJTimeAxisDataListModel+ModifyInfo.h"
#import "TKCommonTools.h"

@implementation LJTimeAxisDataListModel (ModifyInfo)
-(NSDictionary*)toModifyDictionary{
    
    NSMutableDictionary *tempDictionary = [NSMutableDictionary dictionary];
    
    [tempDictionary setObject:self.type forKey:@"type"];
    [tempDictionary setObject:self.title forKey:@"title"];
    NSString *sponsor = @"";
    if (self.type.integerValue == 2) {
        sponsor = self.sponsor;
    }
    [tempDictionary setObject:sponsor forKey:@"sponsor"];
    [tempDictionary setObject:self.address forKey:@"address"];
    [tempDictionary setObject:self.timeShow forKey:@"time_show"];
    if (self.timeEnd) {
        [tempDictionary setObject:self.timeEnd forKey:@"time_end"];
    }
    [tempDictionary setObject:self.content forKey:@"content"];
    
    return tempDictionary;
}

- (NSArray *)toMidifyArrayIsSimplify:(BOOL)simplify{
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithObjects:self.title,self.address,[self convertTimeStampToDateString:self.timeShow], [self convertTimeStampToDateString:self.timeEnd],self.content, nil];
    NSString *type = @"";
    if (simplify) {
        type = [self convertTypeToSimplify];
    }else{
        type = [self convertType];
    }
    [tempArray insertObject:type atIndex:1];
    if (self.type.integerValue == 2) {
        if (!self.sponsor) {
            self.sponsor = @"";
        }
        [tempArray addObject:self.sponsor];
    }
    
    return tempArray;
}

- (NSString *)convertTypeBack:(NSString *)type{
    if ([type isEqualToString:@"个人专用（此类目仅本人可见）"]) {
        return @"0";
    }else if ([type isEqualToString:@"重要节点"]){
        return @"1";
    }
    return @"2";
}

/**
 *  type转为中文有俩种形式
 *
 */
- (NSString *)convertTypeToSimplify{
    if ([self.type isEqualToString:@"0"]) {
        return @"个人日程";
    }else if ([self.type isEqualToString:@"1"]){
        return @"重要节点";
    }
    return @"发布会";
}

- (NSString *)convertType{
    if ([self.type isEqualToString:@"0"]) {
        return @"个人专用（此类目仅本人可见）";
    }else if ([self.type isEqualToString:@"1"]){
        return @"重要节点";
    }
    return @"发布会";
}

- (NSString *)convertTimeStampToDateString:(NSString *)timeString{
    NSString *rtnString = @"";
    if (timeString && timeString.length > 0 && ![timeString isEqualToString:@"0"]) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeString.integerValue];
        
        NSString *dateString = [TKCommonTools dateStringWithFormat:TKDateFormatChineseYMD date:date];
        NSString *weekString = [TKCommonTools weekOfDate:date];
        NSString *hourString = [TKCommonTools dateStringWithFormat:TKDateFormatHHMM date:date];
        rtnString = [NSString stringWithFormat:@"%@ %@  %@",dateString,weekString,hourString];
    }
    return rtnString;
}

- (UIColor *)getTextColorWithType{
    
    UIColor *redC = RGBACOLOR(242, 99, 115, 1);
    UIColor *blueC = RGBACOLOR(5, 146, 254, 1);
    UIColor *origenC = RGBACOLOR(249, 163, 127, 1);
    NSArray *colorArray = [NSArray arrayWithObjects:redC,blueC,origenC, nil];
    
    return colorArray[self.type.integerValue];
}

@end
