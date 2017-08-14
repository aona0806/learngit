//
//  AddEventTableViewController.m
//  news
//
//  Created by 奥那 on 15/12/22.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJAddEventTableViewController.h"
#import "news-Swift.h"
#import "LJEventStyleViewController.h"
#import "LJTimeAxisModel.h"
#import "CommonMacro.h"

@interface LJAddEventTableViewController ()<UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong)NSArray *titleList;
//@property (nonatomic, copy)NSString *typeString;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, strong)UIDatePicker *datePicker;
@property (nonatomic, strong)UITextField *titleTextField;
@property (nonatomic, strong)UITextField *typeTextField;
@property (nonatomic, strong)UITextField *positionTextField;
@property (nonatomic, strong)UITextField *startdateTextField;
@property (nonatomic, strong)UITextField *endDateTextField;
@property (nonatomic, strong)UITextView *detailTextView;
@property (nonatomic, strong)UITextView *sponsorTextView;

@end

@implementation LJAddEventTableViewController

#define TextFieldBaseTag 1000

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [self getTitle];
    [self setupData];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self customNavigationItem];
    
    [self registerCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)getTitle{
    
    if (self.isEdit) {
        return @"";
    }
    return @"添加";
}

- (void)customNavigationItem{
    
    UIImage *image = [UIImage imageNamed:@"workstation_newOK"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem* refesh_btn = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(saveAction:)];
    self.navigationItem.rightBarButtonItem = refesh_btn;
}

/**
 *  保存
*/
- (void)saveAction:(UIButton *)sender{
    
    NSString * str = [self isOk];
    if (str != nil) {
        [self showToastHidenDefault:str isInWindow:YES];
        return;
    }
    
    if (_isEdit) {
        [self editEvent];
    }else{
        [self addNewEvent];
    }
}

/**
 *  添加事件接口
 */
- (void)addNewEvent{
    __weak typeof(self) weakSelf = self;
    [[TKRequestHandler sharedInstance] AddTimeAxisEventsWithModel:_model finish:^(NSURLSessionDataTask * _Nonnull sessionDataTask, id  _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            [weakSelf showToastHidenDefault:error.domain isInWindow:YES];

        }else{
            NSString *errnoStr = [NSString stringWithFormat:@"%@",response[@"errno"]];
            if (errnoStr.integerValue == 0) {
                if (weakSelf.addEvent) {
                    weakSelf.addEvent(weakSelf.model);
                }
            } else {
                NSString *msg = [(NSDictionary *)response objectForKey:@"msg"];
                [weakSelf showToastHidenDefault:msg isInWindow:YES];

            }
        }
    }];

}

/**
 *  编辑事件接口
 */
- (void)editEvent{
    __weak typeof(self) weakSelf = self;
    [[TKRequestHandler sharedInstance] editTimeAxisEventsWithModel:_model eventId:_model.id finish:^(NSURLSessionDataTask * _Nonnull sessionDataTask, id  _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            [weakSelf showToastHidenDefault:error.domain isInWindow:YES];

        }else{
            NSString *errnoStr = [NSString stringWithFormat:@"%@",response[@"errno"]];
            if (errnoStr.integerValue == 0) {
                if (weakSelf.addEvent) {
                    @try {
                        weakSelf.model.id = response[@"data"][@"id"];
                    } @catch (NSException *exception) {
                        weakSelf.model.id = nil;
                    } @finally {
                    }
                    weakSelf.addEvent(weakSelf.model);
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:[GlobalConsts Notification_TimeAxisEditEvent] object:nil];
            }else{
                [weakSelf showToastHidenDefault:response[@"msg"] isInWindow:YES];
            }
        }
    }];

}

- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MyInfoConfigCell" bundle:nil] forCellReuseIdentifier:@"MyInfoConfig"];
    [self.tableView registerNib:[UINib nibWithNibName:@"IntroduceMyselfCell" bundle:nil] forCellReuseIdentifier:@"introduceCell"];
}

- (void)setupData{
    self.titleList = @[@"标题:",@"类别:",@"地点:",@"开始时间:",@"结束时间:", @"详情:",@"主办方:"];
    if (self.model) {
        self.dataList = [NSMutableArray arrayWithArray:[self.model toMidifyArrayIsSimplify:NO]];
    }else{
        self.model = [[LJTimeAxisDataListModel alloc] init];
    }
}

- (void)convertChooseType{
    
    MyInfoConfigCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    cell.inputContent.text = [_model convertType];
    cell.inputContent.textColor = [_model getTextColorWithType];
    
}

- (void)initInputView:(MyInfoConfigCell *)cell atRow:(NSInteger)row{
    
    [self datePickView];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.inputContent.delegate = self;
    cell.tag = TextFieldBaseTag + row;
    UITextField *textField = cell.inputContent;
    textField.inputView = self.datePicker;
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"取消"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(cancelAction:)];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:self
                                                                               action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(doneAction:)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
    [topView setItems:buttonsArray];
    [textField setInputAccessoryView:topView];
    
}

- (void) datePickView{
    if (!self.datePicker) {
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0,0.0,0.0,0.0)];
        self.datePicker.backgroundColor = [UIColor whiteColor];
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [self.datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        self.datePicker.minuteInterval = 5;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
        components.hour = 9;
        self.datePicker.date = [calendar dateFromComponents:components];
        NSDate *minDate = [TKCommonTools dateWithFormat:TKDateFormatChineseLongYMD dateString:@"1900-01-01 00:00:00"];
        NSDate *maxDate = [TKCommonTools dateWithFormat:TKDateFormatChineseLongYMD dateString:@"2099-01-01 00:00:00"];
        self.datePicker.minimumDate = minDate;
        self.datePicker.maximumDate = maxDate;
    }
}

#pragma mark - action

- (void)cancelAction:(id)sender {
    if (self.startdateTextField.isFirstResponder) {
        [self.startdateTextField resignFirstResponder];
    } else if (self.endDateTextField.isFirstResponder) {
        [self.endDateTextField resignFirstResponder];
    } else {
        return;
    }
}

- (void)doneAction:(id)sender {
    
    NSDate *date = self.datePicker.date;
    UITextField *textField = nil;
    if (self.startdateTextField.isFirstResponder) {
        textField = self.startdateTextField;
        self.startDate = date;
    } else if (self.endDateTextField.isFirstResponder) {
        textField = self.endDateTextField;
        self.endDate = date;
    } else {
        return;
    }
    
    [textField resignFirstResponder];
    
    NSString *dateString = [TKCommonTools dateStringWithFormat:TKDateFormatChineseYMD date:date];
    NSString *weekString = [TKCommonTools weekOfDate:date];
    NSString *hourString = [TKCommonTools dateStringWithFormat:TKDateFormatHHMM date:date];
    
    textField.text = [NSString stringWithFormat:@"%@ %@  %@",dateString,weekString,hourString];
}

#pragma mark - private

- (void)getInputViewWithRow:(NSInteger)row inputView:(UIView *)inputView{
    
    switch (row) {
        case 0:
             self.titleTextField = (UITextField *)inputView;
            break;
        case 1:
            self.typeTextField = (UITextField *)inputView;
            break;
        case 2:
            self.positionTextField = (UITextField *)inputView;
            break;
        case 3:
            self.startdateTextField = (UITextField *)inputView;
            break;
        case 4:
            self.endDateTextField = (UITextField *)inputView;
            break;
        case 5:
            self.detailTextView = (UITextView *)inputView;
            break;
        case 6:
            self.sponsorTextView = (UITextView *)inputView;
            break;
            
        default:
            break;
    }

}

- (void)setupMyCellAtRow:(NSInteger)row cell:(MyInfoConfigCell *)cell{
    
    if (row == 1) {
        cell.inputContent.userInteractionEnabled = NO;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.inputContent.textColor = [self.model getTextColorWithType];
    }
    if (row == 3 || row == 4) {

        cell.titleLabelWidth.constant = 75;
        [self initInputView:cell atRow:row];
    }
}

- (NSString *)isOk{

    
    if (self.titleTextField.text.length == 0) {
        return @"请输入事件标题";
    }else if (self.typeTextField.text.length == 0){
        return @"请选择事件类别";
    }else if (self.positionTextField.text.length == 0){
        return @"请输入事件地址";
    }else if (self.startdateTextField.text.length == 0){
        return @"请选择事件开始时间";
    } else if (self.endDate && self.startDate && [self.endDate isEarlierThanDate:self.startDate]) {
        return @"结束时间小于开始时间";
    } else if (self.detailTextView.text.length == 0){
        return @"请输入事件详情";
    }else if (self.model.type.integerValue == 2 && (self.sponsorTextView.text == nil || [self.sponsorTextView.text isEqualToString:@""])){
        return @"请输入事件主办方";
    }
    
    self.model.title = self.titleTextField.text;
    self.model.address = self.positionTextField.text;
    if (self.startDate) {
         self.model.timeShow = [NSString stringWithFormat:@"%ld", (long)[self.startDate timeIntervalSince1970]];
    }
    if (self.endDate) {
        self.model.timeEnd = [NSString stringWithFormat:@"%ld", (long)[self.endDate timeIntervalSince1970]];
    }
    self.model.content = self.detailTextView.text;
    self.model.sponsor = self.sponsorTextView.text;
    
    return nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (_model.type.integerValue == 2) {
        return 7;
    }
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *title = [_titleList objectAtIndex:indexPath.row];
    NSInteger row = indexPath.row;
    if (indexPath.row > 4) {
        IntroduceMyselfCell *cell = [tableView dequeueReusableCellWithIdentifier:@"introduceCell"];
        
        cell.titleLabel.text = title;
        if (_dataList.count > 0) {
            cell.introduceTextView.text = [_dataList objectAtIndex:indexPath.row];
        }
        cell.isMyInfo = @"timeAxis";
        [self getInputViewWithRow:row inputView:cell.introduceTextView];
        
        if (indexPath.row == 6 || indexPath.row == 5) {
            cell.introduceTextView.delegate = self;
        }else {
            cell.introduceTextView.delegate = nil;
        }
        
        return cell;
    }else{
        MyInfoConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyInfoConfig"];
        cell.isMyInfo = @"timeAxis";
        cell.inputContent.delegate = self;
        NSString *text = title;
        cell.titleLB.text = text;
        [self setupMyCellAtRow:indexPath.row cell:cell];
        
        if (_dataList.count > 0) {
            cell.inputContent.text = [_dataList objectAtIndex:indexPath.row];
        }
        [self getInputViewWithRow:row inputView:cell.inputContent];

        return cell;
    }
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 1) {
        __weak typeof(self) weakSelf = self;
        LJEventStyleViewController *controller = [[LJEventStyleViewController alloc] init];
        controller.chooseType = ^(NSString *content){
           
            weakSelf.model.type = content;
            if (weakSelf.dataList.count > 0) {
                [weakSelf.dataList addObject:@""];
            }
            [weakSelf.tableView reloadData];
            [weakSelf convertChooseType];
        };
        [self.navigationController pushViewController:controller animated:YES];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 44;
    
    if (self.model.type.integerValue == 2)
    {
        if (indexPath.row == 5)
        {
            height = 100;
        }
        else if (indexPath.row == 6)
        {
            height = SCREEN_HEIGHT - 44 * 4 - 100;
        }
    }
    else
    {
        if (indexPath.row == 5)
        {
            height = SCREEN_HEIGHT - 44 * 4;
        }
    }
    
    return height;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSInteger row = 4;//一级时滑动为时间为最上面
    if (self.model.type.integerValue == 2){
        if (textView == self.sponsorTextView){
            row = 6;
        }else{
            row = 5;
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    });
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (textView == self.self.detailTextView) {
        self.dataList[5] = self.detailTextView.text;
    } else if (textView == self.self.sponsorTextView){
        self.dataList[6] = self.sponsorTextView.text;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    NSInteger tag = textField.tag;
    if (tag == TextFieldBaseTag + 3) {
        self.startDate = nil;
    } else if (tag == TextFieldBaseTag + 4) {
        self.endDate = nil;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == self.titleTextField) {
        self.dataList[0] = self.titleTextField.text;
    } else if (textField == self.positionTextField){
        self.dataList[2] = self.positionTextField.text;
    }
}

@end
