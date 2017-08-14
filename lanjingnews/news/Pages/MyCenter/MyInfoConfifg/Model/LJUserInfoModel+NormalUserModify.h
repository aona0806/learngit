//
//  LJUserInfoModel+NormalUserModify.h
//  news
//
//  Created by 奥那 on 16/1/7.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "LJUserInfoModel.h"

@interface LJUserInfoModel (NormalUserModify)
//个人资料 model -> array
- (NSArray *)toNormalUserModifyArray;
//完善资料 model -> array
- (NSArray *)toCompleteUserModifyArray;
//修改个人资料
- (NSDictionary *)toNormalUserModifyDictionary;
//完善资料
- (NSDictionary *)toCompleteInfoDictionary;
//验证昵称
- (BOOL)checkNickName:(NSString *)nickName;
@end
