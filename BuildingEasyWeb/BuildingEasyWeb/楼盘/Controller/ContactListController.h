//
//  ContactListController.h
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/10.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "BaseController.h"

#import "ContactModel.h"

typedef void(^SelectedContact)(ContactModel* model);

@interface ContactListController : BaseController

@property (nonatomic, strong) SelectedContact selectedContact;

@end
