//
//  LJMeetUploadAudioModel.h
//  news
//
//  Created by chunhui on 15/10/15.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "JSONModel.h"

@interface  LJMeetUploadAudioDataModel  : JSONModel

@property(nonatomic , copy)   NSString * audio;

@end


@interface  LJMeetUploadAudioModel  : JSONModel

@property(nonatomic , copy)   NSString * msg;
@property(nonatomic , strong) NSNumber * dErrno;
@property(nonatomic , strong) LJMeetUploadAudioDataModel * data ;

@end

