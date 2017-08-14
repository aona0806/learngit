//
//  NewsActivityDetailModel.h
//  news
//
//  Created by 陈龙 on 16/1/9.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "LJBaseJsonModel.h"

/**
 * id	int	专题编号
 * title	string	新闻标题
 * template_type	string	模板类型
 * thumb	string	缩略图
 * content	string	活动详情
 * desc	string	活动说明
 * remark	string	报名说明
 * share_url	string	分享地址
 * author_info	string	作者信息
 * fav_status	int	是否收藏
 * fav_type	int	收藏类型
 * fav_time	int	收藏时间
 * time_start	int	活动开始时间
 * ctime	int	发布时间
 */
@interface  NewsActivityDetailDataModel  : JSONModel

@property (nonatomic, copy , nullable) NSString *content;
@property (nonatomic, copy , nullable) NSString *remark;
@property (nonatomic, copy , nullable) NSString *timeStart;
@property (nonatomic, copy , nullable) NSString *thumb;
@property (nonatomic, copy , nullable) NSString *ctime;
@property (nonatomic, copy , nullable) NSString *title;
@property (nonatomic, copy , nullable) NSString *favType;
@property (nonatomic, copy , nullable) NSString *author;
@property (nonatomic, copy , nullable) NSString *favTime;
@property (nonatomic, copy , nullable) NSString *shareUrl;
@property (nonatomic, copy , nullable) NSString *inList;
@property (nonatomic, copy , nullable) NSString *templateType;
@property (nonatomic, copy , nullable) NSString *favStatus;
@property (nonatomic, copy , nullable) NSString *sponsor;
@property (nonatomic, copy , nullable) NSString *id;
@property (nonatomic, copy , nullable) NSString *desc;
@property(nonatomic , copy , nullable) NSString * authorInfo;

@end

@interface  NewsActivityDetailModel  : LJBaseJsonModel

@property(nonatomic , strong , nullable) NewsActivityDetailDataModel * data ;

@end

