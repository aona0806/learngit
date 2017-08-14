//
//  LJProvinceSelectedTableViewController.m
//  news
//
//  Created by 陈龙 on 16/1/1.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "LJProvinceSelectedTableViewController.h"

@interface LJProvinceSelectedTableViewController ()<UITableViewDataSource, UITableViewDelegate> {
    
    void (^block)(NSString *);
}
@property (nonatomic, nonnull, strong) NSArray *dataArray;

@end

@implementation LJProvinceSelectedTableViewController

#pragma mark - LifeCycle

- (instancetype) initWithSelectedBlock:(void(^)(NSString *province)) selectedBlock{
    self = [self init];
    if (self) {
        block = selectedBlock;
    }
    return self;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        NSString *citysFileName = [bundlePath stringByAppendingPathComponent: @"district.json"];
        NSData *citysData = [NSData dataWithContentsOfFile:citysFileName];
        
        NSError *error;
        self.dataArray = [NSJSONSerialization JSONObjectWithData:citysData options:kNilOptions error:&error];
    }
    return self;
}

- (void) loadView {
    [super loadView];
    
    self.title = @"省份";
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger count = self.dataArray.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
    }
    
    NSDictionary *proDic = self.dataArray[indexPath.row];
    NSArray *pirArray = proDic.allKeys;
    cell.textLabel.text = pirArray[0];
    cell.textLabel.textColor = RGBACOLOR(112, 112, 112, 1);
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *proDic = self.dataArray[indexPath.row];
    NSArray *pirArray = proDic.allKeys;
    NSString *provinceString = pirArray[0];
    if (block) {
        block(provinceString);
    }
}

@end
