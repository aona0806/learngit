//
//  LJUserBasicInfoModel+ModifyInfo.m
//  news
//
//  Created by chunhui on 15/12/21.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJUserInfoModel+ModifyInfo.h"
#import "news-Swift.h"


@implementation LJUserInfoModel (ModifyInfo)


-(NSDictionary*)toModifyDictionary{
    
    NSMutableDictionary *tempDictionary = [NSMutableDictionary dictionary];
    
    
    [tempDictionary setObject:self.sname forKey:@"sname"];
    [tempDictionary setObject:self.avatar forKey:@"avatar"];
    [tempDictionary setObject:[self convertSexBack:self.sex] forKey:@"sex"];
    [tempDictionary setObject:[self convertUkindVerifyBack:self.ukind] forKey:@"identity"];
    [tempDictionary setObject:self.uname forKey:@"phone"];
    [tempDictionary setObject:self.uemail forKey:@"uemail"];
    [tempDictionary setObject:self.city forKey:@"city"];
    [tempDictionary setObject:[self convertPrivacyBack:self.privacy] forKey:@"privacy"];
    [tempDictionary setObject:self.company forKey:@"company"];
    [tempDictionary setObject:self.companyJob forKey:@"company_job"];
    [tempDictionary setObject:self.companyJionTime forKey:@"join_time"];
    [tempDictionary setObject:self.intro forKey:@"intro"];
    
    NSMutableString *industryRelString = [NSMutableString new];
    
    NSArray *industryArray = [GlobalConsts Industry];
    for (LJUserInfoIndustryModel *model in self.followIndustry) {
        NSInteger index = [industryArray indexOfObject:model.title];
        if (index >= 0) {
            if (industryRelString.length == 0) {
                [industryRelString appendFormat:@"%d",(int)(index + 1)];
            } else {
                [industryRelString appendFormat:@",%d",(int)(index + 1)];
            }
        }
    }
    
    [tempDictionary setObject:industryRelString forKey:@"industry_rel"];
    
    
    return tempDictionary;
}

- (NSString *)convertSex:(NSString *)sex{
    if ([sex isEqualToString:@"0"]) {
        return @"女";
    }else if ([sex isEqualToString:@"1"]){
        return @"男";
    }else{
        return @"保密";
    }
}

- (NSString *)convertSexBack:(NSString *)sex{
    
    if ([sex isEqualToString:@"女"]) {
        return @"0";
    }else if ([sex isEqualToString:@"男"]){
        return @"1";
    }else{
        return @"2";
    }
}

- (NSString *)convertPrivacy:(NSString *)privacy{
    
    if ([privacy isEqualToString:@"1"]) {
        return @"好友可见";
    }else if ([privacy isEqualToString:@"2"]){
        return @"花费蓝鲸币";
    }else{
        return @"所有人可见";
    }
}

- (NSString *)convertPrivacyBack:(NSString *)privacy{
    
    if ([privacy isEqualToString:@"好友可见"]) {
        return @"1";
    }else if ([privacy isEqualToString:@"花费蓝鲸币"]){
        return @"2";
    }else{
        return @"0";
    }
}

- (NSString *)convertUkindVerify:(NSString *)kind{

    if ([kind isEqualToString:@"0"]) {
        return @"普通用户";
    }else if ([kind isEqualToString:@"1"]){
        return @"记者";
    }else{
        return @"专家";
    }

}

- (NSString *)convertUkindVerifyBack:(NSString *)kind{
    
    if ([kind isEqualToString:@"普通用户"]) {
        return @"0";
    }else if ([kind isEqualToString:@"记者"]){
        return @"1";
    }else if ([kind isEqualToString:@"专家"]){
        return @"2";
    }
    return kind;
}

- (NSArray *)convertIndustryToArray:(NSArray<LJUserInfoIndustryModel> *)industries{

    NSMutableArray *mutArr = [NSMutableArray array];
    for (LJUserInfoIndustryModel *model in industries) {
        if (model.title) {
            [mutArr addObject:model.title];
        }

    }
    return mutArr;
    
}

- (NSString *)convertIndustry:(NSArray<LJUserInfoIndustryModel> *)industries{

    return [[self convertIndustryToArray:industries] componentsJoinedByString:@" | "];
    
}

- (NSArray *)convertIndustryToLJUserInfoIndustryModel:(NSString *)industry{
    
    NSString *trimIndustry = [industry stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *nameArray = [trimIndustry componentsSeparatedByString:@"|"];
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *name in nameArray) {
        LJUserInfoIndustryModel *model = [[LJUserInfoIndustryModel alloc] init];
        model.title = name;
        [array addObject:model];
    }
    
    return array;
}



@end
