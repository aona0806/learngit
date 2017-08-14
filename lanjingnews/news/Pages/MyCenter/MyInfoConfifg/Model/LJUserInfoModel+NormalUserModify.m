//
//  LJUserInfoModel+NormalUserModify.m
//  news
//
//  Created by 奥那 on 16/1/7.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "LJUserInfoModel+NormalUserModify.h"
#import "LJUserInfoModel+ModifyInfo.h"
#import "news-Swift.h"

@implementation LJUserInfoModel (NormalUserModify)
//个人资料 model -> array
- (NSArray *)toNormalUserModifyArray{
    
    self.sex = [self convertSex:self.sex];
    
    if (self.uemail.length == 0) {
        self.uemail = @"";
    }
    if (self.city.length == 0) {
        self.city = @"";
    }
    self.uname = [self.uname stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    
    NSArray *temp = @[self.nickname,self.sex,self.uemail,self.city,self.uname];
    
    return temp;
}

//完善资料 model -> array
- (NSArray *)toCompleteUserModifyArray{
    if (self.sname == nil) {
        return  nil;
    }
    NSMutableArray *nameList = [NSMutableArray array];
    for (LJUserInfoIndustryModel *model in self.followIndustry) {
        [nameList addObject:model.title];
    }
    NSString *industry = [nameList componentsJoinedByString:@" | "];
    NSArray *temp = @[self.sname,[self convertUkindVerify:self.ukind],self.city,industry,self.company,self.companyJob,self.companyJionTime];
    return  temp;
}

//修改个人资料
- (NSDictionary *)toNormalUserModifyDictionary{
    
    NSMutableDictionary *tempDictionary = [NSMutableDictionary dictionary];
    
    [tempDictionary setObject:self.nickname forKey:@"nickname"];
    [tempDictionary setObject:[self convertSexBack:self.sex] forKey:@"sex"];
    [tempDictionary setObject:self.uemail forKey:@"uemail"];
    [tempDictionary setObject:self.city forKey:@"city"];
    
    return tempDictionary;
}

//完善资料
- (NSDictionary *)toCompleteInfoDictionary{
    
    NSMutableDictionary *tempDictionary = [NSMutableDictionary dictionary];

    [tempDictionary setObject:self.sname forKey:@"sname"];
    [tempDictionary setObject:self.avatar forKey:@"avatar"];
    [tempDictionary setObject:[self convertUkindVerifyBack:self.ukind] forKey:@"ukind"];
    [tempDictionary setObject:self.city forKey:@"city"];
    [tempDictionary setObject:self.company forKey:@"company"];
    [tempDictionary setObject:self.companyJob forKey:@"company_job"];
    [tempDictionary setObject:self.companyJionTime forKey:@"company_jion_time"];
    
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
    [tempDictionary setObject:industryRelString forKey:@"industry"];
    
    return tempDictionary;
}

//验证昵称
- (BOOL)checkNickName:(NSString *)nickName{
    
    NSString *regex = @"[A-Za-z0-9_\\u4e00-\\u9fa5]{2,16}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([pred evaluateWithObject:nickName]) {
        return YES;
    }else{
        return NO;
    }
}
@end
