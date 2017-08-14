//
//  LJMeetExpandProtocol.h
//  news
//
//  Created by chunhui on 15/9/30.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#ifndef LJMeetExpandProtocol_h
#define LJMeetExpandProtocol_h

typedef NS_ENUM(NSInteger , LJMeetShowDegree) {
    KMeetShowMinimum,
    kMeetShowHalf,
    kMeetShowFull,
};

@protocol  LJMeetExpandProtocol<NSObject>

-(void)expand:(UIViewController *)controller;

@end


#endif /* LJMeetExpandProtocol_h */
