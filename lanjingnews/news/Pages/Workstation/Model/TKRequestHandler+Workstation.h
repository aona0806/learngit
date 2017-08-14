//
//  TKRequestHandler+Workstation.h
//  news
//
//  Created by 陈龙 on 15/12/18.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler.h"
#import "LJWorkStationModel.h"
#import "LJPhoneBookModel.h"
#import "LJUploadImageModel.h"
#import "LJUserPhoneBookModel.h"
#import "LJPhoneBookFeedBackModel.h"
#import "LJPhoneBookDetailModel.h"
#import "LJPhoneBookRageModel.h"

@interface TKRequestHandler (Workstation)

typedef NS_ENUM(NSInteger, LJPhoneBookType) {
    LJPhoneBookTypeTotal,//默认从0开始
    LJPhoneBookTypePersional,
    LJPhoneBookTypeSpecialist,//专家
};

/**
 *  1.0 获取工作站目录数据
 *
 *  @param finish <#finish description#>
 *
 *  @return <#return value description#>
 */
- (NSURLSessionDataTask * _Nonnull)getWorkSpaceWithComplated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJWorkStationModel * _Nullable model , NSError * _Nullable error))finish;

/**
 *  1.1 采访数据库搜索接口
 *
 *  @param type    LJPhoneBookTypeTotal: 全部数据 LJPhoneBookTypePersional： 个人数据
 *  @param keyword keyword description
 *  @param page    <#page description#>
 *  @param perct   <#perct description#>
 *  @param finish  <#finish description#>
 *
 *  @return <#return value description#>
 */
- (NSURLSessionDataTask * _Nonnull)getPhoneBookSearchWithType:(LJPhoneBookType)type
                                                      Keyword:(NSString * _Nullable)keyword
                                                         Page:(NSString * _Nonnull)page
                                                    withPerct:(NSString * _Nonnull)perct
                                                    complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJPhoneBookModel * _Nullable model , NSError * _Nullable error))finish;

/**
 *  1.2 采访通讯录添加头像
 *
 *  @param imageData <#imageData description#>
 *  @param categoty  <#categoty description#>
 *  @param finish    <#finish description#>
 *
 *  @return <#return value description#>
 */
- (NSURLSessionDataTask * _Nonnull)postAddNoteInfoImageWithField:(NSData * _Nonnull)imageData
                                                    withCategory:(NSString * _Nonnull)categoty
                                                       complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJUploadImageModel * _Nullable model , NSError * _Nullable error))finish;

/**
 *  1.3 添加采访通讯录
 *
 *  @param name       require
 *  @param company    require
 *  @param job        require
 *  @param mobile     require
 *  @param provString option
 *  @param identity   option
 *  @param industry   option
 *  @param email      option
 *  @param remark     option
 *  @param card_pic   option
 *  @param cityString option
 *  @param finish     <#finish description#>
 *
 *  @return <#return value description#>
 */
- (NSURLSessionDataTask * _Nonnull)postAddNoteInfoWithName:(NSString * _Nonnull)name
                                                   company:(NSString * _Nonnull)company
                                                       job:(NSString * _Nonnull)job
                                                    mobile:(NSString * _Nonnull)mobile
                                                provString:(NSString * _Nullable)provString
                                                  identity:(NSString * _Nullable)identity
                                                  industry:(NSString * _Nullable)industry
                                                     email:(NSString * _Nullable)email
                                                    remark:(NSString * _Nullable)remark
                                               card_picUrl:(NSString * _Nullable)card_pic
                                                cityString:(NSString * _Nullable)cityString
                                                 complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJBaseJsonModel * _Nullable model , NSError * _Nullable error))finish;

/**
 *  1.4 用户通讯录数据
 *
 *  @param keyword <#keyword description#>
 *  @param page    <#page description#>
 *  @param count   <#count description#>
 *  @param finish  <#finish description#>
 *
 *  @return <#return value description#>
 */
- (NSURLSessionDataTask * _Nonnull)getUserPhoneBookSearchKeyword:(NSString * _Nullable)keyword
                                                            Page:(NSString * _Nonnull)page
                                                       withCount:(NSString * _Nonnull)count
                                                       complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJUserPhoneBookModel * _Nullable model , NSError * _Nullable error))finish;

/**
 * 1.5 通讯录获取反馈评论信息
 *
 *  @param dataId 通讯录id
 *  @param page   <#page description#>
 *  @param perct  <#perct description#>
 *  @param kind   <#kind description#>
 *  @param finish <#finish description#>
 *
 *  @return <#return value description#>
 */
- (NSURLSessionDataTask * _Nonnull)getNoteFanKuiCommentDataWithId:(NSString * _Nonnull)dataId
                                                         withPage:(NSInteger)page
                                                        withPerct:(NSInteger)perct
                                                         withKind:(NSString * _Nullable)kind
                                                        complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJPhoneBookFeedBackModel * _Nullable model , NSError * _Nullable error))finish;

/**
 *  1.6 通讯录详情接口
 *
 *  @param dataId 通讯录id
 *  @param finish <#finish description#>
 *
 *  @return <#return value description#>
 */
- (NSURLSessionDataTask * _Nonnull)getPhoneBookDetailWithId:(NSString * _Nonnull)dataId
                                                  complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJPhoneBookDetailModel * _Nullable model , NSError * _Nullable error))finish;

/**
 *  1.7 获取电话采访成功率
 *
 *  @param phoneId <#phoneId description#>
 *  @param kind    | kind | 否 | int | 1-蓝鲸通讯录，2-用户联系方式 |
 *  @param finish  <#finish description#>
 *
 *  @return <#return value description#>
 */
- (NSURLSessionDataTask * _Nonnull)getFeedbackRateWithPhoneId:(NSString * _Nonnull)phoneId
                                                     WithKind:(NSString * _Nonnull)kind
                                                    complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJPhoneBookRageModel * _Nullable model , NSError * _Nullable error))finish;

/**
 *  1.8 消耗蓝鲸比获取用户手机号码
 *
 *  @param phoneId <#phoneId description#>
 *  @param finish  <#finish description#>
 *
 *  @return <#return value description#>
 */
- (NSURLSessionDataTask * _Nonnull)getPhoneBookMobileByPhoneId:(NSString * _Nonnull)phoneId
                                                     complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJPhoneBookDetailModel * _Nullable model , NSError * _Nullable error))finish;

/**
 *  1.9 添加采访反馈数据
 *
 *  @param phoneId     <#phoneId description#>
 *  @param type        <#type description#>
 *  @param phoneNumber <#phoneNumber description#>
 *  @param comment     comment description
 *  @param kind        | kind | 否 | int | 1-蓝鲸通讯录，2-用户联系方式 |
 *  @param finish      <#finish description#>
 *
 *  @return <#return value description#>
 */
- (NSURLSessionDataTask * _Nonnull)postPhoneBookFeedBackAddWithPhone_id:(NSString * _Nonnull)phoneId
                                                               withType:(NSString * _Nonnull)type
                                                            withContact:(NSString * _Nonnull)phoneNumber
                                                            withComment:(NSString * _Nonnull)comment
                                                               withKind:(NSString * _Nonnull)kind
                                                              complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJPhoneBookRageModel * _Nullable model , NSError * _Nullable error))finish;

@end
