//
//  AuthIdentityController.h
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/6/25.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "BaseController.h"
#import "MyInfoModel.h"
#import "EditMyInfoDelegate.h"

@interface AuthIdentityController : BaseController

@property(nonatomic, strong) UserExtInfoModel* userExtModel;
@property (nonatomic, weak) id<EditMyInfoDelegate> delegate;

@end
