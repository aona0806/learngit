//
//  LJUserDeltailViewController.h
//  news
//
//  Created by 陈龙 on 15/12/11.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LJUserDeltailViewControllerDelegate <NSObject>

-(void)userTelTableViewControllerWithRelationType:(NSString * _Nonnull)typeString;

@end

@interface LJUserDeltailViewController : UIViewController

@property (nonatomic, weak, nullable) id <LJUserDeltailViewControllerDelegate> delegate;

@property (nonatomic, strong, nullable) NSString *noteId;

@property (nonatomic, assign) BOOL isGetMobile;

@end
