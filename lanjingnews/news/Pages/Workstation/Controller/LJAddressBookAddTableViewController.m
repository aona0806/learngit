//
//  LJAddressBookAddViewController.m
//  news
//
//  Created by 陈龙 on 15/12/19.
//  Copyright © 2015年 lanjing. All rights reserved.
//

#import "LJAddressBookAddTableViewController.h"
#import <objc/runtime.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "LJInputFieldTableViewCell.h"
#import "LJInputTextViewTableViewCell.h"
#import "MBProgressHUD.h"
#import "TKRequestHandler+Workstation.h"
#import "ImageHelper.h"
#import "UIButton+WebCache.h"
#import "news-Swift.h"
#import "LJProvinceSelectedTableViewController.h"
#import "NSString+Valid.h"

@interface LJAddressBookAddViewController ()<LJInputFieldTableViewCellDelegate, LJInputTextViewTableViewCellDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate> {
    
    UIButton* right_btn;
}

@property (nonatomic, strong, nonnull) UIButton *photoImageButton;
@property (nonatomic, strong, nonnull) NSDictionary *params;
@property (nonatomic, strong, nonnull) NSArray<NSArray<NSString *> *> *keyArray;

@end

@implementation LJAddressBookAddViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加采访通讯录";
        
    self.tableView.backgroundColor = RGBA(247, 247, 247, 1);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.params = [NSMutableDictionary new];
    
    right_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [right_btn setFrame:CGRectMake(0, 0, 40, 44)];
    right_btn.backgroundColor = [UIColor clearColor];
    [right_btn setTitle: @"保存" forState: UIControlStateNormal];
    [right_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [right_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [right_btn addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:right_btn];
    self.keyArray = [NSArray arrayWithObjects:@[@"姓名",@"单位",@"职务"], @[@"所在省份"], @[@"手机号",@"邮箱"], @[@"备注"], @[@"avatar"], nil];
}

#pragma mark - private

- (void)addGoldAnimations
{
    //浪哥让先去掉添加蓝鲸币的动画
/*
    LJInputFieldTableViewCell *cell = (LJInputFieldTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
    [right_btn setEnabled:false];
    [cell animation:^(BOOL finished) {
        [right_btn setEnabled:true];
        [self performSelector:@selector(goBackController) withObject:self afterDelay:1];
    }];
 */
    
    [self goBackController];
    
}

-(void)goBackController
{
    [self.navigationController popViewControllerAnimated: YES];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return  3;
    }else if(section == 1){
        return  1;
    }else if (section == 2){
        return 2;
    }else if (section == 3){
        return 1;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    //    NSInteger row = indexPath.row;
    if (section == 0) {
        return  50;
    }else if (section == 1)
    {
        return 50;
    }else if (section == 2)
    {
        return 50;
    }else if (section == 3)
    {
        return 80;
    }else{
        return 80;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 10;
            break;
        case 1:
            return 10;
            break;
        case 2:
            return 10;
            break;
        case 3:
            return 10;
        case 4:
            return 10;
            
        default:
            return 0;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSString *titleString = self.keyArray[indexPath.section][indexPath.row];

    if (section == 0) {

        NSString *reuseIdentifier = [NSString stringWithCString:class_getName([LJInputFieldTableViewCell class]) encoding:NSUTF8StringEncoding];
        LJInputFieldTableViewCell *cell = nil; //[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        
        if (indexPath.row == 0) {
            cell = [[LJInputFieldTableViewCell alloc] initWithTitle:titleString
                                                        placeholder:@"必填"
                                                        animoteText:@"+2蓝鲸币"
                                                    reuseIdentifier:reuseIdentifier];
        } else {
            cell = [[LJInputFieldTableViewCell alloc] initWithTitle:titleString
                                                        placeholder:@"必填"
                                                    reuseIdentifier:reuseIdentifier];
        }
        if (indexPath.row < 2) {
            cell.isShowSeperateLine = YES;
        }
        cell.delegate = self;
        NSString *contentString = [self.params objectForKey:titleString];
        [cell updateInfo:contentString];
        return cell;
    } else if (section == 1) {
        NSString *reuseIdentifier = [NSString stringWithCString:class_getName([UITableViewCell class])
                                                       encoding:NSUTF8StringEncoding];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
            cell.textLabel.textColor = [UIColor lightGrayColor];
        }
        cell.textLabel.text = titleString;
        NSString *provinceString = [self.params objectForKey:titleString];
        cell.detailTextLabel.text = provinceString;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    } else if (section == 2) {
        NSArray *placeholderArray = @[@"必填",@""];
        
        NSString *reuseIdentifier = [NSString stringWithCString:class_getName([LJInputFieldTableViewCell class]) encoding:NSUTF8StringEncoding];
        LJInputFieldTableViewCell *cell = nil;//[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
      
        NSString *placeholderString = placeholderArray[indexPath.row];
        cell = [[LJInputFieldTableViewCell alloc] initWithTitle:titleString
                                                    placeholder:placeholderString
                                                reuseIdentifier:reuseIdentifier];
        cell.delegate = self;
        NSString *contentString = [self.params objectForKey:titleString];
        [cell updateInfo:contentString];

        if (indexPath.row == 0) {
            cell.isShowSeperateLine = YES;
            cell.keytboardType = UIKeyboardTypePhonePad;
        }
        return cell;

    } else if (section == 3) {
        
        NSString *reuseIdentifier = [NSString stringWithCString:class_getName([LJInputTextViewTableViewCell class]) encoding:NSUTF8StringEncoding];
        LJInputTextViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            
            cell = [[LJInputTextViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:reuseIdentifier];
            cell.delegate = self;
            cell.contentTextView.delegate = self;
        }
        NSString *contentString = [self.params objectForKey:titleString];
        [cell updateInfo:contentString];
        return cell;

    } else if (section == 4){
        NSString *reuseIdentifier = @"UITableViewCell_photo";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        UIButton *imageButton = [UIButton buttonWithType: UIButtonTypeCustom];
        imageButton.backgroundColor = [UIColor clearColor];
        NSString *avatarImageUrl = [self.params objectForKey:titleString];
        UIImage *placeholderImage = [UIImage imageNamed:@"workstation_addressbookadd_camara"];
        NSURL *imageUrl = [LJUrlHelper tryEncode:avatarImageUrl];
        [imageButton sd_setImageWithURL:imageUrl
                               forState:UIControlStateNormal
                       placeholderImage:placeholderImage];
        imageButton.frame = CGRectMake((SCREEN_WIDTH - 80)/2 , 10, 80, 60);
        [cell.contentView addSubview: imageButton];
        [imageButton addTarget:self action:@selector(imageButtonClick:)
              forControlEvents:UIControlEventTouchUpInside];
        self.photoImageButton = imageButton;
        return cell;
    } else {
        UITableViewCell *cell = [UITableViewCell new];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    long section = indexPath.section;
    
    if (section == 1) {
        if (row == 0)
        {
            LJProvinceSelectedTableViewController *controller = [[LJProvinceSelectedTableViewController alloc] initWithSelectedBlock:^(NSString *province) {
                
                NSString *keyString = self.keyArray[indexPath.section][indexPath.row];
                [self.params setValue:province forKey:keyString];
                [self.navigationController popViewControllerAnimated:YES];
                NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
                [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            }];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

#pragma mark - action

-(void)imageButtonClick:(UIButton *)button
{
    [self hideKeyboard];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: @"上传名片"
                                                             delegate: self
                                                    cancelButtonTitle: @"取消"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: @"相机",@"从手机相册选择", nil];
    [actionSheet showInView: self.view];
}

-(void)uploadThePhotoWith:(NSInteger) buttonIndex
{
    //上传图片
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [picker setAllowsEditing:YES];
    

    picker.navigationBar.tintColor = [UIColor blackColor];
    
    switch (buttonIndex) {
        case 0://Take picture
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
            }else{
                NSLog(@"模拟器无法打开相机");
            }
            
            NSString *mediaType = AVMediaTypeVideo;
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
            if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请为蓝鲸财经开放相机权限，手机设置－隐私－相机－蓝鲸财经（打开）" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                [alertView show];
            } else {
                [self presentViewController: picker animated: YES completion:nil];
            }
            
            break;
        }
        case 1://From album
        {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            __weak UIImagePickerController *weakPicker = picker;
            [self presentViewController: picker animated: YES completion:^{
//                NSLog(@"right item is: \n%@\n\n",weakPicker.navigationItem.rightBarButtonItems);
//                NSLog(@"nav bar is: %@\n\n",weakPicker.navigationItem);
//                [weakPicker.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
            }];
        }
            break;
            
        default:
            
            break;
    }
    
}

-(void)hideKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark - download

-(void)saveButtonAction:(UIButton *)button
{
    [self.view endEditing:YES];
    
    NSString *errorString = nil;
    NSString *nameString = [self.params objectForKey:self.keyArray[0][0]];
    NSString *companyString = [self.params objectForKey:self.keyArray[0][1]];
    NSString *jobString = [self.params objectForKey:self.keyArray[0][2]];
    NSString *provinceString = [self.params objectForKey:self.keyArray[1][0]];
    NSString *mobileString = [self.params objectForKey:self.keyArray[2][0]];
    NSString *emailString = [self.params objectForKey:self.keyArray[2][1]];
    NSString *remarkString = [self.params objectForKey:self.keyArray[3][0]];
    NSString *cardpicUrlString = [self.params objectForKey:self.keyArray[4][0]];
    
    
    if (!nameString || nameString.length == 0) {
        errorString = @"请输入姓名";
    } else if(!companyString || companyString.length == 0) {
        errorString = @"请输入单位信息";
    } else if (!jobString || jobString.length == 0) {
        errorString = @"请输入职务信息";
    } else if (!mobileString || mobileString.length == 0) {
        errorString = @"请填写手机号码";
    } else if (remarkString.length > 0 && remarkString.length < 10) {
        errorString = @"简介长度不能小于10个字符";
    } else if (remarkString.length > 70) {
        errorString = @"简介长度不能大于70个字符";
    }
    
    if (errorString) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.text = errorString;
        [hud hideAnimated:YES afterDelay: 1];
        return;
    }
    
    if (![mobileString isValidateMobile]) {
        
        
        [UIAlertView bk_showAlertViewWithTitle:@"温馨提示"
                                       message:@"您填写的手机号非11位，确认提交？"
                             cancelButtonTitle:@"取消"
                             otherButtonTitles:@[@"确定"]
                                       handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                           
                                           switch (buttonIndex) {
                                               case 0:
                                                   
                                                   break;
                                               case 1:
                                                   // 添加通讯录手机号码错误统计
                                                   [MobClick event:@"AddressBookAdd_Mobile_NumError"];
                                                   
                                                   [self addNoteinfoWithName:nameString company:companyString job:jobString mobile:mobileString provString:provinceString identity:nil industry:nil email:emailString remark:remarkString card_picUrl:cardpicUrlString cityString:nil];
                                                   break;
                                                   
                                               default:
                                                   break;
                                           }
                                       }];
        
    } else {
        [self addNoteinfoWithName:nameString company:companyString job:jobString mobile:mobileString provString:provinceString identity:nil industry:nil email:emailString remark:remarkString card_picUrl:cardpicUrlString cityString:nil];
    }
}

- (void)addNoteinfoWithName:(NSString *)nameString
                    company:(NSString *)companyString
                        job:(NSString *)jobString
                     mobile:(NSString *)mobileString
                 provString:(NSString *)provinceString
                   identity:(NSString *)identity
                   industry:(NSString *)industry
                      email:(NSString *)emailString
                     remark:(NSString *)remarkString
                card_picUrl:(NSString *)cardpicUrlString
                 cityString:(NSString *)cityString
{

    MBProgressHUD *loadHud = [MBProgressHUD showHUDAddedTo:self.view animated: YES];
    right_btn.enabled = NO;
    __weak typeof(self) weakSelf = self;
    [[TKRequestHandler sharedInstance] postAddNoteInfoWithName:nameString
                                                       company:companyString
                                                           job:jobString
                                                        mobile:mobileString
                                                    provString:provinceString
                                                      identity:identity industry:industry
                                                         email:emailString
                                                        remark:remarkString
                                                   card_picUrl:cardpicUrlString
                                                    cityString:nil
                                                     complated:^(NSURLSessionDataTask * _Nonnull sessionDataTask,
                                                                 LJBaseJsonModel * _Nullable model, NSError * _Nullable error) {
                                                         
                                                         [loadHud hideAnimated: YES];
                                                         right_btn.enabled = YES;
                                                         if (error) {
                                                             [right_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                                             [right_btn setEnabled:true];
                                                             
                                                             [weakSelf showToastHidenDefault:error.domain];
                                                         }else{
                                                             if (model.dErrno.integerValue == 0)
                                                             {
                                                                 
                                                                 [weakSelf showToastHidenDefault:@"添加成功"];

                                                                 [weakSelf invokeOnUIThread:^{
                                                                     [weakSelf addGoldAnimations];
                                                                 }];
                                                                 
                                                             }else{
                                                                 
                                                                 [weakSelf showToastHidenDefault:model.msg];

                                                                 
                                                                 [right_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                                                 [right_btn setEnabled:true];
                                                             }
                                                         }
                                                         
                                                     }];
}

- (void)uploadImage:(UIImage *)image
{
    UIImage *defaultImage = [UIImage imageNamed:@"workstation_addressbookadd_camara"];
    
    [self.photoImageButton setImage:image forState:UIControlStateNormal];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated: YES];
    
    NSData *imageData = [ImageHelper imageToData:image];
    
    __weak typeof(self) waekSefl = self;
    [[TKRequestHandler sharedInstance] postAddNoteInfoImageWithField:imageData withCategory:@"123Test" complated:^(NSURLSessionDataTask * _Nonnull sessionDataTask, LJUploadImageModel * _Nullable model, NSError * _Nullable error) {
        
        [hud hideAnimated:YES];
        if (error) {
            [waekSefl.photoImageButton setImage:defaultImage forState:UIControlStateNormal];
        } else {
            if (model.dErrno.integerValue == 0) {
                [waekSefl.params setValue:model.data.pic forKey:self.keyArray[4][0]];
            } else {
                [waekSefl.photoImageButton setImage:defaultImage forState:UIControlStateNormal];
            }
        }
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIViewController *viewController = (picker.parentViewController != nil) ? picker.parentViewController : picker;
    __weak typeof(self) weakSelf = self;
    [viewController dismissViewControllerAnimated:YES completion:^{
        UIImage *image = info[UIImagePickerControllerEditedImage];
        [weakSelf uploadImage:image];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog (@"Cancel");
    [picker dismissViewControllerAnimated:YES completion:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self uploadThePhotoWith:buttonIndex];
}

#pragma mark - LJInputFieldTableViewCellDelegate

- (void)LJInputFieldUpdateWithTitle:(NSString * _Nonnull)title content:(NSString * _Nonnull)content
{
    //FIXME: update params
    [self.params setValue:content forKey:title];
}

#pragma mark - LJInputTextViewTableViewCellDelegate

- (void)LJInputTextViewUpdateWithTitle:(NSString * _Nonnull)title content:(NSString * _Nonnull)content
{
    NSString *text = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self.params setValue:text forKey:title];

}

//收回键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if (textField.returnKeyType == UIReturnKeyDone) {
        [textField resignFirstResponder];
        return YES;
    }
    
    return NO;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSString *contentString = textView.text;
    contentString = [contentString stringByReplacingCharactersInRange:range withString:text];
    contentString = [contentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (contentString.length > 70) {
        [self showToastHidenDefault:@"输入的简介字符长度不能超过70"];
        return false;
    } else {
        return true;
    }
}
@end
