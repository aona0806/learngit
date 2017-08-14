//
//  LJUserBasicInfoModel+ModifyInfo.h
//  news
//
//  Created by chunhui on 15/12/21.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJUserInfoModel.h"

@interface LJUserInfoModel (ModifyInfo)

-(NSDictionary*)toModifyDictionary;

- (NSString *)convertSex:(NSString *)sex;

- (NSString *)convertSexBack:(NSString *)sex;

- (NSString *)convertPrivacy:(NSString *)privacy;

- (NSString *)convertPrivacyBack:(NSString *)privacy;

- (NSString *)convertUkindVerify:(NSString *)kind;

- (NSString *)convertUkindVerifyBack:(NSString *)kind;

- (NSArray *)convertIndustryToArray:(NSArray<LJUserInfoIndustryModel> *)industries;

- (NSString *)convertIndustry:(NSArray<LJUserInfoIndustryModel> *)industries;

- (NSArray *)convertIndustryToLJUserInfoIndustryModel:(NSString *)industry;
@end
