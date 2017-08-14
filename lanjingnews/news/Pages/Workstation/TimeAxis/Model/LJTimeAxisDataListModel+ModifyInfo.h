//
//  LJTimeAxisDataListModel+ModifyInfo.h
//  news
//
//  Created by 奥那 on 15/12/25.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJTimeAxisModel.h"

@interface LJTimeAxisDataListModel (ModifyInfo)

-(NSDictionary*)toModifyDictionary;

- (NSArray *)toMidifyArrayIsSimplify:(BOOL)simplify;

- (NSString *)convertTypeBack:(NSString *)type;

- (NSString *)convertType;

- (UIColor *)getTextColorWithType;

@end
