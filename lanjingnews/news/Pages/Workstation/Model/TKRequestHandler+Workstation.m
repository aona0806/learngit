//
//  TKRequestHandler+Workstation.m
//  news
//
//  Created by 陈龙 on 15/12/18.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "TKRequestHandler+Workstation.h"
#import "news-Swift.h"
#import "TKUploader.h"
#import "NSMutableDictionary+Util.h"
#import "NSData+ImageContentType.h"

@implementation TKRequestHandler (Workstation)

- (NSURLSessionDataTask * _Nonnull)getWorkSpaceWithComplated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJWorkStationModel * _Nullable model , NSError * _Nullable error))finish
{

    NSString *path = [NSString stringWithFormat:@"%@%@",[NetworkManager apiHost],@"/v2/workstation/get_item"];
    
    NSTimeInterval currentInterval = [[NSDate date] timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%f", currentInterval];
    NSDictionary *param = @{@"time":timeString};
    
    NSString *jsonName = [NSString stringWithCString:class_getName([LJWorkStationModel class])
                                                   encoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *sessionDataTask = [[TKRequestHandler sharedInstance] getRequestForPath:path param:param jsonName:jsonName finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask, (LJWorkStationModel *)model, error);
        }
    }];
    return sessionDataTask;
}

- (NSURLSessionDataTask * _Nonnull)getPhoneBookSearchWithType:(LJPhoneBookType)type
                                                      Keyword:(NSString * _Nullable)keyword
                                                         Page:(NSString * _Nonnull)page
                                                    withPerct:(NSString * _Nonnull)perct
                                                    complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJPhoneBookModel * _Nullable model , NSError * _Nullable error))finish
{
    NSString *methodString = @"/1/phonebook/search";
    switch (type) {
        case LJPhoneBookTypeTotal:
            methodString = @"/1/phonebook/search";
            break;
        case LJPhoneBookTypePersional:
            methodString = @"/1/phonebook/get_list_cost_buid";
            break;
        case LJPhoneBookTypeSpecialist:
            methodString = @"/1/phonebook/get_list_hot";
            break;
            
        default:
            break;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@%@",[NetworkManager apiHost],methodString];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"page":page, @"perct":perct}];
    if (keyword) {
        [param setObject:keyword forKey:@"q"];
    }
    
    NSString *jsonName = [NSString stringWithCString:class_getName([LJPhoneBookModel class])
                                            encoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *sessionDataTask = [[TKRequestHandler sharedInstance] getRequestForPath:path param:param jsonName:jsonName finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask, (LJPhoneBookModel *)model, error);
        }
    }];
    return sessionDataTask;
}

- (NSURLSessionDataTask * _Nonnull)postAddNoteInfoImageWithField:(NSData * _Nonnull)imageData
                                                    withCategory:(NSString * _Nonnull)categoty
                                                       complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJUploadImageModel * _Nullable model , NSError * _Nullable error))finish
{
    
    
    NSString *methodString = @"/1/common/upload";
    
    NSString *path = [NSString stringWithFormat:@"%@%@",[NetworkManager apiHost],methodString];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"categoty":categoty}];
    
    NSString *jsonName = [NSString stringWithCString:class_getName([LJUploadImageModel class])
                                            encoding:NSUTF8StringEncoding];

    
    NSURLSessionDataTask *sessionDataTask = [[TKRequestHandler sharedInstance] postRequestForPath:path param:param jsonName:jsonName formData:^(id<AFMultipartFormData> formData) {
        
        NSString *mimeTypeString = [NSData sd_contentTypeForImageData:imageData];
        NSString *imageTypeString = [mimeTypeString stringByReplacingOccurrencesOfString:@"image/" withString:@""];
        NSString *fileNameString = [NSString stringWithFormat:@"userfile%d.%@",(int)[[NSDate date] timeIntervalSince1970],imageTypeString];
        [formData appendPartWithFileData:imageData name:@"field" fileName:fileNameString mimeType:mimeTypeString];
    } finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        
        if (finish) {
            finish(sessionDataTask, (LJUploadImageModel *)model, error);
        }
    }];
    return sessionDataTask;
}

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
                                                 complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJBaseJsonModel * _Nullable model , NSError * _Nullable error))finish
{
    
    
    NSString *methodString = @"/1/phonebook/add";
    
    NSString *path = [NSString stringWithFormat:@"%@%@",[NetworkManager apiHost],methodString];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"name":name, @"company":company, @"job":job, @"mobile":mobile}];
    [param lj_setObject:provString forKey:@"provString"];
    [param lj_setObject:identity forKey:@"identity"];
    [param lj_setObject:industry forKey:@"industry"];
    [param lj_setObject:email forKey:@"email"];
    [param lj_setObject:remark forKey:@"remark"];
    [param lj_setObject:card_pic forKey:@"card_pic"];
    [param lj_setObject:cityString forKey:@"cityString"];
    
    NSString *jsonName = [NSString stringWithCString:class_getName([LJBaseJsonModel class])
                                            encoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *sessionDataTask = [[TKRequestHandler sharedInstance] postRequestForPath:path param:param jsonName:jsonName finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask, (LJBaseJsonModel *)model, error);
        }
    }];
    return sessionDataTask;
}

- (NSURLSessionDataTask * _Nonnull)getUserPhoneBookSearchKeyword:(NSString * _Nullable)keyword
                                                            Page:(NSString * _Nonnull)page
                                                       withCount:(NSString * _Nonnull)count
                                                       complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJUserPhoneBookModel * _Nullable model , NSError * _Nullable error))finish
{
    NSString *methodString = @"/plus/user/search";
    
    NSString *path = [NSString stringWithFormat:@"%@%@",[NetworkManager apiHost],methodString];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"page":page, @"count":count, @"order":@"0"}];
    if (keyword) {
        [param setObject:keyword forKey:@"q"];
    }
    
    NSString *jsonName = [NSString stringWithCString:class_getName([LJUserPhoneBookModel class])
                                            encoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *sessionDataTask = [[TKRequestHandler sharedInstance] getRequestForPath:path param:param jsonName:jsonName finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask, (LJUserPhoneBookModel *)model, error);
        }
    }];
    return sessionDataTask;
}

- (NSURLSessionDataTask * _Nonnull)getNoteFanKuiCommentDataWithId:(NSString * _Nonnull)dataId
                                                         withPage:(NSInteger)page
                                                        withPerct:(NSInteger)perct
                                                         withKind:(NSString * _Nullable)kind
                                                       complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJPhoneBookFeedBackModel * _Nullable model , NSError * _Nullable error))finish
{
    NSString *methodString = @"/1/feedback/get_by_phonebook_id";
    
    NSString *path = [NSString stringWithFormat:@"%@%@",[NetworkManager apiHost],methodString];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"page":[NSString stringWithFormat:@"%ld", (long)page], @"id":dataId, @"perct":[NSString stringWithFormat:@"%ld",(long)perct], @"kind":kind}];
    NSString *jsonName = [NSString stringWithCString:class_getName([LJPhoneBookFeedBackModel class])
                                            encoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *sessionDataTask = [[TKRequestHandler sharedInstance] getRequestForPath:path param:param jsonName:jsonName finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask, (LJPhoneBookFeedBackModel *)model, error);
            
        }
    }];
    return sessionDataTask;
}

- (NSURLSessionDataTask * _Nonnull)getPhoneBookDetailWithId:(NSString * _Nonnull)dataId
                                                        complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJPhoneBookDetailModel * _Nullable model , NSError * _Nullable error))finish
{
    NSString *methodString = @"/1/phonebook/get_by_id";
    
    NSString *path = [NSString stringWithFormat:@"%@%@",[NetworkManager apiHost],methodString];
    NSDictionary *param = @{@"id":dataId};
    NSString *jsonName = [NSString stringWithCString:class_getName([LJPhoneBookDetailModel class])
                                            encoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *sessionDataTask = [[TKRequestHandler sharedInstance] getRequestForPath:path param:param jsonName:jsonName finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask, (LJPhoneBookDetailModel *)model, error);
            
        }
    }];
    return sessionDataTask;
}

- (NSURLSessionDataTask * _Nonnull)getFeedbackRateWithPhoneId:(NSString * _Nonnull)phoneId
                                                     WithKind:(NSString * _Nonnull)kind
                                                    complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJPhoneBookRageModel * _Nullable model , NSError * _Nullable error))finish
{
    NSString *methodString = @"/1/feedback/rate";
    
    NSString *path = [NSString stringWithFormat:@"%@%@",[NetworkManager apiHost],methodString];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"phone_id":phoneId}];
    if (kind) {
        [param setObject:kind forKey:@"kind"];
    }
    NSString *jsonName = [NSString stringWithCString:class_getName([LJPhoneBookRageModel class])
                                            encoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *sessionDataTask = [[TKRequestHandler sharedInstance] getRequestForPath:path param:param jsonName:jsonName finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask, (LJPhoneBookRageModel *)model, error);
        }
    }];
    return sessionDataTask;
}

- (NSURLSessionDataTask * _Nonnull)getPhoneBookMobileByPhoneId:(NSString * _Nonnull)phoneId
                                                     complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJPhoneBookDetailModel * _Nullable model , NSError * _Nullable error))finish
{
    NSString *methodString = @"/1/phonebook/get_mobile_by_lanjingbi";
    
    
    NSString *path = [NSString stringWithFormat:@"%@%@",[NetworkManager apiHost],methodString];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"phone_id":phoneId}];
    NSString *jsonName = [NSString stringWithCString:class_getName([LJPhoneBookDetailModel class])
                                            encoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *sessionDataTask = [[TKRequestHandler sharedInstance] getRequestForPath:path param:param jsonName:jsonName finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask, (LJPhoneBookDetailModel *)model, error);
        }
    }];
    return sessionDataTask;
}

//| kind | 否 | int | 1-蓝鲸通讯录，2-用户联系方式 |
- (NSURLSessionDataTask * _Nonnull)postPhoneBookFeedBackAddWithPhone_id:(NSString * _Nonnull)phoneId
           withType:(NSString * _Nonnull)type
        withContact:(NSString * _Nonnull)phoneNumber
        withComment:(NSString * _Nonnull)comment
           withKind:(NSString * _Nonnull)kind
          complated:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull sessionDataTask, LJPhoneBookRageModel * _Nullable model , NSError * _Nullable error))finish;
{
    NSString *methodString = @"/1/feedback/add";
        
    NSString *path = [NSString stringWithFormat:@"%@%@",[NetworkManager apiHost],methodString];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:phoneId,@"phone_id",
                                type,@"type",
                                comment,@"comment",nil];
    
    if (phoneNumber) {
        [param setObject:phoneNumber forKey: @"contact"];
    }
    
    if (kind) {
        [param setObject:kind forKey: @"kind"];
    }
    
    NSString *jsonName = [NSString stringWithCString:class_getName([LJPhoneBookRageModel class])
                                            encoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *sessionDataTask = [[TKRequestHandler sharedInstance] postRequestForPath:path param:param jsonName:jsonName finish:^(NSURLSessionDataTask *sessionDataTask, JSONModel *model, NSError *error) {
        if (finish) {
            finish(sessionDataTask, (LJPhoneBookRageModel *)model, error);
        }
    }];
    return sessionDataTask;
}
@end
