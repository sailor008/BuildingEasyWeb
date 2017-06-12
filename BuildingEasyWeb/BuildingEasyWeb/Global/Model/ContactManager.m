//
//  ContactManager.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/4.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "ContactManager.h"

@implementation ContactManager

+ (void)getAllContact:(Contacts)contacts
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
