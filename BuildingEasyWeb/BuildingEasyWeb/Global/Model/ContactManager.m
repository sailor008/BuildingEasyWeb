//
//  ContactManager.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/4.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "ContactManager.h"

#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>
#import <UIKit/UIKit.h>

@implementation ContactManager

+ (void)getAllContact:(Contacts)contacts
{
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    
    if (phoneVersion.integerValue > 8) {
        [ContactManager requestContactIniOS8:contacts];
    } else {
        [ContactManager requestContactIniOS9:contacts];
    }
}

#pragma mark iOS8及以下 通讯录
+ (void)requestContactIniOS8:(Contacts)contacts
{
    //如果用户没决定过，请求授权
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        //创建通讯录
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        //请求授权
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {//请求授权页面用户同意授权
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ContactManager readLocalAddressBook:contacts];
                });
            }
            CFRelease(addressBookRef);
        });
        //如果是已授权状态
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        [ContactManager readLocalAddressBook:contacts];
    } else {
        NSLog(@"请在设置中打开通讯录授权");
    }
}

+ (void)readLocalAddressBook:(Contacts)contacts
{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    //拿到所有联系人
    CFArrayRef peopleArray = ABAddressBookCopyArrayOfAllPeople(addressBook);
    //数组数量
    CFIndex peopleCount = CFArrayGetCount(peopleArray);
    
    NSMutableArray* tempArr = [NSMutableArray array];
    
    for (int i = 0; i < peopleCount; i++) {
        //拿到一个人
        ABRecordRef person = CFArrayGetValueAtIndex(peopleArray, i);
        //拿到姓名
        //姓
        NSString *lastNameValue = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        //名
        NSString *firstNameValue = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        
        //拿到多值电话
        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        //多值数量
        CFIndex phoneCount = ABMultiValueGetCount(phones);
        for (int j = 0; j < phoneCount ; j++) {
            //拿到标签下对应的电话号码
            NSString *phoneValue = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, j);
            
            ContactModel* model = [[ContactModel alloc] init];
            model.name = [NSString stringWithFormat:@"%@%@", firstNameValue, lastNameValue];
            model.phone = phoneValue;
            [tempArr addObject:model];
        }
        CFRelease(phones);
    }
    CFRelease(addressBook);
    CFRelease(peopleArray);
    
    contacts([tempArr copy]);
}

#pragma mark iOS9及以上 通讯录
+ (void)requestContactIniOS9:(Contacts)contacts
{
    // 1. 判断当前的授权状态
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) {// 未授权
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [ContactManager readLocalContactBook:contacts];
                });
            } else {
                NSLog(@"授权失败");
            }
        }];
    } else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized) {
        [ContactManager readLocalContactBook:contacts];
    } else {
        NSLog(@"未授权");
    }
}

+ (void)readLocalContactBook:(Contacts)contacts
{
    // 2. 获取联系人仓库
    CNContactStore *store = [[CNContactStore alloc] init];
    
    // 3. 创建联系人信息的请求对象
    NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    
    // 4. 根据请求Key, 创建请求对象
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
    
    NSMutableArray* tempArr = [NSMutableArray array];
    
    // 5. 发送请求
    [store enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        
        // 6.1 获取姓名
        NSString *givenName = contact.givenName;
        NSString *familyName = contact.familyName;
//        NSLog(@"%@--%@", givenName, familyName);
        
        // 6.2 获取电话
        NSArray *phoneArray = contact.phoneNumbers;
        for (CNLabeledValue *labelValue in phoneArray) {
            
            CNPhoneNumber *number = labelValue.value;
//            NSLog(@"%@--%@", number.stringValue, labelValue.label);
            
            ContactModel* model = [[ContactModel alloc] init];
            model.name = [NSString stringWithFormat:@"%@%@", familyName, givenName];
            if (!model.name.length) {
                model.name = number.stringValue;
            }
            model.phone = number.stringValue;
            [tempArr addObject:model];
            
        }
    }];
    
    contacts([tempArr copy]);
}

@end
