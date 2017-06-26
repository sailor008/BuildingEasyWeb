//
//  ContactManager.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/4.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ContactModel.h"

typedef void(^Contacts)(NSArray<ContactModel *> *allContacts);

@interface ContactManager : NSObject

+ (void)getAllContact:(Contacts)contacts;

@end
