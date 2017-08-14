//
//  ConferenceTableViewCell.h
//  news
//
//  Created by 陈龙 on 15/9/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJMeetListModel.h"
#import "LJReservationMeetListModel.h"
#import "LJHistoryMeetListModel.h"

typedef NS_ENUM(NSUInteger, ConferenceTableViewCellType) {
    ConferenceForthcomingType,
    ConferenceOnlineType,
    ConferenceCloseType
};

@protocol LJConferenceTableViewCellDelegate <NSObject>

@required
- (void)share:(JSONModel *_Nonnull)obj;

@optional
- (void)joinAppointment:(JSONModel * _Nonnull)model;
- (void)cancelAppointment:(JSONModel * _Nonnull)model;
- (void)enterConference:(JSONModel * _Nonnull)model;

@end

@interface LJConferenceTableViewCell : UITableViewCell

@property(nonatomic, weak, nullable)   id<LJConferenceTableViewCellDelegate> delegate;

+ (NSString * _Nonnull)reuseIdentifier;
+ (CGFloat)heightForCellWithData:(JSONModel * _Nonnull)model;

/**
 *  更新会议列表数据
 *
 *  @param model model description
 */
- (void)updateCellWithData:(LJMeetListDataModel * _Nonnull)model;
@end
