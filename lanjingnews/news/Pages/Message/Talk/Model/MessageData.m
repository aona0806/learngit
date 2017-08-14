//
//  MessageData.m
//  news
//
//  Created by chenny on 15/5/21.
//  Copyright (c) 2015年 lanjing. All rights reserved.
//

#import "MessageData.h"

@implementation MessageData

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    if (self == nil) return nil;
    
    _nameStr = [NSString stringWithFormat:@"%@",dictionary[@"sname"]];
    _headUrl = [LJUrlHelper tryEncode:[NSString stringWithFormat:@"%@@!thumb0",dictionary[@"avatar"]]];
    _timeStr = [NSString stringWithFormat:@"%@",dictionary[@"ctime"]];
    _contentStr = [NSString stringWithFormat:@"%@",dictionary[@"content"]];
    _has_new_msg = [NSString stringWithFormat:@"%@",dictionary[@"has_new_msg"]];
    _from_uid = [NSString stringWithFormat:@"%@",dictionary[@"from_uid"]];
    _to_uid = [NSString stringWithFormat:@"%@",dictionary[@"to_uid"]];
    
    return self;
}

- (instancetype) initWithModel:(LJMessageListDataContentModel *)model
{
    if (self = [self init]) {
        self.nameStr = model.sname;
        self.headUrl = [NSURL URLWithString:model.avatar];
        self.timeStr = model.ctime;
        self.contentStr = model.content;
        self.has_new_msg = [NSString stringWithFormat:@"%@",model.hasNewMsg];
        self.from_uid = model.fromUid;
        self.to_uid = model.toUid;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    if (self = [super init]) {
        _nameStr = [coder decodeObjectForKey:@"nameStr"];
        _headUrl = [coder decodeObjectForKey:@"headUrl"];
        _timeStr = [coder decodeObjectForKey:@"timeStr"];
        _contentStr = [coder decodeObjectForKey:@"contentStr"];
        _has_new_msg = [coder decodeObjectForKey:@"has_new_msg"];
        _from_uid = [coder decodeObjectForKey:@"from_uid"];
        _to_uid = [coder decodeObjectForKey:@"to_uid"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    if (self.nameStr != nil) [coder encodeObject:self.nameStr forKey:@"nameStr"];
    if (self.headUrl != nil) [coder encodeObject:self.headUrl forKey:@"headUrl"];
    if (self.timeStr != nil) [coder encodeObject:self.timeStr forKey:@"timeStr"];
    if (self.contentStr != nil) [coder encodeObject:self.contentStr forKey:@"contentStr"];
    if (self.has_new_msg != nil) [coder encodeObject:self.has_new_msg forKey:@"has_new_msg"];
    if (self.from_uid != nil) [coder encodeObject:self.from_uid forKey:@"from_uid"];
    if (self.to_uid != nil) [coder encodeObject:self.to_uid forKey:@"to_uid"];
    
}

@end
