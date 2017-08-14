//
//  UserAddressBook.m
//  news
//
//  Created by 奥那 on 16/1/8.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "UserAddressBook.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@implementation UserAddressBook

+ (NSArray *)getAddressBooks
{
    //取得本地通信录名柄
    ABAddressBookRef tmpAddressBook = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        tmpAddressBook=ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema=dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else
    {
        tmpAddressBook =ABAddressBookCreate();
    }
    
    //取得本地所有联系人记录
    if (tmpAddressBook==nil)
    {
        return nil;
    }
    
    NSMutableArray *mutablePhoneArray = [[NSMutableArray alloc] init];
    
    NSArray* tmpPeoples = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(tmpAddressBook);
    for(id tmpPerson in tmpPeoples)
    {
        NSMutableDictionary *onePersionDic = [[NSMutableDictionary alloc] init];
        
        //获取的联系人单一属性:First name
        
        NSString* tmpFirstName = (__bridge_transfer NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonFirstNameProperty);
        
        NSString *nameString = [tmpFirstName isKindOfClass:[NSNull class]] ? @"" : tmpFirstName;
        
        nameString = nameString ? nameString : @"";
        [onePersionDic setObject:nameString forKey:@"name"];
        
        //获取的联系人单一属性:Generic phone number
        ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonPhoneProperty);
        if (NULL != tmpPhones)
        {
            for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++)
            {
                NSString* tmpPhoneIndex = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(tmpPhones, j);
                
                //只取第一个电话
                if (j == 0) {
                    
                    [onePersionDic setObject:tmpPhoneIndex forKey:@"mobile"];
                    break;
                }
            }
        }
        
        [mutablePhoneArray addObject: onePersionDic];
        
        if(tmpPhones){
            CFRelease(tmpPhones);
        }
    }
    //释放内存
    CFRelease(tmpAddressBook);
    return mutablePhoneArray;

}


@end
