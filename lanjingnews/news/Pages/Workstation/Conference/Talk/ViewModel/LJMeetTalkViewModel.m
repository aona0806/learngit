//
//  LJMeetTalkViewModel.m
//  news
//
//  Created by chunhui on 15/10/20.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJMeetTalkViewModel.h"
#import "TKRequestHandler+MeetTalk.h"

@implementation LJMeetTalkViewModel

+(void)enterMeetWithMid:(NSString *)meetid completion:(void (^)(bool ok ,NSString *errMsg , LJMeetJoinMeetInfoModel *userinfo))completion
{

    NSURLSessionTask *request = [[TKRequestHandler sharedInstance]meetJoinMeetWithMeetId:meetid finish:^(NSURLSessionTask *task, LJMeetJoinMeetInfoModel *model, NSError *error) {
        BOOL OK = NO;
        NSString *errMsg = error.domain;
        if (error) {
            errMsg = @"网络连接失败，请检查网络";
            if (completion) {
                completion(OK,errMsg,model);
            }

        } else {
            OK = YES;

            if (completion) {
                completion(OK,errMsg,model);
            }
        }
//        if (model) {
//            OK = YES;
//        } else if (error && errMsg.length == 0){
//            errMsg = @"网络连接失败，请检查网络";
//        } else if (model.dErrno != 0) {
//            errMsg = model.msg;
//        }
//        if (completion) {
//            completion(OK,errMsg,model);
//        }
    }];
    
    if (request == nil &&completion) {
        completion(NO,nil,nil);
    }
}

+(void)quitMeetWithMeetId:(NSString *)meetid completion:(void (^)(bool ok))completion
{
    [[TKRequestHandler sharedInstance]meetQuitMeetWithMeetId:meetid completion:^(NSError *error) {        
        if (completion) {
            completion(error == nil);
        }
    }];
}


-(void)enterMeet:(void (^)(bool ok ,NSString *errMsg , LJMeetJoinMeetInfoModel *userinfo))completion
{
    [LJMeetTalkViewModel enterMeetWithMid:_meetUserInfo.meetId completion:^(bool ok,NSString *errMsg , LJMeetJoinMeetInfoModel *userinfo) {
        if (userinfo) {
            self.meetUserInfo.meetInfo = userinfo.data.user;
        }
        if (completion) {
            completion(ok,errMsg,userinfo);
        }
    }];
}

-(void)quitMeet:(void (^)(bool ok))completion
{
    [LJMeetTalkViewModel quitMeetWithMeetId:_meetUserInfo.meetInfo.meetingId completion:^(bool ok) {
        if (completion) {
            completion(ok);
        }
    }];
}


@end
